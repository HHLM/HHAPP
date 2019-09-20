//
//  HHAppPurchaseTool.h
//  HHAPP
//
//  Created by Now on 2019/9/20.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "HHFileManager.h"


NS_ASSUME_NONNULL_BEGIN

//*!!!:1、iOS内购导入框架StoreKit.frame  并导入头文件 <StoreKit/StoreKit.h>

//*!!!:2、Project -> Capabilities -> in-App Purchase -> YES 上线时候打开要不然会没有商品

typedef NS_ENUM(NSInteger,HHAppPurchaseFailedCode) {
    HHIAP_APPLEFAILED       = 0,    //苹果返回错误
    HHIAP_NOPERMISSION      = 1,    //没有开启内购权限
    HHIAP_EMPTYPRODUCT      = 2,    //没有购买商品
    HHIAP_PURCHASEFAILED    = 3,    //购买失败
    HHIAP_USERCANCEL        = 4,    //用户取消购买
    HHIAP_REQUSETEMPTY      = 5     //无法获取产品信息
};



typedef NS_ENUM(NSInteger,HHAppPurchasePayStatue) {
    HHAppPurchaseCheckSuccess = 1,    //验证成功
    HHAppPurchaseCheck21000 = 2,      //App Store不能读取你提供的JSON对象
    HHAppPurchaseCheck21002 = 3,      //receipt-data域的数据有问题
    HHAppPurchaseCheck21003 = 4,      //receipt无法通过验证
    HHAppPurchaseCheck21004 = 5,      //提供的shared secret不匹配你账号中的shared secret
    HHAppPurchaseCheck21005 = 6,      //receipt服务器当前不可用
    HHAppPurchaseCheck21006 = 7,      //receipt合法，但是订阅已过期
    HHAppPurchaseCheckSandbox = 8,    //receipt是Sandbox receipt，但却发送至生产系统的验证服务
    HHAppPurchaseCheckReceipt = 9,    //receipt是生产receipt，但却发送至Sandbox环境的验证服务
};


@protocol HHAppPurchaseDelegate <NSObject>

//可选 不必实现的
@optional

/** 从苹果服务起获取验证的产品id */
- (void)appPurchaseProductIds:(NSArray <NSString *> *)productIds;

/** 购买失败 */
- (void)failedWithErrorCode:(NSInteger)errorCode; //失败

/** 购买成功 */
- (void)appPurchaseSuccessWithInfo:(NSDictionary *)info;

//必须实现的
@required

@end

@interface HHAppPurchaseTool : NSObject

@property (nonatomic, weak) id <HHAppPurchaseDelegate> delegate;

+ (instancetype)shareInstall;

/** 开始购买 */
- (void)starPurchase;

/** 结束购买 */
- (void)stoPurchase;

/** 从苹果服务器验证产品id */
- (void)hh_requestProducts:(NSArray <NSString *> *)productIds;

//购买某一个产品
- (void)hh_purchaseProductWihtProductId:(NSString *)productId;

//购买多个个产品
- (void)hh_purchaseProductWihtProductIds:(NSArray <NSString *> *)productIds;

/** 删除本地验签 receiptName文件名 */
- (void)remevReceipt:(NSString *)receiptName;
@end

NS_ASSUME_NONNULL_END
