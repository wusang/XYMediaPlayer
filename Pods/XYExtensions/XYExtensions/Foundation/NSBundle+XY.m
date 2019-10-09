//
//  NSBundle+XY.m
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/23.
//  Copyright © 2019 lange. All rights reserved.
//

#import "NSBundle+XY.h"

@implementation NSBundle (XY)
+ (instancetype)xy_bundleWithCustomClass:(Class)customClass bundleName:(NSString *)bundleName{
    
    //    static NSBundle *bundle = nil;
    //    if (!bundle) {
    // 这里不使用mainBundle是为了适配pod 1.x和0.x
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:customClass] pathForResource:bundleName ofType:@"bundle"]];
    //    }
    return bundle;
}

- (NSString *)xy_bundlePathWithName:(NSString *)name{
    return [[self resourcePath] stringByAppendingPathComponent:name];
}
@end
