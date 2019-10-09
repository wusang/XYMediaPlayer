//
//  UIWebView+XY.h
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/9/24.
//  Copyright © 2019 lange. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWebView (XY)

+ (NSArray *)voiceAllFileExtension;
+ (NSArray *)imageAllFileExtension;

+ (BOOL)xy_isVoiceFileWithExtName:(NSString *)extName;

+ (BOOL)xy_isImgFileWithExtName:(NSString *)extName;

- (void)xy_setTextSizeWithRate:(NSString *)rate;

- (void)xy_addImgClickEvent;
/** 获取到H5页面上所有图片的url的拼接 */
- (NSString *)xy_getImages;

@end

NS_ASSUME_NONNULL_END
