//
//  NSString+XY.m
//  XYManageTool
//
//  Created by wuxiaoyuan on 2019/7/30.
//  Copyright © 2019 lange. All rights reserved.
//

#import "NSString+XY.h"

@implementation NSString (XY)

#pragma mark - URL处理
- (NSString *)xy_URLDecode{
    return [self stringByRemovingPercentEncoding];
}
- (NSString *)xy_URLEncode{
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kxyCharactersGeneralDelimitersToEncode stringByAppendingString:kxyCharactersSubDelimitersToEncode]];
    NSString *URLEscapedString = [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    return URLEscapedString;
}
- (NSString *)xy_URLQueryAllowedCharacterSet{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)xy_urlUTF8{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSDictionary *)xy_parseJumpUrlParameter {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *parameterUrl = self;
    
    if ([parameterUrl containsString:@"&AssignmentName="] && [parameterUrl containsString:@"&SysID"]) {
        NSRange start = [parameterUrl rangeOfString:@"&AssignmentName="];
        NSRange end = [parameterUrl rangeOfString:@"&SysID"];
        NSRange range = NSMakeRange(start.location + start.length, end.location -start.location - start.length);
        NSString *resultStr = [parameterUrl substringWithRange:range];
        
        if ([resultStr containsString:@"&"]) {
            NSString *removeStr = [NSString stringWithFormat:@"&AssignmentName=%@",resultStr];
            NSString *tempStr = [parameterUrl stringByReplacingOccurrencesOfString:removeStr withString:@""];
            NSArray *parameterArr = [tempStr componentsSeparatedByString:@"&"];
            for (NSString *parameter in parameterArr) {
                NSArray *parameterBoby = [parameter componentsSeparatedByString:@"="];
                if (parameterBoby.count == 2) {
                    [dic setObject:parameterBoby[1] forKey:parameterBoby[0]];
                } else {
                    NSLog(@"Invalid Parameter String");
                    return nil;
                }
            }
            [dic setObject:resultStr forKey:@"AssignmentName"];
            return dic;
            
        }else{
            NSArray *parameterArr = [parameterUrl componentsSeparatedByString:@"&"];
            for (NSString *parameter in parameterArr) {
                NSArray *parameterBoby = [parameter componentsSeparatedByString:@"="];
                if (parameterBoby.count == 2) {
                    [dic setObject:parameterBoby[1] forKey:parameterBoby[0]];
                } else {
                    NSLog(@"Invalid Parameter String");
                    return nil;
                }
            }
            return dic;
        }
        
    }else{
        NSArray *parameterArr = [parameterUrl componentsSeparatedByString:@"&"];
        for (NSString *parameter in parameterArr) {
            NSArray *parameterBoby = [parameter componentsSeparatedByString:@"="];
            if (parameterBoby.count == 2) {
                [dic setObject:parameterBoby[1] forKey:parameterBoby[0]];
            } else {
                NSLog(@"Invalid Parameter String");
                return nil;
            }
        }
        return dic;
    }
    return nil;
    
}


+ (NSString *)xy_Char1{
    return [NSString stringWithFormat:@"%c",1];
}
+ (NSString *)xy_StandardAnswerSeparatedStr{
    return @"$/";
}
+ (NSString *)xy_stringToASCIIStringWithIntCount:(NSInteger)intCount{
    return [NSString stringWithFormat:@"%c",(int)intCount];
}
+ (NSString *)xy_stringToSmallTopicIndexStringWithIntCount:(NSInteger)intCount{
    NSDictionary *dic = @{
                          @"0":@"①",
                          @"1":@"②",
                          @"2":@"③",
                          @"3":@"④",
                          @"4":@"⑤",
                          @"5":@"⑥",
                          @"6":@"⑦",
                          @"7":@"⑧",
                          @"8":@"⑨",
                          @"9":@"⑩",
                          @"10":@"⑪",
                          @"11":@"⑫",
                          @"12":@"⑬",
                          @"13":@"⑭",
                          @"14":@"⑮",
                          @"15":@"⑯"
                          };
    NSArray *allKeys = [dic allKeys];
    NSString *key = [NSString stringWithFormat:@"%li",intCount];
    if (![allKeys containsObject:key]) {
        return @"-";
    }
    return [dic objectForKey:key];
}
- (NSString *)xy_fileExtensionName{
    return [self componentsSeparatedByString:@"."].lastObject;
}
- (NSString *)xy_deleteWhitespaceCharacter{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
- (NSInteger)xy_stringToASCIIInt{
    return [self characterAtIndex:0];
}
- (NSArray *)xy_splitToCharacters{
    if (self.length > 0) {
        NSInteger length = [self length];
        NSInteger len = 0;
        NSMutableArray *arr = [NSMutableArray array];
        while (len < length) {
            [arr addObject:[NSString stringWithFormat:@"%c",[self characterAtIndex:len]]];
            len++;
        }
        return arr;
    }
    return @[];
}

#pragma mark - UUID

+ (NSString *)xy_UUID{
    if([[[UIDevice currentDevice] systemVersion] floatValue] > 6.0){
        return  [[NSUUID UUID] UUIDString];
    }else{
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef uuid = CFUUIDCreateString(NULL, uuidRef);
        CFRelease(uuidRef);
        return (__bridge_transfer NSString *)uuid;
    }
}
+ (NSString *)xy_UUIDTimestamp{
    return  [[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]*1000] stringValue];
}
#pragma mark - 富文本
- (NSMutableAttributedString *)xy_toMutableAttributedString{
    return [[NSMutableAttributedString alloc] initWithString:self];
}
- (NSMutableAttributedString *)xy_toHtmlMutableAttributedString{
    NSData *htmlData = [self dataUsingEncoding:NSUnicodeStringEncoding];
    return [[NSMutableAttributedString alloc] initWithData:htmlData options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
}
- (NSString *)xy_appendFontAttibuteWithSize:(CGFloat)size{
    return [NSString stringWithFormat:@"<font size=\"%f\">%@</font>",size,self];
}
- (NSString *)xy_replaceStrongFontWithTextColorHex:(NSString *)textColorHex{
    NSString *str = self;
    if (![str containsString:@"<strong>"]) {
        return str;
    }
    str = [str stringByReplacingOccurrencesOfString:@"<strong>" withString:[NSString stringWithFormat:@"<font color=\"%@\">",textColorHex]];
    str = [str stringByReplacingOccurrencesOfString:@"</strong>" withString:@"</font>"];
    return str;
}

+ (NSString *)xy_filterHTML:(NSString *)html{
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    return html;
}
+ (NSString *)xy_adaptWebViewForHtml:(NSString *)htmlStr{
    NSMutableString *headHtml = [[NSMutableString alloc] initWithCapacity:0];
    [headHtml appendString : @"<html>" ];
    [headHtml appendString : @"<head>" ];
    [headHtml appendString : @"<meta charset=\"utf-8\">" ];
    [headHtml appendString : @"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />" ];
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />" ];
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />" ];
    [headHtml appendString : @"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />" ];
    [headHtml appendString:@"<body style=\"word-wrap:break-word;\">"];
    //适配图片宽度，让图片宽度等于屏幕宽度
    //[headHtml appendString : @"<style>img{width:100%;}</style>" ];
    //[headHtml appendString : @"<style>img{height:auto;}</style>" ];
    //适配图片宽度，让图片宽度最大等于屏幕宽度
    //    [headHtml appendString : @"<style>img{max-width:100%;width:auto;height:auto;}</style>"];
    //适配图片宽度，如果图片宽度超过手机屏幕宽度，就让图片宽度等于手机屏幕宽度，高度自适应，如果图片宽度小于屏幕宽度，就显示图片大小
    [headHtml appendString : @"<script type='text/javascript'>"
     "window.onload = function(){\n"
     "var maxwidth=document.body.clientWidth;\n" //屏幕宽度
     "for(i=0;i <document.images.length;i++){\n"
     "var myimg = document.images[i];\n"
     "if(myimg.width > maxwidth){\n"
     "myimg.style.width = '90%';\n"
     "myimg.style.height = 'auto'\n;"
     "}\n"
     "}\n"
     "}\n"
     "</script>\n"];
    [headHtml appendString : @"<style>table{width:90%;}</style>" ];
    [headHtml appendString : @"<title>webview</title>" ];
    NSString *bodyHtml;
    bodyHtml = [NSString stringWithString:headHtml];
    bodyHtml = [bodyHtml stringByAppendingString:htmlStr];
    return bodyHtml;
}
+ (BOOL)predicateMatchWithText:(NSString *)text matchFormat:(NSString *)matchFormat{
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", matchFormat];
    return [predicate evaluateWithObject:text];
}
#pragma mark - 尺寸
- (CGFloat)xy_widthWithFont:(UIFont *)font{
    CGSize stringSize = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return ceil(stringSize.width);
}
- (CGFloat)xy_heightWithFont:(UIFont *)font{
    CGSize stringSize = [self boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return ceil(stringSize.height);
}
#pragma mark - 时间
- (NSDate *)xy_dateWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:self];
    return date;
}

- (NSDate *)xy_date {
    NSString *zelf = [self copy];
    if ([zelf containsString:@"T"]) {
        zelf = [zelf stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    }else if ([zelf containsString:@"/"]){
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        dateformatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [dateformatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        NSDate *date = [dateformatter dateFromString:zelf];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        zelf = [dateformatter stringFromDate:date];
    }
    if (zelf.length > 19) {
        zelf = [zelf substringToIndex:19];
    }else if (zelf.length == 16){
        zelf = [zelf stringByAppendingString:@":00"];
    }else if (zelf.length == 13){
        zelf = [zelf stringByAppendingString:@":00:00"];
    }
    return [zelf xy_dateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)xy_dateStringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self.xy_date];
}
- (NSString *)xy_yearString{
    return [self xy_dateStringWithFormat:@"yyyy"];
}
- (NSString *)xy_dateString {
    return [self xy_dateStringWithFormat:@"yyyy-MM-dd"];
}

- (NSString *)xy_shortDateString {
    return [self xy_dateStringWithFormat:@"MM-dd"];
}
- (NSString *)xy_shortTimeString {
    return [self xy_dateStringWithFormat:@"HH:mm"];
}
- (NSString *)xy_shortDateTimeString {
    return [self xy_dateStringWithFormat:@"MM-dd HH:mm"];
}
- (NSString *)xy_longDateTimeString {
    return [self xy_dateStringWithFormat:@"yyyy-MM-dd HH:mm"];
}
- (NSString *)xy_absoluteDateTimeString {
    return [self xy_dateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}
+ (NSString *)xy_timeFromTimeInterval:(NSTimeInterval)timeInterval isShowChinese:(BOOL)isShowChinese isRetainMinuter:(BOOL)isRetainMinuter{
    if (timeInterval < 60) {
        NSInteger second = timeInterval;
        if (isShowChinese) {
            if (isRetainMinuter) {
                return [NSString stringWithFormat:@"00:%02li秒",second];
            }else{
                return [NSString stringWithFormat:@"%02li秒",second];
            }
        }else{
            if (isRetainMinuter) {
                return [NSString stringWithFormat:@"00:%02li",second];
            }else{
                return [NSString stringWithFormat:@"%02li",second];
            }
        }
    }if (timeInterval < 60*60) {
        NSInteger minute = (NSInteger)timeInterval % (60*60) / 60;
        NSInteger second = (NSInteger)timeInterval % (60*60) % 60;
        if (isShowChinese) {
            return [NSString stringWithFormat:@"%li分%02li秒",minute,second];
        }else{
            return [NSString stringWithFormat:@"%02li:%02li",minute,second];
        }
    }else{
        NSInteger hour = (NSInteger)timeInterval / (60*60);
        NSInteger minute = (NSInteger)timeInterval % (60*60) / 60;
        NSInteger second = (NSInteger)timeInterval % (60*60) % 60;
        if (isShowChinese) {
            return [NSString stringWithFormat:@"%li时%li分%02li秒",hour,minute,second];
        }else{
            return [NSString stringWithFormat:@"%02li:%02li:%02li",hour,minute,second];
        }
    }
}
+ (NSString *)xy_displayTimeWithCurrentTime:(NSString *)currentTime referTime:(NSString *)referTime{
    NSDate *currentDate = currentTime.xy_date;
    NSDate *referDate = referTime.xy_date;
    NSTimeInterval intervalEnd = [currentDate timeIntervalSinceDate:referDate];
    NSString *displayTime;
    if (intervalEnd > 24*60*60) {
        displayTime = [NSString stringWithFormat:@"%@",referTime.xy_shortDateTimeString];
    }else{
        NSInteger nowDay = [currentTime.xy_shortDateString componentsSeparatedByString:@"-"].lastObject.integerValue;
        NSInteger creaDay = [referTime.xy_shortDateString componentsSeparatedByString:@"-"].lastObject.integerValue;
        if (nowDay == creaDay) {
            displayTime = [NSString stringWithFormat:@"今天: %@",referTime.xy_shortTimeString];
        }else{
            displayTime = [NSString stringWithFormat:@"昨天: %@",referTime.xy_shortTimeString];
        }
    }
    return displayTime;
}






@end
