//
//  RACMulticastConnectionViewController.m
//  HHAPP
//
//  Created by Now on 2020/5/25.
//  Copyright © 2020 任他疾风起. All rights reserved.
//

#import "RACMulticastConnectionViewController.h"

@interface RACMulticastConnectionViewController ()

@end

@implementation RACMulticastConnectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSArray *aaray = [NSArray array];
    [aaray.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        
    }];
    
    //应用场景： 避免多次订阅订阅造成多次执行
    @weakify(self)
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        NSLog(@"-----：RACSignal的block");
        [self loadData:^(id data) {
            //            [subscriber sendNext:@"发送订阅消息"];
            //            [subscriber sendCompleted];
        }];

        //        NSError *error = [[NSError alloc] init];
        //        [subscriber sendError:error];

        return [RACDisposable disposableWithBlock:^{
            //订阅者被销毁的时候执行此处代码
            //订阅者发送完成或者发送失败error时候执行此处代码
            //再此处清空数据
            NSLog(@"RACDisposable的block")
        }];
    }];
    
    
#if 0
    
    //订阅两次 load就会执行两次 实际情况下不需要的这样的
    [signal subscribeNext:^(id  _Nullable x) {
        
    }];
    [signal subscribeNext:^(id  _Nullable x) {
        
    }];
#else
    //使用RACMulticastConnection解决这样的副作用
    RACMulticastConnection *connection = [signal publish];
    
    [connection.signal subscribeNext:^(id  _Nullable x) {
        
    }];
    [connection.signal subscribeNext:^(id  _Nullable x) {
        
    }];
    [connection connect];
    
#endif
}

- (void)loadData:(void (^)(id))block {
    block(@"请求到数据~~~");
}

@end
