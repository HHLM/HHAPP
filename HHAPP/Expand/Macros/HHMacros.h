
#ifndef HHMacros_h
#define HHMacros_h


#pragma mark - 文件

//NSUserDefaults
#define kUserDefault            [NSUserDefaults standardUserDefaults]
#define kNotificationCenter     [NSNotificationCenter defaultCenter]
#define kManager                [ZZManager sharedManager]
#define kWeakSelf               __weak typeof(self) weakSelf = self
#define kStrongSelf             __strong __typeof__(self) strongSelf = weakSelf



//NSLog失效
#ifndef __OPTIMIZE__
#define NSLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#else
#define NSLog(...) {}
#endif

#define ZZ_Lang(a)          NSLocalizedString(a,nil)


#define kWindow     ([UIApplication sharedApplication].keyWindow)

/** 或者只是标记那一行 */
#define MARK    NSLog(@"\nMARK: %s -- 第%d行", __PRETTY_FUNCTION__, __LINE__);

/*----------------------分割-----------------------*/

#pragma mark - Info.Plist
/** plist文件内容 */
#define kInfoPlist              [[NSBundle mainBundle] infoDictionary]

/** 获取infoPlist文件中的 属性 */
#define kReadInfoPlist(_name)   [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)_name]

/** APP版本 */
#define AppVersion               kReadInfoPlist(kCFBundleVersionKey)

/** APP Build版本 */
#define AppBundleIdentifier      kReadInfoPlist(kCFBundleIdentifierKey)




#endif /* ZZMacros_h */
