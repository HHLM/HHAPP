//
//  RACSignalViewController.m
//  HHAPP
//
//  Created by Now on 2020/5/25.
//  Copyright © 2020 任他疾风起. All rights reserved.
//

#import "RACSignalViewController.h"

@interface RACSignalViewController ()

@end

@implementation RACSignalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //万物皆信号
    /**
        掌握这个框架，比较常见的类 类方法
        框架怎么去设计，设计的有那些好的地方
     */

    //信号 => 订阅 (响应式编程思想，只要信号变化立马就通知你)
    //RACSignal:信号，最近本的类
    //RACDisposable:处理数据清空数据
    //RACSubscriber:订阅者，发送信号消息
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

    //不要订阅多次订阅一次就好
    //因为只要订阅就会就会打印 RACSignal的block

#if 0
    [signal subscribeNext:^(id _Nullable x) {
        NSLog(@"信号的传值：%@", x);
    } error:^(NSError *_Nullable error) {
    } completed:^{
    }];
#else

    //订阅信号传的值
    [signal subscribeNext:^(id _Nullable x) {
    }];
    //订阅信号错误信息
    [signal subscribeError:^(NSError *_Nullable error) {
    }];
    //订阅信号完成
    [signal subscribeCompleted:^{
    }];
#endif

    //*!!!: --必须先订阅在发送信号
}

- (void)loadData:(void (^)(id))block {
    block(@"请求到数据~~~");
}

@end
