//
//  XYLrcAudioView.m
//  XYTeachCloud
//
//  Created by wuxiaoyuan on 2019/8/19.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "XYLrcAudioView.h"
#import "XYListenPlayer.h"
#import "XYProgressView.h"
#import "XYVideoLrcView.h"
#import "XYSubtitleParser.h"
#import "XYVideoLrcModel.h"
#import "XYGifView.h"
#import "XYLrcScrollProtocal.h"
#import "Masonry.h"
#import <XYExtensions/XYExtensions.h>
#import "XYMediaPlayer.h"
#import "XYAlertHUD.h"
NSString *const XYVoiceTextPlayerViewStopPlayNotification = @"XYVoiceTextPlayerViewStopPlayNotification";
NSString *const XYVoiceTextPlayerViewPausePlayNotification = @"XYVoiceTextPlayerViewPausePlayNotification";
static CGFloat kXYListenSliderHeight = 2;
@interface XYLSlider : UISlider
@end
@implementation XYLSlider
- (CGRect)trackRectForBounds:(CGRect)bounds{
    return CGRectMake(0, (self.bounds.size.height - kXYListenSliderHeight)/2, self.bounds.size.width, kXYListenSliderHeight);
}
@end

@interface XYLrcAudioView ()<XYListenPlayerDelegate,XYVideoLrcViewDelegate,XYLrcScrollProtocal>


@property (nonatomic, strong) UIImageView *imgListen;
//new
@property (nonatomic,strong) XYProgressView *progressView;
@property (strong, nonatomic) XYLSlider *playSlider;
@property (nonatomic,strong) UILabel *currentPlayTimeL;
@property (nonatomic,strong) UILabel *timeSpaceLab;
@property (strong, nonatomic) UILabel *totalPlayTimeL;
@property (strong, nonatomic) UIButton *playBtn;
@property (strong, nonatomic) UIButton *stopBtn;
@property (strong, nonatomic) UIButton *subtitleBtn;
@property (strong,nonatomic) XYListenPlayer *listenPlayer;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property (nonatomic,assign) CGFloat totalDuration;
@property (copy, nonatomic) void (^BtnTapBlock) (void);
@property (nonatomic, strong) XYVideoLrcView *subtitleView;
@property (nonatomic, strong) XYVideoLrcModel *lrcModel;
@property (nonatomic,strong) XYGifView *bgImgView;

@end

@implementation XYLrcAudioView
- (void)startScroll{
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(startScroll)]) {
        [self.scrollDelegate startScroll];
    }
}
- (void)endScroll{
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(endScroll)]) {
        [self.scrollDelegate endScroll];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (void)loadDataWithUrl:(NSString *)url{
    self.url = url;
    [self layoutUI];
    //解析字幕
    [self parseSubtitle];
}
#pragma mark -创建音频UI
- (void)creatBgGifImg{
    [self addSubview:self.bgImgView];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-30);
        make.width.equalTo(self).multipliedBy(0.6);
        make.height.equalTo(self.bgImgView.mas_width).multipliedBy(0.7);
    }];
    [self.bgImgView presentationGIFImageWithPath:[[NSBundle mainBundle] pathForResource:@"XYMediaPlayer.bundle/Audio/kq_audio_loudspeak" ofType:@"gif"] duration:5 repeatCount:0];
}
- (void)layoutUI{
    
    //
    self.backgroundColor = [UIColor clearColor];
    UIView *shadowView = [UIView new];
    [self addSubview:shadowView];
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-(6+ 60 + [self xy_tabBarSpace]));
        make.height.mas_equalTo(6);
    }];
    [shadowView layoutIfNeeded];
    [shadowView xy_setGradientBackgroundWithColors:@[XY_ColorWithHexA(0xf0f0f0, 0.2),XY_ColorWithHexA(0xdcdcdc, 0.6)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    //
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shadowView.mas_bottom);
        make.centerX.bottom.left.equalTo(self);
    }];
    
    [self creatBgGifImg];
    
    //
    
    UIView *listenBgView = [UIView new];
    [self addSubview:listenBgView];
    [listenBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.top.equalTo(shadowView);
        make.height.mas_equalTo(10);
    }];
    
    [listenBgView addSubview:self.playSlider];
    [self.playSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listenBgView).offset(0.5);
        make.centerX.left.equalTo(listenBgView);
    }];
    
    [listenBgView insertSubview:self.progressView belowSubview:self.playSlider];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.left.equalTo(self.playSlider);
        make.height.mas_equalTo(kXYListenSliderHeight);
    }];
    
    [contentView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(15);
        make.left.equalTo(contentView).offset(10);
        make.height.width.mas_equalTo(30);
    }];
    [contentView addSubview:self.stopBtn];
    [self.stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playBtn);
        make.left.equalTo(self.playBtn.mas_right).offset(10);
        make.height.width.mas_equalTo(20);
    }];
    
    [contentView addSubview:self.totalPlayTimeL];
    [self.totalPlayTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(8);
        make.right.equalTo(contentView).offset(-5);
        make.width.mas_equalTo(38);
    }];
    [contentView addSubview:self.timeSpaceLab];
    [self.timeSpaceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.totalPlayTimeL);
        make.right.equalTo(self.totalPlayTimeL.mas_left).offset(0);
        make.width.mas_equalTo(5);
    }];
    [contentView addSubview:self.currentPlayTimeL];
    [self.currentPlayTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.totalPlayTimeL);
        make.right.equalTo(self.timeSpaceLab.mas_left).offset(0);
        make.width.mas_equalTo(38);
    }];
    
//    [contentView addSubview:self.subtitleBtn];
//    [self.subtitleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.playBtn);
//        make.width.height.mas_equalTo(26);
//        make.right.equalTo(contentView).offset(-94);
//    }];
    
    [contentView addSubview:self.indicatorView];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(contentView);
    }];
    
    [self indicatorViewStop];
    self.playSlider.userInteractionEnabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ApplicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlay) name:XYVoiceTextPlayerViewStopPlayNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayer) name:XYVoiceTextPlayerViewPausePlayNotification object:nil];
    
}


#pragma mark -音频字幕
- (void)parseSubtitle{
    
    NSString *subUrl = [self.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (subUrl.length >4) {
        subUrl = [subUrl substringToIndex:subUrl.length-4];
        subUrl = [NSString stringWithFormat:@"%@.lrc",subUrl];
    }
    
    if ([subUrl length]) {
        WeakSelf;
        NSString *pathStr = [subUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:pathStr]];
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                NSString *string = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if (IsStrEmpty(string)) {
                    NSString *string2 = [[NSMutableString alloc] initWithData:data encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
                    if (!IsStrEmpty(string2)) {
                        string = string2;
                    }
                }
                NSDictionary *info = [[XYSubtitleParser parser] parseLrc:string];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    selfWeak.lrcModel = [[XYVideoLrcModel alloc]initWithDictionary:info];
                    selfWeak.lrcModel.subTitleType = 0;
                    [selfWeak showLrcContent];
                });
            }else{
                NSLog(@"error  is  %@",error.localizedDescription);
            }
            
        }];
        
        [dataTask resume];
    }
    
}
- (void)showLrcContent{
    if (!IsArrEmpty(self.lrcModel.srtList)) {
        [self addSubview:self.subtitleView];
        [self.subtitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-(10+ 60 + [self xy_tabBarSpace]));
        }];
        self.subtitleView.srtModel = self.lrcModel;
    }
}

- (void)showLrcTabWithProgress:(CGFloat)progress{
    if (!IsArrEmpty(self.lrcModel.srtList)) {
        self.subtitleView.currentTime = progress;
    }
}
#pragma mark - XYVideoLrcViewDelegate
- (void)XYVideoLrcView:(XYVideoLrcView *)lrcView seekToTime:(NSTimeInterval)time{
    [self seekToTime:time];
}

#pragma mark -菊花
- (void)indicatorViewStop{
    [self.indicatorView stopAnimating];
    self.indicatorView.hidden = YES;
}
- (void)indicatorViewStart{
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimating];
}

#pragma mark - XYListenPlayerDelegate
- (void)xy_listenPlayer:(XYListenPlayer *)player totalDuration:(CGFloat)totalDuration{
    if (self.totalDuration == 0) {
        self.BtnTapBlock();
        self.totalDuration = totalDuration;
        self.totalPlayTimeL.text = [self timeWithInterVal:totalDuration];
    }
}

- (void)xy_listenPlayer:(XYListenPlayer *)player totalBuffer:(CGFloat)totalBuffer{
    if (_totalDuration > 0) {
        self.progressView.progress = totalBuffer/_totalDuration;
    }
}

- (void)xy_listenPlayer:(XYListenPlayer *)player currentPlayProgress:(CGFloat)progress{
    if (self.totalDuration > 0) {
        [self indicatorViewStop];
        // 关闭屏保
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        self.playSlider.value = progress/self.totalDuration;
    }else{
        self.playSlider.value = 0;
    }
    if (progress > 0) {
        [self stopBtnNomal];
    }else{
        [self stopBtnGrey];
    }
    self.currentPlayTimeL.text = [self timeWithInterVal:progress];
    [self showLrcTabWithProgress:progress];
}

- (void)xy_listenPlayerDidPlayFinish{
    // 开启屏保
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self stopPlayerAction];
    [self.bgImgView stopAnimating];
}

- (void)xy_listenPlayerDidSeekFinish{
    self.playBtn.selected = YES;
    [self.listenPlayer play];
}

- (void)xy_listenPlayerDidPlayFail{
    [self indicatorViewStop];
    self.playBtn.selected = NO;
    self.playSlider.userInteractionEnabled = NO;
    [self.bgImgView stopAnimating];
    [XYAlert showStatus:@"音频资源加载失败"];
}
#pragma mark -Methory
- (NSString *)timeWithInterVal:(float) interVal{
    int minute = interVal / 60;
    int second = (int)interVal % 60;
    return [NSString stringWithFormat:@"%02d:%02d",minute,second];
}

- (void)gifStart{
    if (IsArrEmpty(self.lrcModel.srtList)) {
        [self.bgImgView startAnimating];
    }
}
- (void)gifStop{
    if (IsArrEmpty(self.lrcModel.srtList)) {
        [self.bgImgView stopAnimating];
    }
}

- (void)seekToTime:(CGFloat)time{
    if (_totalDuration > 0) {
        [self indicatorViewStart];
        [self.listenPlayer seekToTime:time];
    }
}

- (void)buttonAction:(UIButton *)button{
    if (!button.selected) {
        if (self.totalDuration == 0) {
            [self indicatorViewStart];
            if (!IsStrEmpty(self.url)) {
                [self.listenPlayer setPlayerWithUrlString:self.url];
            }else{
                [XYAlert showStatus:@"音频已损坏"];
            }
            
            WeakSelf;
            self.BtnTapBlock = ^{
                button.selected = YES;
                selfWeak.playSlider.userInteractionEnabled = YES;
                if (![selfWeak.listenPlayer isPlaying]) {
                    [selfWeak.listenPlayer play];
                    [selfWeak gifStart];
                }
            };
        }else{
            button.selected = YES;
            if (![self.listenPlayer isPlaying]) {
                [self.listenPlayer play];
                [self gifStart];
            }
        }
        
    }else{
        button.selected = NO;
        if ([self.listenPlayer isPlaying]) {
            [self.listenPlayer pause];
            [self gifStop];
        }
    }
}
- (void)startPlay{
    [self.playBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}
- (void)stopPlayerAction{
    self.playBtn.selected = NO;
    [self.listenPlayer stop];
    self.playSlider.value = 0;
    if (self.progressView.progress < 1) {
        self.progressView.progress = 0;
    }
    [self indicatorViewStop];
}

- (void)stopPlay{
    [self stopPlayerAction];
}
- (void)slideAction:(UISlider *)slide{
    [self.listenPlayer seekToTime:slide.value * _totalDuration];
}

- (void)stopBtnAction:(UIButton *)button{
    [self ApplicationDidEnterBackground:nil];
}

- (void)ApplicationDidEnterBackground:(NSNotification *) noti{
    [self pausePlayer];
}
- (void)pausePlayer{
    // 开启屏保
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self.listenPlayer pause];
    [self gifStop];
    self.playBtn.selected = NO;
}

- (void)stopBtnGrey{
    self.stopBtn.alpha = 0.3;
    self.stopBtn.userInteractionEnabled = NO;
}

- (void)stopBtnNomal{
    if (!self.stopBtn.userInteractionEnabled) {
        self.stopBtn.alpha = 1.0;
        self.stopBtn.userInteractionEnabled = YES;
    }
}

- (void)dealloc{
    [self destroyPlayer];
}
- (void)destroyPlayer{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -lazy
- (UIImageView *)imgListen{
    if (!_imgListen) {
        _imgListen = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imgListen.image = [UIImage imageNamed:@"XYMediaPlayer.bundle/Audio/kq_resChange_audioBg"];
    }
    return _imgListen;
}

- (XYProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[XYProgressView alloc] initWithFrame:CGRectZero];
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.progressTintColor = XY_ColorWithHex(0xE6E6E6);
        _progressView.progress = 0;
    }
    return _progressView;
}

- (XYLSlider *)playSlider{
    if (!_playSlider) {
        _playSlider = [[XYLSlider alloc] initWithFrame:CGRectZero];
        [_playSlider setThumbImage:[UIImage imageNamed:@"XYMediaPlayer.bundle/Audio/kq_audio_thumb"] forState:UIControlStateNormal];
        _playSlider.minimumTrackTintColor = XY_ColorWithHex(0x25CDF5);
        _playSlider.maximumTrackTintColor = [UIColor clearColor];
        _playSlider.value = 0;
        [_playSlider addTarget:self action:@selector(slideAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _playSlider;
}

- (UILabel *)currentPlayTimeL{
    if (!_currentPlayTimeL) {
        _currentPlayTimeL = [UILabel new];
        _currentPlayTimeL.textColor = XY_ColorWithHex(0x25CDF5);
        _currentPlayTimeL.font = [UIFont systemFontOfSize:11];
        _currentPlayTimeL.textAlignment = NSTextAlignmentRight;
        _currentPlayTimeL.text = @"00:00";
    }
    return _currentPlayTimeL;
}

- (UILabel *)timeSpaceLab{
    if (!_timeSpaceLab) {
        _timeSpaceLab = [UILabel new];
        _timeSpaceLab.font = [UIFont systemFontOfSize:10];
        _timeSpaceLab.textColor = XY_ColorWithHex(0x25CDF5);
        _timeSpaceLab.textAlignment = NSTextAlignmentCenter;
        _timeSpaceLab.text = @"/";
    }
    return _timeSpaceLab;
}

- (UILabel *)totalPlayTimeL{
    if (!_totalPlayTimeL) {
        _totalPlayTimeL = [UILabel new];
        _totalPlayTimeL.textColor = XY_ColorWithHex(0x25CDF5);
        _totalPlayTimeL.font = [UIFont systemFontOfSize:11];
        _totalPlayTimeL.text = @"00:00";
    }
    return _totalPlayTimeL;
}

- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"XYMediaPlayer.bundle/Audio/kq_audio_play"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"XYMediaPlayer.bundle/Audio/kq_audio_pause"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)stopBtn{
    if (!_stopBtn) {
        _stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stopBtn setImage:[UIImage imageNamed:@"XYMediaPlayer.bundle/Audio/kq_audio_stop"] forState:UIControlStateNormal];
        [_stopBtn addTarget:self action:@selector(stopPlayerAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopBtn;
}

- (UIButton *)subtitleBtn{
    if (!_subtitleBtn) {
        _subtitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_subtitleBtn setImage:[UIImage imageNamed:@"XYMediaPlayer.bundle/Audio/kq_audio_lrc"] forState:UIControlStateNormal];
//        [_subtitleBtn addTarget:self action:@selector(subtitleClickActon) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subtitleBtn;
}

- (UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _indicatorView;
}

- (XYListenPlayer *)listenPlayer{
    if (!_listenPlayer) {
        _listenPlayer = [[XYListenPlayer alloc] init];
        _listenPlayer.delegate = self;
    }
    return _listenPlayer;
}

- (XYVideoLrcView *)subtitleView{
    if (!_subtitleView) {
        _subtitleView = [[XYVideoLrcView alloc]init];
        _subtitleView.delegate = self;
        _subtitleView.scrollDelegate = self;
    }
    return _subtitleView;
}

- (XYGifView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[XYGifView alloc]initWithImage:[UIImage imageNamed:@"XYMediaPlayer.bundle/Audio/kq_resChange_audioBg"]];
    }
    return _bgImgView;
}

@end
