//
//  AuditingStationViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/4/16.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "AuditingStationViewController.h"
#import "RDVTabBarController.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "AizenMD5.h"
#import "RAlertView.h"
#import "DGActivityIndicatorView.h"
#import "People.h"
#import "PersonModel.h"
#import "NotAuditingViewController.h"
#import "HaveAuditingViewController.h"
#import "ZLNavTabBarController.h"

@interface AuditingStationViewController ()

@end

@implementation AuditingStationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"审核岗位";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [[self rdv_tabBarController]setTabBarHidden:YES animated:YES];
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction:)];
    [backBtnItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = backBtnItem;
    
    [self startLayout];
}


-(void)backAction:(UIBarButtonItem *)sender{
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) startLayout{
    NotAuditingViewController *notView = [[NotAuditingViewController alloc] init];
    notView.title = @"未审核";
    
    HaveAuditingViewController *haveView = [[HaveAuditingViewController alloc] init];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
