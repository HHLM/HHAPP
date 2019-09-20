//
//  HHFileManager.m
//  HHAPP
//
//  Created by Now on 2019/9/20.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "HHFileManager.h"

@implementation HHFileManager
 // 程序主目录，可见子目录(3个):Documents、Library、tmp
+ (NSString *)homeFilePath {
    NSString *filePath = NSHomeDirectory();
    return filePath;
}

// 程序目录，不能存任何东西
+ (NSString *)appFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    return paths.firstObject;
}

#pragma mark 沙盒路径
// 文档目录，需要ITUNES同步备份的数据存这里，可存放用户数据
+ (NSString *)documentsFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths.firstObject;
}

// 配置目录，配置文件存这里
+ (NSString *)libPrefFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingString:@"/Perferences"];
}

// 缓存目录，系统永远不会删除这里的文件，ITUNES会删除
+ (NSString *)libCacheFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingString:@"Caches"];
}

// 临时缓存目录，APP退出后，系统可能会删除这里的内容
+ (NSString *)tmpFilePath {
    return [NSHomeDirectory() stringByAppendingString:@"/tmp"];
}

//用于存储iap内购返回的购买凭证
+ (NSString *)iapReceiptFilePath {
    NSString *path = [[self libPrefFilePath] stringByAppendingString:@"/EACEF35FE363A75A"];
    [self hasLive:path];
    return path;
}

#pragma mark 创建文件夹
+ (BOOL)hasLive:(NSString *)path {
    //判断文件夹是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return YES;
    }
    //创建文件夹
    BOOL res = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:nil];
    if (res) {
        NSLog(@"文件夹创建成功");
    } else {
        NSLog(@"文件夹创建失败");
    }
    return res;
}

#pragma mark 创建一个文件夹
+ (NSString *)creatFolder:(NSString *)folderName {
    NSString *path = [[self documentsFilePath] stringByAppendingString:[NSString stringWithFormat:@"/%@", folderName]];
    if ([self hasLive:path]) {
        return path;
    } else {
        return nil;
    }
}

#pragma mark 保存文件
+ (BOOL)creatFile:(id)file fileName:(NSString *)fileName {
    NSString *path = [[self documentsFilePath] stringByAppendingString:[NSString stringWithFormat:@"%@", file]];

    BOOL res = [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];

    if (res) {
        NSLog(@"文件创建成功");
    } else {
        NSLog(@"文件创建失败");
        return res;
    }

    if ([file isKindOfClass:[NSString class]]) {
        return [@"" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    } else if ([file isKindOfClass:[UIImage class]]) {
        UIImage *image = file;
        NSData *data = UIImageJPEGRepresentation(image, 1);
        return [data writeToFile:path atomically:YES];
    } else if ([file isKindOfClass:[NSData class]]) {
        NSData *data = file;
        return [data writeToFile:path atomically:YES];
    } else if ([file isKindOfClass:[NSDictionary class]] || [file isKindOfClass:[NSArray class]]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:file options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return [jsonStr writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    return res;
}

#pragma mark 追加文本
+ (void)addContent:(NSString *)content filePath:(NSString *)filePath {
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    //光标移动到末尾
    [fileHandle seekToEndOfFile];
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [fileHandle writeData:data];
    [fileHandle closeFile];
}

#pragma mark 删除文件
- (BOOL)removePath:(NSString *)filePath {
    BOOL res =  [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    if (res) {
        NSLog(@"文件删除成功");
    }else {
        NSLog(@"文件删除失败");
    }
    return res;
}

#pragma mark 移动文件
- (BOOL)moveFilePath:(NSString *)filePath toTargetFilePath:(NSString *)targetFilePath {
    BOOL res = [[NSFileManager defaultManager] moveItemAtPath:filePath toPath:targetFilePath error:nil];
    if (res) {
        NSLog(@"文件移动成功");
    }else {
        NSLog(@"文件移动失败");
    }
    return res;
}

#pragma mark copy文件
- (BOOL)copyFilePath:(NSString *)filePath toTargetFilePath:(NSString *)targetFilePath {
    BOOL res = [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:targetFilePath error:nil];
    if (res) {
        NSLog(@"文件copy成功");
    }else {
        NSLog(@"文件copy失败");
    }
    return res;
}

#pragma mark 读取保存的文本
- (NSString *)readStringAtFliePath:(NSString *)filePath {
    return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark 读取保存的图片
- (UIImage *)readImageAtFilepath:(NSString *)filePath {
    return [UIImage imageWithContentsOfFile:filePath];
}

#pragma mark 读取保存的文件
- (NSData *)readDataAtFilepath:(NSString *)filePath {
    return [NSData dataWithContentsOfFile:filePath];
}

#pragma mark 计算文件大小
- (unsigned long long)fileSizeAtFilePath:(NSString *)filePath {
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
        return fileSize;
    }return 0;
}

#pragma mark 计算文件夹大小
- (unsigned long long)fileSizeAtFolderPath:(NSString *)folderPath {
    if ([[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        NSEnumerator *childEnumerator = [[[NSFileManager defaultManager] subpathsAtPath:folderPath] objectEnumerator];
        NSString *fileName = @"";
        unsigned long long folderSize = 0;
        //遍历文件夹 查找文件获取每个文件的大小
        while ((fileName =  [childEnumerator nextObject])!= nil) {
            NSString *filePath = [folderPath stringByAppendingString:fileName];
            folderSize += [self fileSizeAtFolderPath:filePath];
        }
        return folderSize;
    }return 0;
}

#pragma mark 文件大小格式化
- (NSString *)formatSize:(unsigned long long)fileSize {
    if (fileSize <= 0) {
        return @"0K";
    }
    if (fileSize < 1024) {
        return  [NSString stringWithFormat:@"%0.2fB",(fileSize/1.f)];;
    }else if ((fileSize/1024.0) < 1024) {
        return [NSString stringWithFormat:@"%0.2fkB",(fileSize/1024.f)];
    }else  {
        return [NSString stringWithFormat:@"%0.2fM",(fileSize/1024.f/1024)];
    }
}
@end