//
//  NSArray+XYColor.m
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/23.
//  Copyright © 2019 lange. All rights reserved.
//

#import "NSArray+XY.h"

@implementation NSArray (XY)

- (id)xy_objectAtIndex:(NSUInteger)index{
    if (index > self.count-1) {
        return self.lastObject;
    }
    return [self objectAtIndex:index];
}
- (void)xy_each:(void (^)(id object))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
}

- (void)xy_eachWithIndex:(void (^)(id object, NSUInteger index))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj, idx);
    }];
}

- (NSArray *)xy_map:(id (^)(id object))block {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    
    for (id object in self) {
        [array addObject:block(object) ?: [NSNull null]];
    }
    
    return array;
}

- (NSArray *)xy_filter:(BOOL (^)(id object))block {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return block(evaluatedObject);
    }]];
}

- (NSArray *)xy_reject:(BOOL (^)(id object))block {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return !block(evaluatedObject);
    }]];
}

- (id)xy_detect:(BOOL (^)(id object))block {
    for (id object in self) {
        if (block(object))
            return object;
    }
    return nil;
}

- (id)xy_reduce:(id (^)(id accumulator, id object))block {
    return [self xy_reduce:nil withBlock:block];
}

- (id)xy_reduce:(id)initial withBlock:(id (^)(id accumulator, id object))block {
    id accumulator = initial;
    
    for(id object in self)
        accumulator = accumulator ? block(accumulator, object) : object;
    
    return accumulator;
}
@end


@implementation NSMutableArray (xy)
- (void)xy_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    if (index > self.count-1) {
        return;
    }
    [self replaceObjectAtIndex:index withObject:anObject];
}
- (void)xy_removeObjectAtIndex:(NSUInteger)index{
    if (index > self.count-1) {
        return;
    }
    [self removeObjectAtIndex:index];
}
@end

