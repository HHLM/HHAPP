//
//  HHAppPurchaseTool.m
//  HHAPP
//
//  Created by Now on 2019/9/20.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "HHAppPurchaseTool.h"

@implementation HHAppPurchaseTool

+ (instancetype)shareInstall {
    static HHAppPurchaseTool *appPurchase =  nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!appPurchase) {
            appPurchase = [[HHAppPurchaseTool alloc] init];
        }
    });
    return appPurchase;
}
@end
