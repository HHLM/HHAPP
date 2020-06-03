//
//  RACReplaySubjectViewController.m
//  HHAPP
//
//  Created by Now on 2020/5/25.
//  Copyright © 2020 任他疾风起. All rights reserved.
//

#import "RACReplaySubjectViewController.h"

@interface RACReplaySubjectViewController ()

@end

@implementation RACReplaySubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //保存发送值
    //信号订阅和发送不分先后
    
    //可以先发送信号在订阅信号
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    //遍历值，让一个订阅者去发送多个值
    //只要订阅一次，之前所有发送的值都能获取到
    
    //应用场景：
    //可以先发送，后订阅
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收到信号：%@",x);
    } error:^(NSError * _Nullable error) {
        
    } completed:^{
        
    }];
    [subject sendNext:@"第一次发送信号"];
    [subject sendCompleted];
}

@end
