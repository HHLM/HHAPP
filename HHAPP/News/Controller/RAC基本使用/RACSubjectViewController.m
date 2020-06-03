//
//  RACSubjectViewController.m
//  HHAPP
//
//  Created by Now on 2020/5/25.
//  Copyright © 2020 任他疾风起. All rights reserved.
//

#import "RACSubjectViewController.h"
#import "HHTouchView.h"
@interface RACSubjectViewController ()

@end

@implementation RACSubjectViewController

/**
 RACSignal：信号
 订阅RACSignal，自动创建RACSubscriber，RACSubscriber发佛那个信号
 RACSignal：只能创发送信号不能订阅信号
 RACSubject和RACReplaySubject:
 既可以订阅又可以发送信号；
 共同点：既可以充当信号也可以充当订阅者
 
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RACSubject *subject = [RACSubject subject];
    
    //先订阅 订阅时候：内部会创建一个RACSubsriber 保存起来
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收到信号：%@",x);
    } error:^(NSError * _Nullable error) {
        
    } completed:^{
        
    }];
    //再发送信号
    [subject sendNext:@"第一次发送信号"];
    [subject sendNext:@"第二次发送信号"];
    [subject sendCompleted];
    
    HHTouchView *touchV = [[HHTouchView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:touchV];
    touchV.backgroundColor = [UIColor redColor];
    RACSubject *sub = [RACSubject subject];
    touchV.subject = sub;
    [sub subscribeNext:^(id  _Nullable x) {
        NSLog(@"点击了：%@",x);
    }];
}

@end
