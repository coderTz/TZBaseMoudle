//
//  RouterUrlNavgation.m
//  TZBasePro_OC
//
//  Created by IOS on 2021/11/17.
//

#import "RouterUrlNavgation.h"

@implementation RouterUrlNavgation
+ (UIViewController *)rootViewController{
    return  [UIApplication sharedApplication].keyWindow.rootViewController;
}
+ (UIViewController*)currentViewController {
   
    return [self currentViewControllerFrom:[self rootViewController]];
}

+ (UINavigationController*)currentNavigationViewController {
    UIViewController* currentViewController = self.currentViewController;
    return currentViewController.navigationController;
}

+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated replace:(BOOL)replace
{
    if (!viewController) {
       
    }
    else {
        if([viewController isKindOfClass:[UINavigationController class]]) {
            [RouterUrlNavgation setRootViewController:viewController];
        } // 如果是导航控制器直接设置为根控制器
        else {
            UINavigationController *navigationController = [self currentNavigationViewController];
            if (navigationController) { // 导航控制器存在
                // In case it should replace, look for the last UIViewController on the UINavigationController, if it's of the same class, replace it with a new one.
                if (replace && [navigationController.viewControllers.lastObject isKindOfClass:[viewController class]]) {
                                        
                    NSArray *viewControllers = [navigationController.viewControllers subarrayWithRange:NSMakeRange(0, navigationController.viewControllers.count-1)];
                    [navigationController setViewControllers:[viewControllers arrayByAddingObject:viewController] animated:animated];
                } // 切换当前导航控制器 需要把原来的子控制器都取出来重新添加
                else {
                    [navigationController pushViewController:viewController animated:animated];
                } // 进行push
            }
            else {
                navigationController = [[UINavigationController alloc]initWithRootViewController:viewController];
                [UIApplication sharedApplication].keyWindow.rootViewController = navigationController;
            } // 如果导航控制器不存在,就会创建一个新的,设置为根控制器
        }
    }
}

+ (void)presentViewController:(UIViewController *)viewController animated: (BOOL)flag completion:(void (^ __nullable)(void))completion
{
    if (!viewController) {
    
    }else {
        UIViewController *currentViewController = [self currentViewController];
        if (currentViewController) { // 当前控制器存在
            [currentViewController presentViewController:viewController animated:flag completion:completion];
        } else { // 将控制器设置为根控制器
            [UIApplication sharedApplication].keyWindow.rootViewController = viewController;
        }
    }
}

// 设置为根控制器
+ (void)setRootViewController:(UIViewController *)viewController
{
    [UIApplication sharedApplication].keyWindow.rootViewController = viewController;
}

// 通过递归拿到当前控制器
+ (UIViewController*)currentViewControllerFrom:(UIViewController*)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController *)viewController;
        return [self currentViewControllerFrom:navigationController.viewControllers.lastObject];
    } // 如果传入的控制器是导航控制器,则返回最后一个
    else if([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController *)viewController;
        return [self currentViewControllerFrom:tabBarController.selectedViewController];
    } // 如果传入的控制器是tabBar控制器,则返回选中的那个
    else if(viewController.presentedViewController != nil) {
        return [self currentViewControllerFrom:viewController.presentedViewController];
    } // 如果传入的控制器发生了modal,则就可以拿到modal的那个控制器
    else {
        return viewController;
    }
}

+ (void)popTwiceViewControllerAnimated:(BOOL)animated {
    [self popViewControllerWithTimes:2 animated:YES];
}

+ (void)popViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated {

    UIViewController *currentViewController = [self currentViewController];
    NSUInteger count = currentViewController.navigationController.viewControllers.count;
    if(currentViewController){
        if(currentViewController.navigationController) {
            if (count > times){
                [currentViewController.navigationController popToViewController:[currentViewController.navigationController.viewControllers objectAtIndex:count-1-times] animated:animated];
            }else { // 如果times大于控制器的数量
                
            }
        }
    }
}

+ (void)popToRootViewControllerAnimated:(BOOL)animated {
    UIViewController *currentViewController = [self currentViewController];
    NSUInteger count = currentViewController.navigationController.viewControllers.count;
    [self popViewControllerWithTimes:count-1 animated:YES];
}


+ (void)dismissTwiceViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion {
    [self dismissViewControllerWithTimes:2 animated:YES completion:completion];
}


+ (void)dismissViewControllerWithTimes:(NSUInteger)times animated: (BOOL)flag completion: (void (^ __nullable)(void))completion {
    UIViewController *rootVC = [self currentViewController];
    
    if (rootVC) {
        while (times > 0) {
            rootVC = rootVC.presentingViewController;
            times -= 1;
        }
        [rootVC dismissViewControllerAnimated:YES completion:completion];
    }
    
    if (!rootVC.presentedViewController) {
      
    }
}


+ (void)dismissToRootViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion {
    UIViewController *currentViewController = [self currentViewController];
    UIViewController *rootVC = currentViewController;
    while (rootVC.presentingViewController) {
        rootVC = rootVC.presentingViewController;
    }
    [rootVC dismissViewControllerAnimated:YES completion:completion];
}


@end
