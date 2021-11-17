//
//  RouterTool.h
//  TZBasePro_OC
//
//  Created by IOS on 2021/11/10.
//

#import <Foundation/Foundation.h>
#import "JLRoutes.h"
NS_ASSUME_NONNULL_BEGIN

@interface RouterTool : NSObject

/// 无参数 跳转处理
/// @param url 协议url
+ (BOOL)loadURL:(NSString *)url;

/// 参数 跳转处理
/// @param url 协议url
+ (BOOL)loadURL:(NSString *)url WithParms:(NSDictionary *)parms;

+ (void)addRoute:(NSString *)router handler:(BOOL (^)(NSDictionary *parameters))handlerBlock;//注册 Router,调用 Router 时会触发回调;










@end

NS_ASSUME_NONNULL_END
