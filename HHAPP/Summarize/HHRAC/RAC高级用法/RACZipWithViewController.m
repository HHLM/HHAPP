//
//  RACZipWithViewController.m
//  HHAPP
//
//  Created by Now on 2020/6/3.
//  Copyright © 2020 任他疾风起. All rights reserved.
//

#import "RACZipWithViewController.h"

@interface RACZipWithViewController ()

@end

@implementation RACZipWithViewController

#pragma mark zipWith 把两个信号压缩成一个信号，只有两个信号同时发出信号内容时候，才能接收到数据，并把两个信号压缩成一个元组
- (void)viewDidLoad {
    [super viewDidLoad];
    RACSubject *singalA = [RACSubject subject];
    RACSubject *singalB = [RACSubject subject];
    RACSubject *singalC = [RACSubject subject];
    
    [[[singalA zipWith:singalB] zipWith:singalC] subscribeNext:^(RACTuple *x) {
        NSLog(@"zipWith ABC 订阅到的信号内容: %@-%@",x.first,x.last);
    }];
    
    [[singalA zipWith:singalB] subscribeNext:^(RACTuple *x) {
        NSLog(@"zipWith AB 订阅到的信号内容: %@-%@",x.first,x.last);
    }];
    
    [[singalB zipWith:singalC] subscribeNext:^(RACTuple *x) {
           NSLog(@"zipWith BC 订阅到的信号内容: %@-%@",x.first,x.last);
       }];
    
    //只有其中一个信号不发送信息  就不能定接收到信息
    [singalB sendNext:@"信号B"];
    [singalC sendNext:@"信号C"]; //只有singalB 也发送两次 “zipWith BC” 才会打印两次
    
//    [singalA sendNext:@"信号A"];
    [singalC sendNext:@"信号C"];
}


@end
