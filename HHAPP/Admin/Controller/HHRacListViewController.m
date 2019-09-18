//
//  HHRacListViewController.m
//  HHAPP
//
//  Created by Now on 2019/9/18.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "HHRacListViewController.h"
#import "HHAdminViewController.h"
#import "HHRacTableView.h"
#import <RACReturnSignal.h>
@interface HHRacListViewController ()

@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) HHRacTableView *tableView;
@end

@implementation HHRacListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RAC总结";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.titlesArray = @[ @[@"RACSignal", @"RACSubject", @"RACReplaySubject"]];
    self.tableView.titlesArray = self.titlesArray;
    RACSubject *subject = [RACSubject subject];
    self.tableView.subject = subject;
    @weakify(self);
    [subject subscribeNext:^(NSNumber *x) {
        @strongify(self);
        [self didSelectIndex:x.integerValue];
    }];
}

- (void)didSelectIndex:(NSInteger)index {
    if (index == 0) {
        [self creatSignal];
    } else if (index == 1) {
        [self creatSubject];
    } else if (index == 2) {
        [self creatReplaySubject];
    }
}

#pragma mark 创建一个信号 订阅信号
- (void)creatSignal {
    //*!!!:应用场景
    //1、创建一个信号
    NSLog(@"1");
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
        // 每当订阅者订阅信号，就会调用block
        //3、发送一个信号
        NSLog(@"3");
        [subscriber sendNext:@"这是发送的一个信号"];
        //5、不在需要发送数据，发送完成  内部就会自动取消订阅信号
        NSLog(@"5");
        [subscriber sendCompleted];
        NSLog(@"6");
        //6、信号被取消：1、主动取消 2、主动取消会调用block
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"7");
            NSLog(@"取消订阅信号");
        }];
    }];

    NSLog(@"2");
    //2、MARK:订阅一个信号  只要订阅信号，就会返回一个取消订阅信号的类
    [signal subscribeNext:^(id _Nullable x) {
        //4、接受到信号
        NSLog(@"4");
    }];
}

- (void)creatSubject {
    //*!!!:应用场景 代替代理 回调数据 先订阅后发送消息
    RACSubject *subject = [RACSubject subject];
    //订阅信号
    [subject subscribeNext:^(id _Nullable x) {
        NSLog(@"第一个订阅：%@", x);
    }];
    //发送信号
    [subject sendNext:@"发送了一个信号1~~~"];
    [subject sendNext:@"发送了一个信号2~~~"];
    [subject subscribeNext:^(id _Nullable x) {
        NSLog(@"第二个订阅：%@", x);
    }];
}

- (void)creatReplaySubject {
    //*!!!:应用场景 重复提供信号
    RACReplaySubject *subject = [RACReplaySubject subject];
    //订阅信号
    [subject subscribeNext:^(id _Nullable x) {
        NSLog(@"第一个Replay订阅：%@", x);
    }];
    //发送信号
    [subject sendNext:@"发送了一个信号1~~~"];
    [subject sendNext:@"发送了一个信号2~~~"];
    [subject subscribeNext:^(id _Nullable x) {
        NSLog(@"第二个Replay订阅：%@", x);
    }];
}

#pragma mark creat UI
- (HHRacTableView *)tableView {
    if (!_tableView) {
        _tableView = [[HHRacTableView alloc] initWithFrame:self.view.bounds];
    }
    return _tableView;
}

@end
