//
//  XYBaseView.h
//  XYExtensionsDemo
//
//  Created by wuxiaoyuan on 2019/9/30.
//  Copyright © 2019 lange. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYBaseView : UIView

/** Create an instance with a nib whose name is same as its class' */
+ (instancetype)newFromNib;

/** The controller which owns the receiver. The default is nil, you should assign it manually. */
@property (weak, nonatomic) UIViewController *ownerController;

/** Configure the receiver. This method is called when init by code or from nib. */
- (void)configure;

/** Configure the subviews. This method is called when init by code or from nib. */
- (void)setupSubviews;

@end

NS_ASSUME_NONNULL_END
