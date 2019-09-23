//
//  HHAdminViewModel.m
//  HHAPP
//
//  Created by Now on 2019/8/15.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "HHAdminViewModel.h"

@implementation HHAdminViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }return self;
}

- (void)initWithBlock:(void(^)(NSArray *array))block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSArray *array = @[@"乔峰",@"段誉",@"虚竹",@"张无忌",@"张翠山",@"张丹枫",@"陆小凤",@"西门吹雪"];
            block(array);
        });
    });
    
}
@end

