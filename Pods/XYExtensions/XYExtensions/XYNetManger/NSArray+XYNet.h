//
//  NSArray+XYNet.h
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/17.
//  Copyright © 2019 lange. All rights reserved.
//

#import <Foundation/Foundation.h>

#define xy_IsStrEmpty(_ref)                  (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) isEqualToString:@""]))
#define xy_IsArrEmpty(_ref)     (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0) || ([(_ref) isKindOfClass:[NSNull class]]))
#define xy_IsObjEmpty(_ref)                  (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) isKindOfClass:[NSNull class]]))
@interface NSArray (XYNet)


- (id)xy_objectAtIndex:(NSUInteger)index;
- (NSString *)toJSONString;

@end

@interface NSMutableArray (XYNet)
- (void)xy_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
@end

