//
//  NSMutableAttributedString+XY.m
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/24.
//  Copyright © 2019 lange. All rights reserved.
//

#import "NSMutableAttributedString+XY.h"

@implementation NSMutableAttributedString (XY)

- (void)xy_setColor:(UIColor *)color{
    [self xy_setColor:color atRange:NSMakeRange(0, self.length)];
}
- (void)xy_setColor:(UIColor *)color atRange:(NSRange)range{
    [self addAttribute:NSForegroundColorAttributeName value:color range:range];
}
- (void)xy_setFont:(CGFloat)font{
    [self xy_setFont:font atRange:NSMakeRange(0, self.length)];
}
- (void)xy_setBoldFont:(CGFloat)font{
    [self xy_setBoldFont:font atRange:NSMakeRange(0, self.length)];
}
- (void)xy_setBoldFont:(CGFloat)font atRange:(NSRange)range{
    [self addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:font] range:range];
}
- (void)xy_setFont:(CGFloat)font atRange:(NSRange)range{
    [self addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range];
}
- (void)xy_addParagraphLineSpacing:(CGFloat)lineSpacing{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
}
- (void)xy_setChineseForegroundColor:(UIColor *)color font:(CGFloat)font{
    for (int i=0; i<self.string.length; i++) {
        unichar ch = [self.string characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            [self addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(i, 1)];
            [self addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(i, 1)];
        }
    }
}

- (void)xy_setNumberForegroundColor:(UIColor *)color font:(CGFloat)font{
    for (int i=0; i<self.string.length; i++) {
        unichar ch = [self.string characterAtIndex:i];
        if (0x0030 <= ch  && ch <= 0x0039) {
            [self addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(i, 1)];
            [self addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(i, 1)];
        }
    }
}

- (void)xy_setSubChar:(NSString *)subStr foregroundColor:(UIColor *)color font:(CGFloat)font{
    for (int i=0; i<self.string.length; i++) {
        NSString *ch = [self.string substringWithRange:NSMakeRange(i, 1)];
        if ([ch isEqualToString:subStr]) {
            [self addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(i, 1)];
            [self addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(i, 1)];
        }
    }
}

+ (NSMutableAttributedString *)xy_AttributedStringByHtmls:(NSArray *)htmls colors:(NSArray *)colors fonts:(NSArray *)fonts{
    NSMutableArray *atts = [NSMutableArray array];
    for (int i = 0; i < htmls.count; i++) {
        NSString *html = htmls[i];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:html];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[fonts[i] integerValue]]range:NSMakeRange(0,attrStr.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:colors[i] range:NSMakeRange(0,attrStr.length)];
        [atts addObject:attrStr];
    }
    NSMutableAttributedString *att = [atts firstObject];
    for (int i = 1; i < atts.count; i++) {
        NSMutableAttributedString *att1 = atts[i];
        [att appendAttributedString:att1];
    }
    return att;
}

@end
