
#import <UIKit/UIKit.h>
#import <objc/message.h>
//控制器跳转相关参数配置;
UIKIT_EXTERN NSString *const Router_Back;
UIKIT_EXTERN NSString *const Router_needLogin;// 是否需要登录
// 是否带动画
UIKIT_EXTERN NSString *const RouteAnimated;
UIKIT_EXTERN NSString *const RouteBackIndex;
UIKIT_EXTERN NSString* const RouteBackPage;//指定同级导航栏到此页面
UIKIT_EXTERN NSString *const Router_segueStyle;// 跳转方式 push默认
extern NSString* const RouterSeguePush;  //Push
extern NSString* const RouterSegueModal;

extern NSString* const RouterSegueNeedNavigation;  //Modal
extern NSString* const RouteIndexRoot;  //回到rootVc

// 路由内的参数
extern NSString* const RouteClassName ;
extern NSString* const RouteClassTitle;
extern NSString* const RouteClassFlags ;
extern NSString* const RouteClassNeedLogin;
extern NSString* const router_name;




// app内控制器跳转
extern NSString* const RouteLogin;
extern NSString* const RouteRegister;
extern NSString* const RouteHomeVc;
extern NSString* const router_webView;
extern NSString* const Route_moudleVc;
extern NSString* const Route_test;
