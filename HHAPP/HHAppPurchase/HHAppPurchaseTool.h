//
//  HHAppPurchaseTool.h
//  HHAPP
//
//  Created by Now on 2019/9/20.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HHAppPurchaseDelegate <NSObject>

//可选 不必实现的
@optional

//必须实现的
@required

@end

@interface HHAppPurchaseTool : NSObject

@property (nonatomic, weak) id <HHAppPurchaseDelegate> delegate;

+ (instancetype)shareInstall;

@end

NS_ASSUME_NONNULL_END
