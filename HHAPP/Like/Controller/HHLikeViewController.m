//
//  HHLikeViewController.m
//  HHAPP
//
//  Created by Now on 2019/5/1.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "HHLikeViewController.h"
#import "HHLikeHeaderView.h"
@interface HHLikeViewController ()

@end

@implementation HHLikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 40, 40)];
    btn.backgroundColor = [UIColor greenColor];
    
    TRBadgeButton* icon = [[TRBadgeButton alloc] initWithCustomUIButton:btn];
    icon.type = TRBadgeButtonOfShowNumber;
    icon.badgeOriginX = 0;
    icon.badgeOriginY = 0;
    icon.badgeValue = @"88";
    self.navigationItem.rightBarButtonItem  = icon;
    HHLikeHeaderView *header = [[HHLikeHeaderView alloc] initWithFrame:CGRectMake(10, 100, 300, 400)];
    [self.view addSubview:header];
    [header addFirstView];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

@end
