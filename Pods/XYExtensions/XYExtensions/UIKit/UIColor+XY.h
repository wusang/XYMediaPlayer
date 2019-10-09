//
//  UIColor+XY.h
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/23.
//  Copyright © 2019 lange. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (XY)

+ (UIColor *)xy_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

+ (UIColor *)xy_colorwithHexString:(NSString *)color;

+ (UIColor*)xy_colorWithHex:(NSInteger)hexValue;

+ (UIColor*)xy_colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

@end

NS_ASSUME_NONNULL_END
