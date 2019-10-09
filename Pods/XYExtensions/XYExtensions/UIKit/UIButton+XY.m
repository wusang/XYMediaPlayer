//
//  UIButton+XY.m
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/24.
//  Copyright © 2019 lange. All rights reserved.
//

#import "UIButton+XY.h"
#import <objc/runtime.h>

@interface UIButton ()

@property(nonatomic, strong) UIView *xy_modalView;
@property(nonatomic, strong) UIActivityIndicatorView *xy_spinnerView;
@property(nonatomic, strong) UILabel *xy_spinnerTitleLabel;

@end

@implementation UIButton (XY)

- (UIEdgeInsets)xy_touchAreaInsets{
    return [objc_getAssociatedObject(self, @selector(xy_touchAreaInsets)) UIEdgeInsetsValue];
}

- (void)setXy_touchAreaInsets:(UIEdgeInsets)touchAreaInsets{
    NSValue *value = [NSValue valueWithUIEdgeInsets:touchAreaInsets];
    objc_setAssociatedObject(self, @selector(xy_touchAreaInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    UIEdgeInsets touchAreaInsets = self.xy_touchAreaInsets;
    CGRect bounds = self.bounds;
    bounds = CGRectMake(bounds.origin.x - touchAreaInsets.left,
                        bounds.origin.y - touchAreaInsets.top,
                        bounds.size.width + touchAreaInsets.left + touchAreaInsets.right,
                        bounds.size.height + touchAreaInsets.top + touchAreaInsets.bottom);
    return CGRectContainsPoint(bounds, point);
}

- (void)xy_setImagePosition:(XYImagePosition)postion spacing:(CGFloat)spacing{
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGFloat labelWidth = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
    CGFloat labelHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font].height;
#pragma clang diagnostic pop
    
    CGFloat imageOffsetX = (imageWith + labelWidth) / 2 - imageWith / 2;//image中心移动的x距离
    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
    CGFloat labelOffsetX = (imageWith + labelWidth / 2) - (imageWith + labelWidth) / 2;//label中心移动的x距离
    CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离
    
    switch (postion) {
        case XYImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            break;
            
        case XYImagePositionRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageHeight + spacing/2), 0, imageHeight + spacing/2);
            break;
            
        case XYImagePositionTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            break;
            
        case XYImagePositionBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            break;
            
        default:
            break;
    }
}

- (void)xy_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state{
    [self setBackgroundImage:[UIButton xy_b_imageWithColor:backgroundColor] forState:state];
}
+ (UIImage *)xy_b_imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 提交按钮
- (void)xy_beginSubmitting:(NSString *)title{
    [self xy_endSubmitting];
    
    self.xy_submitting = @YES;
    self.hidden = YES;
    
    self.xy_modalView = [[UIView alloc] initWithFrame:self.frame];
    self.xy_modalView.backgroundColor =
    [self.backgroundColor colorWithAlphaComponent:0.6];
    self.xy_modalView.layer.cornerRadius = self.layer.cornerRadius;
    self.xy_modalView.layer.borderWidth = self.layer.borderWidth;
    self.xy_modalView.layer.borderColor = self.layer.borderColor;
    
    CGRect viewBounds = self.xy_modalView.bounds;
    self.xy_spinnerView = [[UIActivityIndicatorView alloc]
                           initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.xy_spinnerView.tintColor = self.titleLabel.textColor;
    
    CGRect spinnerViewBounds = self.xy_spinnerView.bounds;
    self.xy_spinnerView.frame = CGRectMake(
                                           15, viewBounds.size.height / 2 - spinnerViewBounds.size.height / 2,
                                           spinnerViewBounds.size.width, spinnerViewBounds.size.height);
    self.xy_spinnerTitleLabel = [[UILabel alloc] initWithFrame:viewBounds];
    self.xy_spinnerTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.xy_spinnerTitleLabel.text = title;
    self.xy_spinnerTitleLabel.font = self.titleLabel.font;
    self.xy_spinnerTitleLabel.textColor = self.titleLabel.textColor;
    [self.xy_modalView addSubview:self.xy_spinnerView];
    [self.xy_modalView addSubview:self.xy_spinnerTitleLabel];
    [self.superview addSubview:self.xy_modalView];
    [self.xy_spinnerView startAnimating];
}
- (void)xy_endSubmitting{
    if (!self.xy_submitting.boolValue) {
        return;
    }
    
    self.xy_submitting = @NO;
    self.hidden = NO;
    
    [self.xy_modalView removeFromSuperview];
    self.xy_modalView = nil;
    self.xy_spinnerView = nil;
    self.xy_spinnerTitleLabel = nil;
}

- (void)setXy_submitting:(NSNumber * _Nonnull)submitting{
    objc_setAssociatedObject(self, @selector(setXy_submitting:), submitting, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)xy_submitting{
    return objc_getAssociatedObject(self, @selector(setXy_submitting:));
}

- (UIActivityIndicatorView *)xy_spinnerView{
    return objc_getAssociatedObject(self, @selector(setXy_spinnerView:));
}

- (void)setXy_spinnerView:(UIActivityIndicatorView *)spinnerView{
    objc_setAssociatedObject(self, @selector(setXy_spinnerView:), spinnerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)xy_modalView{
    return objc_getAssociatedObject(self, @selector(setXy_modalView:));
}

- (void)setXy_modalView:(UIView *)modalView{
    objc_setAssociatedObject(self, @selector(setXy_modalView:), modalView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)xy_spinnerTitleLabel{
    return objc_getAssociatedObject(self, @selector(setXy_spinnerTitleLabel:));
}

- (void)setXy_spinnerTitleLabel:(UILabel *)spinnerTitleLabel{
    objc_setAssociatedObject(self, @selector(setXy_spinnerTitleLabel:), spinnerTitleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
