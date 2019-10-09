//
//  NSNumber+XY.h
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/24.
//  Copyright © 2019 lange. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (XY)

/* 展示 */
- (NSString*)xy_toDisplayNumberWithDigit:(NSInteger)digit;
- (NSString*)xy_toDisplayPercentageWithDigit:(NSInteger)digit;

/** 四舍五入 */
- (NSNumber*)xy_doRoundWithDigit:(NSUInteger)digit;
/** 取上整 */
- (NSNumber*)xy_doCeilWithDigit:(NSUInteger)digit;
/** 取下整 */
- (NSNumber*)xy_doFloorWithDigit:(NSUInteger)digit;

@end

NS_ASSUME_NONNULL_END
