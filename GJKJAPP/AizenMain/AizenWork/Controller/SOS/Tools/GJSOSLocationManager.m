//
//  GJSOSLocationManager.m
//  GJKJAPP
//
//  Created by git burning on 2018/10/10.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "GJSOSLocationManager.h"

@implementation GJSOSLocationManager
+(instancetype)shareManager{
    
    static GJSOSLocationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GJSOSLocationManager alloc] init];
    });
    return manager;
}
@end
