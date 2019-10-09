//
//  XYNetMonitoring.m
//  LGIJKPlayerDemo
//
//  Created by wuxiaoyuan on 2019/8/16.
//  Copyright © 2019 lange. All rights reserved.
//

#import "XYNetMonitoring.h"
#import <Reachability/Reachability.h>

@interface XYNetMonitoring ()
@property (nonatomic) Reachability *hostReachability;
@end

@implementation XYNetMonitoring

+ (XYNetMonitoring *)shareMonitoring{
    static XYNetMonitoring * macro = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        macro = [[XYNetMonitoring alloc]init];
    });
    return macro;
}

- (void)startNetMonitoring{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.hostReachability = [Reachability reachabilityForInternetConnection];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
}

- (void)stopNetMonitoring{
    [self.hostReachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void) reachabilityChanged:(NSNotification *)note{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability{
    if (reachability == self.hostReachability){
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        switch (netStatus){
            case NotReachable: {
                self.netStatus = XYNetMonitoringStatusNotReachable;
                NSLog(@"没有网络！");
                break;
            }
            case ReachableViaWWAN: {
                self.netStatus = XYNetMonitoringStatusReachableViaWWAN;
                NSLog(@"4G/3G");
                break;
            }
            case ReachableViaWiFi: {
                self.netStatus = XYNetMonitoringStatusReachableViaWiFi;
                NSLog(@"WiFi");
                break;
            }
        }
    }
}




@end
