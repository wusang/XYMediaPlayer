//
//  NSDate+XY.m
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/24.
//  Copyright © 2019 lange. All rights reserved.
//

#import "NSDate+XY.h"
#import "NSString+XY.h"

@implementation NSDate (XY)

- (NSString *)xy_string {
    return [self xy_stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)xy_stringDate {
    return [self xy_stringWithFormat:@"yyyy-MM-dd"];
}

- (NSString *)xy_stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

- (NSDateComponents *)xy_dateComponents {
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:unitFlags fromDate:self];
    return dateComponents;
}

- (NSDate *)xy_dayBegin {
    NSDateComponents *dateComponents = self.xy_dateComponents;
    NSString *dateString = [NSString stringWithFormat:@"%04ld-%02ld-%02ld 00:00:00", dateComponents.year, dateComponents.month, dateComponents.day];
    return dateString.xy_date;
}

- (NSDate *)xy_dayEnd {
    NSDateComponents *dateComponents = self.xy_dateComponents;
    NSString *dateString = [NSString stringWithFormat:@"%04ld-%02ld-%02ld 23:59:59", dateComponents.year, dateComponents.month, dateComponents.day];
    return dateString.xy_date;
}

@end
