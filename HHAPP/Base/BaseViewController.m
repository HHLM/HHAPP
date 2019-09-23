//
//  BaseViewController.m
//  HHAPP
//
//  Created by Now on 2019/5/1.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)config {
    
}

- (void)addDataView {
    [self.view addSubview:self.tableView];
}

- (HHRacTableView *)tableView {
    if (!_tableView) {
        _tableView = [[HHRacTableView alloc] initWithFrame:self.view.bounds];
        _tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64);
    }return _tableView;
}

@end
