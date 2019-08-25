//
//  BaseViewController.h
//  GJKJAPP
//
//  Created by git burning on 2018/9/8.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#define kSuccessCodeTag  100
@interface BaseViewController : UIViewController
@property (nonatomic, copy) void(^updateBlock)(id info);
@property (nonatomic , assign) BOOL isApear;
@property (nonatomic, assign) CGFloat nav_offset;
+ (void)br_endKeyboard;

+ (void)br_showAlterMsg:(NSString *)msg;

+ (void)br_showAlterMsg:(NSString *)msg sureBlock:(void(^)(id info))block;

+ (void)br_toSetting;


+ (UINavigationController *)getCurrentNav;

+ (AppDelegate *)br_getAppDelegate;
@end
