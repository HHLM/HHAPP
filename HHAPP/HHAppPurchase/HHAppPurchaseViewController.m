//
//  HHAppPurchaseViewController.m
//  HHAPP
//
//  Created by Now on 2019/9/20.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "HHAppPurchaseViewController.h"
#import "HHAppPurchaseTool.h"
@interface HHAppPurchaseViewController ()

@end

@implementation HHAppPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
}
- (void)config {
    self.title = @"APPle 内购";
    //添加tableView
    [self addDataView];
    self.tableView.titlesArray = @[@[@"购买套餐一",@"购买套餐二"],@[@"查询漏单"]];
    RACSubject *subject = [RACSubject subject];
    self.tableView.subject = subject;
    @weakify(self);
    [subject subscribeNext:^(NSNumber * x) {
        @strongify(self);
        [self didSelectIndex:x.integerValue];
    }];
}
- (void)didSelectIndex:(NSInteger)index {
    
}

@end
