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

//*!!!:3、内购产品要添加图片提交审核，要不然线上app没有内购产品

/**
 内购步骤：
 0 、检测本地时候有未校验的receipt  遍历取到后 走下面 ----> 4步骤
 1、判断当前环境是否支持内购
 2、从苹果服务器获取能够支付的商品id
        — 获取成功并且有数据进行 3步骤
 3、购买产品加入购买队列，并且绑定用户id 这样为了让后端能够区分这个订单是那个用户的
        — 成功：就本地获取receipt 保存到本地 进行 ----> 4步骤
        — 失败：判断是用户自己取消，还是支付失败问题
4、 接3步骤的成功  上传到服务器进行验证 、若成功就删除本地的receipt 失败不走
5、验证成功后处理后面的逻辑
 */

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

- (void)checkIAPFiles;
@end

NS_ASSUME_NONNULL_END
