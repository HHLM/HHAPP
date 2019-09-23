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
    
    [[JLRoutes routesForScheme:kScheme] addRoute:@"/push/:controller"handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
           Class class = NSClassFromString(parameters[@"controller"]);
           UIViewController *nextVC = [[class alloc] init];
           [self paramToVc:nextVC param:parameters];
           UIViewController *currentVc = [self currentViewController];
           [currentVc.navigationController pushViewController:nextVC animated:YES];
           return YES;
       }];
}
//确定是哪个viewcontroller
-(UIViewController *)currentViewController{
    
    UIViewController * currVC = nil;
    UIViewController * Rootvc = self.window.rootViewController ;
    do {
        if ([Rootvc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)Rootvc;
            UIViewController * v = [nav.viewControllers lastObject];
            currVC = v;
            Rootvc = v.presentedViewController;
            continue;
        }else if([Rootvc isKindOfClass:[UITabBarController class]]){
            UITabBarController * tabVC = (UITabBarController *)Rootvc;
            currVC = tabVC;
            Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        }
    } while (Rootvc!=nil);
    
    return currVC;
}
//传参数
-(void)paramToVc:(UIViewController *) v param:(NSDictionary<NSString *,NSString *> *)parameters{
    //        runtime将参数传递至需要跳转的控制器
    unsigned int outCount = 0;
    objc_property_t * properties = class_copyPropertyList(v.class , &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *key = [NSString stringWithUTF8String:property_getName(property)];
        NSString *param = parameters[key];
        if (param != nil) {
            [v setValue:param forKey:key];
        }
    }
}

@end
