//
//  HHLikeViewController.m
//  HHAPP
//
//  Created by Now on 2019/5/1.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "HHLikeViewController.h"
#import "HHLikeHeaderView.h"
#import "BadgeButton.h"
#import "BaseTableView.h"
#import <HHExtensionHeader.h>
@interface HHLikeViewController ()
@property (nonatomic, strong) BadgeButton *icon;

@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation HHLikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"iOS底层分析";
    [self addDataView];
    BadgeButton *icon = [[BadgeButton alloc] initWithBadgeButtonType:BadgeButtonOfShowNumber];
    [icon setFrame:CGRectMake(self.view.width/2-20, 20, 40, 40)];
    icon.backgroundColor = [UIColor greenColor];
    icon.badgeValue = @"0";
    self.icon = icon;

    HHLikeHeaderView *header = [[HHLikeHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    [self.view addSubview:header];
    header.backgroundColor = [UIColor cyanColor];
    [header addSubview:icon];
    [self.tableView setTableHeaderView:header];

    NSArray *titleArray = @[@"NSObject"];
    self.titleArray = titleArray;
    self.tableView.titlesArray = titleArray;
    [self addAction];
}

- (void)addAction {
    RACSubject *subject = [RACSubject subject];
    self.tableView.subject = subject;

    [subject subscribeNext:^(NSIndexPath *_Nullable x) {
        NSString *url = [NSString stringWithFormat:@"HHLZXYRoutes://push/HH%@ViewController?title=%@", self.titleArray[x.row],self.titleArray[x.row]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]
                                           options:@{ UIApplicationOpenURLOptionsSourceApplicationKey: @YES }
                                 completionHandler:nil];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.icon.badgeValue integerValue] == 0) {
        self.icon.badgeValue = @"2";
    } else {
        self.icon.badgeValue = @"0";
    }
}

@end
