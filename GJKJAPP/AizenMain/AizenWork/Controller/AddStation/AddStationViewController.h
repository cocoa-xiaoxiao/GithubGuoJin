//
//  AddStationViewController.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/3/1.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPAutoCompleteTextFieldDataSource.h"
#import "MLPAutoCompleteTextFieldDelegate.h"

@class MLPAutoCompleteTextField;
@interface AddStationViewController : BaseViewController<UITextFieldDelegate,MLPAutoCompleteTextFieldDelegate,MLPAutoCompleteTextFieldDataSource>

@property(nonatomic,strong) NSDictionary *getCompanyDic;

@end
