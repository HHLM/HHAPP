//
//  HHAdminViewModel.h
//  HHAPP
//
//  Created by Now on 2019/8/15.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "BaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHAdminViewModel : BaseViewModel
@property (nonatomic, copy) NSArray *dataArray;
- (void)initWithBlock:(void(^)(NSArray *array))block;
@end

NS_ASSUME_NONNULL_END
