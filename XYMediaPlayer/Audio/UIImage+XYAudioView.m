//
//  UIImage+XYAudioView.m
//  AFNetworking
//
//  Created by wuxiaoyuan on 2019/10/10.
//

#import "UIImage+XYAudioView.h"
#import "NSBundle+XYAudioView.h"
@implementation UIImage (XYAudioView)


+ (UIImage *)xyAudio_imageNamed:(NSString *)name{
    return [self xyAudio_imageNamed:name atDir:nil];
}
+ (UIImage *)xyAudio_imageNamed:(NSString *)name atDir:(NSString *)dir{
    NSString *namePath = name;
    if (dir && dir.length > 0) {
        namePath = [dir stringByAppendingPathComponent:namePath];
    }
    return [UIImage imageNamed:[NSBundle xyMedia_playerViewBundlePathWithName:namePath]];
}


@end
