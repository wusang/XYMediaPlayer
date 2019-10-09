//
//  UIWindow+XYAlertView.h
//  XYAlertView
//
//
//

#import "UIWindow+XYAlertView.h"

@implementation UIWindow (XYAlertView)

- (nullable UIViewController *)currentViewController {
    UIViewController *viewController = self.rootViewController;

    if (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }

    return viewController;
}

@end
