//
//  HHRacModel.m
//  HHAPP
//
//  Created by Now on 2019/9/18.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "HHRacModel.h"

@implementation HHRacModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
           return [self creatSignalWithInput:input];
        }];
    }
    return self;
}
- (void)initWithRacBlock:(NSString * (^)(NSString * _Nonnull))block {
    NSLog(@"%@",block(@"NNNNNNNNN")); 
}

- (void)initWithRacArrayBlock:(NSDictionary * (^)(id data))block {
//    NSLog(@"%@",block(@"NNNNNNNNN"));
    NSDictionary *dict = block(@"");
    [[self.command execute:dict] subscribeNext:^(id  _Nullable x) {
        block(x);
    }];
//    return block();
}

- (RACSignal *)creatSignalWithInput:(id)input {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        if ([input isKindOfClass:[NSDictionary class]]) {
            if ([input[@"name"] isEqualToString:@"小明"]) {
                 [subscriber sendNext:@"小明是谁~~~"];
            }else {
                 [subscriber sendNext:[NSString stringWithFormat:@"%@你好的~~~",input[@"name"]]];
            }
        }else {
            [subscriber sendNext:@"信号发送成功"];
        }
        
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"取消订阅");
        }];
    }];
}
@end
