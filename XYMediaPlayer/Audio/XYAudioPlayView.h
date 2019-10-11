//
//  XYLrcAudioView.h
//  LGTeachCloud
//
//  Created by wuxiaoyuan on 2019/8/19.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYLrcScrollProtocal.h"
@interface XYAudioPlayView : UIView

@property (nonatomic, copy) NSString *url;
- (void)seekToTime:(CGFloat) time;
- (void)pausePlayer;
- (void)loadDataWithUrl:(NSString *)url;
- (void)startPlay;
- (void)stopPlay;
- (void)destroyPlayer;
@property (nonatomic,assign) id<XYLrcScrollProtocal> scrollDelegate;
@end


