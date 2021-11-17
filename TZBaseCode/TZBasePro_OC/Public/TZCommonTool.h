//
//  TZCommonTool.h
//  TZBasePro_OC
//
//  Created by IOS on 2021/11/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TZCommonTool : NSObject

/// 可动态获取tabbar的配置
/// @param option 外部配置
+ (NSArray*)getJsonWithTabBarOption:(id)option;


@end

NS_ASSUME_NONNULL_END
