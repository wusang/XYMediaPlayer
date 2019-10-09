//
//  XYVideoLrcView.h
//  LGIJKPlayerDemo
//
//  Created by wuxiaoyuan on 2019/8/14.
//  Copyright © 2019 lange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYLrcScrollProtocal.h"


@class XYVideoLrcModel,XYVideoLrcView;
@protocol XYVideoLrcViewDelegate <NSObject>
- (void)XYVideoLrcView:(XYVideoLrcView *)lrcView seekToTime:(NSTimeInterval)time;
@end

@interface XYVideoLrcView : UIView

/** 字幕 */
@property (nonatomic,strong) XYVideoLrcModel *srtModel;

@property (nonatomic,assign) CGFloat currentTime;
@property (nonatomic,assign) id<XYVideoLrcViewDelegate> delegate;
@property (nonatomic,assign) id<XYLrcScrollProtocal> scrollDelegate;


@end


