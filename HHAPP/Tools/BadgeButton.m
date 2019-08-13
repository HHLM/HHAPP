//
//  BadgeButton.m
//  Retail-iOS
//
//  Created by zz on 2019/7/22.
//  Copyright © 2019年 ttp. All rights reserved.
//

#import "BadgeButton.h"
@interface BadgeButton()
/** 小红点 */
@property (nonatomic, strong) UILabel * badgeLabel;

@end

@implementation BadgeButton

#pragma mark - Public Method 公开方法（头文件声明的方法）
- (BadgeButton *)initWithBadgeButtonType:(BadgeButtonType)type {
    self = [BadgeButton buttonWithType:UIButtonTypeCustom];
    if (self) {
        self.type = type;
        [self addSubview:self.badgeLabel];
        [self  layoutSubviewsContraint];

    }
    return self;
}
#pragma mark - Private Method 私有方法
- (void)layoutSubviewsContraint {
    if (self.type == BadgeButtonOfShowRedPoint) {
        [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-3);
            make.top.mas_equalTo(self.mas_top).offset(3);
            make.width.height.mas_equalTo(10);
        }];
        self.badgeLabel.layer.cornerRadius = 5;
    }else {
        [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_right).offset(-10);
            make.top.mas_equalTo(self.mas_top).offset(-10);
            make.width.height.mas_equalTo(20);
        }];
        self.badgeLabel.layer.cornerRadius = 10;
        self.badgeLabel.layer.borderWidth = 5;
        self.badgeLabel.layer.borderColor = [UIColor yellowColor].CGColor;
        self.badgeLabel.layer.backgroundColor = [UIColor redColor].CGColor;
        
    }
    self.badgeLabel.layer.masksToBounds = YES;
}
/**
 刷新UI
 */
- (void)refreshBadge {
    self.badgeLabel.textColor        = self.badgeTextColor;
    self.badgeLabel.backgroundColor  = self.badgeBGColor;
    self.badgeLabel.font             = self.badgeFont;
}

/**
 当消息为0时，不显示
 */
- (void)removeBadge {
    [UIView animateWithDuration:0.01 animations:^{
        self.badgeLabel.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        self.badgeLabel.hidden = YES;
        self.badgeLabel.transform = CGAffineTransformMakeScale(1, 1);
//        self.badgeLabel = nil;
    }];
}

/**
 展示小红点
 */
- (void)showBadge {
    if (self.type == BadgeButtonOfShowRedPoint) {
        self.badgeLabel.hidden = NO;
        self.badgeValue = @"1";
        
    }
}
/**
 移除小红点
 */
-(void)dismissBadge {
    if (self.type == BadgeButtonOfShowRedPoint) {
        [self removeBadge];
    }
}
#pragma mark - Getters and Setters Method getter和setter方法
- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    if (self.type == BadgeButtonOfShowNumber) {
        
        if ( [badgeValue isEqualToString:@""] || [badgeValue isEqualToString:@"0"] ) {
            [self removeBadge];
        
        }else {
            self.badgeLabel.hidden = NO;

            if ([badgeValue isEqualToString:@"..."]) {
                NSMutableAttributedString * attributtedText = [[NSMutableAttributedString alloc] initWithString:badgeValue];
                [attributtedText addAttribute:NSBaselineOffsetAttributeName value:@(2) range:NSMakeRange(0,badgeValue.length)];
                self.badgeLabel.attributedText = attributtedText;
            }else {
                self.badgeLabel.text = badgeValue;
                
            }
            if (badgeValue.length > 1) {
                [self.badgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(24);
                }];
                
            }
            
        }
        NSLog(@"%@",NSStringFromCGRect(self.badgeLabel.frame));
    }
}

- (void)setBadgeBGColor:(UIColor *)badgeBGColor
{
    _badgeBGColor = badgeBGColor;
    
    if (self.badgeLabel) {
        [self refreshBadge];
    }
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor
{
    _badgeTextColor = badgeTextColor;
    
    if (self.badgeLabel) {
        [self refreshBadge];
    }
}

- (void)setBadgeFont:(UIFont *)badgeFont
{
    _badgeFont = badgeFont;
    
    if (self.badgeLabel) {
        [self refreshBadge];
    }
}

- (UILabel *)badgeLabel {
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc]init];
        _badgeLabel.font = [UIFont systemFontOfSize:12];
        _badgeLabel.backgroundColor = [UIColor redColor];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _badgeLabel;
}
@end
