//
//  UINavigationBar+XY.h
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/24.
//  Copyright © 2019 lange. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (XY)

- (void)xy_setBackgroundColor:(UIColor *)backgroundColor;
- (void)xy_setElementsAlpha:(CGFloat)alpha;
- (void)xy_setTranslationY:(CGFloat)translationY;
- (void)xy_reset;

@end

NS_ASSUME_NONNULL_END
