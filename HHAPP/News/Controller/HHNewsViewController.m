//
//  HHNewsViewController.m
//  HHAPP
//
//  Created by Now on 2019/5/1.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "HHNewsViewController.h"

@interface HHNewsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, strong) UITableView *table;

@end

@implementation HHNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RAC使用";
    self.titleArray = @[@"RACSignal",
                        @"RACSubject",
                        @"RACReplaySubject",
                        @"RACSequence",
                        @"RACMulticastConnection",
                        @"RACCommand",
                        @"RACSelector"];
    [self.view addSubview:self.table];
}

#pragma mark UITableVieDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat: @" %@",self.titleArray[indexPath.row]];
    cell.detailTextLabel.text = @"副标题";
    cell.imageView.image = [UIImage imageNamed:@"video"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"HHLZXYRoutes://push/%@ViewController?title=%@",self.titleArray[indexPath.row],self.titleArray[indexPath.row]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]
                                       options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES}
                             completionHandler:nil];
}
#pragma mark creat UI
- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:self.view.bounds];
        _table.delegate = self;
        _table.dataSource = self;
        _table.estimatedRowHeight = 100; //设置估计高度
        _table.rowHeight = UITableViewAutomaticDimension;
        _table.estimatedSectionHeaderHeight = 0;
        _table.estimatedSectionFooterHeight = 0;
    }return _table;
}
@end
