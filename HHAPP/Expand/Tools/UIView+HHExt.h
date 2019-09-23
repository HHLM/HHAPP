//
//  UIView+HHExt.h
//  HHAPP
//
//  Created by Now on 2019/7/22.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HHExt)

- (void)addBadgeValue:(NSString *)badgeValue;
/**
 
 * 移除添加的角标
 
 */
- (void)removeBadgeValue;
@end

NS_ASSUME_NONNULL_END
