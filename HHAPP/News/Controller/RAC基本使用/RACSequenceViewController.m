//
//  RACSequenceViewController.m
//  HHAPP
//
//  Created by Now on 2020/5/25.
//  Copyright © 2020 任他疾风起. All rights reserved.
//

#import "RACSequenceViewController.h"

@interface RACSequenceViewController ()

@end

@implementation RACSequenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *array = @[@"小米", @"华为", @"OPPO", @"VIVO", @"中兴"];

    [array.rac_sequence.signal subscribeNext:^(id _Nullable x) {
        NSLog(@"%@---%@", x, [NSThread currentThread]);
    }];

    NSArray *arr =  [[array.rac_sequence map:^id _Nullable (id _Nullable value) {
        return [NSString stringWithFormat:@"chain:%@", value];
    }] array];
    
    NSLog(@"map后的数组：%@",arr);

    NSDictionary *dict = @{ @"name": @"小米", @"price": @"¥999元" };

    [dict.rac_sequence.signal subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"%@---%@", x, [NSThread currentThread]);
        RACTupleUnpack(NSString *key,id value) = x;
        NSLog(@"%@----%@",key,value);
    } completed:^{
        NSLog(@"遍历字典完成！！！");
    }];
}

@end
