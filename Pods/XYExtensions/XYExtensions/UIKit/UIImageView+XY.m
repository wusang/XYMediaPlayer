//
//  UIImageView+XY.m
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/24.
//  Copyright © 2019 lange. All rights reserved.
//

#import "UIImageView+XY.h"
#import <objc/runtime.h>

const char kProcessedImage;
@interface UIImageView ()

@property (assign, nonatomic) CGFloat xyRadius;
@property (assign, nonatomic) UIRectCorner roundingCorners;
@property (assign, nonatomic) CGFloat xyBorderWidth;
@property (strong, nonatomic) UIColor *xyBorderColor;
@property (assign, nonatomic) BOOL xyHadAddObserver;
@property (assign, nonatomic) BOOL xyIsRounding;

@end


@implementation UIImageView (XY)

#pragma mark - 倒角
- (instancetype)initWithRoundingRectImageView {
    self = [super init];
    if (self) {
        [self xy_cornerRadiusRoundingRect];
    }
    return self;
}

- (instancetype)initWithCornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    self = [super init];
    if (self) {
        [self xy_cornerRadiusAdvance:cornerRadius rectCornerType:rectCornerType];
    }
    return self;
}

- (void)xy_attachBorderWidth:(CGFloat)width color:(UIColor *)color {
    self.xyBorderWidth = width;
    self.xyBorderColor = color;
}


- (void)xy_cornerRadiusWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (nil == currentContext) {
        return;
    }
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCornerType cornerRadii:cornerRadii];
    [cornerPath addClip];
    [self.layer renderInContext:currentContext];
    [self drawBorder:cornerPath];
    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (processedImage) {
        objc_setAssociatedObject(processedImage, &kProcessedImage, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    self.image = processedImage;
}


- (void)xy_cornerRadiusWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType backgroundColor:(UIColor *)backgroundColor {
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (nil == currentContext) {
        return;
    }
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCornerType cornerRadii:cornerRadii];
    UIBezierPath *backgroundRect = [UIBezierPath bezierPathWithRect:self.bounds];
    [backgroundColor setFill];
    [backgroundRect fill];
    [cornerPath addClip];
    [self.layer renderInContext:currentContext];
    [self drawBorder:cornerPath];
    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (processedImage) {
        objc_setAssociatedObject(processedImage, &kProcessedImage, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    self.image = processedImage;
}

/**
 * @brief set cornerRadius for UIImageView, no off-screen-rendered
 */
- (void)xy_cornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    self.xyRadius = cornerRadius;
    self.roundingCorners = rectCornerType;
    self.xyIsRounding = NO;
    if (!self.xyHadAddObserver) {
        [[self class] swizzleDealloc];
        [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        self.xyHadAddObserver = YES;
    }
    //Xcode 8 xib 删除了控件的Frame信息，需要主动创造
    [self layoutIfNeeded];
}

/**
 * @brief become Rounding UIImageView, no off-screen-rendered
 */
- (void)xy_cornerRadiusRoundingRect {
    self.xyIsRounding = YES;
    if (!self.xyHadAddObserver) {
        [[self class] swizzleDealloc];
        [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        self.xyHadAddObserver = YES;
    }
    //Xcode 8 xib 删除了控件的Frame信息，需要主动创造
    [self layoutIfNeeded];
}

#pragma mark - Private
- (void)drawBorder:(UIBezierPath *)path {
    if (0 != self.xyBorderWidth && nil != self.xyBorderColor) {
        [path setLineWidth:2 * self.xyBorderWidth];
        [self.xyBorderColor setStroke];
        [path stroke];
    }
}

- (void)xy_dealloc {
    if (self.xyHadAddObserver) {
        [self removeObserver:self forKeyPath:@"image"];
    }
    [self xy_dealloc];
}

- (void)validateFrame {
    if (self.frame.size.width == 0) {
        [self.class swizzleLayoutSubviews];
    }
}

+ (void)swizzleMethod:(SEL)oneSel anotherMethod:(SEL)anotherSel {
    Method oneMethod = class_getInstanceMethod(self, oneSel);
    Method anotherMethod = class_getInstanceMethod(self, anotherSel);
    method_exchangeImplementations(oneMethod, anotherMethod);
}

+ (void)swizzleDealloc {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:NSSelectorFromString(@"dealloc") anotherMethod:@selector(xy_dealloc)];
    });
}

+ (void)swizzleLayoutSubviews {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(layoutSubviews) anotherMethod:@selector(xy_LayoutSubviews)];
    });
}

- (void)xy_LayoutSubviews {
    [self xy_LayoutSubviews];
    if (self.xyIsRounding) {
        [self xy_cornerRadiusWithImage:self.image cornerRadius:self.frame.size.width/2 rectCornerType:UIRectCornerAllCorners];
    } else if (0 != self.xyRadius && 0 != self.roundingCorners && nil != self.image) {
        [self xy_cornerRadiusWithImage:self.image cornerRadius:self.xyRadius rectCornerType:self.roundingCorners];
    }
}

#pragma mark - KVO for .image
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"image"]) {
        UIImage *newImage = change[NSKeyValueChangeNewKey];
        if ([newImage isMemberOfClass:[NSNull class]]) {
            return;
        } else if ([objc_getAssociatedObject(newImage, &kProcessedImage) intValue] == 1) {
            return;
        }
        [self validateFrame];
        if (self.xyIsRounding) {
            [self xy_cornerRadiusWithImage:newImage cornerRadius:self.frame.size.width/2 rectCornerType:UIRectCornerAllCorners];
        } else if (0 != self.xyRadius && 0 != self.roundingCorners && nil != self.image) {
            [self xy_cornerRadiusWithImage:newImage cornerRadius:self.xyRadius rectCornerType:self.roundingCorners];
        }
    }
}

#pragma mark property
- (CGFloat)xyBorderWidth {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setXyBorderWidth:(CGFloat)xyBorderWidth {
    objc_setAssociatedObject(self, @selector(xyBorderWidth), @(xyBorderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)xyBorderColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setXyBorderColor:(UIColor *)xyBorderColor {
    objc_setAssociatedObject(self, @selector(xyBorderColor), xyBorderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)xyHadAddObserver {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setXyHadAddObserver:(BOOL)xyHadAddObserver {
    objc_setAssociatedObject(self, @selector(xyHadAddObserver), @(xyHadAddObserver), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)xyIsRounding {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setXyIsRounding:(BOOL)xyIsRounding {
    objc_setAssociatedObject(self, @selector(xyIsRounding), @(xyIsRounding), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIRectCorner)roundingCorners {
    return [objc_getAssociatedObject(self, _cmd) unsignedLongValue];
}

- (void)setRoundingCorners:(UIRectCorner)roundingCorners {
    objc_setAssociatedObject(self, @selector(roundingCorners), @(roundingCorners), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)xyRadius {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setXyRadius:(CGFloat)xyRadius {
    objc_setAssociatedObject(self, @selector(xyRadius), @(xyRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
