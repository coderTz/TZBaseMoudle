//
//  MainViewController.m
//  TZBasePro_OC
//
//  Created by IOS on 2021/11/9.
//

#import "MainViewController.h"
#import "TestViewController.h"
@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"demo示例";
    [self tableView];
    
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"普通router跳转(默认push)";
            break;
        case 1:
            cell.textLabel.text = @"带参数以及block回调例子";
            break;
        case 2:
            cell.textLabel.text = @"注意参数区别modea跳转：不带导航栏";
            break;
        case 3:
            cell.textLabel.text = @"注意参数区别modea跳转：带导航栏";
            break;
        case  4:
            cell.textLabel.text = @"拦截登录，可在plist配置亦可参数配置";
            break;
            
            
        default:
            break;
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            [RouterTool loadURL:Route_moudleVc];
        }
        break;
        case 1: {
            [RouterTool loadURL:Route_moudleVc WithParms:@{
                @"name":@"必须要有对应的name属性 否则会崩溃",@"callback2":^(NSString *name){
                NSLog(@"测试回调得name为:%@",name);
            },@"callback":^{
                NSLog(@"测试回调action");
            }
        }];
        }
        break;
        case 2: {
            [RouterTool loadURL:Route_moudleVc WithParms:@{Router_segueStyle:RouterSegueModal,RouterSegueNeedNavigation:@(false)}];
        }
        break;
        case 3: {
            [RouterTool loadURL:Route_moudleVc WithParms:@{Router_segueStyle:RouterSegueModal,RouterSegueNeedNavigation:@(YES)}];
        }
            break;
        case 4: {
            [RouterTool loadURL:Route_test];
            
        }
            break;
            
        default:
            break;
    }
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundView.backgroundColor = UIColor.whiteColor;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
