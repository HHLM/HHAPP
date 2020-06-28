//
//  HHLoginViewModel.m
//  HHAPP
//
//  Created by Now on 2020/6/17.
//  Copyright © 2020 任他疾风起. All rights reserved.
//

#import "HHLoginViewModel.h"

@implementation HHLoginViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSignal];
    }
    return self;
}

- (void)initSignal {
    self.loginSignal = [RACSignal combineLatest:@[RACObserve(self, name), RACObserve(self, pwd)] reduce:^id _Nullable (NSString *name, NSString *pwd) {
        return @(name.length > 5 && pwd.length > 5);
    }];

    self.loginCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *_Nonnull (id _Nullable input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *_Nullable (id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"请求登录成功"];
            [subscriber sendCompleted];
            return nil;
        }];
        return signal;
    }];

    [[_loginCmd.executing skip:1] subscribeNext:^(NSNumber *_Nullable x) {
        if ([x boolValue]) {
            NSLog(@"成功！！！");
        } else {
            NSLog(@"请求数据中~~~");
        }
    }];

    [_loginCmd.executionSignals.switchToLatest subscribeNext:^(id _Nullable x) {
        NSLog(@"%@", x);
    }];
}

@end
