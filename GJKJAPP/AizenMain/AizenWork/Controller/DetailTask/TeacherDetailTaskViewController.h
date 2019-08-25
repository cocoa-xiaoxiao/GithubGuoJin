//
//  TeacherDetailTaskViewController.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/16.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherDetailTaskViewController : BaseViewController

@property(nonatomic,strong) NSString *flagRole;

@property(nonatomic,strong) NSString *taskID;


/**
 是否可以 显示审核。
 */
@property (nonatomic, assign) BOOL isNotApplay;

@end
