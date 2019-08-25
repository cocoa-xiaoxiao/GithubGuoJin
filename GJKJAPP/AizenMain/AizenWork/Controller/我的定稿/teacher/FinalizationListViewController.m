//
//  FinalizationListViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/13.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "FinalizationListViewController.h"
#import "HaveFinalizationListViewController.h"
#import "NotFinalizationListViewController.h"
#import "ZLNavTabBarController.h"
@interface FinalizationListViewController ()

@end

@implementation FinalizationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"定稿审核";
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self startLayout];
}
-(void) startLayout{
    HaveFinalizationListViewController *notView = [[HaveFinalizationListViewController alloc] init];
    notView.title = @"待审核";
    
    NotFinalizationListViewController *haveView = [[NotFinalizationListViewController alloc] init];
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
