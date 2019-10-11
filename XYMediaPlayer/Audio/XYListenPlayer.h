//
//  XYListenPlayer.h
//  LGTeachCloud
//
//  Created by wuxiaoyuan on 2019/8/20.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class XYListenPlayer;

@protocol XYListenPlayerDelegate <NSObject>
@optional
// 已经播放完毕时执行的方法
- (void)xy_listenPlayerDidPlayFinish;
// 获取总时长
- (void)xy_listenPlayer:(XYListenPlayer *) player totalDuration:(CGFloat) totalDuration;
// 获取当前进度
- (void)xy_listenPlayer:(XYListenPlayer *) player currentPlayProgress:(CGFloat) progress;
// 获取总缓存时长
- (void)xy_listenPlayer:(XYListenPlayer *)player totalBuffer:(CGFloat) totalBuffer;
// 在指定时间播放已准备好
- (void)xy_listenPlayerDidSeekFinish;
// 播放失败
- (void)xy_listenPlayerDidPlayFail;

@end

@interface XYListenPlayer : NSObject
// 播放音量
@property (nonatomic) float volume;
@property (nonatomic) id<XYListenPlayerDelegate> delegate;


// 根据URL设置播放器
- (void)setPlayerByUrlString:(NSString *)urlString;
- (void)setPlayerWithUrlString:(NSString *) urlString;
- (void)setPlayerWithPath:(NSString *)path;

// 播放
- (void)play;
// 暂停
- (void)pause;
// 停止
- (void)stop;
// 在指定时间播放
- (void)seekToTime:(CGFloat) time;

// 判断当前音乐是否正在播放
- (BOOL)isPlaying;
// 判断是否正在播放指定的音乐
- (BOOL)isPlayingWithUrl:(NSString *)urlString;
@end


