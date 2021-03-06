//
//  UnitFiveVC.h
//  GJKJAPP
//
//  Created by 肖啸 on 2019/12/17.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UnitFiveVC : UIViewController
@property(nonatomic,strong) NSString *uploadSaraly;
@property(nonatomic,strong) NSString *uploadDate;
@property(nonatomic,strong) NSString *uploadStay;
@property(nonatomic,strong) NSString *uploadFood;
@property(nonatomic,strong) NSString *uploadAgreement;
@property(nonatomic,strong) NSString *uploadDescr;

@property(nonatomic,strong) NSString *uploadID;
@property(nonatomic,strong) NSString *uploadQYName;
@property(nonatomic,strong) NSString *uploadQYCode;
@property(nonatomic,strong) NSString *uploadQYTotal;
@property(nonatomic,strong) NSString *uploadQYAddress;
@property (nonatomic,assign) BOOL uploadQYFlag;

@property(nonatomic,strong) NSString *uploadStationID;
@property(nonatomic,strong) NSString *uploadStationName;
@property(nonatomic,strong) NSString *uploadStationTotal;
@property(nonatomic,strong) NSString *uploadStationIntro;

@property(nonatomic,strong) NSString *uploadJSID;
@property(nonatomic,strong) NSString *uploadJSName;
@property(nonatomic,strong) NSString *uploadJSPhone;
@property(nonatomic,strong) NSString *uploadJSTel;
@property(nonatomic,strong) NSString *uploadJSEmail;
@end

NS_ASSUME_NONNULL_END
