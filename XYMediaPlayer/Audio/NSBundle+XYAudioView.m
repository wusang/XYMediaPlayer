//
//  NSBundle+XYAudioView.m
//  AFNetworking
//
//  Created by wuxiaoyuan on 2019/10/10.
//

#import "NSBundle+XYAudioView.h"

@interface XYAudiodExtModel : NSObject
@end
@implementation XYAudiodExtModel
@end


@implementation NSBundle (XYAudioView)

+ (instancetype)xyMedia_playerViewBundle{
    static NSBundle *dictionaryBundle = nil;
    if (!dictionaryBundle) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        dictionaryBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[XYAudiodExtModel class]] pathForResource:@"XYMediaPlayer" ofType:@"bundle"]];
    }
    return dictionaryBundle;
}
+ (NSString *)xyMedia_playerViewBundlePathWithName:(NSString *)name{
    return [[[NSBundle xyMedia_playerViewBundle] resourcePath] stringByAppendingPathComponent:name];
}

@end
