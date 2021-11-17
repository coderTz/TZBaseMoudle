//
//  TZCommonTool.m
//  TZBasePro_OC
//
//  Created by IOS on 2021/11/9.
//

#import "TZCommonTool.h"
@implementation TZCommonTool


/// 可动态获取tabbar的配置
/// @param option 外部配置
+ (NSArray *)getJsonWithTabBarOption:(id)option{
    // 默认json资源文件
    NSString * jsonName = @"BaseTabBarConfig";
    // 获得路径
    NSString * docStr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
    NSString * jsonPath = [docStr stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",jsonName]];
    NSData * data = [NSData dataWithContentsOfFile:jsonPath];
    // 沙盒中不存在则 本地加载资源文件
    if (data == nil) {
        NSString * filePath = [[NSBundle mainBundle]pathForResource:jsonName ofType:@".json"];
        data = [NSData dataWithContentsOfFile:filePath];
    }
    NSError * error;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error || !data) {
        return [NSArray new];
    }
    NSArray * tempArray =(NSArray *)jsonObj;
    NSMutableArray * array = [NSMutableArray new];
    for (NSDictionary * dic in tempArray) {
        TabBarModel * model = [[TabBarModel alloc] initWithDic:dic];
        [array addObject:model];
    }
    return [array copy];
}

@end
