//
//  UINavigationBar+XY.m
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/24.
//  Copyright © 2019 lange. All rights reserved.
//

#import "UINavigationBar+XY.h"
#import <objc/runtime.h>

@implementation UINavigationBar (XY)

static char xy_overlayKey;

- (UIView *)xy_overlay{
    return objc_getAssociatedObject(self, &xy_overlayKey);
}

- (void)setXy_overlay:(UIView *)overlay{
    objc_setAssociatedObject(self, &xy_overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)xy_setBackgroundColor:(UIColor *)backgroundColor{
    if (!self.xy_overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.xy_overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
        self.xy_overlay.userInteractionEnabled = NO;
        self.xy_overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.xy_overlay atIndex:0];
    }
    self.xy_overlay.backgroundColor = backgroundColor;
}

- (void)xy_setTranslationY:(CGFloat)translationY{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)xy_setElementsAlpha:(CGFloat)alpha{
    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = alpha;
    //    when viewController first load, the titleView maybe nil
    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
            obj.alpha = alpha;
            *stop = YES;
        }
    }];
}

- (void)xy_reset{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.xy_overlay removeFromSuperview];
    self.xy_overlay = nil;
}


@end
