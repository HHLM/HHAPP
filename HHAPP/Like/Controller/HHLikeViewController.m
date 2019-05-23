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
    HHLikeHeaderView *header = [[HHLikeHeaderView alloc] initWithFrame:CGRectMake(10, 100, 300, 400)];
    [self.view addSubview:header];
    [header addFirstView];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

@end
