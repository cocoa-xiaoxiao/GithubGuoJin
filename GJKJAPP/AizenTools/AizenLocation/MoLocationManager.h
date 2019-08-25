//
//  MoLocationManager.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/2/10.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^MoLocationSuccess) (double lat, double lng);
typedef void(^MoLocationFailed) (NSError *error);

@interface MoLocationManager : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *manager;
    MoLocationSuccess successCallBack;
    MoLocationFailed failedCallBack;
}

+ (MoLocationManager *) sharedGpsManager;

+ (void) getMoLocationWithSuccess:(MoLocationSuccess)success Failure:(MoLocationFailed)failure;

+ (void) stop;

@end
