//
//  UIView+HHEXT.h
//  HHAPP
//
//  Created by liuxiaohui on 2019/10/22.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HHEXT)

- (UIViewController *)viewController;

+ (CGFloat)getLabelHeightByWidth:(CGFloat)width Title:(NSString *)title font:(UIFont *)font;

/**  设置圆角  */
- (void)round:(CGFloat)cornerRadius;

/**  设置圆角和边框  */
- (void)round:(CGFloat)cornerRadius width:(CGFloat)borderWidth color:(UIColor *)borderColor;

/**  设置边框  */
- (void)border:(CGFloat)borderWidth color:(UIColor *)borderColor;

/**   给哪几个角设置圆角  */
- (void)round:(CGFloat)cornerRadius RectCorners:(UIRectCorner)rectCorner;

/**  设置阴影  */
- (void)shadow:(UIColor *)shadowColor opacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset;

@end

#pragma mark -- CornerRadius
@interface UIView (CornerRadius)

@end

#pragma mark -- Register
@interface UIView (Register)

+ (instancetype _Nullable)loadInstanceFromNib;

+ (instancetype _Nullable)loadInstanceFromNibWithName:(NSString *_Nullable)nibName;

+ (instancetype _Nullable)loadInstanceFromNibWithName:(NSString *_Nullable)nibName owner:(nullable id)owner;

+ (instancetype _Nullable)loadInstanceFromNibWithName:(NSString *_Nullable)nibName owner:(nullable id)owner bundle:(NSBundle *_Nullable)bundle;

- (void)setRoundingCornerWithCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

@end

#pragma mark -- frame
@interface UIView (frame)

@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat right;

@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat centerY;

@end

NS_ASSUME_NONNULL_END
