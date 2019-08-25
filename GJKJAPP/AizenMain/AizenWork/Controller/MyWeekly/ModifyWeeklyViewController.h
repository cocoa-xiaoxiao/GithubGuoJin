//
//  ModifyWeeklyViewController.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/4/22.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyWeeklyViewController : BaseViewController
//    NSInteger CheckState = [dataDic[@"CheckState"] integerValue];

@property(nonatomic,strong) NSDictionary *dataDic;
@property (nonatomic,assign) BOOL isCanEidt;
@end
