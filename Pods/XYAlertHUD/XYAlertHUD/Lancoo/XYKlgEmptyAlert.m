//
//  XYKlgEmptyAlert.m
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/23.
//  Copyright © 2019 lange. All rights reserved.
//

#import "XYKlgEmptyAlert.h"
#import <Masonry/Masonry.h>
#import "XYAlertHUD.h"
#import "UIColor+XY.h"
#import "UIImage+XY.h"
@interface XYKlgEmptyAlert ()

@property (nonatomic,strong) UIImageView *bgImgView;
@property (nonatomic,strong) UILabel *contentLab;
@property(nonatomic,strong) UIView *maskView;

@end

@implementation XYKlgEmptyAlert

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgImgView];
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-20);
        }];
        
        [self addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgImgView);
            make.centerY.equalTo(self.bgImgView).offset(self.bgImgView.image.size.height*0.5*0.35);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
    }
    return self;
}


+ (XYKlgEmptyAlert *)klgEmptyAlertWithText:(NSString *)text{
    XYKlgEmptyAlert *klgAlert = [[XYKlgEmptyAlert alloc] initWithFrame:[UIScreen mainScreen].bounds];
    klgAlert.contentLab.text = text;
    klgAlert.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    klgAlert.maskView.backgroundColor = [UIColor xy_colorWithHex:0x000000 alpha:0.6];
    
    return klgAlert;
}

- (void)show{
    UIWindow *rootWindow = [UIApplication sharedApplication].delegate.window;
    for (UIView *view in rootWindow.subviews) {
        if ([view isKindOfClass:[XYKlgEmptyAlert class]]) {
            [(XYKlgEmptyAlert *)view hide];
        }
    }
    [rootWindow addSubview:self.maskView];
    [rootWindow addSubview:self];
    
    self.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                             CGAffineTransformMakeScale(0.7f, 0.7f));
    self.alpha = 0.0f;
    self.maskView.alpha = 0.0f;
    [UIView animateWithDuration:0.3f animations:^{
        self.maskView.alpha = 0.6f;
        self.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                 CGAffineTransformMakeScale(1.0f, 1.0f));
        self.alpha = 1.0f;
    }];
}
- (void)hide{
    [UIView animateWithDuration:0.2 animations:^(void) {
        self.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                 CGAffineTransformMakeScale(0.1f, 0.1f));
        self.maskView.alpha = 0.0f;
        self.alpha = 0.0f;
    } completion:^(BOOL isFinished) {
        [self.maskView removeFromSuperview];
        [self removeFromSuperview];
    }];
}
- (UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithImage:[UIImage xy_imageNamed:@"xy_hud_empty" atBundle:XYAlert.alertBundle]];
//        _bgImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"XYAlertHUD.bundle/xy_hud_empty"]];
    }
    return _bgImgView;
}
- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.font = [UIFont systemFontOfSize:16];
        _contentLab.textColor = [UIColor xy_colorWithHex:0x989898];
        _contentLab.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLab;
}

@end
