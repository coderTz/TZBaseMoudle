//
//  TZBaseTabBarVC.h
//  TZBasePro_OC
//
//  Created by IOS on 2021/11/8.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface TabBarModel : NSObject
@property(nonatomic,copy)NSString *  RootVcName;
@property(nonatomic,copy)NSString *SelectImgName;
@property(nonatomic,copy)NSString *Title;
@property(nonatomic,copy)NSString *NorImgName;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN
@interface TZBaseTabBarVC : UITabBarController

- (UITabBarItem *)tabBarItemWithName:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName WithNetWorkUrl:(BOOL)isNetWork;

@end

NS_ASSUME_NONNULL_END
