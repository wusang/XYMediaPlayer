//
//  XYNetManger.m
//  LGIJKPlayerDemo
//
//  Created by wuxiaoyuan on 2019/8/16.
//  Copyright © 2019 lange. All rights reserved.
//

#import "XYNetManger.h"
#import "XYUploadModel.h"
#import "NSArray+XYNet.h"
#import "NSError+XYNetManager.h"
@interface XYNetManger ()
@property (nonatomic,copy)NSString * url;
@property (nonatomic,assign)XYRequestType wRequestType;
@property (nonatomic,assign)XYRequestSerializer requestSerialize;
@property (nonatomic,assign)XYResponseSerializer responseSerialize;
@property (nonatomic,copy)id parameters;
@property (nonatomic,copy)NSDictionary * wHTTPHeader;
@property (nonatomic,assign) NSTimeInterval timeout;
@property (nonatomic,strong) XYUploadModel *uploadModel;
@property (nonatomic,copy) NSString *resFileExtension;
// token验证
@property (nonatomic,assign) BOOL tokenVerify;
@property (nonatomic,assign) BOOL offlineEnter;
@end

static NSString *netStatus = @"XY_netStatus";
@implementation XYNetManger

+ (XYNetManger *)shareNetworking{
    static XYNetManger * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XYNetManger alloc]init];
        [manager replace];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    });
    return manager;
}
#pragma mark - action
- (void)J1_cancelAllOperations{
    [self.operationQueue cancelAllOperations];
}

- (void)setUpBeforeStart {
    //设置请求头
    [self setupRequestSerializerBeforeStart];
    [self setupHTTPHeaderBeforeStart];
    //设置返回头
    [self setupResponseSerializerBeforeStart];
}

- (void)setupRequestSerializerBeforeStart {
    
    switch (self.requestSerialize) {
        case XYRequestSerializerJSON: {
            self.requestSerializer = [AFJSONRequestSerializer serializer];
        }
            break;
        case XYRequestSerializerHTTP: {
            self.requestSerializer = [AFHTTPRequestSerializer serializer];
        }
            break;
        default:
            break;
    }
    
    self.requestSerializer.timeoutInterval = self.timeout;
}

- (void)setupHTTPHeaderBeforeStart {
    for (NSString * key in self.wHTTPHeader.allKeys) {
        [self.requestSerializer setValue:self.wHTTPHeader[key] forHTTPHeaderField:key];
    }
}
- (void)setupResponseSerializerBeforeStart {
    switch (self.responseSerialize) {
        case XYResponseSerializerJSON: {
            self.responseSerializer = [AFJSONResponseSerializer serializer];
        }
            break;
        case XYResponseSerializerHTTP: {
            self.responseSerializer = [AFHTTPResponseSerializer serializer];
        }
            break;
        case XYResponseSerializerXML: {
            self.responseSerializer = [AFXMLParserResponseSerializer serializer];
        }
            break;
        default:
            break;
    }
}

#pragma mark -request
- (void)xyNet_startRequestWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self startRequestWithProgress:nil success:success failure:failure];
}
- (void)xyNet_startRequestWithProgress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self startRequestWithProgress:progress success:success failure:failure];
}

- (void)startRequestWithProgress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self setUpBeforeStart];
    NSString * url = [self.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (xy_IsObjEmpty(url)) {
        failure([NSError xy_errorWithCode:XYErrorUrlEmpty description:@"资源地址为空"]);
    }else{
        switch (self.wRequestType) {
            case XYGET: {
                [self GET:url parameters:self.parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success(responseObject);
                    });
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(error);
                    });
                }];
            }
                break;
           
            case XYSysGET: {
                NSURL *requestUrl = [NSURL URLWithString:url];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
                [request setValue:self.wHTTPHeader[@"secret"] forHTTPHeaderField:@"secret"];
                request.timeoutInterval = self.timeout;
                NSURLSession *session = [NSURLSession sharedSession];
                NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
                    if (error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            failure(error);
                        });
                    }else{
                        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            success(str);
                        });
                    }
                }];
                [dataTask resume];
            }
                break;
            case XYGETData: {
                NSURL *requestUrl = [NSURL URLWithString:url];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
                [request setValue:self.wHTTPHeader[@"secret"] forHTTPHeaderField:@"secret"];
                request.timeoutInterval = self.timeout;
                NSURLSession *session = [NSURLSession sharedSession];
                NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
                    if (error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            failure(error);
                        });
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            success(data);
                        });
                    }
                }];
                [dataTask resume];
            }
                break;
            case XYUpload: {
                __weak typeof(self) weakSelf = self;
                [self POST:url parameters:self.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    for (int i = 0; i < weakSelf.uploadModel.uploadDatas.count; i++) {
                        NSData *imageData = weakSelf.uploadModel.uploadDatas[i];
                        NSString *imageName = weakSelf.uploadModel.fileNames[i];
                        [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"%@%i",weakSelf.uploadModel.name,i] fileName:imageName mimeType:weakSelf.uploadModel.fileType];
                    }
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        progress(uploadProgress);
                    });
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success(responseObject);
                    });
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(error);
                    });
                }];
                
            }
                break;
            case XYGETXML: {
                NSURL *requestUrl = [NSURL URLWithString:url];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
                [request setValue:self.wHTTPHeader[@"secret"] forHTTPHeaderField:@"secret"];
                request.timeoutInterval = self.timeout;
                NSURLSession *session = [NSURLSession sharedSession];
                NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
                    if (error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            failure(error);
                        });
                    }else{
                        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            success(str);
                        });
                    }
                }];
                [dataTask resume];
            }
                break;
            case XYPOST: {
                [self POST:url parameters:self.parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success(responseObject);
                    });
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(error);
                    });
                }];
            }
                break;
            case XYSysPOST: {
            
                NSURL *requestUrl = [NSURL URLWithString:url];
                // POST请求
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
                request.HTTPMethod = @"POST";
                // 设置请求头
                [request setValue:self.wHTTPHeader[@"secret"] forHTTPHeaderField:@"secret"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                request.timeoutInterval = self.timeout;
                // 检验给定的对象是否能够被序列化
                if (![NSJSONSerialization isValidJSONObject:self.parameters]) {
                    NSLog(@"格式不正确，不能被序列化");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure([NSError xy_errorWithCode:XYErrorIllegalParameter description:@"格式不正确，不能被序列化"]);
                    });
                    return;
                }
                //设置请求体
                request.HTTPBody = [NSJSONSerialization dataWithJSONObject:self.parameters options:NSJSONWritingPrettyPrinted error:NULL];
                //                NSLog(@"123：    %@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
                // 异步连接
                NSURLSession *session = [NSURLSession sharedSession];
                NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            failure(error);
                        });
                    }else{
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            success(dic);
                        });
                    }
                }];
                [dataTask resume];
            }
           
                break;
            case XYPUT: {
                [self PUT:url parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success(responseObject);
                    });
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(error);
                    });
                }];
            }
                break;
                
            case XYPATCH: {
                [self PATCH:url parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success(responseObject);
                    });
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(error);
                    });
                }];
            }
                break;
                
            case XYDELETE: {
                [self DELETE:url parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success(responseObject);
                    });
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(error);
                    });
                }];
            }
                break;
            default:
                break;
        }
        [self replace];
    }
    
}

//重置
- (void)replace {
    self.url = nil;
    self.wRequestType = XYGET;
    self.parameters = nil;
    self.wHTTPHeader = nil;
    self.requestSerialize = XYRequestSerializerHTTP;
    self.responseSerialize = XYResponseSerializerJSON;
    self.timeout = 15;
    self.tokenVerify = NO;
    self.uploadModel = nil;
    self.resFileExtension = @"txt";
}

#pragma mark - lazy
+(XYNetManger *)networking{
    XYNetManger *manager = [[XYNetManger alloc]init];
    [manager replace];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"text/xml",nil];
    return manager;
}

- (XYNetManger *(^)(NSTimeInterval))setTimeoutInterval{
    return ^XYNetManger *(NSTimeInterval timeoutInterval){
        self.timeout = timeoutInterval;
        return self;
    };
}
- (XYNetManger *(^)(NSString *))setRequest{
    return ^XYNetManger* (NSString * url) {
        self.url = url;
        return self;
    };
}
- (XYNetManger *(^)(BOOL))setTokenVerify{
    return ^XYNetManger* (BOOL tokenVerify){
        self.tokenVerify = tokenVerify;
        return self;
    };
}
- (XYNetManger *(^)(XYRequestType))setRequestType{
    return ^XYNetManger* (XYRequestType type) {
        self.wRequestType = type;
        return self;
    };
}
- (XYNetManger *(^)(id))setParameters{
    return ^XYNetManger* (id parameters) {
        self.parameters = parameters;
        return self;
    };
}
- (XYNetManger *(^)(NSDictionary *))setHTTPHeader{
    return ^XYNetManger* (NSDictionary * HTTPHeaderDic) {
        self.wHTTPHeader = HTTPHeaderDic;
        return self;
    };
}
- (XYNetManger *(^)(XYRequestSerializer))setRequestSerialize{
    return ^XYNetManger* (XYRequestSerializer requestSerializer) {
        self.requestSerialize = requestSerializer;
        return self;
    };
}
- (XYNetManger *(^)(XYResponseSerializer))setResponseSerialize{
    return ^XYNetManger* (XYResponseSerializer responseSerializer) {
        self.responseSerialize = responseSerializer;
        return self;
    };
}

- (XYNetManger *(^)(XYUploadModel *))setUploadModel{
    return ^XYNetManger * (XYUploadModel *uploadModel) {
        self.uploadModel = uploadModel;
        return self;
    };
}
- (XYNetManger *(^)(NSString *))setResFileExtension{
    return ^XYNetManger * (NSString *resFileExtension) {
        self.resFileExtension = resFileExtension;
        return self;
    };
}

@end
