//
//  UIView+HHExt.m
//  HHAPP
//
//  Created by Now on 2019/7/22.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "UIView+HHExt.h"

@implementation UIView (HHExt)
- (void)addBadgeValue:(NSString *)badgeValue {
        [self removeBadgeValue];

        

        UITabBar *tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];

        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"" image:nil tag:0];

        item.badgeValue = badgeValue;

        NSArray *array = [[NSArray alloc] initWithObjects:item, nil];

        tabBar.items = array;

     

        //寻找

        for (UIView *viewTab in tabBar.subviews) {
                for (UIView *subview in viewTab.subviews) {
                        NSString *strClassName = [NSString stringWithUTF8String:object_getClassName(subview)];

                        if ([strClassName isEqualToString:@"UITabBarButtonBadge"] ||

                                            [strClassName isEqualToString:@"_UIBadgeView"]) {
                                //从原视图上移除

                                [subview removeFromSuperview];

                                //

                                [self addSubview:subview];

                                subview.frame = CGRectMake(self.frame.size.width - 10, 0,

                                                                                                      subview.frame.size.width, subview.frame.size.height);

                                return;

                           
            }

                   
        }

           
    }

     
}

- (void)removeBadgeValue

{
    for (UIView *subview in self.subviews) {
            NSString *strClassName = [NSString stringWithUTF8String:object_getClassName(subview)];

            if ([strClassName isEqualToString:@"UITabBarButtonBadge"] ||

                            [strClassName isEqualToString:@"_UIBadgeView"]) {
                    [subview removeFromSuperview];

                    break;

               
    }

           
    }

        
}

@end
