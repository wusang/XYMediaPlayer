//
//  XYAlertViewCell.h
//  XYAlertView
//
//
//

#import <UIKit/UIKit.h>
#import "XYAlertViewShared.h"

@interface XYAlertViewCell : UITableViewCell

@property (strong, nonatomic, readonly, nonnull) UIView *separatorView;

@property (strong, nonatomic, nullable) UIColor *titleColor;
@property (strong, nonatomic, nullable) UIColor *titleColorHighlighted;
@property (strong, nonatomic, nullable) UIColor *titleColorDisabled;

@property (strong, nonatomic, nullable) UIColor *backgroundColorNormal;
@property (strong, nonatomic, nullable) UIColor *backgroundColorHighlighted;
@property (strong, nonatomic, nullable) UIColor *backgroundColorDisabled;

@property (strong, nonatomic, nullable) UIImage *image;
@property (strong, nonatomic, nullable) UIImage *imageHighlighted;
@property (strong, nonatomic, nullable) UIImage *imageDisabled;

@property (assign, nonatomic) XYAlertViewButtonIconPosition iconPosition;

@property (assign, nonatomic) BOOL enabled;

@end
