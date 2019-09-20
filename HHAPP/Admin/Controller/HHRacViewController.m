//
//  HHRacViewController.m
//  HHAPP
//
//  Created by Now on 2019/9/18.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "HHRacViewController.h"
#import "HHRacListViewController.h"
#import "HHAdminViewController.h"
#import "HHFileManagerViewController.h"
#import <RACReturnSignal.h>
@interface HHRacViewController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *titlesArry;
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) UITableView *table;
@end
@implementation HHRacViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
    [self.view addSubview:self.table];
    
    
}
- (void)config {
    self.title = @"工具总结";
    self.view.backgroundColor = [UIColor whiteColor];
    self.titlesArry = @[@"RAC使用",@"RAC总结",@"文件管理",@"iOS内购"];
    self.viewControllers = @[@"HHAdminViewController",
                             @"HHRacListViewController",
                             @"HHFileManagerViewController",
                             @"HHAppPurchaseViewController"];
}

#pragma mark UITableVieDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [BaseTableViewCell creatCellWithTable:tableView];
    cell.textLabel.text = self.titlesArry[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Class cls = NSClassFromString(self.viewControllers[indexPath.row]);
    BaseViewController *vc = [[cls alloc] init];
    vc.title = self.titlesArry[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark creat UI
- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.estimatedRowHeight = 100; //设置估计高度
        _table.rowHeight = UITableViewAutomaticDimension;
        _table.estimatedSectionHeaderHeight = 0;
        _table.estimatedSectionFooterHeight = 0;
    }return _table;
}
@end
