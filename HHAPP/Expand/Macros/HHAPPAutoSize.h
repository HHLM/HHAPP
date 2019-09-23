

#ifndef HHAPPAutoSize_h
#define HHAPPAutoSize_h


#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

/** 屏幕大小适配 */
#pragma mark -- 尺寸
/** 屏幕宽度 */
#define kScreenWidth  ([[UIScreen mainScreen] bounds].size.width)

/** 屏幕高度 */
#define kScreenHeight  ([[UIScreen mainScreen] bounds].size.height)

#define iPhoneX ((kStatusBarHeight > 20) ? YES : NO)
/** 导航高度 */
#define kNavBarHeight  (iPhoneX ? 88 : 64)

/** 底部安全高度 */
#define kSafeBottomHeight  (iPhoneX ? 34 : 0)

/** tabBar高度 */
#define kTabBarHeight  (iPhoneX ? 83 : 49)
/** tabbar安全区域 */
#define kTabbar_SafeArea ([[UIApplication sharedApplication] statusBarFrame].size.height > 20 ? 34 : 0)
//宽度缩小系数
#define TaurusWidthScale   [UIScreen mainScreen].bounds.size.width/375.0
/**
 * 假如设计给的图是750的图 那么应该是375的标准是1 其他的 就是屏幕宽度/375.0
 *  4、5的 比例就该是 320/375.0    plus的比例就是 414/375.0
 */
#pragma mark -- 只是适用于iPhone iTouch 不适用 iPad
#if 0   //若设计给的是640的图
#define KAutoSizeScaleX ((kScreenWidth > 320)  ? (kScreenWidth / 320.0) : 1)
#else   //设计给的是750的图
#define KAutoSizeScaleX ((kScreenWidth != 375) ? (kScreenWidth / 375.0) : 1)
#endif

#define KSameSizeScaleX ((kScreenWidth > 375) ? (kScreenWidth / 375.0) : 1)

//Img宏定义
#define IMG(img) [UIImage imageNamed:img]

CG_INLINE CGFloat
kAutoWidth(CGFloat width)    // 5,6同尺寸,7以上自动放大
{
    CGFloat autoWidth = width * KAutoSizeScaleX;
    return autoWidth;
}
CG_INLINE CGFloat
kSameWidth(CGFloat width)    // 5,6同尺寸,7以上自动放大
{
    CGFloat autoWidth = width * KSameSizeScaleX;
    return autoWidth;
}

#pragma mark -- 字体大小
/** 一般4 5 6 字体大小一样  Plus上字体 +2 */
#define kFontNumer(a)   ((kScreenWidth > 375) ? a  : a)

#define kFont(a)        [UIFont systemFontOfSize:kFontNumer(a)]

#define kBFont(a)       [UIFont boldSystemFontOfSize:kFontNumer(a)]

#endif /* ZZAPPAutoSize_h */
