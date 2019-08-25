//
//  BRUserInfoModifyView.h
//  GJKJAPP
//
//  Created by git burning on 2018/9/12.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IQKeyboardManager/IQPreviousNextView.h>
@interface BRUserInfoModifyView : IQPreviousNextView
@property (retain, nonatomic) IBOutlet UIButton *headerBtn;
@property (retain, nonatomic) IBOutlet UITextField *telTextFeild;
@property (retain, nonatomic) IBOutlet UITextField *emailTextFeild;
@property (retain, nonatomic) IBOutlet UITextField *cardTextFeild;

+ (BRUserInfoModifyView *)br_getBRUserInfoModifyView;
@end
