//
//  NSFileManager+XY.h
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/24.
//  Copyright © 2019 lange. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (XY)

+ (NSURL *)xy_documentsURL;

+ (NSString *)xy_documentsPath;

+ (NSURL *)xy_libraryURL;

+ (NSString *)xy_libraryPath;

+ (NSURL *)xy_cachesURL;

+ (NSString *)xy_cachesPath;

+ (BOOL)xy_addSkipBackupAttributeToFile:(NSString *)path;

+ (double)xy_availableDiskSpace;

/** 判断文件是否存在于某个路径中 */
+ (BOOL)xy_fileIsExistOfPath:(NSString *)filePath;

/** 从某个路径中移除文件 */
+ (BOOL)xy_removeFileOfPath:(NSString *)filePath;

/** 创建文件夹 */
+ (BOOL)xy_creatDirectoryWithPath:(NSString *)dirPath;

/** 创建文件 */
+ (BOOL)xy_creatFileWithPath:(NSString *)filePath;

/** 保存文件 */
+ (BOOL)xy_saveFile:(NSString *)filePath withData:(NSData *)data;

/** 追加写文件 */
+ (BOOL)xy_appendData:(NSData *)data withPath:(NSString *)path;

/** 获取文件 */
+ (NSData *)xy_getFileData:(NSString *)filePath;

/** 获取指定文件 */
+ (NSData *)xy_getFileData:(NSString *)filePath startIndex:(long long)startIndex length:(NSInteger)length;

/** 移动文件 */
+ (BOOL)xy_moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;

/** 拷贝文件 */
+ (BOOL)xy_copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;

/** 获取文件夹下文件列表 */
+ (NSArray *)xy_getFileListInFolderWithPath:(NSString *)path;

/** 获取文件大小 */
+ (long long)xy_getFileSizeWithPath:(NSString *)path;

+ (NSString *)xy_sizeStringBy:(NSInteger)size;

@end

NS_ASSUME_NONNULL_END
