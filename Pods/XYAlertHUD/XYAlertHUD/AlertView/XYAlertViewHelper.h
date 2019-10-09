//
//  XYAlertViewHelper.h
//  XYAlertView
//
//
//

#import <UIKit/UIKit.h>

@class XYAlertView;

#pragma mark - Constants

extern CGFloat const XYAlertViewPaddingWidth;
extern CGFloat const XYAlertViewPaddingHeight;
extern CGFloat const XYAlertViewButtonImageOffsetFromTitle;

#pragma mark - Interface

@interface XYAlertViewHelper : NSObject

+ (void)animateWithDuration:(NSTimeInterval)duration
                 animations:(void(^)())animations
                 completion:(void(^)(BOOL finished))completion;

+ (void)keyboardAnimateWithNotificationUserInfo:(NSDictionary *)notificationUserInfo
                                     animations:(void(^)(CGFloat keyboardHeight))animations;

+ (UIImage *)image1x1WithColor:(UIColor *)color;

+ (BOOL)isNotRetina;

+ (BOOL)isPad;

+ (CGFloat)statusBarHeight;

+ (CGFloat)separatorHeight;

+ (BOOL)isPadAndNotForce:(XYAlertView *)alertView;

+ (BOOL)isCancelButtonSeparate:(XYAlertView *)alertView;

+ (CGFloat)systemVersion;

+ (UIWindow *)appWindow;
+ (UIWindow *)keyWindow;

+ (BOOL)isViewControllerBasedStatusBarAppearance;

@end
