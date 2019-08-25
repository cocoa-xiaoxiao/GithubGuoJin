//
//  CheckStatisticsViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/7.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "CheckStatisticsViewController.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "DataStatisticsViewController.h"
#import "LeaveStatisticsViewController.h"
#import "DutyStatisticsViewController.h"
#import "NormalStatisticsViewController.h"
#import "RDVTabBarController.h"
#import "ZLNavTabBarController.h"


@interface CheckStatisticsViewController ()

@end

@implementation CheckStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"考勤统计";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction:)];
    [backBtnItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = backBtnItem ;
    
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:self.navigationItem.title style:UIBarButtonItemStylePlain target:nil action:nil];
    [backBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.backBarButtonItem = backBtn;
    
    [self startLayout];
}

-(void)backAction:(UIBarButtonItem *)sender{
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) startLayout{
    DataStatisticsViewController *dataView = [[DataStatisticsViewController alloc] init];
    dataView.title = @"数据";
    
    LeaveStatisticsViewController *LeaveView = [[LeaveStatisticsViewController alloc] init];
    LeaveView.title = @"请假";
    
    DutyStatisticsViewController *DutyView = [[DutyStatisticsViewController alloc]init];
    DutyView.title = @"缺勤";
    
    NormalStatisticsViewController *NormalView = [[NormalStatisticsViewController alloc]init];
    NormalView.title = @"正常";
    
    ZLNavTabBarController *navTabBarController = [[ZLNavTabBarController alloc] init];
    navTabBarController.subViewControllers = @[dataView, LeaveView,DutyView,NormalView];
    navTabBarController.navTabBarColor = [UIColor clearColor];
    navTabBarController.mainViewBounces = YES;
    navTabBarController.selectedToIndex = 4;
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
