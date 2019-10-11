//
//  XYListenPlayer.m
//  LGTeachCloud
//
//  Created by wuxiaoyuan on 2019/8/20.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "XYListenPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <XYExtensions/XYExtensions.h>
@interface XYListenPlayer ()
{
    BOOL _isPlaying;
    // 播放时间观察者
    id _timeObserver;
}
@property (nonatomic,assign) BOOL isSeek;
@property (nonatomic,strong) AVPlayer *player;
@end

@implementation XYListenPlayer

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}
- (AVPlayer *)player{
    if (!_player) {
        self.player = [[AVPlayer alloc] init];
        
    }
    return _player;
}
- (void)play{
    _isPlaying = YES;
    [self removeTimeObserver];
    [self.player play];
    [self addTimeObserVer];
}
- (void)pause{
    _isPlaying = NO;
    [self.player pause];
}
- (void)stop{
    // 停止的时候要先暂停
    [self pause];
    [self.player seekToTime:CMTimeMake(0, self.player.currentTime.timescale)];
    [self removeObserverFromPlayerItem:self.player.currentItem];
}
- (BOOL)isPlaying{
    return _isPlaying;
}
- (BOOL)isPlayingWithUrl:(NSString *)urlString{
    // 找出当前正在播放歌曲的url
    NSString *url = [(AVURLAsset *)self.player.currentItem.asset URL].absoluteString;
    // 判断
    BOOL isEqual = [url isEqualToString:urlString];
    return isEqual;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserverFromPlayerItem:self.player.currentItem];
}
- (void)setPlayerByUrlString:(NSString *)urlString{
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    [session setActive:YES error:nil];
    
    // 根据url创建一个歌曲的播放对象
    AVPlayerItem *currentItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlString]];
    [self.player replaceCurrentItemWithPlayerItem:currentItem];
}
- (void)setPlayerWithUrlString:(NSString *)urlString{
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    [session setActive:YES error:nil];
    // 播放前先清除通知
    [self removeNotification];
    if (!IsStrEmpty([(AVURLAsset *)self.player.currentItem.asset URL].absoluteString)) {
        [self removeObserverFromPlayerItem:self.player.currentItem];
    }
    // 根据url创建一个歌曲的播放对象
    AVPlayerItem *currentItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlString]];
    // 用刚创建的播放对象替换原来的播放对象
    [self.player replaceCurrentItemWithPlayerItem:currentItem];
    if (@available(iOS 10.0, *)) {
        self.player.automaticallyWaitsToMinimizeStalling = NO;
    }
    // 添加观察者
    [self addObserverToPlayerItem:currentItem];
    // 注册通知
    [self addNotification];
}
- (void)setPlayerWithPath:(NSString *)path{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    [session setActive:YES error:nil];
    // 播放前先清除通知
    [self removeNotification];
    if (self.player.currentItem) {
        [self removeObserverFromPlayerItem:self.player.currentItem];
    }
    // 根据url创建一个歌曲的播放对象
    AVPlayerItem *currentItem = [AVPlayerItem playerItemWithURL:[[NSURL alloc] initFileURLWithPath:path]];
    // 添加观察者
    [self addObserverToPlayerItem:currentItem];
    // 用刚创建的播放对象替换原来的播放对象
    [self.player replaceCurrentItemWithPlayerItem:currentItem];
    // 注册通知
    [self addNotification];
}
- (void)setVolume:(float)volume{
    self.player.volume = volume;
}
- (void)seekToTime:(CGFloat)time{
    // 在拖动进度条的时候先暂停
    [self pause];
    CMTime cmTime = CMTimeMakeWithSeconds(time, self.player.currentTime.timescale);
    __weak typeof(self) weakSelf = self;
    [self.player seekToTime:cmTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        // 拖动结束后音乐重新播放
        if (finished) {
            weakSelf.isSeek = YES;
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(xy_listenPlayerDidSeekFinish)]) {
                [weakSelf.delegate xy_listenPlayerDidSeekFinish];
            }
        }
    }];
}
-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEndTimeNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem xy_addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem xy_addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
}
-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    [playerItem xy_removeObserver:self forKeyPath:@"status"];
    [playerItem xy_removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [playerItem cancelPendingSeeks];
    [playerItem.asset cancelLoading];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if([keyPath isEqualToString:@"status"])
    {
        
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerItemStatusReadyToPlay) {
            //只有在播放状态才能获取视频时间长度
            NSTimeInterval duration = CMTimeGetSeconds(playerItem.asset.duration);
            if (self.delegate && [self.delegate respondsToSelector:@selector(xy_listenPlayer:totalDuration:)]) {
                [self.delegate xy_listenPlayer:self totalDuration:duration];
            }
        }else{// 失败
            if (self.delegate && [self.delegate respondsToSelector:@selector(xy_listenPlayerDidPlayFail)]) {
                if (!IsStrEmpty(playerItem.error.description)) {
                    NSLog(@"音频资源加载失败：%@",playerItem.error.description);
                }
                [self.delegate xy_listenPlayerDidPlayFail];
            }
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array=playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        if (self.delegate && [self.delegate respondsToSelector:@selector(xy_listenPlayer:totalBuffer:)]) {
            [self.delegate xy_listenPlayer:self totalBuffer:totalBuffer];
        }
        
    }
}
- (void)handleEndTimeNotification:(NSNotification *) noti{
    AVPlayerItem *playerItem = (AVPlayerItem *)noti.object;
    NSString *urlStr =  [(AVURLAsset *)playerItem.asset URL].absoluteString;
    NSString *currentUrlStr =  [(AVURLAsset *)self.player.currentItem.asset URL].absoluteString;
    if (!IsStrEmpty(urlStr) && !IsStrEmpty(currentUrlStr) && ![urlStr isEqualToString:currentUrlStr]) {
        return;
    }
    if ((self.delegate && [self.delegate respondsToSelector:@selector(xy_listenPlayerDidPlayFinish)])) {
        // 协议方法的实现，会在代理的类里面具体实现步骤
        [self.delegate xy_listenPlayerDidPlayFinish];
    }
}
-(void)removeTimeObserver
{
    if (_timeObserver)
    {
        [self.player removeTimeObserver:_timeObserver];
        _timeObserver = nil;
    }
}
- (void)addTimeObserVer{
    __weak typeof(self) weakSelf = self;
    _timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        if (weakSelf.isSeek) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(xy_listenPlayer:currentPlayProgress:)]) {
                    [weakSelf.delegate xy_listenPlayer:weakSelf currentPlayProgress:CMTimeGetSeconds(weakSelf.player.currentTime)];
                }
                weakSelf.isSeek = NO;
            });
        }else{
            CGFloat currentTime = CMTimeGetSeconds(time);
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(xy_listenPlayer:currentPlayProgress:)]) {
                [weakSelf.delegate xy_listenPlayer:weakSelf currentPlayProgress:currentTime];
            }
        }
    }];
}

@end
