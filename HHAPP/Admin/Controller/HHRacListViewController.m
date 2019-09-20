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
#import "HHRacModel.h"
@interface HHRacListViewController ()

@property (nonatomic, strong) HHRacModel *vm;
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSDictionary *infoDict;
@end

@implementation HHRacListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
    [self addDataView];
    self.tableView.titlesArray = self.titlesArray;
    RACSubject *subject = [RACSubject subject];
    self.tableView.subject = subject;
    @weakify(self);
    [subject subscribeNext:^(NSNumber *x) {
        @strongify(self);
        [self didSelectIndex:x.integerValue];
    }];
    [self initViewModel];
}
- (void)config {
    self.title = @"RAC总结";
    self.view.backgroundColor = [UIColor whiteColor];
    self.infoDict = @{@"微软":@"C#",@"苹果":@"Objective-C",@"谷歌":@"Flutter"};
    self.dataArray = @[@{@"name":@"苹果",@"language":@"Objective-C"},
                       @{@"name":@"谷歌",@"language":@"flutter"},
                       @{@"name":@"微软",@"language":@"C#"}];
    
    self.titlesArray = @[ @[@"RACSignal",
                            @"RACSubject",
                            @"RACReplaySubject",
                            @"RACTuble",
                            @"RACCommand",
                            @"RACMulticastConnection"]];
}

- (void)initViewModel {
    HHRacModel *vm = [HHRacModel new];
    self.vm = vm;
    @weakify(self);
    [[vm.command execute:@"MMMMMM"] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
    }];
    [vm initWithRacArrayBlock:^NSDictionary * _Nonnull(id  _Nonnull data) {
        NSLog(@"%@",data);
        return @{@"name":@"小明"};
    }];
    
    [RACObserve(self.vm, name) subscribeNext:^(id  _Nullable x) {
        NSLog(@"监听变化：%@",x);
    }];
    

    
}

- (void)didSelectIndex:(NSInteger)index {
    self.vm.name = @(index).description;
    if (index == 0) {
        [self creatSignal];
    } else if (index == 1) {
        [self creatSubject];
    } else if (index == 2) {
        [self creatReplaySubject];
    } else if (index == 3) {
        [self rac_RACTuple];
    } else if (index == 4) {
        [self creatRACCommand];
    } else if (index == 5) {
        [self creatRACMulticastConnection];
    }
}

- (void)creatRACCommand {
    RACCommand *racCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"发送信号"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    // executionSignals:信号源，包含事件处理的所有信号。
    // executionSignals: signalOfSignals，信号中的信号，就是信号发出的数据也是信号类
    [racCmd.executionSignals subscribeNext:^(id  _Nullable x) {
        NSLog(@"0:%@",x);
        [x subscribeNext:^(id  _Nullable y) {
            NSLog(@"1:%@",y);
        }];
    }];
    
    [racCmd execute:@50];
    
    [racCmd.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"3:%@",x);
    }];
    
    //监听信号是否执行完毕 默认会再来一次 因此跳过一次
    [[racCmd.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue]) {
            NSLog(@"正在执行");
        }else {
            NSLog(@"执行完毕");
        }
        NSLog(@"2:%@",x);
    }];
    
    
//    [[racCmd execute:@"1"] subscribeNext:^(id  _Nullable x) {
//         NSLog(@"%@",x);
//    }];

}
#pragma mark RACTuble 字典转模型
- (void)rac_RACTuple {
    [self.titlesArray.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [self.infoDict.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        RACTupleUnpack(NSString *key,NSString *value) = x;
         NSLog(@"%@--%@",key,value);
        
    }];
    [self.infoDict.rac_keySequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"key:%@",x);
    }];
    [self.infoDict.rac_valueSequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"value:%@",x);
    }];
    
    self.dataArray =  [[self.dataArray.rac_sequence map:^id _Nullable(id  _Nullable value) {
        return @"HHH";
    }] array];
    
    NSLog(@"%@",self.dataArray);
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
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"4");
    }];
}

- (void)creatRACMulticastConnection {
    
    //避免多次掉发送信号
    
    //创建一个信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"发送信号");
        [subscriber sendNext:@"这是发送的一个信号"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"取消订阅信号");
        }];
    }];

    //2.创建连接
    RACMulticastConnection *connet = [signal publish];

    [connet.signal subscribeNext:^(id _Nullable x) {
        //4、接受到信号
        NSLog(@"订阅信号一");
    }];
    
    [connet.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅信号二");
    }];
    
    //激活连接 必须写到订阅的后面
    [connet connect];
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

@end
