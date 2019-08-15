//
//  HHAdminViewController.m
//  HHAPP
//
//  Created by Now on 2019/5/1.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "HHAdminViewController.h"
#import "HHAdminViewModel.h"
@interface HHAdminViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) HHAdminViewModel *vm;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UIButton *nameBtn;
@end

@implementation HHAdminViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.nameTF];
    [self.view addSubview:self.nameBtn];
    self.nameTF.delegate = self;

    /**
        MVVM UI和Model通过viewModel数据双向绑定：
        点击UI去调用接口改变数据
        监听数据改变从而改变UI
     */
    self.vm = [[HHAdminViewModel alloc] init];
    [self.vm initWithBlock:^(NSArray *_Nonnull array) {
        NSLog(@"%@", array);
        [array.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
            NSLog(@"这是什么：%@--%@",x,[NSThread currentThread]);
        }];
        self.vm.dataArray = [array copy];
    }];
//    [self hh_rac];
//    [self Rac_KVO];
//    [self Rac_NSNotification];
    [self Rac_Gesture];
//    [self Rac_TargetAciotn];
//    [self Rac_Timer];
}

/** KVO */
- (void)Rac_KVO {
    //跳过第一个信号
    [[RACObserve(self.vm, dataArray) skip:1] subscribeNext:^(id _Nullable x) {
        NSLog(@"数据改变了~~~x:%@", x);
        NSLog(@"发送通知！！！");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RAC_NOTIFICATION" object:nil];
    }];
}

/** 通知 */
- (void)Rac_NSNotification {
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RAC_NOTIFICATION" object:nil] subscribeNext:^(NSNotification *_Nullable x) {
        NSLog(@"收到通知了，干干干干！！！");
    }];
}

/** 代理方法 */
- (void)Rac_Protocol {
    [[self.nameTF rac_signalForSelector:@selector(textFieldDidEndEditing:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(id x) {
        // 实现 UITextFieldDelegate: 代理方法
        NSLog(@"%@", x);
    }];
}

/** 手势 */
- (void)Rac_Gesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [self.view addGestureRecognizer:tap];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer *_Nullable x) {
        NSLog(@"点击view的frame：%@",NSStringFromCGRect(self.view.frame));
        [self.view endEditing:YES];
    }];
    
    
}

/** 点击事件 */
- (void)Rac_TargetAciotn {
    [[self.nameBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl *_Nullable x) {
        
    }];
}

/** 定时器 */
- (void)Rac_Timer {
    
    [[RACSignal interval:1 onScheduler:[RACScheduler scheduler]] subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"%@---%@",x,[NSThread currentThread]);
    }];
}

/** 信号过滤 */
- (void)hh_rac {
    //创建一个信号默认是冷信号
    //被订阅后成为热信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"信号"];

        [subscriber sendCompleted];
        return nil;
    }];
    //订阅信号
    [signal subscribeNext:^(id _Nullable x) {
        NSLog(@"x:%@", x);
    } error:^(NSError *_Nullable error) {
        NSLog(@"error:%@", error);
    } completed:^{
        NSLog(@"完成了~~~");
    }];

    [self.nameTF.rac_textSignal subscribeNext:^(NSString *_Nullable x) {
        NSLog(@"x1:%@", x);
    }];
    [[self.nameTF.rac_textSignal flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
        NSLog(@"xxx--value->%@",value);
        return nil;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"xxx--->%@",x);
    }];
    
    // megr 信号合并
    RACSignal *a = [self.nameBtn rac_signalForControlEvents:UIControlEventTouchUpInside];
    RACSignal *b = self.nameTF.rac_textSignal;
    //信号合并
    [[a merge:b] subscribeNext:^(id  _Nullable x) {
        NSLog(@"点击view的frame：%@",NSStringFromCGRect(self.view.frame));
        [self.view endEditing:YES];
    }];
    
    //
    
    // Map创建一个订阅者的映射 并返回数据
    [[self.nameTF.rac_textSignal map:^id _Nullable (NSString *_Nullable value) {
        NSLog(@"map-value:%@", value);
        //可以在处理一些数据然后返回 这里都是处理过的
        return @"我是至尊";
    }] subscribeNext:^(id _Nullable x) {
        NSLog(@"map-x:%@", x);
    }];

    // filter 过滤
    [[self.nameTF.rac_textSignal filter:^BOOL (NSString *_Nullable value) {
        NSLog(@"filter-value:%@", value);
        return NO;
    }] subscribeNext:^(NSString *_Nullable x) {
        NSLog(@"filter-x:%@", x);
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
    RACSignal *signal1 = [[RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"信号1-0"];
        [subscriber sendNext:@"信号1-1"];
        [subscriber sendNext:@"信号1-2"];
        [subscriber sendNext:@"信号1-3"];
        [subscriber sendNext:@"信号1-4"];
        [subscriber sendCompleted];
        return nil;
    }] take:2];

    [signal1 subscribeNext:^(id _Nullable x) {
        NSLog(@"signal1:%@", x);
    }];

    // skip跳过前两个信号
    RACSignal *signal2 = [[RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"信号2-0"];
        [subscriber sendNext:@"信号2-1"];
        [subscriber sendNext:@"信号2-2"];
        [subscriber sendNext:@"信号2-3"];
        [subscriber sendNext:@"信号2-4"];
        [subscriber sendCompleted];
        return nil;
    }] skip:2];
    [signal2 subscribeNext:^(id _Nullable x) {
        NSLog(@"signal2:%@", x);
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
    RACSignal *signal3 = [[RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"信号3-0"];
        [subscriber sendCompleted];
        return nil;
    }] delay:2];
    NSLog(@"延迟2秒发送讯号");
    [signal3 subscribeNext:^(id _Nullable x) {
        NSLog(@"signal3:%@", x);
    }];

    RACSignal *signal4 = [[RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"信号4-0"];
        [subscriber sendCompleted];
        return nil;
    }] throttle:2];
    NSLog(@"延迟2秒发送讯号");
    [signal4 subscribeNext:^(id _Nullable x) {
        NSLog(@"signal3:%@", x);
    }];
    
}

- (UITextField *)nameTF {
    if (!_nameTF) {
        _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(30, 100, 200, 30)];
        _nameTF.placeholder = @"输入文字";
        _nameTF.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _nameTF;
}

- (UIButton *)nameBtn {
    if (!_nameBtn) {
        _nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nameBtn setFrame:CGRectMake(100, 150, 100, 50)];
        _nameBtn.backgroundColor = [UIColor redColor];
        [_nameBtn setTitle:@"点我" forState:UIControlStateNormal];
    }return _nameBtn;
}
@end
