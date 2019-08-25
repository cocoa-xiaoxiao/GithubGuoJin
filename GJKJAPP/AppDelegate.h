//
//  AppDelegate.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/1/6.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(strong,nonatomic) NSMutableArray *subModuleDic;

@property(strong,nonatomic) NSMutableDictionary *batchDic;

@property (nonatomic, assign) NSInteger totalSubModule;

@property (nonatomic, strong) UITabBarController *mainTabbar;
@end

