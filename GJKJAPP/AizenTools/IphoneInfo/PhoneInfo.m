//
//  PhoneInfo.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/1/10.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "PhoneInfo.h"
#import <sys/utsname.h>

@implementation PhoneInfo

+ (NSString*)iphoneType {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    if([platform isEqualToString:@"iPhone1,1"])  return@"iPhone 2G";
    if([platform isEqualToString:@"iPhone1,2"])  return@"iPhone 3G";
    if([platform isEqualToString:@"iPhone2,1"])  return@"iPhone 3GS";
    if([platform isEqualToString:@"iPhone3,1"])  return@"iPhone 4";
    if([platform isEqualToString:@"iPhone3,2"])  return@"iPhone 4";
    if([platform isEqualToString:@"iPhone3,3"])  return@"iPhone 4";
    if([platform isEqualToString:@"iPhone4,1"])  return@"iPhone 4S";
    if([platform isEqualToString:@"iPhone5,1"])  return@"iPhone 5";
    if([platform isEqualToString:@"iPhone5,2"])  return@"iPhone 5";
    if([platform isEqualToString:@"iPhone5,3"])  return@"iPhone 5c";
    if([platform isEqualToString:@"iPhone5,4"])  return@"iPhone 5c";
    if([platform isEqualToString:@"iPhone6,1"])  return@"iPhone 5s";
    if([platform isEqualToString:@"iPhone6,2"])  return@"iPhone 5s";
    if([platform isEqualToString:@"iPhone7,1"])  return@"iPhone 6 Plus";
    if([platform isEqualToString:@"iPhone7,2"])  return@"iPhone 6";
    if([platform isEqualToString:@"iPhone8,1"])  return@"iPhone 6s";
    if([platform isEqualToString:@"iPhone8,2"])  return@"iPhone 6s Plus";
    if([platform isEqualToString:@"iPhone8,4"])  return@"iPhone SE";
    if([platform isEqualToString:@"iPhone9,1"])  return@"iPhone 7";
    if([platform isEqualToString:@"iPhone9,2"])  return@"iPhone 7 Plus";
    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    if([platform isEqualToString:@"iPod1,1"])  return@"iPod Touch 1G";
    if([platform isEqualToString:@"iPod2,1"])  return@"iPod Touch 2G";
    if([platform isEqualToString:@"iPod3,1"])  return@"iPod Touch 3G";
    if([platform isEqualToString:@"iPod4,1"])  return@"iPod Touch 4G";
    if([platform isEqualToString:@"iPod5,1"])  return@"iPod Touch 5G";
    if([platform isEqualToString:@"iPad1,1"])  return@"iPad 1G";
    if([platform isEqualToString:@"iPad2,1"])  return@"iPad 2";
    if([platform isEqualToString:@"iPad2,2"])  return@"iPad 2";
    if([platform isEqualToString:@"iPad2,3"])  return@"iPad 2";
    if([platform isEqualToString:@"iPad2,4"])  return@"iPad 2";
    if([platform isEqualToString:@"iPad2,5"])  return@"iPad Mini 1G";
    if([platform isEqualToString:@"iPad2,6"])  return@"iPad Mini 1G";
    if([platform isEqualToString:@"iPad2,7"])  return@"iPad Mini 1G";
    if([platform isEqualToString:@"iPad3,1"])  return@"iPad 3";
    if([platform isEqualToString:@"iPad3,2"])  return@"iPad 3";
    if([platform isEqualToString:@"iPad3,3"])  return@"iPad 3";
    if([platform isEqualToString:@"iPad3,4"])  return@"iPad 4";
    if([platform isEqualToString:@"iPad3,5"])  return@"iPad 4";
    if([platform isEqualToString:@"iPad3,6"])  return@"iPad 4";
    if([platform isEqualToString:@"iPad4,1"])  return@"iPad Air";
    if([platform isEqualToString:@"iPad4,2"])  return@"iPad Air";
    if([platform isEqualToString:@"iPad4,3"])  return@"iPad Air";
    if([platform isEqualToString:@"iPad4,4"])  return@"iPad Mini 2G";
    if([platform isEqualToString:@"iPad4,5"])  return@"iPad Mini 2G";
    if([platform isEqualToString:@"iPad4,6"])  return@"iPad Mini 2G";
    if([platform isEqualToString:@"iPad4,7"])  return@"iPad Mini 3";
    if([platform isEqualToString:@"iPad4,8"])  return@"iPad Mini 3";
    if([platform isEqualToString:@"iPad4,9"])  return@"iPad Mini 3";
    if([platform isEqualToString:@"iPad5,1"])  return@"iPad Mini 4";
    if([platform isEqualToString:@"iPad5,2"])  return@"iPad Mini 4";
    if([platform isEqualToString:@"iPad5,3"])  return@"iPad Air 2";
    if([platform isEqualToString:@"iPad5,4"])  return@"iPad Air 2";
    if([platform isEqualToString:@"iPad6,3"])  return@"iPad Pro 9.7";
    if([platform isEqualToString:@"iPad6,4"])  return@"iPad Pro 9.7";
    if([platform isEqualToString:@"iPad6,7"])  return@"iPad Pro 12.9";
    if([platform isEqualToString:@"iPad6,8"])  return@"iPad Pro 12.9";
    if([platform isEqualToString:@"i386"])  return@"iPhone Simulator";
    if([platform isEqualToString:@"x86_64"])  return@"iPhone Simulator";
    return platform;
    
}


//获取当前的时间
+(NSString*)getCurrentTimes:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:format];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}


//获取当前时间戳  （以毫秒为单位）
+(NSString *)getNowTimeTimestamp3{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    return timeSp;
}


+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    NSLog(@"将某个时间转化成 时间戳&&&&&&&timeSp:%ld",(long)timeSp); //时间戳的值
    return timeSp;
}


+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSLog(@"1296035591  = %@",confromTimesp);
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    //NSLog(@"&&&&&&&confromTimespStr = : %@",confromTimespStr);
    return confromTimespStr;
}


+(NSString *)handleDateStr:(NSString *)needHandleDateStr handleFormat:(NSString *)Format{
    NSString *dateStr = @"";
    
    NSRange rang = {0,10};
    
    NSString *remove_date = [needHandleDateStr stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
    remove_date = [remove_date stringByReplacingOccurrencesOfString:@")/" withString:@""];
    NSString *DateTime;
    if (remove_date.length > 10) {
        DateTime  = [remove_date substringWithRange:rang];
    }
    else{
        DateTime = remove_date;
    }
    
    NSString *DateStr = [PhoneInfo timestampSwitchTime:[DateTime integerValue] andFormatter:Format];
    
    dateStr = DateStr;
    
    return dateStr;
}


+(NSDictionary *)jsonDictWithString:(NSString *)string
{
    if (string && 0 != string.length)
    {
        NSError *error;
        NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
//        if (error != nil)
//        {
//            NSLog(@"json解析失败：%@", error.localizedDescription);
//            return nil;
//        }
        
        return jsonDict;
    }
    
    return nil;
}









@end
