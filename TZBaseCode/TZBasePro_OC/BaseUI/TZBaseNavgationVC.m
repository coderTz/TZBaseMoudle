//
//  TZBaseNavgationVC.m
//  TZBasePro_OC
//
//  Created by IOS on 2021/11/8.
//

#import "TZBaseNavgationVC.h"

@interface TZBaseNavgationVC ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation TZBaseNavgationVC
- (void)viewDidLoad {
   [super viewDidLoad];
//    // 强制开启侧滑返回操作
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.delegate = self;
//        self.delegate = self;
//        self.interactivePopGestureRecognizer.enabled = YES;
//    }
   /// 返回按钮颜色
   [UINavigationBar appearance].tintColor = [UIColor blackColor];
   //修改导航栏背景色
   [UINavigationBar appearance].barTintColor = [UIColor whiteColor];
   //为导航栏设置字体颜色等
   [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
   /// 去除导航栏下的线
   [self.navigationBar setShadowImage:[UIImage new]];

   [self.navigationItem setHidesBackButton:YES];
   
//   // 测试环境下添加debug工具
//   if (ENVIRONMENT < 3) {
//       UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
//       longPress.minimumPressDuration = 1.5;
//       [self.view addGestureRecognizer:longPress];
//   }
//}
//- (void)longPressEvent:(UILongPressGestureRecognizer *)gesture{
//   //直接return掉，不在开始的状态里面添加任何操作，则长按手势就会被少调用一次了
//   if(gesture.state == UIGestureRecognizerStateBegan){
//       DebugViewController *debugVC = [[DebugViewController alloc] init];
//       if ([self.viewControllers.lastObject isKindOfClass:[UIViewController class]] && ![self.viewControllers.lastObject isKindOfClass:[DebugViewController class]]) {
//           [self.viewControllers.lastObject.navigationController pushViewController:debugVC animated:true];
//       }
//   }
}

#pragma mark --- 拦截所有push 进来的控制器
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
   if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated) {
       self.interactivePopGestureRecognizer.enabled = YES;
   }
   if (self.viewControllers.count > 0) {
       viewController.hidesBottomBarWhenPushed = YES;
       UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
      
       [btn setImage:IMAGENAMED_FIXED(@"search_back_arror") forState:0];
       [btn setImage:IMAGENAMED_FIXED(@"search_back_arror")
            forState:UIControlStateHighlighted];
       [btn setFrame:CGRectMake(0, 0, 50, 50)];
       [btn setTitle:@"返回" forState:0];
       [btn setTitleColor:UIColor.blackColor forState:0];
       [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
       UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
   //    [backItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
       viewController.navigationItem.leftBarButtonItem = backItem;
       
   }

//    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

   [super pushViewController:viewController animated:animated];
}
- (void)backAction{
   [self popViewControllerAnimated:YES];
}
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
   viewControllerToPresent.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
   [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}
-(NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
   if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated) {
       self.interactivePopGestureRecognizer.enabled = YES;
   }
   NSMutableArray *mArray = [NSMutableArray arrayWithArray:self.viewControllers];
   if (mArray.count != 0) {
       [mArray removeObjectAtIndex:mArray.count - 1];
   }
   return [super popToRootViewControllerAnimated:animated];
}
-(NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
   if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
       self.interactivePopGestureRecognizer.enabled = YES;
   }
 
   return [super popToViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
   if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
       self.interactivePopGestureRecognizer.enabled = YES;
   }
   NSMutableArray *mArray = [NSMutableArray arrayWithArray:self.viewControllers];
   if (mArray.count != 0) {
       [mArray removeObjectAtIndex:mArray.count - 1];
   }
   return [super popViewControllerAnimated:animated];
}

// same as push methods
/// 导航栏返回按钮的监听事件
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
   if (self.viewControllers.count < (navigationBar.items.count)) {
       return true;
   }
   BOOL shouldPop = false;
   UIViewController *vc = self.topViewController;
//   if ([vc respondsToSelector:@selector(ir_navigationShouldPopMethod)]) {
//
//   }
    shouldPop = true;
   if (shouldPop) {
       __weak typeof (self) weakSelf = self;
       dispatch_async(dispatch_get_main_queue(), ^{
           [weakSelf popViewControllerAnimated:true];
       });
   }else {
       for (UIView *subView in navigationBar.subviews) {
           if (0.0 < subView.alpha && subView.alpha < 1.0) {
               [UIView animateWithDuration:0.25 animations:^{
                   subView.alpha = 1.0;
               }];
           }
       }
   }
   return false;
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated
{
    NSInteger count = viewControllers.count;
    if (count > 1) {
        //push后隐藏tabBar
        viewControllers.lastObject.hidesBottomBarWhenPushed = YES;
    }
    [super setViewControllers:viewControllers animated:animated];
}

#pragma mark --- UIGestureRecognizerDelegate
/// 重写此协议方法的目的是拦截侧滑返回事件。
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    if (self.childViewControllers.count == 1) {
//        return false;
//    }else {
//        if ([self.topViewController respondsToSelector:@selector(ir_navigationShouldPopMethod)]) {
//            return [self.topViewController ir_navigationShouldPopMethod];
//        }
//    }
//    //判断当导航堆栈中存在页面，并且 可见视图 如果不是导航堆栈中的最后一个视图时，就会屏蔽掉滑动返回的手势。此设置是为了避免页面滑动返回时因动画存在延迟所导致的卡死。
//    if ([gestureRecognizer isEqual:self.interactivePopGestureRecognizer] && self.viewControllers.count > 1 && [self.visibleViewController isEqual:[self.viewControllers lastObject]]) {
//        return YES;
//    } else {
//        return NO;
//    }
//}

@end
