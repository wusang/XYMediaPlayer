//
//  NSError+XYNetManager.h
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/8/13.
//  Copyright © 2019 lange. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kXYNetManagerErrorDamain = @"_XYNetManagerErrorDamain";
NS_ENUM(NSInteger) {
    XYErrorUnknown = -1,
    
    //User
    XYErrorTokenExpired = -1001,
    
    //Network
    XYErrorNoNetwork = -2000,
    XYErrorApiServerCannotConnect = -2101,
    XYErrorApiServerTimeout = -2102,
    XYErrorRequestFailed = -2103,
    XYErrorUrlEmpty = -2104,
    
    //DataTransform
    XYErrorCannotParseJSON = -3101,
    XYErrorCannotParseXML = -3102,
    
    XYErrorIllegalParameter = -4001,
    XYErrorValueNull = -4002,
};
    
@interface NSError (XYNetManager)

+ (instancetype)xy_errorWithCode:(NSInteger)code description:(NSString *)description;


@end

