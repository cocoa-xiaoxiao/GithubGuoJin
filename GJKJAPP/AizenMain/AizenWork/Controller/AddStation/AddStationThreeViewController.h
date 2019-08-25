//
//  AddStationThreeViewController.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/3/2.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddStationThreeViewController : UIViewController

@property(nonatomic,strong) NSDictionary *getStationDic;

@property(nonatomic,strong) NSString *uploadStationID;

@property(nonatomic,strong) NSString *uploadID;
@property(nonatomic,strong) NSString *uploadQYName;
@property(nonatomic,strong) NSString *uploadQYCode;
@property(nonatomic,strong) NSString *uploadQYTotal;
@property(nonatomic,strong) NSString *uploadQYAddress;
@property (nonatomic,assign) BOOL uploadQYFlag;

@property(nonatomic,strong) NSString *uploadStationName;
@property(nonatomic,strong) NSString *uploadStationTotal;
@property(nonatomic,strong) NSString *uploadStationIntro;

@end
