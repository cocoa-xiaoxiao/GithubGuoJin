//
//  PhoneInfo.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/1/10.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneInfo : NSObject

+ (NSString*)iphoneType;

+(NSString*)getCurrentTimes:(NSString *)format;

+(NSString *)getNowTimeTimestamp3;

+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;

+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format;

+(NSString *)handleDateStr:(NSString *)needHandleDateStr handleFormat:(NSString *)Format;

+(NSDictionary *)jsonDictWithString:(NSString *)string;


@end
