//
//  UIImage+HHEXT.h
//  HHAPP
//
//  Created by Now on 2019/9/23.
//  Copyright © 2019 任他疾风起. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (HHEXT)
/** 生成纯色图片 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

/**
 *  @brief  根据颜色生成纯色图片
 *
 *  @param color 颜色
 *
 *  @return 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/** 压缩图片大小 并不是截取图片而是按照size绘制图片*/
+ (UIImage*)scaleImage:(UIImage*)img toSize:(CGSize)size;


 /** 图片压缩
 @param image 图片
 @param maxLength 大小
 @return image
 */
+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;
@end

NS_ASSUME_NONNULL_END
