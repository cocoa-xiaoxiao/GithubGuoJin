//
//  BRCheckWorkModel.m
//  GJKJAPP
//
//  Created by git burning on 2018/9/15.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "BRCheckWorkModel.h"

@implementation BRCheckWorkModel
-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError **)err{
    self = [super initWithDictionary:dict error:err];
    if (self) {
        if (self.CheckInPlace.length > 0) {
            self.signCount = self.signCount + 1;
        }
        if (self.CheckOutPlace.length > 0 && ![self.CheckOutPlace isEqualToString:@" "]) {
            self.signCount = self.signCount + 1;
        }
        self.CheckInDate = self.CheckInDate.changeYYYYMMDDSSTime;
        self.CheckOutDate = self.CheckOutDate.changeYYYYMMDDSSTime;

    }
    return self;
}
@end
