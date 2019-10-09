//
//  XYKlgEmptyAlert.h
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/23.
//  Copyright © 2019 lange. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYKlgEmptyAlert : UIView
+ (XYKlgEmptyAlert *)klgEmptyAlertWithText:(NSString *)text;

- (void)show;
@end

NS_ASSUME_NONNULL_END
