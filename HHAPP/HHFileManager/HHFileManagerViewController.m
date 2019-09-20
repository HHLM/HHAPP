//
//  HHFileManagerViewController.m
//  HHAPP
//
//  Created by Now on 2019/9/20.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "HHFileManagerViewController.h"
#import "HHFileManager.h"
#import "HHRacTableView.h"
@interface HHFileManagerViewController ()

@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) HHRacTableView *tableView;
@end

@implementation HHFileManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
    [self updataMainUI];
}
- (void)config {
    self.title = @"文件管理";
    self.titlesArray = @[@[@"创建文件夹",@"创建文件",@"遍历文件夹"]];
}
- (void)updataMainUI {
    [self.view addSubview:self.tableView];
    self.tableView.titlesArray = self.titlesArray;
    RACSubject *subject = [RACSubject subject];
    self.tableView.subject = subject;
    @weakify(self);
    [subject subscribeNext:^(NSNumber * x) {
        @strongify(self);
        [self didSelectIndex:x.integerValue];
    }];
}
- (void)didSelectIndex:(NSInteger)index {
    NSLog(@"点击了：%ld",index);
    if (index == 0) {
        [self creatFolder];
    }else if (index == 1) {
        [self saveFile];
    }
}
- (void)creatFolder {
    NSLog(@"%@",NSHomeDirectory());
    [HHFileManager creatFolder:@"HHLM"];
}
- (void)saveFile {
    for (int i = 0; i < 10; i ++) {
        [HHFileManager creatFile:@"1111" fileName:[NSString stringWithFormat:@"text%d.txt",i]];
    }
    
}
- (HHRacTableView *)tableView {
    if (!_tableView) {
        _tableView = [[HHRacTableView alloc] initWithFrame:self.view.bounds];
    }return _tableView;
}
@end
