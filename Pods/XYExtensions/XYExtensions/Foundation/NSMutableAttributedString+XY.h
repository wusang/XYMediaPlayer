//
//  NSMutableAttributedString+XY.h
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/24.
//  Copyright © 2019 lange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (XY)

- (void)xy_setColor:(UIColor *)color;
- (void)xy_setColor:(UIColor *)color atRange:(NSRange)range;

- (void)xy_setFont:(CGFloat)font;
- (void)xy_setFont:(CGFloat)font atRange:(NSRange)range;

- (void)xy_setBoldFont:(CGFloat)font;
- (void)xy_setBoldFont:(CGFloat)font atRange:(NSRange)range;

- (void)xy_setChineseForegroundColor:(UIColor *)color font:(CGFloat)font;
- (void)xy_setNumberForegroundColor:(UIColor *)color font:(CGFloat)font;
- (void)xy_setSubChar:(NSString *)subStr foregroundColor:(UIColor *)color font:(CGFloat)font;
- (void)xy_addParagraphLineSpacing:(CGFloat) lineSpacing;

+ (NSMutableAttributedString *)xy_AttributedStringByHtmls:(NSArray *)htmls colors:(NSArray *)colors fonts:(NSArray *)fonts;

@end

NS_ASSUME_NONNULL_END
