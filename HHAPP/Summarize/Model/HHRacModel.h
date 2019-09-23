//
//  HHRacModel.h
//  HHAPP
//
//  Created by Now on 2019/9/18.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHRacModel : BaseModel

@property (nonatomic, strong) RACCommand *command;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *language;

- (void)initWithRacBlock:(NSString *(^)(NSString *string))block;

- (void)initWithRacArrayBlock:(NSDictionary *(^)(id data))block;

@end

NS_ASSUME_NONNULL_END
