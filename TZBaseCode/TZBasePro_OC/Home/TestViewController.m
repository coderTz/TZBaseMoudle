//
//  TestViewController.m
//  TZBasePro_OC
//
//  Created by IOS on 2021/11/17.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试测试十四师";
    self.view.backgroundColor  = UIColor.whiteColor;
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 60, 100, 60)];
    btn.backgroundColor = UIColor.redColor;
    [btn addTarget:self action:@selector(clickss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)clickss{
    [RouterTool loadURL:Route_moudleVc];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
