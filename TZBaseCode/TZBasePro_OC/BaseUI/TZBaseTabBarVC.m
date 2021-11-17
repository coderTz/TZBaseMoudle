//
//  TZBaseTabBarVC.m
//  TZBasePro_OC
//
//  Created by IOS on 2021/11/8.
//

#import "TZBaseTabBarVC.h"
#import "ViewController.h"

@implementation TabBarModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.RootVcName = dic[@"RootVcName"];
        self.Title = dic[@"Title"];
        self.SelectImgName = dic[@"SelectImgName"];
        self.NorImgName = dic[@"NorImgName"];
    }
    return self;
}
+ (instancetype)initWithDictionary:(NSDictionary *)dic{
    return  [[TabBarModel alloc] initWithDic:dic];
}
@end

@interface TZBaseTabBarVC ()<UITabBarControllerDelegate>

@end

@implementation TZBaseTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabWithJsonResource];
    //    /// 去掉黑线
//    self.tabBar.barStyle = UIBarStyleDefault;
    self.delegate = self;
    
    [UITabBar appearance].translucent = NO;
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
  
    [[UITabBar appearance] setShadowImage:[self imageWithColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth,0.5)]];
    [[UITabBar appearance] setBackgroundImage:[self imageWithColor:[UIColor whiteColor] size:CGSizeMake(ScreenWidth, self.tabBar.frame.size.height)]];
   
    /// 设置阴影
    self.tabBar.layer.shadowColor = UIColor.clearColor.CGColor;
    self.tabBar.layer.shadowOpacity = 0.24;
    
    
}
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    if (!color || size.width <=0 || size.height <=0) return nil;
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size,NO, 0);
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, rect);
    
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
- (void)setTabWithJsonResource{
    NSArray * modelArray = [TZCommonTool getJsonWithTabBarOption:@"main"];
    NSMutableArray *vcAray = [NSMutableArray array];
    for (TabBarModel *model in modelArray) {
        [vcAray addObject:[self setTabbarWithModel:model]];
    }
    [self setViewControllers:vcAray];
}

- (UIViewController *)setTabbarWithModel:(TabBarModel *)model{
    Class vc = NSClassFromString(model.RootVcName);
    //父类指针指向子类对象
    UIViewController *viewController = [[vc alloc]init];
    viewController.navigationItem.title = model.Title;
    TZBaseNavgationVC *navig = [[TZBaseNavgationVC alloc] initWithRootViewController:viewController];
    navig.tabBarItem = [self tabBarItemWithName:model.Title image:model.NorImgName selectedImage:model.SelectImgName WithNetWorkUrl:false];
    return navig;
}
//设置tabbar的图标
- (UITabBarItem *)tabBarItemWithName:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName WithNetWorkUrl:(BOOL)isNetWork
{
    UIImage *image = [[self imageWithimage:imageName isUrl:isNetWork] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [[self imageWithimage:selectedImageName isUrl:isNetWork] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:title image:image selectedImage:selectedImage];
    NSDictionary *normalColorDic = @{NSForegroundColorAttributeName:UIColor.blackColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:14]};
    NSDictionary *selectColorDic = @{NSForegroundColorAttributeName:UIColor.redColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:15]};
    
    // 适配iOS13导致的bug
    if (@available(iOS 13.0, *)) {
        // iOS 13以上
        self.tabBar.tintColor = UIColor.whiteColor;
        self.tabBar.unselectedItemTintColor = UIColor.blackColor;
        UITabBarItem *item = [UITabBarItem appearance];
        [item setTitleTextAttributes:selectColorDic forState:UIControlStateSelected];
        item.titlePositionAdjustment = UIOffsetMake(0, -2);
    } else {
        // iOS 13以下
        UITabBarItem *item = [UITabBarItem appearance];
        item.titlePositionAdjustment = UIOffsetMake(0, 1);
        [item setTitleTextAttributes:normalColorDic forState:UIControlStateNormal];
        [item setTitleTextAttributes:selectColorDic forState:UIControlStateSelected];
    }
    return item;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog_d(@"item=%@",item);
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    // 判断哪个界面要需要再次点击刷新，这里以第一个VC为例
//      if ([tabBarController.selectedViewController isEqual:[tabBarController.viewControllers firstObject]]) {
          // 判断再次选中的是否为当前的控制器
//          if ([viewController isEqual:tabBarController.selectedViewController]) {
//              // 执行操作
//              if ([YDGlobal.topViewController isKindOfClass:[YDHomePageViewController class]]) {
//                  if ([self doubleClick]) {
//                      YDHomePageViewController * main = ( YDHomePageViewController*)YDGlobal.topViewController;
//                      [main reloadCurrentVc ];
//                  }
//              }else if ([YDGlobal.topViewController isKindOfClass:[YDPanicBuyPageViewController class]]){
//                  if ([self doubleClick]) {
//                      YDPanicBuyPageViewController * main = ( YDPanicBuyPageViewController*)YDGlobal.topViewController;
//                      [main reloadCurrentVc ];
//                  }
//
//              }
//              return NO;
//          }
      
    return YES;
}
- (UIImage *)imageWithimage:(NSString *)imageName isUrl:(BOOL)isUrl {
   
    UIImage *image ;
    
    if (isUrl) {
      
        NSData *data =[ [NSData alloc] initWithContentsOfURL:URLIMAGENAMED(imageName)];
        
        image = [[UIImage alloc] initWithData:data];
        //tabbar上的图片需要的尺寸 44x44
        CGSize size22 = CGSizeMake(20, 20);
        UIGraphicsBeginImageContextWithOptions(size22, NO, 0.0);
//        UIGraphicsBeginImageContext(size22);
//
        [image drawInRect:CGRectMake(0, 0, size22.width, size22.height)];

        UIImage *newImage2 = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();

        image = newImage2;
        
    }else{
        image = [UIImage imageNamed:imageName];
    }
    
    return image;
}

@end
