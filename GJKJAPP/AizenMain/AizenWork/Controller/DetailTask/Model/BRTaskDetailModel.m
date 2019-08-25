//
//  BRTaskDetailModel.m
//  GJKJAPP
//
//  Created by git burning on 2018/9/15.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "BRTaskDetailModel.h"
#import "PhoneInfo.h"
@implementation BRTaskDetailModel
-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError **)err{
//    if ([dict isKindOfClass:[NSDictionary class]]) {
//        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
//        NSString *dict_str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        dict_str = [dict_str stringByReplacingOccurrencesOfString:@"null" withString:@"\" \""];
//        dict = [NSJSONSerialization JSONObjectWithData:[dict_str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
//        
//    }
    self = [super initWithDictionary:dict error:nil];
    if (self) {
        if (self.SubmitContent.length == 0 || [self.SubmitContent isEqualToString:@" "]) {
            self.SubmitContent = [@"暂无" copy];
        }
        self.CreateDate = [self.CreateDate stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
        self.CreateDate = [self.CreateDate stringByReplacingOccurrencesOfString:@")/" withString:@""];
        self.CreateDate = [PhoneInfo timestampSwitchTime:self.CreateDate.integerValue / 1000 andFormatter:@"YYYY-MM-dd"];

    }
    return self;
}
@end
