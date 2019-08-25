//
//  CheckReportViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/3/27.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "CheckReportViewController.h"
#import "NCCheckReportViewController.h"
#import "HCCheckReportViewController.h"
#import "ZLNavTabBarController.h"
@interface CheckReportViewController ()

@end

@implementation CheckReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报告审核";
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self startLayout];
}
-(void) startLayout{
    NCCheckReportViewController *notView = [[NCCheckReportViewController alloc] init];
    notView.title = @"待审核";
    
    HCCheckReportViewController *haveView = [[HCCheckReportViewController alloc] init];
    haveView.title = @"已审核";
    
    ZLNavTabBarController *navTabBarController = [[ZLNavTabBarController alloc] init];
    navTabBarController.subViewControllers = @[notView, haveView];
    navTabBarController.navTabBarColor = [UIColor clearColor];
    navTabBarController.mainViewBounces = YES;
    navTabBarController.selectedToIndex = 2;
    navTabBarController.unchangedToIndex = 1;
    navTabBarController.showArrayButton = NO;
    [navTabBarController addParentController:self];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
@end
