//
//  XYAlertViewButton.h
//  XYAlertView
//
//
//

#import <UIKit/UIKit.h>
#import "XYAlertViewShared.h"

@interface XYAlertViewButton : UIButton

@property (assign, nonatomic) XYAlertViewButtonIconPosition iconPosition;

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;

@end
