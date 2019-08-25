//
//  NSString+ImgUrl.m
//  GJKJAPP
//
//  Created by git burning on 2018/9/13.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "NSString+ImgUrl.h"
#import "PhoneInfo.h"
@implementation NSString (ImgUrl)
-(NSString *)fullImg{
    if ([self rangeOfString:@"http"].location != NSNotFound || [self rangeOfString:@"https"].location != NSNotFound) {
        return self;
    }
    else{
        return [NSString stringWithFormat:@"%@/%@",kCacheHttpRoot,self];
    }
}
-(NSString *)changeYYYYMMDDTime {
    NSString *temp = [self stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@")/" withString:@""];
    temp = [PhoneInfo timestampSwitchTime:temp.integerValue / 1000 andFormatter:@"YYYY-MM-dd"];
    return temp;
}
-(NSString *)changeYYYYMMDDSSTime {
    NSString * temp = [self stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@")/" withString:@""];
    temp = [PhoneInfo timestampSwitchTime:temp.integerValue / 1000 andFormatter:@"YYYY-MM-dd HH:mm:ss"];
    return temp;
}
- (NSString *)changeMMDDSSTime{
    NSString *temp = [PhoneInfo timestampSwitchTime:self.integerValue / 1000 andFormatter:@"MM-dd HH:mm:ss"];
    return temp;
}
@end
