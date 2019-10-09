//
//  UIImage+XY.h
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/7/30.
//  Copyright © 2019 lange. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (XY)

#pragma mark - Bundle资源
+ (UIImage *)xy_imageNamed:(NSString *)name atBundle:(NSBundle *)bundle;
+ (UIImage *)xy_imageNamed:(NSString *)name atDir:(nullable NSString *)dir atBundle:(NSBundle *)bundle;
+ (UIImage *)xy_animatedImageNamed:(NSString *)name atDir:(nullable NSString *)dir duration:(NSInteger)duration atBundle:(NSBundle *)bundle;
+ (UIImage *)xy_imagePathName:(NSString *)name atBundle:(NSBundle *)bundle;
+ (UIImage *)xy_imagePathName:(NSString *)name atDir:(nullable NSString *)dir atBundle:(NSBundle *)bundle;
+ (UIImage *)xy_animatedGIFNamed:(NSString *)name atDir:(nonnull NSString *)dir atBundle:(nonnull NSBundle *)bundle;
+ (NSArray *)xy_animationImagesWithImageName:(NSString *)name atDir:(NSString *)dir atBundle:(NSBundle *)bundle;
#pragma mark - UIView转UIImage
+ (UIImage *)xy_imageWithView:(UIView*)view;
+ (UIImage *)xy_imageWithColor:(UIColor *)color size:(CGSize)size;

#pragma mark - UIImage处理
- (UIImage *)xy_transformtoSize:(CGSize)Newsize;
+ (UIImage *)xy_fixOrientation:(UIImage *)aImage;

@end

NS_ASSUME_NONNULL_END
