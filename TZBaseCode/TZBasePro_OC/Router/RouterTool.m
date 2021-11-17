//
//  RouterTool.m
//  TZBasePro_OC
//
//  Created by IOS on 2021/11/10.
//

#import "RouterTool.h"
#define TzRouterURL(string) [NSURL URLWithString:string]
@implementation RouterTool

+ (BOOL)loadURL:(NSString *)url {
    
    return [self routeURL:url parameters:nil];
}

+ (BOOL)loadURL:(NSString *)url WithParms:(NSDictionary *)parms{
    
   return [self routeURL:url parameters:parms];
}

+ (void)addRoute:(NSString *)route handler:(BOOL (^)(NSDictionary * _Nonnull parameters))handlerBlock {
    [JLRoutes addRoute:route handler:handlerBlock];
}

#pragma mark - mark JLRouter

+ (BOOL)routeURL:(NSString*)url parameters:(NSDictionary *)parameters{
    
    return [JLRoutes routeURL:TzRouterURL(url) withParameters:parameters];
}

@end
