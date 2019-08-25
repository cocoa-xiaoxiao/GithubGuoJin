//
//  LoginViewController.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/1/6.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPAutoCompleteTextFieldDelegate.h"
#import "MLPAutoCompleteTextFieldDataSource.h"

@class MLPAutoCompleteTextField;
@interface LoginViewController : UIViewController<UITextFieldDelegate, MLPAutoCompleteTextFieldDelegate,MLPAutoCompleteTextFieldDataSource>

+ (void)hadLogInRefrshData;
@end
