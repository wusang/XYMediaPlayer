//
//  UIWindow+XY.h
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/24.
//  Copyright © 2019 lange. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (XY)
/** present */
- (UIViewController*)xy_topMostController;
/** push */
- (UIViewController*)xy_currentViewController;

@end

NS_ASSUME_NONNULL_END
