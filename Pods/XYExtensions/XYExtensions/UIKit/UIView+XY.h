//
//  UIView+XY.h
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/23.
//  Copyright © 2019 lange. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XYShakeDirection) {
    XYShakeDirectionHorizontal = 0,
    XYShakeDirectionVertical
};

@interface UIView (XY)
#pragma mark - 渐变色
@property(nullable, copy) NSArray *colors;
@property(nullable, copy) NSArray<NSNumber *> *locations;
@property CGPoint startPoint;
@property CGPoint endPoint;

+ (UIView *_Nullable)xy_gradientViewWithColors:(NSArray<UIColor *> *_Nullable)colors
                                     locations:(NSArray<NSNumber *> *_Nullable)locations
                                    startPoint:(CGPoint)startPoint
                                      endPoint:(CGPoint)endPoint;

- (void)xy_setGradientBackgroundWithColors:(NSArray<UIColor *> *_Nullable)colors
                                 locations:(NSArray<NSNumber *> *_Nullable)locations
                                startPoint:(CGPoint)startPoint
                                  endPoint:(CGPoint)endPoint;

#pragma mark - UIView处理
- (void)xy_clipLayerWithRadius:(CGFloat)r
                         width:(CGFloat)w
                         color:(nullable UIColor *)color;

- (void)xy_shadowWithWidth:(CGFloat)width
               borderColor:(UIColor *)borderColor
                   opacity:(CGFloat)opacity
                    radius:(CGFloat)radius
                    offset:(CGSize)offset;

- (void)xy_shadowWithCornerRadius:(CGFloat)cRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor shadowColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowOffset:(CGSize)shadowOffset roundedRect:(CGRect)roundedRect cornerRadii:(CGSize)cornerRadii rectCorner:(UIRectCorner)rectCorner;
#pragma mark - Shake
- (void)xy_shake;
- (void)xy_shake:(int)times withDelta:(CGFloat)delta;
- (void)xy_shake:(int)times withDelta:(CGFloat)delta completion:(void((^)(void)))handler;
- (void)xy_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval;
- (void)xy_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(void((^)(void)))handler;
- (void)xy_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(XYShakeDirection)shakeDirection;
- (void)xy_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(XYShakeDirection)shakeDirection completion:(void(^)(void))completion;

#pragma mark - Frame
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;


@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;

- (BOOL)xy_isIPAD;
- (BOOL)xy_isIPhoneX;
- (CGFloat)xy_stateBarSpace;
- (CGFloat)xy_tabBarSpace;
- (CGFloat)xy_customNavBarHeight;
- (CGFloat)xy_customTabBarHeight;
@end

NS_ASSUME_NONNULL_END
