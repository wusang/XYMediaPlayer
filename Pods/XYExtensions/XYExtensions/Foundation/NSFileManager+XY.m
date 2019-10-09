//
//  NSFileManager+XY.m
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/24.
//  Copyright © 2019 lange. All rights reserved.
//

#import "NSFileManager+XY.h"

@implementation NSFileManager (XY)

+ (NSURL *)xy_URLForDirectory:(NSSearchPathDirectory)directory{
    return [self.defaultManager URLsForDirectory:directory inDomains:NSUserDomainMask].lastObject;
}

+ (NSString *)xy_pathForDirectory:(NSSearchPathDirectory)directory{
    return NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES)[0];
}

+ (NSURL *)xy_documentsURL{
    return [self xy_URLForDirectory:NSDocumentDirectory];
}

+ (NSString *)xy_documentsPath{
    return [self xy_pathForDirectory:NSDocumentDirectory];
}

+ (NSURL *)xy_libraryURL{
    return [self xy_URLForDirectory:NSLibraryDirectory];
}

+ (NSString *)xy_libraryPath{
    return [self xy_pathForDirectory:NSLibraryDirectory];
}

+ (NSURL *)xy_cachesURL{
    return [self xy_URLForDirectory:NSCachesDirectory];
}

+ (NSString *)xy_cachesPath{
    return [self xy_pathForDirectory:NSCachesDirectory];
}

+ (BOOL)xy_addSkipBackupAttributeToFile:(NSString *)path{
    return [[NSURL.alloc initFileURLWithPath:path] setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
}

+ (double)xy_availableDiskSpace{
    NSDictionary *attributes = [self.defaultManager attributesOfFileSystemForPath:self.xy_documentsPath error:nil];
    
    return [attributes[NSFileSystemFreeSize] unsignedLongLongValue] / (double)0x100000;
}

+ (BOOL)xy_fileIsExistOfPath:(NSString *)filePath{
    BOOL flag = NO;
    if ([self.defaultManager fileExistsAtPath:filePath]) {
        flag = YES;
    } else {
        flag = NO;
    }
    return flag;
}
+ (BOOL)xy_removeFileOfPath:(NSString *)filePath{
    BOOL flag = YES;
    if ([self.defaultManager fileExistsAtPath:filePath]) {
        if (![self.defaultManager removeItemAtPath:filePath error:nil]) {
            flag = NO;
        }
    }
    return flag;
}

+ (BOOL)xy_creatDirectoryWithPath:(NSString *)dirPath{
    BOOL ret = YES;
    BOOL isExist = [self.defaultManager fileExistsAtPath:dirPath];
    if (!isExist) {
        NSError *error;
        BOOL isSuccess = [self.defaultManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!isSuccess) {
            ret = NO;
            NSLog(@"creat Directory Failed. errorInfo:%@",error);
        }
    }
    return ret;
}
+ (BOOL)xy_creatFileWithPath:(NSString *)filePath{
    BOOL isSuccess = YES;
    BOOL temp = [self.defaultManager fileExistsAtPath:filePath];
    if (temp) {
        return YES;
    }
    NSError *error;
    //stringByDeletingLastPathComponent:删除最后一个路径节点
    NSString *dirPath = [filePath stringByDeletingLastPathComponent];
    isSuccess = [self.defaultManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        NSLog(@"creat File Failed. errorInfo:%@",error);
    }
    if (!isSuccess) {
        return isSuccess;
    }
    isSuccess = [self.defaultManager createFileAtPath:filePath contents:nil attributes:nil];
    return isSuccess;
}

+ (BOOL)xy_saveFile:(NSString *)filePath withData:(NSData *)data{
    BOOL ret = YES;
    ret = [self xy_creatFileWithPath:filePath];
    if (ret) {
        ret = [data writeToFile:filePath atomically:YES];
        if (!ret) {
            NSLog(@"%s Failed",__FUNCTION__);
        }
    } else {
        NSLog(@"%s Failed",__FUNCTION__);
    }
    return ret;
}

+ (BOOL)xy_appendData:(NSData *)data withPath:(NSString *)path{
    BOOL result = [self xy_creatFileWithPath:path];
    if (result) {
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
        [handle seekToEndOfFile];
        [handle writeData:data];
        [handle synchronizeFile];
        [handle closeFile];
        return YES;
    } else {
        NSLog(@"%s Failed",__FUNCTION__);
        return NO;
    }
}

+ (NSData *)xy_getFileData:(NSString *)filePath{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData *fileData = [handle readDataToEndOfFile];
    [handle closeFile];
    return fileData;
}

+ (NSData *)xy_getFileData:(NSString *)filePath startIndex:(long long)startIndex length:(NSInteger)length{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    [handle seekToFileOffset:startIndex];
    NSData *data = [handle readDataOfLength:length];
    [handle closeFile];
    return data;
}

+ (BOOL)xy_moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath{
    if (![self.defaultManager fileExistsAtPath:fromPath]) {
        NSLog(@"Error: fromPath Not Exist");
        return NO;
    }
    if (![self.defaultManager fileExistsAtPath:toPath]) {
        NSLog(@"Error: toPath Not Exist");
        return NO;
    }
    NSString *headerComponent = [toPath stringByDeletingLastPathComponent];
    if ([self xy_creatFileWithPath:headerComponent]) {
        return [self.defaultManager moveItemAtPath:fromPath toPath:toPath error:nil];
    } else {
        return NO;
    }
}

+ (BOOL)xy_copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath{
    if (![self.defaultManager fileExistsAtPath:fromPath]) {
        NSLog(@"Error: fromPath Not Exist");
        return NO;
    }
    if (![self.defaultManager fileExistsAtPath:toPath]) {
        NSLog(@"Error: toPath Not Exist");
        return NO;
    }
    NSString *headerComponent = [toPath stringByDeletingLastPathComponent];
    if ([self xy_creatFileWithPath:headerComponent]) {
        return [self.defaultManager copyItemAtPath:fromPath toPath:toPath error:nil];
    } else {
        return NO;
    }
}

+ (NSArray *)xy_getFileListInFolderWithPath:(NSString *)path{
    NSError *error;
    NSArray *fileList = [self.defaultManager contentsOfDirectoryAtPath:path error:&error];
    if (error) {
        NSLog(@"getFileListInFolderWithPathFailed, errorInfo:%@",error);
    }
    return fileList;
}

+ (long long)xy_getFileSizeWithPath:(NSString *)path{
    unsigned long long fileLength = 0;
    NSNumber *fileSize;
    NSDictionary *fileAttributes = [self.defaultManager attributesOfItemAtPath:path error:nil];
    if ((fileSize = [fileAttributes objectForKey:NSFileSize])) {
        fileLength = [fileSize unsignedLongLongValue];
    }
    return fileLength;
}

+ (NSString *)xy_sizeStringBy:(NSInteger)size{
    if (size > 1024 * 1024) {
        float currentSize = size / 1024.0 / 1024.0;
        return [NSString stringWithFormat:@"%.fM",currentSize];
    }else if (size > 1024){
        float currentSize = size / 1024.0 ;
        return [NSString stringWithFormat:@"%.fKB",currentSize];
    }else{
        return [NSString stringWithFormat:@"%ziB",size];
    }
    
}

@end
