//
//  XYAlertViewTextField.m
//  XYAlertView
//
//
//

#import "XYAlertViewTextField.h"
#import "XYAlertViewHelper.h"

@implementation XYAlertViewTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    bounds.origin.x += XYAlertViewPaddingWidth;
    bounds.size.width -= XYAlertViewPaddingWidth * 2.0;

    if (self.leftView) {
        bounds.origin.x += CGRectGetWidth(self.leftView.bounds) + XYAlertViewPaddingWidth;
        bounds.size.width -= CGRectGetWidth(self.leftView.bounds) + XYAlertViewPaddingWidth;
    }

    if (self.rightView) {
        bounds.size.width -= CGRectGetWidth(self.rightView.bounds) + XYAlertViewPaddingWidth;
    }
    else if (self.clearButtonMode == UITextFieldViewModeAlways) {
        bounds.size.width -= 20.0;
    }

    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    bounds.origin.x += XYAlertViewPaddingWidth;
    bounds.size.width -= XYAlertViewPaddingWidth * 2.0;

    if (self.leftView) {
        bounds.origin.x += CGRectGetWidth(self.leftView.bounds) + XYAlertViewPaddingWidth;
        bounds.size.width -= CGRectGetWidth(self.leftView.bounds) + XYAlertViewPaddingWidth;
    }

    if (self.rightView) {
        bounds.size.width -= CGRectGetWidth(self.rightView.bounds) + XYAlertViewPaddingWidth;
    }
    else if (self.clearButtonMode == UITextFieldViewModeAlways) {
        bounds.size.width -= 20.0;
    }

    return bounds;
}

@end
