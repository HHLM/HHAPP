//
//  HHRacSignalViewController.m
//  HHAPP
//
//  Created by Now on 2019/9/23.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "HHRacSignalViewController.h"
#import "HHRacModel.h"
#import <ReactiveObjC/RACReturnSignal.h>

static NSString *const NotificationName = @"HH_RAC_NSNOTIFICATION_NAME";

@interface HHRacSignalViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) HHRacModel *racModel;
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UIButton *nameBtn;
@property (nonatomic, strong) UIView *headView;
@end

@implementation HHRacSignalViewController

//*!!!:RAC开发核心Bind（绑定）

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
    [self addDataView];
}
- (void)hh_popViewController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)config {
    self.title = @"RAC使用";
    self.racModel = [[HHRacModel alloc] init];
    self.racModel.name = @"我是一直小青蛙，呱呱呱~~~";
    self.titlesArray = @[@[@"代理", @"通知", @"KVO", @"手势", @"点击事件", @"倒计时"],
                         @[@"1、liftSelector", @"2、map信号映射",@"3、concat信号连接",@"4、then信号连接",
                           @"5、merge信号合并",@"6、zipWith信号压缩",@"7、combineLatest信号合并",
                           @"8、filter信号过滤",@"9、ignore信号忽略",@"10、distinctUntilChanged",
                           @"11、take信号获取前面",@"12、takeLast信号获取后面",@"13、takeUntil",@"14、skip信号跳过",
                           @"15、switchToLatest信号的信号",@"16、doNext/doCompleted"],
                         @[@"1、deliverOn",@"2、subscribeOn",@"3、timeout超时",@"4、interval定时",@"5、delay延迟发送next",
                           @"6、retry重试",@"7、replay重发",@"8、throttle截流"]];
    [self.tableView setTableHeaderView:self.headView];
    self.tableView.titlesArray = self.titlesArray;
    RACSubject *subject =  [RACSubject subject];
    self.tableView.subject = subject;
    @weakify(self);
    [subject subscribeNext:^(NSIndexPath *x) {
        @strongify(self);
        [self didSelectSection:x.section atIndex:x.row];
    }];
    [self hh_rac_base];
}

//*!!!: RAC基本使用方法 --------我是分割线---------
- (void)hh_rac_base {
    [self hh_rac_textField];
    [self hh_rac_Protocol];
    [self hh_rac_KVO];
    [self hh_rac_NSNotification];
    [self hh_rac_GestureRecognizer];
    [self hh_rac_target];

    //*!!!:宏定义 RAC、RACTuplePack、RACTupleUnpack

    /*
     self.nameBtn.titleLabel的text属性绑定到self.nameTF上 这样self.nameTF值发生变化
     self.nameBtn.titleLabel的text也跟着变化
    */
    RAC(self.nameBtn.titleLabel, text) = self.nameTF.rac_textSignal;

    RACTuple *tuple = RACTuplePack(@2015, @1, @3);
    //把数据包装成RACTuple（元组类）。把包装的类型放在宏的参数里面，就会自动包装。
    NSLog(@"tuple:%@", tuple);

    //把RACTuple（元组类）解包成对应的数据。等号的右边表示解析哪个元组。宏的参数:表示解析成什么类型。
    RACTupleUnpack(NSNumber * number1, NSNumber * number2, NSNumber * number3) = tuple;
    NSLog(@"number1:%@-number2:%@-number3:%@", number1, number2, number3);
}

/** 监听文本框文字变化 */
- (void)hh_rac_textField {
    [[self.nameTF rac_textSignal] subscribeNext:^(NSString *_Nullable x) {
        NSLog(@"nameTF文字:%@", x);
    }];
    [[self.nameTF.rac_textSignal map:^id _Nullable (NSString *_Nullable value) {
        if (value.length > 5) {
            return [value substringToIndex:5];
        }
        return value;
    }] subscribeNext:^(id _Nullable x) {
        NSLog(@"map输出：%@", x);
    }];

    [[self.nameTF.rac_textSignal flattenMap:^__kindof RACSignal *_Nullable (NSString *_Nullable value) {
        NSString *string = value;
        if (value.length > 5) {
            string = [value substringToIndex:5];
        }
        return [RACReturnSignal return :string];
    }] subscribeNext:^(id _Nullable x) {
        NSLog(@"flattenMap输出：%@", x);
    }];
}

#pragma mark protocol代理
/// 判断有没有调用textFieldShouldBeginEditing方法如果有就发送信号
- (void)hh_rac_Protocol {
    [[self rac_signalForSelector:@selector(textFieldDidBeginEditing:)] subscribeNext:^(RACTuple *_Nullable x) {
        NSLog(@"rac_protocol:%@", x);
    }];
}

#pragma mark KVO监听
- (void)hh_rac_KVO {
    [RACObserve(self.racModel, name) subscribeNext:^(id _Nullable x) {
        NSLog(@"hh_rac_KVO:%@", x);
    }];
}

#pragma mark 通知
- (void)hh_rac_NSNotification {
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:NotificationName object:nil] subscribeNext:^(NSNotification *_Nullable x) {
        NSLog(@"rac_Notification:%@", x);
    }];
}

#pragma mark 手势
- (void)hh_rac_GestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [self.headView addGestureRecognizer:tap];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer *_Nullable x) {
        NSLog(@"rac_GestureRacognizer:%@", x);
    }];
}

#pragma mark UIControl添加target
- (void)hh_rac_target {
    [[self.nameBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl *_Nullable x) {
        self.racModel.name = @"呱呱呱呱呱呱~~~";
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName object:@"Rac_NSNotification"];
        NSLog(@"rac_target：%@", x);
    }];
}

//*!!!: RAC基本操作 -------我是分割线----------
#pragma mark bind
- (void)hh_rac_bind {
//    [[self.nameTF.rac_textSignal bind:^RACStreamBindBlock{
//       // 什么时候调用:
//       // block作用:表示绑定了一个信号.
//       return ^RACStream *(id value, BOOL *stop){
//           // 什么时候调用block:当信号有新的值发出，就会来到这个block。
//           // block作用:做返回值的处理
//           // 做好处理，通过信号返回出去.
//           return [RACReturnSignal return:[NSString stringWithFormat:@"输出:%@",value]];
//       };
//    }] subscribeNext:^(id x) {
//       NSLog(@"%@",x);
//    }];
}

#pragma mark map、flattenMap 用于把源信号内容映射成新的内容
- (void)hh_rac_map {
    //map 映射成一个新的内容
    [[self.nameTF.rac_textSignal map:^id _Nullable (NSString *_Nullable value) {
        if (value.length > 5) {
            return [value substringToIndex:5];
        }
        return value;
    }] subscribeNext:^(id _Nullable x) {
        NSLog(@"map输出：%@", x);
    }];

    //flattenMap 把源信号的内容映射成一个新的信号，信号可以是任意类型。
    [[self.nameTF.rac_textSignal flattenMap:^__kindof RACSignal *_Nullable (NSString *_Nullable value) {
        NSString *string = value;
        if (value.length > 5) {
            string = [value substringToIndex:5];
        }
        return [RACReturnSignal return :string];
    }] subscribeNext:^(id _Nullable x) {
        NSLog(@"flattenMap输出：%@", x);
    }];
    
    RACSubject *signalOfSignal = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    [[signalOfSignal flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return value;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [signalOfSignal sendNext:signal];
    [signal sendNext:@"11111"];
}


//*!!!: RAC 信号连接
#pragma mark  concat 信号拼接
/// 按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号。
///  一个信号completed后在订阅另一个，失败后不会再订阅
- (void)hh_rac_concat {
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"发送第一个信号"];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"发送第二个信号"];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signalC = [RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"发送第三个信号"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signal = [[signalA concat:signalB] concat:signalC];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"rac_concat:%@",x);
    }];
}

#pragma mark then 用于连接两个信号，一个完成后才会连接then返回的信号
/// 使用then，之前信号的值会被忽略
- (void)hh_rac_then {
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"then之前的信号"];
        [subscriber sendCompleted];
        return nil;
    }]then:^RACSignal * _Nonnull{
        return  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"then后的信号"];
            [subscriber sendCompleted];
            return nil;
        }];
    }] subscribeNext:^(id  _Nullable x) {
        //这里只能接受then后的信号信号
        NSLog(@"rac_then:%@",x);
    }];;
    
}

#pragma mark merge 把多个信号信号合并成一个信号，任意一个信号有新值变化就会调用
- (void)hh_rac_merge {
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
           [subscriber sendNext:@"发送第一个信号"];
           [subscriber sendCompleted];
           return nil;
       }];
       RACSignal *signalB = [RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
           [subscriber sendNext:@"发送第二个信号"];
           [subscriber sendCompleted];
           return nil;
       }];
       RACSignal *signalC = [RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
           [subscriber sendNext:@"发送第三个信号"];
           [subscriber sendNext:@"发送第三个信号1"];
           [subscriber sendCompleted];
           return nil;
       }];
    RACSignal *signal = [[signalA merge:signalB] merge:signalC];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"rac_merge:%@",x);
    }];
}

#pragma mark zipWith 把两个信号压缩成一个信号，只有两个信号同时发出信号内容时候，并把两个信号压缩成一个元组
- (void)hh_rac_zipWith {
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
           [subscriber sendNext:@"发送第二个信号"];
           [subscriber sendCompleted];
           return nil;
       }];
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
       [subscriber sendNext:@"发送第三个信号"];
       [subscriber sendCompleted];
       return nil;
    }];
    
    RACSignal *signal = [signalA zipWith:signalB];
    [signal subscribeNext:^(RACTuple *x) {
        RACTupleUnpack(id value,id value1) = x;
        NSLog(@"rac_zipWith:%@--%@",value,value1);
    }];
    
}

#pragma mark combineLastest 将多个信号合并，并且拿到各个信号的最新的值，必须每个合并的siganl至少都有一次sendNext,才会触发
- (void)hh_rac_combineLatest {
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
           [subscriber sendNext:@"发送B信号"];
           [subscriber sendCompleted];
           return nil;
       }];
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
       [subscriber sendNext:@"发送A信号"];
       [subscriber sendCompleted];
       return nil;
    }];
    
    RACSignal *signal = [signalA combineLatestWith:signalB];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"rac_combineLastest:%@",x);
    }];
    
}


//MARK: RAC 信号过滤

#pragma mark filter 过滤信号
- (void)hh_rac_filter {
    [[self.nameTF.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return value.length > 3; //大于3的才能发送信号
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"rac_filter:%@",x);
    }];
}

#pragma mark ignore 忽略信号
- (void)hh_rac_ignore {
    //会和忽略掉4
    [[self.nameTF.rac_textSignal ignore:@"4"] subscribeNext:^(NSString * _Nullable x) {
         NSLog(@"rac_ignore:%@",x);
    }];;
}


#pragma mark distinctUntilChanged 当上一次的值和当前的值有明显的变化就会发出信号，否则会被忽略掉
- (void)hh_rac_distinctUntilChanged {
    //会和忽略掉4 应用场景 刷新UI界面  数据不同时候才刷新
    [[self.nameTF.rac_textSignal distinctUntilChanged] subscribeNext:^(NSString * _Nullable x) {
         NSLog(@"rac_distinctUntilChanged:%@",x);
    }];;
}

#pragma mark take 从开始一共取N次的信号
- (void)hh_rac_take {
    RACSubject *subject = [RACSubject subject];
    [[subject take:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"rac_take:%@",x);
    }];
    [subject sendNext:@"take:第1次发送信号"];
    [subject sendNext:@"take:第2次发送信号"];
    [subject sendNext:@"take:第3次发送信号"];
}

#pragma mark takeUntil 获取信号直到某个信号执行完成（监听文本框的改变直到当前对象被销毁）
- (void)hh_rac_takeUntil {
    [[self.nameTF.rac_textSignal takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"rac_takeUntil:%@",x);
    }];;
}

#pragma mark take 取最后N次的信号

/// 前提条件，订阅者必须调用完成，因为只有完成，就知道总共有多少信号。
- (void)hh_rac_takeLast {
    RACSubject *subject = [RACSubject subject];
    [[subject takeLast:1] subscribeNext:^(id  _Nullable x) {
        NSLog(@"rac_takeLast:%@",x);
    }];
    [subject sendNext:@"takeLast:第1次发送信号"];
    [subject sendNext:@"takeLast:第2次发送信号"];
    [subject sendNext:@"takeLast:第3次发送信号"];
    [subject sendCompleted];
}

#pragma mark skip 跳过信号
- (void)hh_rac_skip {
    //skipWhileBlock 当符合block逻辑时跳过
    //skipUntilBlock 直到block逻辑停止跳过
   
    RACSubject *subject = [RACSubject subject];
    [[subject skip:1] subscribeNext:^(id  _Nullable x) {
        NSLog(@"rac_skip:%@",x);
    }];
    [subject sendNext:@"skip:第1次发送信号"];
    [subject sendNext:@"skip:第2次发送信号"];
    [subject sendNext:@"skip:第3次发送信号"];
}

#pragma mark 用于signalOfSignals（信号的信号），有时候信号也会发出信号，会在signalOfSignals中，获取signalOfSignals发送的最新信号。
- (void)hh_rac_switchToLatest {
    RACSubject *signalOfSignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    [signalOfSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"rac_switchToLatest:%@",x);
    }];
    [signalOfSignals sendNext:signal];
    [signal sendNext:@1];
}

#pragma mark 用于doNext/doCompleted
- (void)hh_rac_doNext {
    [[[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"开始发送信号");
        [subscriber sendNext:@"20150103"];
        [subscriber sendCompleted];
        return nil;
    }] doNext:^(id  _Nullable x) {
        NSLog(@"doNext:%@",x);
        // 执行[subscriber sendNext:@1];之前会调用这个Block
    } ] doCompleted:^{
        //执行[subscriber sendCompleted];之前会调用这个Block
        NSLog(@"执行[subscriber sendCompleted];之前会调用这个Block");;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"rac_doNext:%@",x);
    }];;
}


#pragma mark liftSelector
///应用场景： 当页面需要处理多个请求，并且都需要获取数据时候才能展示界面使用。
- (void)hh_rac_liftSelector {
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                           [subscriber sendNext:@"发送第一个信号"];
                           [subscriber sendCompleted];
                       });
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"发送第二个信号"];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signalC = [RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"发送第三个信号"];
        [subscriber sendCompleted];
        return nil;
    }];
    //[self rac_liftSelector:@selector(hh_doSomethingSignalA:andSignalB:) withSignals:signalA,signalB, nil];
    [self rac_liftSelector:@selector(hh_doSomethingSignalA:andSignalB:andSignalC:) withSignalsFromArray:@[signalA, signalB, signalC]];
}

- (void)hh_doSomethingSignalA:(NSString *)signalA
                   andSignalB:(NSString *)signalB
                   andSignalC:(NSString *)signalC {
    NSLog(@"signalA:%@--\nsignalB:%@--\nsignalC:%@", signalA, signalB, signalC);
}


//*!!!: RAC线程操作
#pragma mark timeOut超时 可以让一个信号在一定的时间后，自动报错。
- (void)hh_rac_timeOut {
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"timeOut"];
        return nil;
    }] timeout:1 onScheduler:[RACScheduler currentScheduler]];

    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"rac_timeOut:%@",x);
    } error:^(NSError * _Nullable error) {
         NSLog(@"rac_timeOut 1s后自动调用：%@",error);
    }];
}

#pragma mark interval 定时发送信号
- (void)hh_rac_interval {
    //定时发出一个信号
    [[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"rac_interval:%@",x);
    }];;
}

#pragma mark delay延迟发送信号
- (void)hh_rac_delay {
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"delay信号"];
        [subscriber sendCompleted];
        return nil;
    }] delay:1] subscribeNext:^(id  _Nullable x) {
        NSLog(@"rac_delay:%@",x);
    }];
}

#pragma mark retry 只要失败重新发送信号
- (void)hh_rac_retry {
    __block int i = 0;
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        if (i == 10) {
            [subscriber sendNext:@"retry信号"];
            [subscriber sendCompleted];
        }else {
            [subscriber sendError:nil];
        }
        return nil;
    }] retry] subscribeNext:^(id  _Nullable x) {
        NSLog(@"retry:%@",x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"retey:%@",error);
    }];
}

#pragma mark replay  当一个信号被多次订阅，反复播放内容
- (void)hh_rac_replay {
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       [subscriber sendNext:@1];
       [subscriber sendNext:@2];
       return nil;
    }] replay];
        
    [signal subscribeNext:^(id x) {
       NSLog(@"rac_replay:第一个订阅者%@",x);
    }];
        
    [signal subscribeNext:^(id x) {
       NSLog(@"rac_replay:第二个订阅者%@",x);
    }];
}
#pragma mark throttle 截流 :当某个信号发送比较频繁时，可以使用截流，在某一段时间不发送信号内容，过了一段时间获取信号的最新内容发出。

/// 应用场景：常用于即时搜索优化，防止频繁发出请求。
- (void)hh_rac_throttle {
    //0.5内的信号变化不考虑
    RACSubject *subject = [RACSubject subject];
    [[subject throttle:0.5] subscribeNext:^(id  _Nullable x) {
        NSLog(@"throtte:%@",x);
    }];
}
#pragma mark tableView点击事件
- (void)didSelectSection:(NSInteger)section atIndex:(NSInteger)index {
    if (section == 1) {
        if (index == 0) {
            [self hh_rac_liftSelector];
        } else if (index == 1) {
            [self hh_rac_map];
        }else if (index == 2) {
            [self hh_rac_concat];
        }else if (index == 3) {
            [self hh_rac_then];
        }else if (index == 4) {
            [self hh_rac_merge];
        }else if (index == 5) {
            [self hh_rac_zipWith];
        }else if (index == 6) {
            [self hh_rac_combineLatest];
        }else if (index == 7) {
            [self hh_rac_filter];
        }else if (index == 8) {
            [self hh_rac_ignore];
        }else if (index == 9) {
            [self hh_rac_distinctUntilChanged];
        }else if (index == 10) {
            [self hh_rac_take];
        }else if (index == 11) {
            [self hh_rac_takeLast];
        }else if (index == 12) {
            [self hh_rac_takeUntil];
        }else if (index == 13) {
            [self hh_rac_skip];
        }else if (index == 14) {
            [self hh_rac_switchToLatest];
        }else if (index == 15) {
            [self hh_rac_doNext];
        }
        
    }else if (section == 2) {
        if (index == 0) {
            
        }else if (index == 1) {
            
        }else if (index == 2) {
            [self hh_rac_timeOut];
        }else if (index == 3) {
            [self hh_rac_interval];
        }else if (index == 4) {
            [self hh_rac_delay];
        }else if (index == 5) {
            [self hh_rac_retry];
        }else if (index == 6) {
            [self hh_rac_replay];
        }else if (index == 7) {
            [self hh_rac_throttle];
        }else if (index == 8) {
            
        }else if (index == 9) {
            
        }else if (index == 10) {
            
        }else if (index == 11) {
            
        }else if (index == 12) {
            
        }
    }
}

#pragma mark Creat UI
- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 125)];
        [_headView addSubview:self.nameTF];
        [_headView addSubview:self.nameBtn];
    }
    return _headView;
}

- (UITextField *)nameTF {
    if (!_nameTF) {
        _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(30, 20, 200, 30)];
        _nameTF.placeholder = @"输入文字";
        _nameTF.delegate = self;
//        _nameTF.borderStyle = UITextBorderStyleRoundedRect;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        view.backgroundColor = [UIColor redColor];
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        view1.backgroundColor = [UIColor redColor];
        _nameTF.rightView = view;
        _nameTF.rightViewMode = UITextFieldViewModeAlways;
        _nameTF.leftView = view1;
        _nameTF.leftViewMode = UITextFieldViewModeAlways;
        _nameTF.layer.cornerRadius = 15;
        _nameTF.layer.masksToBounds = YES;
        _nameTF.layer.borderWidth = 1;
        _nameTF.layer.borderColor = [UIColor greenColor].CGColor;
    }
    return _nameTF;
}

- (UIButton *)nameBtn {
    if (!_nameBtn) {
        _nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nameBtn setFrame:CGRectMake(30, 60, 269, 50)];
        _nameBtn.backgroundColor = [UIColor redColor];
        [_nameBtn setTitle:@"点我" forState:UIControlStateNormal];
    }
    return _nameBtn;
}

@end
