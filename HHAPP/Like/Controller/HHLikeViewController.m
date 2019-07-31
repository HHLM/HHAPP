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
@interface HHLikeViewController ()

@property (nonatomic, strong) BadgeButton* icon;
@end

@implementation HHLikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐";
    
    
    BadgeButton* icon = [[BadgeButton alloc] initWithBadgeButtonType:BadgeButtonOfShowNumber];
    [icon setFrame:CGRectMake(0, 0, 40, 40)];
    icon.backgroundColor = [UIColor greenColor];
    icon.badgeValue = @"0";
    self.icon =icon;
    
    HHLikeHeaderView *header = [[HHLikeHeaderView alloc] initWithFrame:CGRectMake(10, 100, 300, 400)];
    [self.view addSubview:header];
    header.backgroundColor = [UIColor cyanColor];
    [header addSubview:icon];
    [header addFirstView];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   
    if ([self.icon.badgeValue integerValue] == 0) {
         self.icon.badgeValue = @"2";
    }else {
         self.icon.badgeValue = @"0";
    }
    
}

@end
