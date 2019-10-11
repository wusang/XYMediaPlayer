//
//  XYVideoLrcModel.h
//  LGIJKPlayerDemo
//
//  Created by wuxiaoyuan on 2019/8/14.
//  Copyright © 2019 lange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XYMediaLrcInfoModel : NSObject

/** 开始时间点 */
@property (nonatomic,assign) CGFloat beginTime;
/** 结束时间点 */
@property (nonatomic,assign) CGFloat endTime;
/** 字幕 */
@property (nonatomic,copy) NSString *subtitles;

@end

@interface XYMediaLrcModel : NSObject
/** 字幕类型
 0:lrc 音频
 1:Srt 视频
 */
@property (nonatomic,assign) NSInteger subTitleType;

@property (nonatomic,strong) NSArray<XYMediaLrcInfoModel *> *srtList;

/** 用字典初始化（MJExtension） */
- (instancetype)initWithDictionary:(NSDictionary *)aDictionary;

/** 用JSONString初始化 */
- (instancetype)initWithJSONString:(NSString *)aJSONString;

@end


