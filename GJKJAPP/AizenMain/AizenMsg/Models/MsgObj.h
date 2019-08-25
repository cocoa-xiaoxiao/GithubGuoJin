//
//  MsgObj.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/1/17.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgObj : NSObject

@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *type;
@property(nonatomic,assign) int msgId;
@property(nonatomic,assign) int messageCount;
@property(nonatomic,strong) NSString *date;
@property(nonatomic,strong) NSString *message;
@property(nonatomic,strong) NSString *imgUrl;

@end
