//
//  WriteWeeklyViewController.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/4/11.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteWeeklyViewController : BaseViewController

@property int flagStatus;  /*判断周记为新增=0、更新=1*/
@property(nonatomic,strong) NSString *weeklyID; /*周记ID*/

@end
