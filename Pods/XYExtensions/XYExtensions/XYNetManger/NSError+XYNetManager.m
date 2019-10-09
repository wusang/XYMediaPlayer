//
//  NSError+XYNetManager.m
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/8/13.
//  Copyright © 2019 lange. All rights reserved.
//

#import "NSError+XYNetManager.h"

@implementation NSError (XYNetManager)
+ (instancetype)xy_errorWithCode:(NSInteger)code description:(NSString *)description{
    if (!description || description.length == 0) {
        description = @"发生错误";
    }
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:description};
    NSError *error = [NSError errorWithDomain:kXYNetManagerErrorDamain code:code userInfo:userInfo];
    return error;
}
@end
