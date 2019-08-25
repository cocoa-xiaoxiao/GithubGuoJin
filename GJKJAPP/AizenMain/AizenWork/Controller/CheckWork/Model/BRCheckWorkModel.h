//
//  BRCheckWorkModel.h
//  GJKJAPP
//
//  Created by git burning on 2018/9/15.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "BRBaseModel.h"

@interface BRCheckWorkModel : BRBaseModel
@property (nonatomic,copy) NSString *CheckInDate;
@property (nonatomic,copy) NSString *CheckInPlace;
@property (nonatomic,copy) NSString *CheckOutPlace;
@property (nonatomic,copy) NSString *CheckOutDate;

@property (nonatomic,assign) NSInteger signCount;
@end
