//
//  XYVideoLrcModel.m
//  LGIJKPlayerDemo
//
//  Created by wuxiaoyuan on 2019/8/14.
//  Copyright © 2019 lange. All rights reserved.
//

#import "XYMediaLrcModel.h"
#import <MJExtension/MJExtension.h>
@implementation XYMediaLrcInfoModel

@end


@implementation XYMediaLrcModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"srtList":[XYMediaLrcInfoModel class]};
}

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary{
    self = [self.class mj_objectWithKeyValues:aDictionary];
    return self;
}

- (instancetype)initWithJSONString:(NSString *)aJSONString{
    self = [self.class mj_objectWithKeyValues:aJSONString];
    return self;
}


@end
