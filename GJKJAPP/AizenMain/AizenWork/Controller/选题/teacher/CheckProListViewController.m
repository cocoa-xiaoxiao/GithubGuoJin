//
//  CheckProListViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/12.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "CheckProListViewController.h"
#import "HaveProListViewController.h"
#import "NotProListViewController.h"
#import "ZLNavTabBarController.h"

@interface CheckProListViewController ()

@end

@implementation CheckProListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选题审核";
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self startLayout];
    
}

-(void) startLayout{
    NotProListViewController *notView = [[NotProListViewController alloc] init];
    notView.title = @"未审核";
    
    HaveProListViewController *haveView = [[HaveProListViewController alloc] init];
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
