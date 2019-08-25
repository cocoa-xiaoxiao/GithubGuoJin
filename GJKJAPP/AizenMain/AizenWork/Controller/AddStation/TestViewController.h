//
//  TestViewController.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/2/19.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPAutoCompleteTextFieldDataSource.h"
#import "MLPAutoCompleteTextFieldDelegate.h"

@class MLPAutoCompleteTextField;
@interface TestViewController : UIViewController<MLPAutoCompleteTextFieldDelegate,MLPAutoCompleteTextFieldDataSource>

@end
