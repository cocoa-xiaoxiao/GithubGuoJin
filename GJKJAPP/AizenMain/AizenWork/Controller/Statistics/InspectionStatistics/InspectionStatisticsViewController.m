//
//  InspectionStatisticsViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/31.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "InspectionStatisticsViewController.h"
#import "RDVTabBarController.h"
#import "ZLNavTabBarController.h"
#import "StandingPointViewController.h"
#import "ApartmentViewController.h"

@interface InspectionStatisticsViewController ()

@end

@implementation InspectionStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"巡察统计";
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction:)];
    [backBtnItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = backBtnItem;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [self startLayout];
}



-(void) startLayout{
    StandingPointViewController *standing = [[StandingPointViewController alloc]init];
    standing.title = @"驻点巡察";
    
    
    ApartmentViewController *apartment = [[ApartmentViewController alloc]init];
    apartment.title = @"部门巡察";
    
    ZLNavTabBarController *navTabBarController = [[ZLNavTabBarController alloc] init];
    navTabBarController.subViewControllers = @[standing, apartment];
    navTabBarController.navTabBarColor = [UIColor clearColor];
    navTabBarController.mainViewBounces = YES;
    navTabBarController.selectedToIndex = 2;
    navTabBarController.unchangedToIndex = 1;
    navTabBarController.showArrayButton = NO;
    [navTabBarController addParentController:self];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}



-(void) backAction:(UIBarButtonItem *)sender{
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
