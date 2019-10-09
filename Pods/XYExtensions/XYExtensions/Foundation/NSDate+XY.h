//
//  NSDate+XY.h
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/24.
//  Copyright © 2019 lange. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (XY)

- (NSString *)xy_string;

- (NSString *)xy_stringDate;

- (NSString *)xy_stringWithFormat:(NSString *)format;

- (NSDateComponents *)xy_dateComponents;

- (NSDate *)xy_dayBegin;

- (NSDate *)xy_dayEnd;

@end

NS_ASSUME_NONNULL_END
