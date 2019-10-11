//
//  XYSubtitleParser.h
//  LGIJKPlayerDemo
//
//  Created by wuxiaoyuan on 2019/8/14.
//  Copyright © 2019 lange. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XYSubtitleParser : NSObject
+ (XYSubtitleParser *)parser;

- (NSDictionary *)parseLrc:(NSString *)lrc;

- (NSDictionary *)parseSrt:(NSString *)srt;

@end


