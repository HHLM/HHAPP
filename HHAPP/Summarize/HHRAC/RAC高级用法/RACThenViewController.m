//
//  RACThenViewController.m
//  HHAPP
//
//  Created by Now on 2020/6/3.
//  Copyright © 2020 任他疾风起. All rights reserved.
//

#import "RACThenViewController.h"

@interface RACThenViewController ()

@end

@implementation RACThenViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    /// then 信号连接 A信号 发送完毕之后才会执行B信号  并且会忽略A信号的值
    RACSubject *subjectA = [RACSubject subject];

    RACSubject *subjectB = [RACReplaySubject subject];

    [[subjectA then:^RACSignal *_Nonnull {
        return subjectB;
    }] subscribeNext:^(id _Nullable x) {
        NSLog(@"订阅信号结果：%@", x);
    }];

    [subjectA sendNext:@"1"];
    [subjectA sendCompleted];
    [subjectB sendNext:@"2"];

    //应用场景：新闻类APP 先获取新闻分类 再去获取分类对应的新闻
}

#pragma mark -
#pragma mark then的使用场景 忽略掉前面得到的数据  只要最后一次的数据
- (void)rac_example {
    [[[[self loadNewsCategory] then:^RACSignal *_Nonnull {
        return [self loadNewsList];
    }] then:^RACSignal * _Nonnull{
        return [self loadNewsList];
    }] subscribeNext:^(id _Nullable x) {
        NSLog(@"接受到数据是:%@", x);
    }];
    
    //平时使用的这样的嵌套模式
//    [self loadNewsCategoryData:^(id data) {
//        [self loadNewsListData:^(id data) {
//            [self loadNewsListData:^(id data) {
//
//            }];
//        }];
//    }];
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
