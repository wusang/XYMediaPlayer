//
//  XYNetMonitoring.h
//  LGIJKPlayerDemo
//
//  Created by wuxiaoyuan on 2019/8/16.
//  Copyright © 2019 lange. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, XYNetMonitoringStatus) {
    XYNetMonitoringStatusNotReachable     = 0,
    XYNetMonitoringStatusReachableViaWWAN = 1,
    XYNetMonitoringStatusReachableViaWiFi = 2,
};

@interface XYNetMonitoring : NSObject

/** 是否外网 0-连接失败,1-外网，2-内网*/
@property (nonatomic,assign) NSInteger networkCanUseState;
/** 网络状态 */
@property (nonatomic,assign) XYNetMonitoringStatus netStatus;

/** 网络监控 */
- (void)startNetMonitoring;
- (void)stopNetMonitoring;

/** 检测是否为外网 */
//- (void)checkNetCanUseWithComplete:(nullable void (^) (void))complete;

@end


