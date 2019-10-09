//
//  NSString+XY.h
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/7/30.
//  Copyright © 2019 lange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString * const kxyCharactersGeneralDelimitersToEncode = @":#[]@";
static NSString * const kxyCharactersSubDelimitersToEncode = @"!$&'()*+,;=";

@interface NSString (XY)

#pragma mark - URL处理
/** URL编码 UTF8 */
- (NSString *)xy_urlUTF8;
/** URL参数解析 */
- (NSDictionary *)xy_parseJumpUrlParameter;
- (NSString *)xy_URLDecode;
- (NSString *)xy_URLEncode;

+ (NSString *)xy_Char1;
+ (NSString *)xy_StandardAnswerSeparatedStr;
+ (NSString *)xy_stringToASCIIStringWithIntCount:(NSInteger)intCount;
+ (NSString *)xy_stringToSmallTopicIndexStringWithIntCount:(NSInteger)intCount;

- (NSString *)xy_fileExtensionName;
- (NSString *)xy_deleteWhitespaceCharacter;
- (NSInteger)xy_stringToASCIIInt;
- (NSArray *)xy_splitToCharacters;

#pragma mark - UUID
/** 获取随机 UUID 例如 E621E1F8-C36C-495A-93FC-0C247A3E6E5F */
+ (NSString *)xy_UUID;
/** 毫秒时间戳 例如 1443066826371 */
+ (NSString *)xy_UUIDTimestamp;
#pragma mark - 富文本
- (NSMutableAttributedString *)xy_toMutableAttributedString;
- (NSMutableAttributedString *)xy_toHtmlMutableAttributedString;
- (NSString *)xy_appendFontAttibuteWithSize:(CGFloat)size;
- (NSString *)xy_replaceStrongFontWithTextColorHex:(NSString *)textColorHex;
+ (NSString *)xy_filterHTML:(NSString *)html;
+ (NSString *)xy_adaptWebViewForHtml:(NSString *)htmlStr;
+ (BOOL)predicateMatchWithText:(NSString *)text matchFormat:(NSString *)matchFormat;
#pragma mark - 尺寸
- (CGFloat)xy_widthWithFont:(UIFont *)font;
- (CGFloat)xy_heightWithFont:(UIFont *)font;

#pragma mark - 时间处理
/** 按格式将字符串转为日期 */
- (NSDate *)xy_dateWithFormat:(NSString *)format;
- (NSString *)xy_yearString;
/** 按"yyyy-MM-dd'T'HH:mm:ss.SSS"或"yyyy-MM-dd HH:mm:ss"格式将字符串转为日期 */
- (NSDate *)xy_date;

/** 将日期字符串按格式format处理 */
- (NSString *)xy_dateStringWithFormat:(NSString *)format;

/** yyyy-MM-dd */
- (NSString *)xy_dateString;

/** MM-dd */
- (NSString *)xy_shortDateString;
/** HH:mm */
- (NSString *)xy_shortTimeString;
/** 将"yyyy-MM-dd HH:mm:ss"转为"MM-dd HH:mm" */
- (NSString *)xy_shortDateTimeString;
/** 将"yyyy-MM-dd HH:mm:ss"转为"yyyy-MM-dd HH:mm" */
- (NSString *)xy_longDateTimeString;
- (NSString *)xy_absoluteDateTimeString;
+ (NSString *)xy_timeFromTimeInterval:(NSTimeInterval)timeInterval isShowChinese:(BOOL)isShowChinese isRetainMinuter:(BOOL)isRetainMinuter;
+ (NSString *)xy_displayTimeWithCurrentTime:(NSString *)currentTime referTime:(NSString *)referTime;


@end

