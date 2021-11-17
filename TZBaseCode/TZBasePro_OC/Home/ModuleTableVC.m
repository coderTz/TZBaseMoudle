//
//  ModuleTableVC.m
//  TZBasePro_OC
//
//  Created by IOS on 2021/11/9.
//

#import "ModuleTableVC.h"

@interface ModuleTableVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;



@end

@implementation ModuleTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"router参数演示";
    [self tableView];
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"测试回调参数以及action";
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"接收到的参数: name--%@", self.name];
            break;
        case 2:
            cell.textLabel.text = @"暂时未";
            break;

        default:
            break;
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            if (self.callback) {
                self.callback();
            }
            
            if (self.callback2) {
                self.callback2(@"我是回掉参数name");
            }
            break;
        case  1:
            
            break;
            
        default:
            break;
    }
}




#pragma --mark  TZModuleSectionTabProtocol代理实现
- (CGFloat)heightForRow:(NSInteger)row{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSInteger)row{
    return nil;
}
- (void)reloadControl:(id)control row:(NSInteger)row{
    
}


#pragma --mark lazz
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
