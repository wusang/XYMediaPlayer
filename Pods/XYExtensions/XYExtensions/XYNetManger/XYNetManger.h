//
//  XYNetManger.h
//  LGIJKPlayerDemo
//
//  Created by wuxiaoyuan on 2019/8/16.
//  Copyright © 2019 lange. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "XYUploadModel.h"
#import "NSError+XYNetManager.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,XYRequestType){
    XYGET,
    XYLocalTxt,
    XYSysGET,
    XYGETXML,
    XYGETData,
    XYPOST,
    XYSysPOST,
    XYMD5POST,
    XYUpload,
    XYPUT,
    XYDELETE,
    XYPATCH
};
typedef NS_ENUM(NSInteger,XYRequestSerializer){
    XYRequestSerializerJSON,
    XYRequestSerializerHTTP
};
typedef NS_ENUM(NSInteger,XYResponseSerializer){
    XYResponseSerializerJSON,
    XYResponseSerializerHTTP,
    XYResponseSerializerXML
};
#define XY_Network          [XYNetManger shareNetworking]
@interface XYNetManger : AFHTTPSessionManager

+ (XYNetManger *)shareNetworking;
+ (XYNetManger *)networking;

/**
 *  @method      设置网络请求时间
 */
- (XYNetManger *(^)(NSTimeInterval timeoutInterval))setTimeoutInterval;
/**
 *  @method      填充网址
 */
- (XYNetManger* (^)(NSString * url))setRequest;
/**
 *  @method      验证Token
 */
- (XYNetManger* (^)(BOOL tokenVerify))setTokenVerify;
/**
 *  @method      填充请求类型，默认为GET
 */
- (XYNetManger* (^)(XYRequestType type))setRequestType;
/**
 *  @method      填充参数
 */
- (XYNetManger* (^)(id parameters))setParameters;
/**
 *  @method      填充请求头
 */
- (XYNetManger* (^)(NSDictionary * HTTPHeaderDic))setHTTPHeader;
/**
 *  @method      更改数据发送类型，默认HTTP
 */
- (XYNetManger* (^)(XYRequestSerializer requestSerializer))setRequestSerialize;
/**
 *  @method      更改数据接收类型，默认JSON
 */
- (XYNetManger* (^)(XYResponseSerializer responseSerializer))setResponseSerialize;
/**
 *  上传文件模型
 */
- (XYNetManger* (^)(XYUploadModel *uploadModel))setUploadModel;
/** 资料扩展名 */
- (XYNetManger* (^)(NSString *resFileExtension))setResFileExtension;

/**
 *  发送请求(不带进度)
 *
 *  @param success 成功的回调
 *  @param failure 失败的回调
 */
- (void)xyNet_startRequestWithSuccess:(void(^)(id response))success
                           failure:(void (^)(NSError * error))failure;

/**
 *  发送请求(带进度)，仅限POST、GET
 *
 *  @param progress 下载或上传进度的回调
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */
- (void)xyNet_startRequestWithProgress:(void(^)(NSProgress * progress))progress
                            success:(void(^)(id response))success
                            failure:(void (^)(NSError * error))failure;

@end

NS_ASSUME_NONNULL_END
