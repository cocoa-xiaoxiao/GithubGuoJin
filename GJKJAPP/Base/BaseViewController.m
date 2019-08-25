//
//  BaseViewController.m
//  GJKJAPP
//
//  Created by git burning on 2018/9/8.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "BaseViewController.h"
#import "RAlertView.h"
#import "RDVTabBarController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.nav_offset = 64;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
+(AppDelegate *)br_getAppDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
-(void)dealloc{
    NSLog(@"%@",NSStringFromClass(self.class));
}
+(void)br_endKeyboard {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

}
+(void)br_showAlterMsg:(NSString *)msg {
    RAlertView *alert = [[RAlertView alloc]initWithStyle:SimpleAlert];
    alert.headerTitleLabel.text = @"提示";
    alert.contentTextLabel.text = msg;
    alert.isClickBackgroundCloseWindow = YES;
}
+ (void)br_showAlterMsg:(NSString *)msg sureBlock:(void (^)(id))block {
    RAlertView *alert = [[RAlertView alloc]initWithStyle:ConfirmAlert];
    alert.headerTitleLabel.text = @"提示";
    alert.contentTextLabel.text = msg;
    alert.isClickBackgroundCloseWindow = NO;
    alert.confirm = ^{
        if (block) {
            block(nil);
        }
    };
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

+ (UINavigationController *)getCurrentNav{
    UITabBarController *tabbar = [BaseViewController br_getAppDelegate].mainTabbar;
    if (!tabbar) {
        return nil;
    }
    else{
        UINavigationController *nav = tabbar.selectedViewController;
        if ([nav isKindOfClass:[UINavigationController class]]) {
            return nav;
        }
        return nil;
    }
}
+ (void)br_toSetting {
    
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        //此处可以做一下版本适配，至于为何要做版本适配，大家应该很清楚
        [[UIApplication sharedApplication] openURL:url];
        
    }
}
@end
