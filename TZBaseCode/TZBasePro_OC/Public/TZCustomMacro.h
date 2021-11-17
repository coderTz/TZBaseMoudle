//
//  TZCustomMacro.h
//  TZBasePro_OC
//
//  Created by IOS on 2021/11/8.
//

#ifndef TZCustomMacro_h
#define TZCustomMacro_h

/*********************************一些宏的定义************************************/
//字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""])||[(_ref) isKindOfClass:[NSNull class]]|| [(_ref) isEqualToString:@"(null)"])
//数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))
// 字典是否为空
#define IsDicEmpty(_ref)    (((_ref) == nil) || ([(_ref) isKindOfClass:[NSNull class]]))
// nsinter是否为空
#define ISNotFoundINinter(_ref) ((_ref) == NSNotFound || (_ref) == 0)
#define WeakSelf __weak typeof(self) weakSelf = self
/********************************* 变量 ************************************/
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth  [[UIScreen mainScreen] bounds].size.width

//宽度适配
#define W(w)  (int)(ScreenWidth / 375.0 * w )
#define H(h)  (int)(ScreenHeight / 667.0 * h )
#define IMAGENAMED(_names)  [UIImage imageNamed:(_names)]

// 单独处理固定不变的图片
#define IMAGENAMED_FIXED(_names)  [UIImage imageNamed:(_names)]
// 商品占位图
#define DD_PLACEHOLDERIMG  IMAGENAMED(@"goods_placeholder")
// banner广告展位图
#define DD_PLACEHOLDERIMG_Banner  IMAGENAMED(@"banner_placeHolder")
// 头像默认
#define APPDefaultAvatar  IMAGENAMED_FIXED(@"mine_user_icon")
// 店铺图片展位图
#define APPShopPic  IMAGENAMED_FIXED(@"shop_hold_pic")
// 加载url图片
#define URLIMAGENAMED(_names)  [NSURL URLWithString:(_names)]
///适配iPhoneX导航栏高度，88
//#define safeAreaTopHeight ((ScreenHeight >= 812.0 && [[UIDevice currentDevice].model isEqualToString:@"iPhone"]) ? 88 : 64)
#define safeAreaTopHeight ([[UIApplication sharedApplication] statusBarFrame].size.height  + 44)
//#define SafeAreaTopIos10Height [YDCommonTools is_Ios10_System] == true?0:safeAreaTopHeight
///适配iPhoneX状态栏高度，44  ios12 48
//#define SafeAreaStatusHeight ((ScreenHeight >= 812.0 && [[UIDevice currentDevice].model isEqualToString:@"iPhone"]) ? 44 : 20)
#define SafeAreaStatusHeight [[UIApplication sharedApplication] statusBarFrame].size.height
/// 适配iPhoneX底部距离，34
#define safeAreaBottomHeight ((ScreenHeight >= 812.0 && [[UIDevice currentDevice].model isEqualToString:@"iPhone"]) ? 34 : 0)
///适配iPhoneX横屏时，左边刘海高度
#define SafeAreaLandscapeLeft ((ScreenHeight >= 812.0 && [[UIDevice currentDevice].model isEqualToString:@"iPhone"]) ? 34 : 0)
///SafeAreaLandscapeBottom
#define SafeAreaLandscapeBottom ((ScreenHeight >= 812.0 && [[UIDevice currentDevice].model isEqualToString:@"iPhone"]) ? 20 : 0)

/// 相对屏幕左右边间距
#define safeAreaMargin 16
#define safeAreaMarginLine 19
/// 上下间距
#define SafeAreaDistance 12


/// 是否是SE 1代手机
#define isiPhoneSE1 (ScreenHeight <= 568 && ScreenWidth == 320) ? true : false
//#define isiPhoneSE1 [[UIDevice supportedDeviceName] isEqualToString:@"iPhoneSE"] ? true : false

/// 是否是SE 代手机
#define isiPhone6 (ScreenHeight == 667 && ScreenWidth == 375) ? true : false



#define SINGLE_LINE_ADJUST_OFFSET (1.0f / [UIScreen mainScreen].scale) / 2

#define SINGLE_LINE_Hight (1 / [UIScreen mainScreen].scale)

#define TABBAR_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)

#define GetX(view) view.frame.origin.x
#define GetY(view) view.frame.origin.y
#define GetWidth(view) view.frame.size.width
#define GetHeight(view) view.frame.size.height
#define RIGHT(view) view.frame.origin.x + view.frame.size.width
#define Bottom(view) view.frame.origin.y + view.frame.size.height


/********************************* Log日志 ************************************/
#ifdef DEBUG
//#define NSLog_d(fmt, ...) NSLog((@"File_name:%s\nFuntion_Name:%s\nlines:%d \n" fmt), [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String] , __FUNCTION__, __LINE__, ##__VA_ARGS__);
#define NSLog_d(fmt, ...) NSLog((@"File_name:%s\n" fmt), [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String] , ##__VA_ARGS__);

//#define NSLog_d(...) printf("%f %s\n",[[NSDatedate]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);

#else
#define NSLog_d(...)
#endif

#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#endif /* TZCustomMacro_h */
