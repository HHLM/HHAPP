//
//  BaseTableView.m
//  HHAPP
//
//  Created by Now on 2019/5/1.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "BaseTableView.h"
#import "UIView+HHExt.h"
#import "BaseTableViewCell.h"
@interface BaseTableView ()<UITableViewDelegate, UITableViewDataSource>

@end
@implementation BaseTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (void)initConfig {
    self.delegate = self;
    self.dataSource = self;
    self.estimatedRowHeight = 40; //设置估计高度
    self.rowHeight = UITableViewAutomaticDimension;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self reloadData];
}

#pragma mark UITableVieDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [BaseTableViewCell creatCellWithTable:tableView];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
