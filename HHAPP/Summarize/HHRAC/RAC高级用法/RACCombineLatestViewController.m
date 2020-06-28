//
//  RACCombineLatestViewController.m
//  HHAPP
//
//  Created by Now on 2020/6/3.
//  Copyright © 2020 任他疾风起. All rights reserved.
//

#import "RACCombineLatestViewController.h"

@interface RACCombineLatestViewController ()

@end

@implementation RACCombineLatestViewController


#pragma mark combineLastest 将多个信号合并，并且拿到各个信号的最新的值，必须每个合并的siganl至少都有一次sendNext,才会触发
- (void)viewDidLoad {
    [super viewDidLoad];
    RACSubject *singalA = [RACSubject subject];
    RACSubject *singalB = [RACSubject subject];
    RACSubject *singalC = [RACSubject subject];
    
    [[singalA combineLatestWith:singalB] subscribeNext:^(id  _Nullable x) {
        NSLog(@"combineLatestWith AB %@",x);
    }];
    
    [[[singalA combineLatestWith:singalB] combineLatestWith:singalC] subscribeNext:^(id  _Nullable x) {
        NSLog(@"combineLatestWith ABC %@",x);
    }];
    
    [singalA sendNext:@"signalA"];
    [singalB sendNext:@"signalB"];
    [singalC sendNext:@"signalC"];
    
    // 合并的信号 每个必须执行一次sendNext  才会触发订阅
    // 后面合并中任意一个信号只要再次发送信号 就会触发响应
    /* 和zipWith区别:
        相同点 1、都是信号合并 2、合并的信号必须都要发送信号才能触发
        不同点：zipWith要想再次触发 还是必须所有的信号 都要发送才能触发响应
              combineLatestWith 是只有参与合并的任意一个信号发送 就能触发响应
     */
    [singalB sendNext:@"signalB"];
    
    
}


@end
