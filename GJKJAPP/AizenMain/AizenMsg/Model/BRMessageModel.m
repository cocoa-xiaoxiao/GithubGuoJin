//
//  BRMessageModel.m
//  GJKJAPP
//
//  Created by git burning on 2018/9/25.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "BRMessageModel.h"

@implementation BRMessageModel
-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError **)err {
    self = [super initWithDictionary:dict error:err];
    if (self) {
        self.CreateDate = [self.CreateDate stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
        self.CreateDate = [self.CreateDate stringByReplacingOccurrencesOfString:@")/" withString:@""];
        self.CreateDate = [self.CreateDate changeMMDDSSTime];

    }
    return self;
}
@end
