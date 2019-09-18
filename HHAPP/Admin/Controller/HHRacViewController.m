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
#import <RACReturnSignal.h>
@interface HHRacViewController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@end
@implementation HHRacViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RAC";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark UITableVieDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = indexPath.row ? @"RAC总结" : @"RAC的使用";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row) {
        HHRacListViewController *vc = [[HHRacListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    HHAdminViewController *vc = [[HHAdminViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark creat UI
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 100; //设置估计高度
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }return _tableView;
}
@end
