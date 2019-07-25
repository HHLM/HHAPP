//
//  TRBadgeButton.h
//  Retail-iOS
//
//  Created by zz on 2019/7/19.
//  Copyright © 2019年 ttp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    TRBadgeButtonOfShowRedPoint,
    TRBadgeButtonOfShowNumber,
    
} TRBadgeButtonType;
@interface TRBadgeButton : UIBarButtonItem
// Badge value to be display
@property (nonatomic, copy) NSString *badgeValue;
// Badge background color
@property (nonatomic, strong) UIColor *badgeBGColor;
// Badge text color
@property (nonatomic, strong) UIColor *badgeTextColor;
// Badge font
@property (nonatomic, strong) UIFont *badgeFont;
// Padding value for the badge
@property (nonatomic) CGFloat badgePadding;
// Minimum size badge to small
@property (nonatomic) CGFloat badgeMinSize;
// Values for offseting the badge over the BarButtonItem you picked
@property (nonatomic) CGFloat badgeOriginX;
@property (nonatomic) CGFloat badgeOriginY;
// In case of numbers, remove the badge when reaching zero
@property BOOL shouldHideBadgeAtZero;
// Badge has a bounce animation when value changes
@property BOOL shouldAnimateBadge;
/* 显示类型 */
@property (nonatomic, assign) TRBadgeButtonType type;


- (TRBadgeButton *)initWithCustomUIButton:(UIButton *)customButton;

@end

NS_ASSUME_NONNULL_END
