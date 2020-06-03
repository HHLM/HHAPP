//
//  RACCommandViewController.m
//  HHAPP
//
//  Created by Now on 2020/5/25.
//  Copyright © 2020 任他疾风起. All rights reserved.
//

#import "RACCommandViewController.h"

@interface RACCommandViewController ()

@end

@implementation RACCommandViewController

/**

 注意点：
    1、内部必须要返回signal
    2、executionSignals信号中的信号，一开始获取不到内部信号
        2-1 switchToLatest：获取内部信号
        2-2 execute：获取内部信号
    3、executing：判断是否正在执行
        3-1 第一次不准确，需要skip，跳过
        3-2 一定要记得sendComplete，否则永远不会执行完成

 */

- (void)viewDidLoad {
    [super viewDidLoad];
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *_Nonnull (id _Nullable input) {
        //command block
        NSLog(@"执行command block");
        return [RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
            //信号blcok
            NSLog(@"执行信号block");

            [subscriber sendNext:@"commamd你好！！！"];
            return nil;
        }];

        //返回空信号
        return [RACSignal empty];
    }];
    [[command execute:@"1"] subscribeNext:^(id _Nullable x) {
        NSLog(@"%@", x);
    }];

    //信号的信号，信号发送信号
    [command.executionSignals subscribeNext:^(id _Nullable x) {
        NSLog(@"executionSignals1:%@", x);
        [x subscribeNext:^(id _Nullable x) {
            NSLog(@"2:%@", x);
        }];
    }];

    //订阅最新的信号
    // switchToLatest：获取最近发送的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id _Nullable x) {
        NSLog(@"switchToLatest:%@", x);
    }];

    //监听命令执行情况  有没有完成
    [command.executing subscribeNext:^(NSNumber *_Nullable x) {
        if (x.boolValue) {
            NSLog(@"正在执行");
        } else {
            NSLog(@"执行完成");
        }
    }];
    
    //skip跳过一次再执行
    [[command.executing skip:1] subscribeNext:^(NSNumber *_Nullable x) {
        if (x.boolValue) {
            NSLog(@"正在执行");
        } else {
            NSLog(@"执行完成");
        }
    }];
}

@end
