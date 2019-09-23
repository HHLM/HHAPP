//
//  BadgeButton.h
//  Retail-iOS
//
//  Created by zz on 2019/7/22.
//  Copyright © 2019年 ttp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    BadgeButtonOfShowRedPoint,///<显示红点
    BadgeButtonOfShowNumber,///<显示数字
    
} BadgeButtonType;
@interface BadgeButton : UIButton
/* 数字 */
@property (nonatomic, copy) NSString *badgeValue;
/** 数字的背景色 */
@property (nonatomic, strong) UIColor *badgeBGColor;
/** 数字的颜色 */
@property (nonatomic, strong) UIColor *badgeTextColor;
/** 数字的字号 */
@property (nonatomic, strong) UIFont *badgeFont;
/* 显示类型 */
@property (nonatomic, assign) BadgeButtonType type;

- (BadgeButton *)initWithBadgeButtonType:(BadgeButtonType)type;
/**
 展示小红点
 */
- (void)showBadge;
/**
 移除小红点
 */
-(void)dismissBadge;
@end

NS_ASSUME_NONNULL_END
