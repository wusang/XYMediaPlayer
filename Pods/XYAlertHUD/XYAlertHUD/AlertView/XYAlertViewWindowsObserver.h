//
//  XYAlertViewWindowsObserver.h
//  XYAlertView
//
//
//

#import <UIKit/UIKit.h>

@interface XYAlertViewWindowsObserver : NSObject

+ (instancetype)sharedInstance;

- (void)startObserving;

@end
