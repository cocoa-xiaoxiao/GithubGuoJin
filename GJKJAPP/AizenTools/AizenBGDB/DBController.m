//
//  DBController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/2/5.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "DBController.h"
#import "People.h"

@implementation DBController

+(NSString*)stringWithDate:(NSDate*)date{
    NSDateFormatter* formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:date];
}

@end
