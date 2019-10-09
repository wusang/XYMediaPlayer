//
//  XYAlertViewWindowContainer.h
//  XYAlertView
//
//
//

#import <UIKit/UIKit.h>

@interface XYAlertViewWindowContainer : NSObject

- (instancetype)initWithWindow:(UIWindow *)window;

+ (instancetype)containerWithWindow:(UIWindow *)window;

@property (weak, nonatomic) UIWindow *window;

@end
