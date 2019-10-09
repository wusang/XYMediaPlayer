//
//  UIDevice+XY.h
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/24.
//  Copyright © 2019 lange. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (XY)

+ (NSString *)xy_platform;
+ (NSString *)xy_platformString;


+ (NSString *)xy_macAddress;

//Return the current device CPU frequency
+ (NSUInteger)xy_cpuFrequency;
// Return the current device BUS frequency
+ (NSUInteger)xy_busFrequency;
//current device RAM size
+ (NSUInteger)xy_ramSize;
//Return the current device CPU number
+ (NSUInteger)xy_cpuNumber;
//Return the current device total memory

/// 获取iOS系统的版本号
+ (NSString *)xy_systemVersion;
/// 判断当前系统是否有摄像头
+ (BOOL)xy_hasCamera;
/// 获取手机内存总量, 返回的是字节数
+ (NSUInteger)xy_totalMemoryBytes;
/// 获取手机可用内存, 返回的是字节数
+ (NSUInteger)xy_freeMemoryBytes;

/// 获取手机硬盘空闲空间, 返回的是字节数
+ (long long)xy_freeDiskSpaceBytes;
/// 获取手机硬盘总空间, 返回的是字节数
+ (long long)xy_totalDiskSpaceBytes;

@end

NS_ASSUME_NONNULL_END
