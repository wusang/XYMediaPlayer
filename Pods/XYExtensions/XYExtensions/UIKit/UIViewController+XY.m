//
//  UIViewController+XY.m
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/24.
//  Copyright © 2019 lange. All rights reserved.
//

#import "UIViewController+XY.h"
#import <objc/runtime.h>
static const void *XYBackButtonHandlerKey = &XYBackButtonHandlerKey;
@implementation UIViewController (XY)

- (void)xy_backButtonTouched:(XYBackButtonHandler)backButtonHandler{
    objc_setAssociatedObject(self, XYBackButtonHandlerKey, backButtonHandler, OBJC_ASSOCIATION_COPY);
}
- (XYBackButtonHandler)xy_backButtonTouched{
    return objc_getAssociatedObject(self, XYBackButtonHandlerKey);
}

+ (UIViewController *)xy_topControllerForController:(UIViewController *)controller{
    NSLog(@"findTopController: %@", NSStringFromClass(controller.class));
    UIViewController *nextController;
    if (nextController == nil && [controller respondsToSelector:@selector(presentedViewController)]) {
        nextController = [controller performSelector:@selector(presentedViewController)];
    }
    if (nextController == nil && [controller respondsToSelector:@selector(topViewController)]) {
        nextController = [controller performSelector:@selector(topViewController)];
    }
    if (nextController == nil && [controller respondsToSelector:@selector(selectedViewController)]) {
        nextController = [controller performSelector:@selector(selectedViewController)];
    }
    if (nextController) {
        return [self xy_topControllerForController:nextController];
    } else {
        return controller;
    }
}

- (void)xy_popViewControllerByName:(NSString *)viewControllerName{
    UINavigationController *navigationVC = self.navigationController;
    for (UIViewController *vc in navigationVC.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(viewControllerName)]) {
            [navigationVC popToViewController:vc animated:YES];
            break;
        }
    }
}
- (void)xy_dismissToRootController{
    UIViewController * presentingViewController = self.presentingViewController;
    while (presentingViewController.presentingViewController) {
        presentingViewController = presentingViewController.presentingViewController;
    }
    [presentingViewController dismissViewControllerAnimated:NO completion:nil];
}
@end

@implementation UINavigationController (ShouldPopItem)
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    UIViewController* vc = [self topViewController];
    XYBackButtonHandler handler = [vc xy_backButtonTouched];
    if (handler) {
        // Workaround for iOS7.1. Thanks to @boliva - http://stackoverflow.com/posts/comments/34452906
        
        for(UIView *subview in [navigationBar subviews]) {
            if(subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(self);
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    }
    
    return NO;
}

@end
