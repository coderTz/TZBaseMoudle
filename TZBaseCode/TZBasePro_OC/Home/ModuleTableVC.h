//
//  ModuleTableVC.h
//  TZBasePro_OC
//
//  Created by IOS on 2021/11/9.
//

#import "TZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ModuleTableVC : TZBaseViewController

@property(nonatomic, strong) void(^callback)(void);
@property(nonatomic, strong) void(^callback2)(NSString * name);
@property(nonatomic, copy)NSString *name;
@end

NS_ASSUME_NONNULL_END
