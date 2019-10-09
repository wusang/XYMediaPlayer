//
//  NSArray+XYColor.h
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/23.
//  Copyright © 2019 lange. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (XY)

- (id)xy_objectAtIndex:(NSUInteger)index;

- (void)xy_each:(void (^)(id object))block;
- (void)xy_eachWithIndex:(void (^)(id object, NSUInteger index))block;
/** 映射：把一个列表变成相同长度的另一个列表，原始列表中的每一个值，在新的列表中都有一个对应的值 */
- (NSArray *)xy_map:(id (^)(id object))block;
/** 过滤：一个列表通过过滤能够返回一个只包含了原列表中符合条件的元素的新列表 */
- (NSArray *)xy_filter:(BOOL (^)(id object))block;
/** 反过滤：过滤掉符合条件的 */
- (NSArray *)xy_reject:(BOOL (^)(id object))block;

- (id)xy_detect:(BOOL (^)(id object))block;
- (id)xy_reduce:(id (^)(id accumulator, id object))block;
- (id)xy_reduce:(nullable id)initial withBlock:(id (^)(id accumulator, id object))block;

@end


@interface NSMutableArray (xy)

- (void)xy_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

- (void)xy_removeObjectAtIndex:(NSUInteger)index;

@end
NS_ASSUME_NONNULL_END
