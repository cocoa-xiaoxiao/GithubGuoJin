//
//  SignAuditViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/3/23.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "SignAuditViewController.h"
#import "RDVTabBarController.h"
#import "ZLNavTabBarController.h"
#import "SignsuccessViewController.h"
#import "SignerrorViewController.h"


@interface SignAuditViewController ()

@end

@implementation SignAuditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    self.navigationItem.title = @"签到审核";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    SignsuccessViewController *successView = [[SignsuccessViewController alloc] init];
    successView.title = @"签到审批";

    SignerrorViewController *errorView = [[SignerrorViewController alloc] init];
    errorView.title = @"签退审批";
    
    ZLNavTabBarController *navTabBarController = [[ZLNavTabBarController alloc] init];
    navTabBarController.subViewControllers = @[successView, errorView];
    navTabBarController.navTabBarColor = [UIColor whiteColor];
    navTabBarController.mainViewBounces = YES;
    navTabBarController.selectedToIndex = 2;
    navTabBarController.unchangedToIndex = 1;
    navTabBarController.showArrayButton = NO;
    [navTabBarController addParentController:self];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction:)];
    [backBtnItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = backBtnItem ;
    
}


-(void)backAction:(UIBarButtonItem *)sender{
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
