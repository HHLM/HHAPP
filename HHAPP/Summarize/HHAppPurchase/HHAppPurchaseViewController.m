//
//  HHAppPurchaseViewController.m
//  HHAPP
//
//  Created by Now on 2019/9/20.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "HHAppPurchaseViewController.h"
#import "HHAppPurchaseTool.h"
@interface HHAppPurchaseViewController ()<HHAppPurchaseDelegate>

@end

@implementation HHAppPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
}
- (void)config {
    self.title = @"APPLE 内购";
    [HHAppPurchaseTool shareInstall].delegate = self;
    [[HHAppPurchaseTool shareInstall] starPurchase];
    //添加tableView
    [self addDataView];
    self.tableView.titlesArray = @[@[@"购买套餐一",@"购买套餐二"],@[@"查询漏单"]];
    RACSubject *subject = [RACSubject subject];
    self.tableView.subject = subject;
    @weakify(self);
    [subject subscribeNext:^(NSIndexPath * x) {
        @strongify(self);
        [self didSelectSection:x.section atIndex:x.row];
    }];
}
- (void)didSelectSection:(NSInteger)section atIndex:(NSInteger)index {
    if (section == 0) {
        if (index == 0) {
            [[HHAppPurchaseTool shareInstall] hh_requestProducts:@[@"com.hishake.addStore2998"]];
        }else {
            [[HHAppPurchaseTool shareInstall] hh_requestProducts:@[@"com.hishake.addstore1398"]];
        }
    }else {
        [[HHAppPurchaseTool shareInstall] checkIAPFiles];
    }
}

- (void)failedWithErrorCode:(NSInteger)errorCode {
    
}
- (void)appPurchaseProductIds:(NSArray<NSString *> *)productIds {
    if (productIds.count < 1) {
        return;
    }
    [[HHAppPurchaseTool shareInstall] hh_purchaseProductWihtProductId:@"com.hishake.addStore2998"];
}
- (void)appPurchaseSuccessWithInfo:(NSDictionary *)info {
    
}
- (void)dealloc {
    [[HHAppPurchaseTool shareInstall] stoPurchase];;
}
@end
