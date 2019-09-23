
#import "HHConstFile.h"


/** 广告通知 */
NSString* const ZZ_ChangeLanguage_Key = @"zz_changeLanguage";

/** APP当前版本 */
NSString* const ZZ_APP_Version = @"zz_app_version";

NSString *const kUserToken  = @"zz_kUserToken";

NSString *const kUserKey  = @"zz_kUserKey";

/** 注册账号 */
NSString* const kUserAccount_Key = @"ZZ_UserAccount_Key";
/** 用户名*/
NSString* const kUserName = @"ZZ_UserName";
/** 用户密码*/
NSString* const kUserPassword = @"ZZ_UserPassword";

CGFloat const kAssortWidht  = 100.f;

/** 用户信息 */
NSString *const kUser_Info      = @"zz_user_info";

/** 是否登录 */
NSString *const kUser_isLogion  = @"zz_user_islogin";





NSString *decimalNumber(double conversionValue)
{
    NSString *doubleString        = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}
NSNumber *number(NSString *doubleString)
{
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    return decNumber;
}

 BOOL isNullValue(id _Nullable value) {
    
    if (!value) {
        
        return YES;
    }
    
    if ([value isKindOfClass:[NSNull class]]){
        
        return YES;
    }
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSString *dataStr = [NSString stringWithFormat:@"%@", value];
        if (dataStr.length == 0){
            return YES;
        }
        return NO;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSString *dataStr = [NSString stringWithFormat:@"%@", value];
        if (dataStr.length == 0){
            return YES;
        }
        return NO;
    }
    if ([value isKindOfClass:[NSArray class]]) {
        NSString *dataStr = [NSString stringWithFormat:@"%@", value];
        
        if (dataStr.length == 0){
            return YES;
        }
        return NO;
    }
    
    
    NSString *dataStr = [NSString stringWithFormat:@"%@", value];
    
    if (dataStr.length == 0){
        return YES;
    }
    
    
    if ([dataStr rangeOfString:@"null"].location != NSNotFound){
        return YES;
    }
    
    return NO;
}
