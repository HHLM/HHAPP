//
//  AppDelegate+HHExt.m
//  HHAPP
//
//  Created by Now on 2019/9/23.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "AppDelegate+HHExt.h"
#import <objc/runtime.h>
/**
 原理：利用scheme进行web app之间的跳转
    JLRotes 使用：
    1、导入JLRotes
    2、打开info.plist文件，并增加URLTypes 添加自定义的scheme 要保证唯一性
 */
@implementation AppDelegate (HHExt)

- (void)regist:(NSDictionary *)launchOptions {
    /**
     这里用 [JLRoutes routesForScheme:kScheme]  最后面的就要使用return [[JLRoutes routesForScheme:kScheme] routeURL:url];
     [[JLRoutes routesForScheme:kScheme] addRoute:@"/push/:controller"handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
       Class class = NSClassFromString(parameters[@"controller"]);
       UIViewController *nextVC = [[class alloc] init];
       [self paramToVc:nextVC param:parameters];
       UIViewController *currentVc = [self currentViewController];
       [currentVc.navigationController pushViewController:nextVC animated:YES];
       return YES;
     }];
     */

    // navigation Push规则
    [[JLRoutes globalRoutes] addRoute:@"/push/:controller" handler:^BOOL (NSDictionary<NSString *, NSString *> *_Nonnull parameters) {
        NSLog(@"parameters==%@", parameters);
        UIViewController *v = [[NSClassFromString(parameters[@"controller"]) alloc] init];
        [self paramToVc:v param:parameters];
        v.title = parameters[@"title"];
        [[self currentViewController] pushViewController:v animated:YES];
        return YES;
    }];

    // 模态窗口规则
    [[JLRoutes globalRoutes] addRoute:@"/present/:controller" handler:^BOOL (NSDictionary<NSString *, NSString *> *_Nonnull parameters) {
        NSLog(@"parameters==%@", parameters);
        UIViewController *v = [[NSClassFromString(parameters[@"controller"]) alloc] init];
        [self paramToVc:v param:parameters];
        v.modalPresentationStyle =  UIModalPresentationFullScreen;
        [[self currentViewController].visibleViewController presentViewController:v animated:YES completion:^{}];
        return YES;
    }];
}

/**
 获取当前控制器
 */
- (UINavigationController *)currentViewController {
    UITabBarController *tabbar = (UITabBarController *)self.window.rootViewController;
    return tabbar.selectedViewController;
}

//传参数
- (void)paramToVc:(UIViewController *)v param:(NSDictionary<NSString *, NSString *> *)parameters {
    // runtime将参数传递至需要跳转的控制器
    unsigned int outCount = 0;

    objc_property_t *properties = class_copyPropertyList(v.class, &outCount);

    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];

        NSString *key = [NSString stringWithUTF8String:property_getName(property)];

        NSString *param = parameters[key];

        if (param != nil) {
            [v setValue:param forKey:key];
        }
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options {
    NSLog(@"从哪个app跳转而来 Bundle ID: %@", options[UIApplicationOpenURLOptionsSourceApplicationKey]);
    NSLog(@"URL scheme:%@", [url scheme]);
    return [[JLRoutes globalRoutes] routeURL:url];
    return [[JLRoutes routesForScheme:kScheme] routeURL:url];
}

@end
