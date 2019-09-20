//
//  HHRacTableView.m
//  HHAPP
//
//  Created by Now on 2019/9/18.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "HHRacTableView.h"
#import "BaseTableViewCell.h"
@interface HHRacTableView()<UITableViewDelegate,UITableViewDataSource>
//是否是多维数组 default YES 多维 , NO 一层
@property (nonatomic, assign) BOOL space;
@end
@implementation HHRacTableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        self.space = YES;
        self.delegate = self;
        self.dataSource = self;
        self.estimatedRowHeight = 100; //设置估计高度
        self.rowHeight = UITableViewAutomaticDimension;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
    }
    return self;
}
- (void)setTitlesArray:(NSArray *)titlesArray {
   
//*!!!:若第一个数据不是数组 就把所有的数据都取出添加到一个新的数组中
    if (![titlesArray.firstObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *allArray = [NSMutableArray array];
        for (int i = 0 ; i < titlesArray.count; i++) {
            if ([titlesArray[i] isKindOfClass:[NSArray class]]) {
                [allArray addObjectsFromArray:titlesArray[i]];
            }else {
                [allArray addObject:[NSString stringWithFormat:@"%@",titlesArray[i]]];
            }
        }
        self.space = NO;
        _titlesArray = [allArray copy];
    }else {
        self.space =  YES;
        _titlesArray = titlesArray;
    }
    [self reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.space ? _titlesArray.count : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.space ? [_titlesArray[section] count] : _titlesArray.count;
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
    cell.textLabel.text = _titlesArray[indexPath.section][indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.subject) {
        [self.subject sendNext:@(indexPath.row)];
    }
}
@end
