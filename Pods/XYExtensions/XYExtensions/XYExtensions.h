//
//  XYExtensions.h
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/25.
//  Copyright © 2019 lange. All rights reserved.
//

#ifndef XYExtensions_h
#define XYExtensions_h

//弱引用化
#define WeakObj(o)      __weak typeof(o) o##Weak = o
#define StrongObj(o)    __strong typeof(o) o##Strong = o
#define WeakSelf        WeakObj(self)

#define XY_ScreenWidth          [UIScreen mainScreen].bounds.size.width
#define XY_ScreenHeight         [UIScreen mainScreen].bounds.size.height
#define XY_AppDelegate      [UIApplication sharedApplication].delegate
#define XY_ApplicationWindow [UIApplication sharedApplication].delegate.window
#define XYKeyWindow             [UIApplication sharedApplication].keyWindow

/** 为空判定 */
#define IsStrEmpty(_ref)                  (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) isEqualToString:@""]))
#define IsArrEmpty(_ref)                  (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0) || ([(_ref) isKindOfClass:[NSNull class]]))
#define IsObjEmpty(_ref)                  (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) isKindOfClass:[NSNull class]]))

// 颜色
#define XY_ColorWithHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define XY_ColorWithHexA(rgbValue,aValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:aValue]
#define XY_RGBToHex(r,g,b,hex) {hex = r << 16 | g << 8 | b;}

/** UIKit */
#import "UIImage+XY.h"
#import "UIView+XY.h"
#import "UIWindow+XY.h"
#import "UIButton+XY.h"
#import "UIDevice+XY.h"
#import "UIViewController+XY.h"
#import "UINavigationBar+XY.h"
#import "UIImageView+XY.h"
#import "UIColor+XY.h"
#import "UIWebView+XY.h"

/** Foundation */
#import "NSArray+XY.h"
#import "NSDictionary+XY.h"
#import "NSObject+XY.h"
#import "NSBundle+XY.h"
#import "NSString+XY.h"
#import "NSDate+XY.h"
#import "NSNumber+XY.h"
#import "NSUserDefaults+XY.h"
#import "NSMutableAttributedString+XY.h"
#import "NSFileManager+XY.h"

/** BaseView */

#endif /* XYExtensions_h */
