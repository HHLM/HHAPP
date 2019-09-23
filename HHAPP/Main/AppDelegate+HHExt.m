//
//  AppDelegate+HHExt.m
//  HHAPP
//
//  Created by Now on 2019/9/23.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "AppDelegate+HHExt.h"
/**
 原理：利用scheme进行web app之间的跳转
    JLRotes 使用：
    1、导入JLRotes
    2、打开info.plist文件，并增加URLTypes 添加自定义的scheme 要保证唯一性
 */
@implementation AppDelegate (HHExt)

- (void)regist:(NSDictionary *)launchOptions {
    
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return YES;
}
@end
