//
//  UIViewController+XY.h
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/24.
//  Copyright © 2019 lange. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^XYBackButtonHandler)(UIViewController *vc);
@interface UIViewController (XY)

-(void)xy_backButtonTouched:(XYBackButtonHandler)backButtonHandler;

+ (UIViewController *)xy_topControllerForController:(UIViewController *)controller;
- (void)xy_popViewControllerByName:(NSString *)viewControllerName;
- (void)xy_dismissToRootController;

@end

NS_ASSUME_NONNULL_END
