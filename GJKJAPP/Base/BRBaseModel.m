//
//  BRBaseModel.m
//  GJKJAPP
//
//  Created by git burning on 2018/9/9.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "BRBaseModel.h"

@implementation BRBaseModel
-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError **)err{
    if ([dict isKindOfClass:[NSDictionary class]]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *dict_str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        dict_str = [dict_str stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
        dict_str = [dict_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"\"\""];

        dict = [NSJSONSerialization JSONObjectWithData:[dict_str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        
    }
    self = [super initWithDictionary:dict error:nil];
    if (self) {
        
    }
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}
@end
