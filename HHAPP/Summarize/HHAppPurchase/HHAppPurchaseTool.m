//
//  HHAppPurchaseTool.m
//  HHAPP
//
//  Created by Now on 2019/9/20.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "HHAppPurchaseTool.h"


static NSString * const receiptKey = @"receipt_key";
static NSString * const dateKey    = @"date_key";
static NSString * const userIdKey  = @"userId_key";
static NSString * const shopIdKey  = @"shopId_key";
static NSString * const productIdKey  = @"productId_key";
static NSString * const fileNameKey  = @"fileName_key";

@interface HHAppPurchaseTool()<SKProductsRequestDelegate,SKPaymentTransactionObserver>

/** 产品是否够买结束 未结束不能处理其他订单 */
@property (nonatomic, assign) BOOL productFinished;

/** info */
@property (nonatomic, strong) NSMutableDictionary *productDic;

/** 保存上传信息 */
@property (nonatomic, strong) NSMutableDictionary *infoDic;

/** 获取到能销售的产品id */
@property (nonatomic, strong) NSMutableArray *productArr;

@end

@implementation HHAppPurchaseTool

+ (instancetype)shareInstall {
    static HHAppPurchaseTool *appPurchase =  nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!appPurchase) {
            appPurchase = [[HHAppPurchaseTool alloc] init];
            [appPurchase config];
        }
    });
    return appPurchase;
}
- (void)config {
    self.infoDic = [NSMutableDictionary dictionary];
}
- (void)starPurchase {
    [self addTransactionObserver];
    [self checkIAPFiles];
}
- (void)stoPurchase {
    [self removeTransactionObserver];
}
//添加观察者
- (void)addTransactionObserver {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}
//移除
- (void)removeTransactionObserver {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}


#pragma mark 获取能购买的产品id
- (void)hh_requestProducts:(NSArray <NSString *> *)productIds {
    //购买中结束
    if (self.productFinished) {
        //检测手机是否支持内购
        if ([SKPaymentQueue canMakePayments]) {
            self.productFinished = NO;
            NSSet *set = [NSSet setWithArray:productIds];
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
            request.delegate = self;
            [request start];
        } else {
            //暂无权限
            self.productFinished =  YES;
            [self hh_failedWithErrorCodel:HHIAP_NOPERMISSION];
        }
    }
}

#pragma mark SKProductsRequestDelegate 苹果获取产品代理请求成功
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    self.productArr = [NSMutableArray array];
    if (self.productDic == nil) {
        self.productDic = [NSMutableDictionary dictionaryWithCapacity:response.products.count];
    }
    if (response.products.count == 0) {
        self.productFinished = YES;
        [self hh_failedWithErrorCodel:HHIAP_REQUSETEMPTY];
    }
    for (SKProduct *product in response.products) {
        // 填充商品字典
        [self.productDic setObject:product forKey:product.productIdentifier];
    }
    /** 按价格排序 */
    [self.productArr setArray:[response.products sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult (SKProduct *obj1, SKProduct *obj2) {
        return [obj1.price compare:obj2.price];
    }]];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(appPurchaseProductIds:)]) {
        self.productFinished = YES;
        [self.delegate appPurchaseProductIds:self.productArr];
        
    }
}
#pragma mark 失败
- (void)requestDidFinish:(SKRequest *)request {
    [self hh_failedWithErrorCodel:HHIAP_APPLEFAILED];
}


#pragma mark 购买需要的一款产品
- (void)hh_purchaseProductWihtProductId:(NSString *)productId {
    if (!productId || self.productDic[productId] || [self.productDic[productId] isKindOfClass:[SKProduct class]]) {
        NSLog(@"没有产品购买");
        self.productFinished = YES;
        [self hh_failedWithErrorCodel:HHIAP_EMPTYPRODUCT];
        return;
    }
    self.productFinished = NO;
    /** 要购买产品 开小票 */
    SKProduct *product = self.productDic[productId];
    // 生成可变订单
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
    //绑定一个用户的id 作为标识
    payment.applicationUsername = @"用户id";
    /** 加入队列 排队支付 */
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}


#pragma mark 购买多款产品
- (void)hh_purchaseProductWihtProductIds:(NSArray <NSString *> *)productIds {
    if (productIds.count == 0) {
        NSLog(@"没有产品购买");
        self.productFinished = YES;
        [self hh_failedWithErrorCodel:HHIAP_EMPTYPRODUCT];
        return;
    }
    self.productFinished = NO;
    for (NSString *productId in productIds) {
        /** 要购买产品 开小票 */
        SKProduct *product = self.productDic[productId];
        // 生成可变订单
        SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
        //绑定一个用户的id 作为标识
        payment.applicationUsername = @"用户id";
        /** 加入队列 排队支付 */
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    
    for (SKPaymentTransaction *transaction in transactions) {
        //产品id
        NSString *productId = transaction.payment.productIdentifier;
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品购买中...");
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"购买失败");
                [self hh_failedTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchased:
                NSLog(@"购买成功");
                [self hh_checkAppPayCodeWithProductId:productId];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"恢复购买成功"); //针对永久商品
                break;
            default:
                NSLog(@"其他状态");
                break;
        }
    }
}


#pragma mark 获取票据验证
- (void)hh_checkAppPayCodeWithProductId:(NSString *)productId  {
    
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:0];
    
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
    
    NSLog(@"苹果验签：%@", payload);
    
    [self saveReceipt:payload];
    
    self.productFinished = YES;
    //获取本地验签后 调用服务器保存信息
}

#pragma mark 获取交易成功后的购买凭证

- (NSString *)appPayCode {
    
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:0];
    
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
    
    return payload;
}

#pragma mark 保存receipt到本地防止漏单
- (void)saveReceipt:(NSString *)receipt  {
    NSString *fileName = [self getNowTimestamp];
    NSString *savedPath = [NSString stringWithFormat:@"%@/%@.plist", [HHFileManager iapReceiptFilePath], fileName];
    NSDictionary *dic = @{ userIdKey: self.infoDic[userIdKey],
                           dateKey: self.infoDic[dateKey],
                           fileNameKey: savedPath,
                           shopIdKey:self.infoDic[shopIdKey]};
    if (self.delegate && [self.delegate respondsToSelector:@selector(appPurchaseSuccessWithInfo:)]) {
        [self.delegate appPurchaseSuccessWithInfo:dic];
    }
    NSLog(@"%@", savedPath);
    [dic writeToFile:savedPath atomically:YES];
}

- (NSString *)getNowTimestamp {
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}

#pragma mark 验证成功后删除保存在本地的receipt
/** 删除本地验签 receiptName文件名 */
- (void)remevReceipt:(NSString *)receiptPath {
    //文件存在就删除
    if ([[NSFileManager defaultManager] fileExistsAtPath:receiptPath]) {
        [HHFileManager removePath:receiptPath];
    }
}


//购买失败处理
- (void)hh_failedTransaction:(SKPaymentTransaction *)transaction {
    self.productFinished = YES;
    if (transaction.error.code == SKErrorPaymentCancelled) {
        NSLog(@"用户自己取消购买");
        [self hh_failedWithErrorCodel:HHIAP_USERCANCEL];
    }else {
        NSLog(@"购买失败~~~");
        [self hh_failedWithErrorCodel:HHIAP_PURCHASEFAILED];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark 错误信息反馈
- (void)hh_failedWithErrorCodel:(HHAppPurchaseFailedCode)code {
    if (self.delegate && [self.delegate respondsToSelector:@selector(failWithError:)]) {
        [self.delegate failedWithErrorCode:code];
    }
}

//*!!!:上传服务器验证
- (void)updateSeverWithInfo:(NSDictionary *)info {
    //请求服务器:
    BOOL res = YES;
    if (res) {
        [self remevReceipt:info[fileNameKey]];
    }
}

#pragma mark 检查本地是否还有未完成验证的订单
- (void)checkIAPFiles {
    
    //文件名
    NSArray *fileNameArray = [HHFileManager enumeratorOtherFolderPath:[HHFileManager iapReceiptFilePath]];
    //遍历获取文件然后重现上传 成功后删除本地数据
    for (NSString *fileName in fileNameArray) {
        NSString *filePath = [[HHFileManager iapReceiptFilePath] stringByAppendingPathComponent:fileName];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        NSLog(@"%@",dict);
        [self updateSeverWithInfo:dict];
    }
}


#pragma mark 苹果本地验证
/**
 苹果本地验证
 @param productId 商品id
 @param appStore  是否是苹果正式验证环境
 */
- (void)checkPruchaseWithProductId:(NSString *)productId appStore:(BOOL)appStore {
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    // 发送网络POST请求，对购买凭据进行验证
    //In the test environment, use https://sandbox.itunes.apple.com/verifyReceipt
    //In the real environment, use https://buy.itunes.apple.com/verifyReceipt
    // Create a POST request with the receipt data.
    NSString *urlString = appStore ? @"https://buy.itunes.apple.com/verifyReceipt" : @"https://sandbox.itunes.apple.com/verifyReceipt";
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 国内访问苹果服务器比较慢，timeoutInterval需要长一点
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:20.0f];
    
    request.HTTPMethod = @"POST";
    
    // 在网络中传输数据，大多情况下是传输的字符串而不是二进制数据
    // 传输的是BASE64编码的字符串
    /**
        BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性
     BASE64是可以编码和解码的
     */
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = payloadData;
    
    // 提交验证请求，并获得官方的验证JSON结果
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // 官方验证结果为空
    if (!result) {
        NSLog(@"验证失败");
    }
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result
                                                         options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"苹果验证结果：%@", dict);
    if (dict) { //验证结果
        /*
         21000 App Store无法读取你提供的JSON数据
         21002 收据数据不符合格式
         21003 收据无法被验证
         21004 你提供的共享密钥和账户的共享密钥不一致
         21005 收据服务器当前不可用
         21006 收据是有效的，但订阅服务已经过期。当收到这个信息时，解码后的收据信息也包含在返回内容中
         21007 收据信息是测试用（sandbox），但却被发送到产品环境中验证
         21008 收据信息是产品环境中使用，但却被发送到测试环境中验证
         */
        HHAppPurchasePayStatue statue = HHAppPurchaseCheck21000;
        if ([dict[@"Status"] intValue] == 21007) { //调用测试环境
            statue = HHAppPurchaseCheckSandbox;
        } else if ([dict[@"Status"] intValue] == 21008) { //调用正式环境
            statue = HHAppPurchaseCheckReceipt;
        } else if ([dict[@"Status"] intValue] == 21000) { //调用正式环境
            statue = HHAppPurchaseCheck21000;
        } else if ([dict[@"Status"] intValue] == 21002) { //调用正式环境
            statue = HHAppPurchaseCheck21002;
        } else if ([dict[@"Status"] intValue] == 21003) { //调用正式环境
            statue = HHAppPurchaseCheck21003;
        } else if ([dict[@"Status"] intValue] == 21004) { //调用正式环境
            statue = HHAppPurchaseCheck21004;
        } else if ([dict[@"Status"] intValue] == 21005) { //调用正式环境
            statue = HHAppPurchaseCheck21005;
        } else if ([dict[@"Status"] intValue] == 21006) { //调用正式环境
            statue = HHAppPurchaseCheck21006;
        } else if ([dict[@"Status"] isEqualToString:@"0"]) {
            NSLog(@"验证成功");
            statue = HHAppPurchaseCheckSuccess;
        }
    } else {
        
//        if (self.delegate && [self.delegate respondsToSelector:@selector(appPurchaseBuySucessWithProductId:InfoDic:statue:)]) {
//            [self.delegate appPurchaseBuySucessWithProductId:productId InfoDic:dict statue:statue];
//        }
    }
}


@end
