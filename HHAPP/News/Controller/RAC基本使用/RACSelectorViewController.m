//
//  RACSelectorViewController.m
//  HHAPP
//
//  Created by Now on 2020/5/26.
//  Copyright © 2020 任他疾风起. All rights reserved.
//

#import "RACSelectorViewController.h"
#import "HHTouchView.h"
@interface RACSelectorViewController ()

@property (nonatomic, strong) HHTouchView *touchView;
@property (nonatomic, strong) UITextField *tf;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, assign) NSInteger count;
@end

@implementation RACSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self mainUI];
    [self rac_signalSelector];

    //监听touchView是否调用了touchViewClicked: 方法
    [[self.touchView rac_signalForSelector:@selector(touchViewClicked:name:age:)] subscribeNext:^(RACTuple *_Nullable x) {
        // x是调用方法 里传的参数 有几个参数 x元组中包含几个值
        NSLog(@"调用了touchViewClicked: 方法");
        NSLog(@"%@", x);
    }];
    
    //
    [self rac_liftSelector];
}

- (void)refershMainUIWithData1:(id)data1 data2:(id)data2 {
    NSLog(@"%@---%@", data1, data2);
}


/// 应用场景：需要同时请求多个方法 ，这些方法 完成后然后再去调用 其他方法
- (void)rac_liftSelector {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
        sleep(2);
        [subscriber sendNext:@"请求数据一"];
        return nil;
    }];
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"请求数据二"];
        return nil;
    }];
    [self rac_liftSelector:@selector(refershMainUIWithData1:data2:) withSignalsFromArray:@[signal, signal1]];
}

- (void)rac_signalSelector {
    
    [self.tf.rac_textSignal subscribeNext:^(NSString *_Nullable x) {
        NSLog(@"%@", x);
    }];
    
    //监听手响应了某个方法
    [[self rac_signalForSelector:@selector(touchesBegan:withEvent:)] subscribeNext:^(RACTuple *_Nullable x) {
        NSLog(@"点击了view");
    }];
    //通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"aa" object:nil] subscribeNext:^(NSNotification *_Nullable x) {
    }];

    //KVO
    [[self rac_valuesForKeyPath:@keypath(self, count) observer:self] subscribeNext:^(id _Nullable x) {
        NSLog(@"KVO1：%@", x);
    }];
    [[self rac_valuesAndChangesForKeyPath:@"count" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld observer:self] subscribeNext:^(RACTwoTuple<id, NSDictionary *> *_Nullable x) {
        NSLog(@"KVO2：%@", x);
    }];
    [RACObserve(self, count) subscribeNext:^(id _Nullable x) {
        NSLog(@"KVO3：%@", x);
    }];

    //数据绑定
    RAC(self.titleLab, text) = self.tf.rac_textSignal;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.count++;
}

#pragma mark -
#pragma mark UI

- (void)mainUI {
    self.count = 0;
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, self.view.width-20, 40)];
    tf.placeholder = @"请在此处输入文字，在上面观察文字变化~";
    [self.view addSubview:tf];
    tf.backgroundColor = [UIColor redColor];

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.width - 20, 80)];
    lab.numberOfLines = 0;
    lab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lab];
    tf.backgroundColor = [UIColor redColor];
    lab.backgroundColor = [UIColor cyanColor];
    self.titleLab = lab;
    self.tf = tf;
    [self.view addSubview:self.touchView];
}

- (HHTouchView *)touchView {
    if (!_touchView) {
        _touchView = [[HHTouchView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
        _touchView.backgroundColor = [UIColor redColor];
    }
    return _touchView;
}

@end
