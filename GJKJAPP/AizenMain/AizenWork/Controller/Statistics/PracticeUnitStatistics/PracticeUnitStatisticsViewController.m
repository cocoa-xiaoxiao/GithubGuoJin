//
//  PracticeUnitStatisticsViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/6/1.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "PracticeUnitStatisticsViewController.h"
#import "RDVTabBarController.h"
#import "InternshipUnitViewController.h"
#import "InternshipAgreementViewController.h"
#import "ZLNavTabBarController.h"

@interface PracticeUnitStatisticsViewController ()

@end

@implementation PracticeUnitStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"企业统计";
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction:)];
    [backBtnItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = backBtnItem;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [self startLayout];
}


-(void) startLayout{
    InternshipUnitViewController *Unit = [[InternshipUnitViewController alloc]init];
    Unit.title = @"实习单位";
    
    
    InternshipAgreementViewController *agreement = [[InternshipAgreementViewController alloc]init];
    agreement.title = @"实习协议";
    
    ZLNavTabBarController *navTabBarController = [[ZLNavTabBarController alloc] init];
    navTabBarController.subViewControllers = @[Unit, agreement];
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
