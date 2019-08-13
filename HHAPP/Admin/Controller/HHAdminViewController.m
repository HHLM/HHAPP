//
//  HHAdminViewController.m
//  HHAPP
//
//  Created by Now on 2019/5/1.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "HHAdminViewController.h"

@interface HHAdminViewController ()

@property (nonatomic, strong) UITextField *nameTF;
@end

@implementation HHAdminViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.nameTF];
    // 代理方法
    [[self rac_signalForSelector:@selector(webViewDidStartLoad:)
      fromProtocol:@protocol(UIWebViewDelegate)]
     subscribeNext:^(id x) {
         // 实现 webViewDidStartLoad: 代理方法
     }];
    
    //创建一个信号默认是冷信号
    //被订阅后成为热信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"信号"];
        
        [subscriber sendCompleted];
        return nil;
    }];

    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"x:%@",x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"error:%@",error);
    } completed:^{
        NSLog(@"完成了~~~");
    }];
    
    [self.nameTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"x1:%@",x);
    }];
    // Map创建一个订阅者的映射 并返回数据
    [[self.nameTF.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        NSLog(@"map-value:%@",value);
        return @"我是至尊";
    }] subscribeNext:^(id  _Nullable x) {
         NSLog(@"map-x:%@",x);
    }];
    
    // filter 过滤
    [[self.nameTF.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        NSLog(@"filter-value:%@",value);
        return NO;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"filter-x:%@",x);
    }];
    
    // ignore 忽略
    [[[self.nameTF rac_textSignal] ignore:@"good"] subscribeNext:^(id x) {
        NSLog(@"ignore：%@", x);
    }];
    
    //throttle 0.5s内信号不变化才处理
    [[[self.nameTF rac_textSignal] throttle:0.5] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    //distinctUntilChanged 两次相同的信号不处理
    [[[self.nameTF rac_textSignal] distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    // take 执行前两个信号
    RACSignal *signal1 = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"信号1-0"];
        [subscriber sendNext:@"信号1-1"];
        [subscriber sendNext:@"信号1-2"];
        [subscriber sendNext:@"信号1-3"];
        [subscriber sendNext:@"信号1-4"];
        [subscriber sendCompleted];
        return nil;
    }] take:2];
    
    [signal1 subscribeNext:^(id  _Nullable x) {
        NSLog(@"signal1:%@",x);
    }];
    
    // skip跳过前两个信号
    RACSignal *signal2 = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"信号2-0"];
        [subscriber sendNext:@"信号2-1"];
        [subscriber sendNext:@"信号2-2"];
        [subscriber sendNext:@"信号2-3"];
        [subscriber sendNext:@"信号2-4"];
        [subscriber sendCompleted];
        return nil;
    }] skip:2];
    [signal2 subscribeNext:^(id  _Nullable x) {
        NSLog(@"signal2:%@",x);
    }];
    
    /*
    // repeat 重复发送讯号
    RACSignal *signal3 = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"信号3-0"];
        [subscriber sendCompleted];
        return nil;
    }] repeat];
    [signal3 subscribeNext:^(id  _Nullable x) {
        NSLog(@"signal3:%@",x);
    }];
     */
    
    // delay 延迟发送信号
    RACSignal *signal3 = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"信号3-0"];
        [subscriber sendCompleted];
        return nil;
    }] delay:2];
    NSLog(@"延迟2秒发送讯号");
    [signal3 subscribeNext:^(id  _Nullable x) {
        NSLog(@"signal3:%@",x);
    }];
    
    RACSignal *signal4 = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"信号4-0"];
        [subscriber sendCompleted];
        return nil;
    }] throttle:2];
    NSLog(@"延迟2秒发送讯号");
    [signal4 subscribeNext:^(id  _Nullable x) {
        NSLog(@"signal3:%@",x);
    }];
    
    
}

- (UITextField *)nameTF {
    if (!_nameTF) {
        _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(30, 100, 200, 30)];
        _nameTF.placeholder = @"输入文字";
    }return _nameTF;
}
@end
