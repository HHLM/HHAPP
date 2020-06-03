//
//  RACMergeViewController.m
//  HHAPP
//
//  Created by Now on 2020/6/3.
//  Copyright © 2020 任他疾风起. All rights reserved.
//

#import "RACMergeViewController.h"

@interface RACMergeViewController ()

@end

@implementation RACMergeViewController



#pragma mark -
#pragma mark merge 把多个信号信号合并成一个信号，任意一个信号有新值变化就会调用
- (void)viewDidLoad {
    [super viewDidLoad];
    RACSubject *singalA = [RACSubject subject];
    RACSubject *singalB = [RACSubject subject];
    RACSubject *singalC = [RACSubject subject];
    [[[singalA merge:singalB] merge:singalC] subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅内容：%@",x);
    }];
    
    [singalB sendNext:@"信号B"];
    [singalA sendNext:@"信号A"];
    [singalC sendNext:@"信号C"];
}



@end
