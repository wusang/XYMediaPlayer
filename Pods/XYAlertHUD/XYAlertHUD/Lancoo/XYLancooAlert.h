//
//  XYLancooAlert.h
//  XYAlertHUDDemo
//

//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYLancooAlert : UIView


+ (XYLancooAlert *)lancooAlertWithTitle:(NSString *)title
                                    msg:(NSString *)msg
                            cancelTitle:(NSString *)cancelTitle
                       destructiveTitle:(NSString *)destructiveTitle
                            cancelBlock:(void (^)(void))cancelBlock
                       destructiveBlock:(void (^)(void))destructiveBlock;

+ (XYLancooAlert *)lancooAlertWithTitle:(NSString *)title
                                    msg:(NSString *)msg
                              sureTitle:(NSString *)sureTitle
                              sureBlock:(void (^)(void))sureBlock;

+ (XYLancooAlert *)lancooAlertWithTitle:(NSString *)title
                                    msgAttr:(NSAttributedString *)msgAttr
                            cancelTitle:(NSString *)cancelTitle
                       destructiveTitle:(NSString *)destructiveTitle
                            cancelBlock:(void (^)(void))cancelBlock
                       destructiveBlock:(void (^)(void))destructiveBlock;

+ (XYLancooAlert *)lancooAlertWithTitle:(NSString *)title
                                msgAttr:(NSAttributedString *)msgAttr
                              sureTitle:(NSString *)sureTitle
                              sureBlock:(void (^)(void))sureBlock;

+ (XYLancooAlert *)lancooAlertGifViewWithGifName:(NSString *)gifName msg:(NSString *)msg duration:(NSInteger)duration;

- (void)show;
- (void)hide;
+ (void)dismiss;
@end

NS_ASSUME_NONNULL_END
