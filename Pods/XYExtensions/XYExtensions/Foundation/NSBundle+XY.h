//
//  NSBundle+XY.h
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/23.
//  Copyright © 2019 lange. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (XY)
+ (instancetype)xy_bundleWithCustomClass:(Class)customClass bundleName:(NSString *)bundleName;
- (NSString *)xy_bundlePathWithName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
