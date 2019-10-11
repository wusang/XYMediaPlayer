//
//  XYAudioLrcView.h
//  LGIJKPlayerDemo
//
//  Created by wuxiaoyuan on 2019/8/14.
//  Copyright © 2019 lange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYLrcScrollProtocal.h"


@class XYMediaLrcModel,XYAudioLrcView;
@protocol XYAudioLrcViewDelegate <NSObject>
- (void)XYAudioLrcView:(XYAudioLrcView *)lrcView seekToTime:(NSTimeInterval)time;
@end

@interface XYAudioLrcView : UIView

/** 字幕 */
@property (nonatomic,strong) XYMediaLrcModel *srtModel;

@property (nonatomic,assign) CGFloat currentTime;
@property (nonatomic,assign) id<XYAudioLrcViewDelegate> delegate;
@property (nonatomic,assign) id<XYLrcScrollProtocal> scrollDelegate;


@end


