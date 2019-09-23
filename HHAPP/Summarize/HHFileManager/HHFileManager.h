//
//  HHFileManager.h
//  HHAPP
//
//  Created by Now on 2019/9/20.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
  文件管理
 1、找到沙盒地址
 2、直接创建文件夹或者文件
 3、判断是否存在存在就不必操作
 4、读取操作反过来
 */

@interface HHFileManager : NSObject

+ (instancetype)shareInstall;

+ (NSString *)homeFilePath;             // 程序主目录，可见子目录(3个):Documents、Library、tmp
/** 程序目录 */
+ (NSString *)appFilePath;              // 程序目录，不能存任何东西
/** 沙盒路径 */
+ (NSString *)documentsFilePath;        // 文档目录，需要ITUNES同步备份的数据存这里，可存放用户数据

+ (NSString *)libPrefFilePath;          // 配置目录，配置文件存这里

+ (NSString *)libCacheFilePath;         // 缓存目录，系统永远不会删除这里的文件，ITUNES会删除

+ (NSString *)tmpFilePath;              // 临时缓存目录，APP退出后，系统可能会删除这里的内容

+ (NSString *)iapReceiptFilePath;       //用于存储iap内购返回的购买凭证

#pragma mark 创建一个文件夹

/**
 创建一个文件夹

 @param folderName 文件夹名称
 @return 是否成功
 */
+ (NSString *)creatFolder:(NSString *)folderName;

#pragma mark 保存文件

/**
 保存文本

 @param file 文件
 @param fileName 文件名称
 @return 是否成功
 */
+ (BOOL)creatFile:(id)file fileName:(NSString *)fileName;

#pragma mark 保存文件到某个文件夹

/**
 保存文件到某个文件夹

 @param file 文件
 @param fileName 文件名称
 @param targetFolderName 目标文件夹名称 为nil或者长度为0时候默认在doucument中
 @return 是否成功
 */
+ (BOOL)creatFile:(id)file fileName:(NSString *)fileName toTagertFolder:(NSString *)targetFolderName;


/**
 保存文件到某个文件夹
 
 @param file 文件
 @param fileName 文件名称
 @param targetFolderPath 目标文件路径
 @return 是否成功
 */
+ (BOOL)creatFile:(id)file fileName:(NSString *)fileName toTagertFolderPath:(NSString *)targetFolderPath;

/**
 追加文本

 @param content 追加内容
 @param filePath 文件地址
 */
+ (void)addContent:(NSString *)content filePath:(NSString *)filePath;

#pragma mark 删除文件/文件夹

/**
 删除文件/文件夹

 @param filePath 文件/文件夹地址
 @return 是否成功
 */
+ (BOOL)removePath:(NSString *)filePath;


#pragma mark 移动文件

/**
 移动文件

 @param filePath 原来文件地址
 @param targetFilePath 目标地址
 @return 是否成功
 */
+ (BOOL)moveFilePath:(NSString *)filePath toTargetFilePath:(NSString *)targetFilePath;

#pragma mark copy文件

/**
 copy文件

 @param filePath 原来文件地址
 @param targetFilePath 目标地址
 @return 是否成功
 */
+ (BOOL)copyFilePath:(NSString *)filePath toTargetFilePath:(NSString *)targetFilePath ;

#pragma mark 读取保存的文本

/**
 读取保存的文本

 @param filePath 文本保存地址
 @return 读取内容
 */
+ (NSString *)readStringAtFliePath:(NSString *)filePath ;

#pragma mark 读取保存的图片

/**
 读取保存的图片

 @param filePath 图片保存地址
 @return 图片
 */
+ (UIImage *)readImageAtFilepath:(NSString *)filePath ;

#pragma mark 读取保存的文件

/**
 读取保存的文件

 @param filePath 文件保存地址
 @return 文件data
 */
+ (NSData *)readDataAtFilepath:(NSString *)filePath ;

#pragma mark 获取指定路径下文件夹中所有文件名字
/**
获取指定文件中文件的文件名字 &PS不包含子文件夹下的文件
 */

/**
 获取指定路径下文件夹中所有文件名字

 @param folderPath 指定路径
 @return 数组
 */
+ (NSArray *)enumeratorOtherFolderPath:(NSString *)folderPath;


#pragma mark 获取指定路径下指定文件夹中所有文件名字
/**
 获取指定路径下指定文件夹中所有文件名字

 @param folderPath 指定路径
 @param folderName 指定文件夹
 @return 数组
 */
+ (NSArray *)enumeratorOtherFolderPath:(NSString *)folderPath folderName:(NSString *)folderName;


#pragma mark 遍历获取Document目录下的文件中文件名字


/**
 遍历获取Document目录下的文件中文件名字

 @param folderName Document下的目录
 @return 数组
 */
+ (NSArray *)enumeratorDocumentFolder:(NSString *)folderName;

#pragma mark 遍历获取Document目录下文件名字
/**
 获取Document文件夹下的文件

 @return 数组
 */
+ (NSArray *)enumeratorDocumentFolder;

#pragma mark 计算文件大小

/**
 计算文件大小

 @param filePath 文件地址
 @return 文件大小
 */
+ (unsigned long long)fileSizeAtFilePath:(NSString *)filePath ;

#pragma mark 计算文件夹大小

/**
 计算文件夹大小

 @param folderPath 文件夹地址
 @return 文件夹大小
 */
+ (unsigned long long)fileSizeAtFolderPath:(NSString *)folderPath ;

#pragma mark 文件大小格式化

/**
 格式化文件大小显示

 @param fileSize 文件大小
 @return 格式化后的结果
 */
+ (NSString *)formatSize:(unsigned long long)fileSize ;

+  (void)test;
@end

NS_ASSUME_NONNULL_END
