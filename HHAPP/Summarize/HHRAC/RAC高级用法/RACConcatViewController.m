//
//  RACConcatViewController.m
//  HHAPP
//
//  Created by Now on 2020/6/3.
//  Copyright © 2020 任他疾风起. All rights reserved.
//

#import "RACConcatViewController.h"

@interface RACConcatViewController ()

@end

@implementation RACConcatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    RACSubject *subjectA = [RACSubject subject];
    RACSubject *subjectB = [RACReplaySubject subject];

    /// concat 信号拼接： 按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号。
    /// 一个信号completed后再订阅另一个，失败后不会再订阅
    /// 示例： A信号发送完成才会发送 B信号
    [[subjectA concat:subjectB] subscribeNext:^(id _Nullable x) {
        NSLog(@"订阅%@", x);
    }];

    [subjectA sendNext:@"A信号"];
    [subjectA sendCompleted];
    [subjectB sendNext:@"B信号"];
    //⚠️ 必须是A信号发送完成才会发送B信号
    //若是先发送B信号再发送A信号  还想得的B发的信号 那B信号就要用 RACReplaySubject
}

#pragma mark -
#pragma mark concat 的使用场景 请求顺序执行 前面的执行完毕之后才能执行后面的 最后把每次执行的数据 顺序返回
- (void)rac_example {
    [[[self loadNewsCategory] concat:[self loadNewsList]] subscribeNext:^(id _Nullable x) {
        NSLog(@"接受到数据是:%@", x);
    }];
    [[[self loadNewsList] filter:^BOOL(id  _Nullable value) {
        return value;
    }] subscribeNext:^(id  _Nullable x) {
        
    }];
    [[[self loadNewsList] map:^id _Nullable(id  _Nullable value) {
        return value;
    }] subscribeNext:^(id  _Nullable x) {
        
    }];
    [[[self loadNewsList] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return nil;
    }] subscribeNext:^(id  _Nullable x) {
        
    }];
}

/** 获取分类数据 得到一个信号 */
- (RACSignal *)loadNewsCategory {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
        [self loadNewsCategoryData:^(id data) {
            [subscriber sendNext:data];
            [subscriber sendCompleted];
        }];
        return [RACDisposable disposableWithBlock:^{
        }];
    }];
    return signal;
}

/** 获取分类数据 得到一个信号 */
- (RACSignal *)loadNewsList {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
        [self loadNewsListData:^(id data) {
            [subscriber sendNext:data];
            [subscriber sendCompleted];
        }];
        return [RACDisposable disposableWithBlock:^{
        }];
    }];
    return signal;
}

/** 获取新闻分类数据 */
- (void)loadNewsCategoryData:(void (^)(id data))success {
    success(@"获取到分类数据");
}

/** 获取新闻列表数据 */
- (void)loadNewsListData:(void (^)(id data))success {
    success(@"获取到类表数据");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self rac_example];
}

@end
