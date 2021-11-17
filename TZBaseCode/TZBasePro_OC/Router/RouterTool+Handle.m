//
//  RouterTool+Handle.m
//  TZBasePro_OC
//
//  Created by IOS on 2021/11/11.
//

#import "RouterTool+Handle.h"
#import "RouterUrlNavgation.h"
#define RouterIsString(s) !((s == nil || [s isKindOfClass:[NSNull class]] || ([s isKindOfClass:[NSString class]] && s.length == 0)))
@implementation RouterTool (Handle)
// 注册router
+ (void)load{
    [self performSelectorOnMainThread:@selector(registRouter) withObject:nil waitUntilDone:false];

}
+ (void)registRouter{
    // 获取本地的plist文件内的匹配规则
   NSDictionary * mapInfo = [self loadConfigDictFromPlist:@"RousterRule.plist" bundle:[NSBundle mainBundle]];
    // 注册所有对应的控制器路径
    for (NSString * router in mapInfo.allKeys ) {
        NSDictionary* routerMap = mapInfo[router];
        NSString* className = routerMap[RouteClassName];
        if (RouterIsString(className)) {
            [self addRoute:router handler:^BOOL(NSDictionary * _Nonnull parameters) {
                return [self executeRouterClassName:className routerMap:routerMap parameters:parameters];
            }];
        }
    }
    // 注册 Router 到指定TabBar Index;
    [self addRoute:@"/rootTab/:index" handler:^BOOL(NSDictionary * _Nonnull parameters) {
        NSInteger index = [parameters[@"index"] integerValue];
        // 处理 UITabBarControllerIndex 切换;
        UITabBarController* tabBarVC = (UITabBarController* )[RouterUrlNavgation rootViewController];
        
        if ([tabBarVC isKindOfClass:[UITabBarController class]] && index >= 0 && tabBarVC.viewControllers.count >= index) {
            UIViewController* indexVC = tabBarVC.viewControllers[index];
            if ([indexVC isKindOfClass:[UINavigationController class]]) {
                indexVC = ((UINavigationController *)indexVC).topViewController;
            }
            //传参
            [self setupParameters:parameters forViewController:indexVC];
            tabBarVC.selectedIndex = index;
            return YES;
        } else {
            return NO;
        }
    }];
    // 注册返回上层页面 Router, 使用 [JSDVCRouter openURL:kJSDVCRouteSegueBack] 返回上一页 或 [JSDVCRouter openURL:kJSDVCRouteSegueBack parameters:@{kJSDVCRouteBackIndex: @(2)}]  返回前两页
    [self addRoute:Router_Back handler:^BOOL(NSDictionary * _Nonnull parameters) {
        
        return [self executeBackRouterParameters:parameters];
    }];
}
+ (NSDictionary *)loadConfigDictFromPlist:(NSString *)pistName bundle:(NSBundle *)bundle{
       NSString *path = [[bundle resourcePath]
                         stringByAppendingPathComponent:pistName];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
       if (dictionary!=nil && dictionary) {
           return dictionary;
       }else {
           NSLog(@"请按照说明添加对应的plist文件");
           return @{};
       }
}
#pragma mark - execute Router VC
// 当查找到指定 Router 时, 触发路由回调逻辑; 找不到已注册 Router 则直接返回 NO; 如需要的话, 也可以在这里注册一个全局未匹配到 Router 执行的回调进行异常处理;
+ (BOOL)executeRouterClassName:(NSString *)className routerMap:(NSDictionary* )routerMap parameters:(NSDictionary* )parameters {
    // 拦截 Router 映射参数,是否需要登录才可跳转;
    BOOL userIsLogin = false;
    if ([routerMap.allKeys containsObject:RouteClassNeedLogin] || [parameters.allKeys containsObject:Router_needLogin]) {
        BOOL needLogin = [routerMap[RouteClassNeedLogin] boolValue];
        BOOL needLogin_router = [routerMap[Router_needLogin] boolValue];
        if ((needLogin && !userIsLogin)|| (needLogin_router && !userIsLogin)) {
            // 去登录页页面
            [RouterTool loadURL:RouteLogin];
            return NO;
        }
        
    }
    //统一初始化控制器,传参和跳转;
    UIViewController* vc = [self viewControllerWithClassName:className routerMap:routerMap parameters: parameters];
    if (vc) {
        [self gotoViewController:vc parameters:parameters];
        return YES;
    } else {
        return NO;
    }
}
// 对 VC 参数赋值
+ (void)setupParameters:(NSDictionary *)params forViewController:(UIViewController* )vc {
    
    for (NSString *key in params.allKeys) {
        BOOL hasKey = [vc respondsToSelector:NSSelectorFromString(key)];
        BOOL notNil = params[key] != nil;
        if (hasKey && notNil) {
            [vc setValue:params[key] forKey:key];
        }
        
#if DEBUG
    //vc没有相应属性，但却传了值
        if ([key hasPrefix:@"JLRoute"]==NO && [key hasPrefix:@"TZRouter"]==NO &&
              [params[@"JLRoutePattern"] rangeOfString:[NSString stringWithFormat:@":%@",key]].location==NSNotFound) {
            NSAssert(hasKey == YES, @"%s: %@ is not property for the key %@",__func__ ,vc,key);
        }
#endif
    };
}
// 根据 Router 映射到的类名实例化控制器;
+ (UIViewController *)viewControllerWithClassName:(NSString *)className routerMap:(NSDictionary *)routerMap parameters:(NSDictionary* )parameters {
    
    id vc = [[NSClassFromString(className) alloc] init];
    if (![vc isKindOfClass:[UIViewController class]]) {
        vc = nil;
    }
#if DEBUG
    //vc不是UIViewController
    NSAssert(vc, @"%s: %@ is not kind of UIViewController class, routerMap: %@",__func__ ,className, routerMap);
#endif
    //参数赋值
    [self setupParameters:parameters forViewController:vc];
    
    return vc;
}
// 返回上层页面回调;
+ (BOOL)executeBackRouterParameters:(NSDictionary *)parameters {
    BOOL animated = parameters[RouteAnimated] ? [parameters[RouteAnimated] boolValue] : YES;
    NSString *backIndexString = parameters[RouteAnimated] ? [NSString stringWithFormat:@"%@",parameters[RouteAnimated]] : nil;  // 指定返回个数, 优先处理此参数;
    id backPage = parameters[RouteBackPage] ? parameters[RouteBackPage] : nil; // 指定返回到某个页面,
    UIViewController* visibleVC = [RouterUrlNavgation currentViewController];
    UINavigationController* navigationVC = visibleVC.navigationController;
    if (navigationVC) {
        // 处理 pop 按索引值处理;
        if (RouterIsString(backIndexString)) {
            if ([backIndexString isEqualToString:RouteIndexRoot]) {//返回根
                [navigationVC popToRootViewControllerAnimated:animated];
            }
            else {
                NSUInteger backIndex = backIndexString.integerValue;
                NSMutableArray* vcs = navigationVC.viewControllers.mutableCopy;
                if (vcs.count > backIndex) {
                    [vcs removeObjectsInRange:NSMakeRange(vcs.count - backIndex, backIndex)];
                    [navigationVC setViewControllers:vcs animated:animated];
                    return YES;
                }
                else {
                    return NO; //指定返回索引值超过当前导航控制器包含的子控制器;
                }
            }
        }
        else if (backPage) { //处理返回指定的控制器, 可以处理
            NSMutableArray *vcs = navigationVC.viewControllers.mutableCopy;
            NSInteger pageIndex = NSNotFound;
            //页面标识为字符串
            if ([backPage isKindOfClass:[NSString class]]) {
                for (int i=0; i<vcs.count; i++) {
                    if ([vcs[i] isKindOfClass:NSClassFromString(backPage)]) {
                        pageIndex = i;
                        break;
                    }
                }
            }
            //页面标识为vc实例
            else if ([backPage isKindOfClass:[UIViewController class]]) {
                for (int i=0; i<vcs.count; i++) {
                    if (vcs[i] == backPage) {
                        pageIndex = i;
                        break;
                    }
                }
            }
         
        }
        else {
            [navigationVC popViewControllerAnimated:animated];
            return YES;
        }
    }
    else {
        [visibleVC dismissViewControllerAnimated:animated completion:nil];
        return YES;
    }
    return NO;
}
// 跳转和参数设置;
+ (void)gotoViewController:(UIViewController *)vc parameters:(NSDictionary *)parameters {
    UIViewController* currentVC = [RouterUrlNavgation currentViewController];
    NSString *segue = parameters[Router_segueStyle] ? parameters[Router_segueStyle] : RouterSeguePush; //  决定 present 或者 Push; 默认值 Push
    BOOL animated = parameters[RouteAnimated] ? [parameters[RouteAnimated] boolValue] : YES;  // 转场动画;
    NSLog(@"%s 跳转: %@ %@ %@",__func__ ,currentVC, segue,vc);
    if ([segue isEqualToString:RouterSeguePush]) { //PUSH
        if (currentVC.navigationController) {
            NSString *backIndexString = [NSString stringWithFormat:@"%@",parameters[RouteBackIndex]];
            UINavigationController* nav = currentVC.navigationController;
            if ([backIndexString isEqualToString:RouteIndexRoot]) {
                NSMutableArray *vcs = [NSMutableArray arrayWithObject:nav.viewControllers.firstObject];
                [vcs addObject:vc];
                [nav setViewControllers:vcs animated:animated];
                
            } else if ([backIndexString integerValue] && [backIndexString integerValue] < nav.viewControllers.count) {
                //移除掉指定数量的 VC, 在Push;
                NSMutableArray *vcs = [nav.viewControllers mutableCopy];
                [vcs removeObjectsInRange:NSMakeRange(vcs.count - [backIndexString integerValue], [backIndexString integerValue])];
                nav.viewControllers = vcs;
                [nav pushViewController:vc animated:YES];
            } else {
                [[RouterUrlNavgation currentNavigationViewController] pushViewController:vc animated:animated];
                
            }
        }
        else { //由于无导航栏, 直接执行 Modal
            BOOL needNavigation = parameters[RouterSegueNeedNavigation] ? NO : YES;
            if (needNavigation) {
                UINavigationController* navigationVC = [[UINavigationController alloc] initWithRootViewController:vc];
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                [currentVC presentViewController:navigationVC animated:YES completion:nil];
            }
            else {
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                [currentVC presentViewController:vc animated:animated completion:nil];
            }
        }
    }
    else { //Modal
        BOOL needNavigation = parameters[RouterSegueNeedNavigation] ? parameters[RouterSegueNeedNavigation] : NO;
        if (needNavigation) {
            UINavigationController* navigationVC = [[UINavigationController alloc] initWithRootViewController:vc];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [currentVC presentViewController:navigationVC animated:animated completion:nil];
        }
        else {
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [currentVC presentViewController:vc animated:animated completion:nil];
        }
    }
}

@end
