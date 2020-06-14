//
//  AppDelegate.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/1/6.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "OutlookViewController.h"
#import "UMMobClick/MobClick.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "XYDJViewController.h"
#import <NilSafety/NilSafetyManager.h>
#import <Bugly/Bugly.h>

#define BUGLY_APP_ID @"f76c7ad602"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // Init the Bugly sdk
    [self setupBugly];
    /**
     *  @brief 配置http端口地址
     */
    [HttpService configeWithUserInfo:nil];
    [NilSafetyManager sharedInstance];
    [[NilSafetyManager sharedInstance] setupWithOdds: 1- FLT_EPSILON * 0.9];
    _subModuleDic = [NSMutableArray arrayWithCapacity:0];
    _batchDic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.window.frame = [[UIScreen mainScreen]bounds];
//    if([AizenStorage readUserDataWithKey:@"isLogin"]){
//
//    }
    
    ViewController *viewCtl = [[ViewController alloc]init];
//    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:viewCtl];
    self.window.rootViewController = viewCtl;
    [self.window makeKeyAndVisible];
   
    
    UMConfigInstance.appKey = @"5ba3d980b465f5b96f0004fd";
    UMConfigInstance.channelId = @"App Store";
    UMConfigInstance.eSType = E_UM_GAME; //仅适用于游戏场景，应用统计不用设置
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
//    NSMutableDictionary *tem = [NSMutableDictionary dictionaryWithCapacity:0];
//    [tem setObject:nil forKey:@"asdad"];
    //XYDJViewController
    //disabledToolbarClasses
//    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[XYDJViewController class]];
    return YES;
}
- (void)setupBugly {
#if !DEBUG
    [Bugly startWithAppId:BUGLY_APP_ID];
#endif
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
