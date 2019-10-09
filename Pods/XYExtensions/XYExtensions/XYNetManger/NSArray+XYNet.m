//
//  NSArray+XYNet.m
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/17.
//  Copyright © 2019 lange. All rights reserved.
//

#import "NSArray+XYNet.h"

@implementation NSArray (XYNet)

- (id)xy_objectAtIndex:(NSUInteger)index{
    if (xy_IsArrEmpty(self)) {
        return @"";
    }
    if (index > self.count-1) {
        return self.lastObject;
    }
    return [self objectAtIndex:index];
}

- (NSString *)toJSONString {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                     error:nil];
    
    if (data == nil) {
        return nil;
    }
    
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return string;
}

@end

@implementation NSMutableArray (XYNet)
- (void)xy_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    if (xy_IsArrEmpty(self)) {
        return;
    }
    [self replaceObjectAtIndex:index withObject:anObject];
}
@end

