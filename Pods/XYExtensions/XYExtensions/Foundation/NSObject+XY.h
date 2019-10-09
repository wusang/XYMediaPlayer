//
//  NSObject+XY.h
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/24.
//  Copyright © 2019 lange. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (XY)

#pragma mark - KVO
- (void)xy_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;
- (void)xy_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

#pragma mark - App信息
-(NSString *)xy_version;
-(NSInteger)xy_build;
-(NSString *)xy_identifier;
-(NSString *)xy_currentLanguage;
-(NSString *)xy_deviceModel;
@end

@interface NSObject (Reflection)
//类名
- (NSString *)xy_className;
+ (NSString *)xy_className;
//父类名称
- (NSString *)xy_superClassName;
+ (NSString *)xy_superClassName;

//实例属性字典
-(NSDictionary *)xy_propertyDictionary;

//属性名称列表
- (NSArray*)xy_propertyKeys;
+ (NSArray *)xy_propertyKeys;

//属性详细信息列表
- (NSArray *)xy_propertiesInfo;
+ (NSArray *)xy_propertiesInfo;

//格式化后的属性列表
+ (NSArray *)xy_propertiesWithCodeFormat;

//方法列表
-(NSArray*)xy_methodList;
+(NSArray*)xy_methodList;

-(NSArray*)xy_methodListInfo;

//创建并返回一个指向所有已注册类的指针列表
+ (NSArray *)xy_registedClassList;
//实例变量
+ (NSArray *)xy_instanceVariable;

//协议列表
-(NSDictionary *)xy_protocolList;
+ (NSDictionary *)xy_protocolList;


- (BOOL)xy_hasPropertyForKey:(NSString*)key;
- (BOOL)xy_hasIvarForKey:(NSString*)key;

@end

NS_ASSUME_NONNULL_END
