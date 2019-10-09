//
//  NSUserDefaults+XY.h
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/24.
//  Copyright © 2019 lange. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (XY)

+ (NSString *)xy_stringForKey:(NSString *)defaultName;

+ (NSArray *)xy_arrayForKey:(NSString *)defaultName;

+ (NSDictionary *)xy_dictionaryForKey:(NSString *)defaultName;

+ (NSData *)xy_dataForKey:(NSString *)defaultName;

+ (NSArray *)xy_stringArrayForKey:(NSString *)defaultName;

+ (NSInteger)xy_integerForKey:(NSString *)defaultName;

+ (float)xy_floatForKey:(NSString *)defaultName;

+ (double)xy_doubleForKey:(NSString *)defaultName;

+ (BOOL)xy_boolForKey:(NSString *)defaultName;

+ (void)xy_setObject:(id)value forKey:(NSString *)defaultName;

@end

NS_ASSUME_NONNULL_END
