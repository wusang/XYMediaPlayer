//
//  NSDictionary+XY.h
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/24.
//  Copyright © 2019 lange. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (XY)

- (void)xy_each:(void (^)(id k, id v))block;
- (void)xy_eachKey:(void (^)(id k))block;
- (void)xy_eachValue:(void (^)(id v))block;
- (NSArray *)xy_map:(id (^)(id key, id value))block;
- (NSDictionary *)xy_pick:(NSArray *)keys;
- (NSDictionary *)xy_omit:(NSArray *)key;

#pragma msrk - URL
+ (NSDictionary *)xy_dictionaryWithURLQuery:(NSString *)query;
- (NSString *)xy_URLQueryString;

@end

NS_ASSUME_NONNULL_END
