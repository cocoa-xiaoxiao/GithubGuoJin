//
//  People.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/2/5.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSObject+BGModel.h"

@interface People : NSObject

@property(nonatomic,strong)NSString *ACCOUNT;
@property(nonatomic,strong)NSString *PWD;
@property(nonatomic,strong)NSNumber *USERID;
@property(nonatomic,strong)NSString *USERNO;
@property(nonatomic,strong)NSString *USERNAME;
@property(nonatomic,strong)NSString *PHONE;
@property(nonatomic,strong)NSString *EMAIL;
@property(nonatomic,strong)NSString *SEX;
@property(nonatomic,strong)NSNumber *COLLEGEID;
@property(nonatomic,strong)NSString *COLLEGENAME;
@property(nonatomic,strong)NSNumber *SUBJECTID;
@property(nonatomic,strong)NSString *SUBJECTNAME;
@property(nonatomic,strong)NSNumber *GRADEID;
@property(nonatomic,strong)NSString *GRADENAME;
@property(nonatomic,strong)NSNumber *CLASSID;
@property(nonatomic,strong)NSString *CLASSNAME;
@property(nonatomic,strong)NSString *LASTLOGINDATE;
@property (nonatomic, strong) NSString *FactUrl;
@property (nonatomic, strong) NSString *signUrl;
@end
