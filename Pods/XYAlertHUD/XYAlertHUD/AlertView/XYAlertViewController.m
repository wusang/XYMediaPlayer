//
//  XYAlertViewController.h
//  XYAlertView
//
//
//

#import "XYAlertViewController.h"
#import "XYAlertView.h"
#import "UIWindow+XYAlertView.h"
#import "XYAlertViewHelper.h"

@interface XYAlertViewController ()

@property (strong, nonatomic) XYAlertView *alertView;

@end

@implementation XYAlertViewController

- (nonnull instancetype)initWithAlertView:(nonnull XYAlertView *)alertView view:(nonnull UIView *)view {
    self = [super init];
    if (self) {
        self.alertView = alertView;

        self.view.backgroundColor = UIColor.clearColor;
        [self.view addSubview:view];
    }
    return self;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:coordinator.transitionDuration animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
            [self.alertView layoutValidateWithSize:size];
        }];
    });
}

#pragma mark -

- (BOOL)shouldAutorotate {
    UIViewController *viewController = XYAlertViewHelper.appWindow.currentViewController;

    if (viewController) {
        return viewController.shouldAutorotate;
    }

    return super.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *viewController = XYAlertViewHelper.appWindow.currentViewController;

    if (viewController) {
        return viewController.supportedInterfaceOrientations;
    }

    return super.supportedInterfaceOrientations;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (XYAlertViewHelper.isViewControllerBasedStatusBarAppearance) {
        UIViewController *viewController = XYAlertViewHelper.appWindow.currentViewController;

        if (viewController) {
            return viewController.preferredStatusBarStyle;
        }
    }

    return super.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    if (XYAlertViewHelper.isViewControllerBasedStatusBarAppearance) {
        UIViewController *viewController = XYAlertViewHelper.appWindow.currentViewController;

        if (viewController) {
            return viewController.prefersStatusBarHidden;
        }
    }

    return super.prefersStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    if (XYAlertViewHelper.isViewControllerBasedStatusBarAppearance) {
        UIViewController *viewController = XYAlertViewHelper.appWindow.currentViewController;

        if (viewController) {
            return viewController.preferredStatusBarUpdateAnimation;
        }
    }

    return super.preferredStatusBarUpdateAnimation;
}

@end
