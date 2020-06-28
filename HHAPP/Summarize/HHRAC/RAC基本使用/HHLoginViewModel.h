//
//  HHLoginViewModel.h
//  HHAPP
//
//  Created by Now on 2020/6/17.
//  Copyright © 2020 任他疾风起. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHLoginViewModel : NSObject
/** 账号名称 */
@property (nonatomic, copy) NSString *name;
/** 账号密码 */
@property (nonatomic, copy) NSString *pwd;

/** 登录信号 */
@property (nonatomic, strong) RACSignal *loginSignal;

/** 登录请求信号 */
@property (nonatomic, strong) RACCommand *loginCmd;

@end

NS_ASSUME_NONNULL_END
