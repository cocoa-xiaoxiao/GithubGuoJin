//
//  MsgMailListViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/29.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MsgMailListViewController.h"
#import "RDVTabBarController.h"
#import "ZLNavTabBarController.h"
#import "AllPeopleViewController.h"
#import "StudentPeopleViewController.h"
#import "TeacherPeopleViewController.h"
#import "OtherPeopleViewController.h"

@interface MsgMailListViewController ()

@end

@implementation MsgMailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"通讯录";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    
    [self startLayout];
}


-(void) startLayout{
    self.view.backgroundColor = [UIColor whiteColor];
    
    AllPeopleViewController *all = [[AllPeopleViewController alloc] init];
    all.title = @"部门领导和同事";
    
//    TeacherPeopleViewController *teacher = [[TeacherPeopleViewController alloc] init];
//    teacher.title = @"";
//
//    StudentPeopleViewController *student = [[StudentPeopleViewController alloc]init];
//    student.title = @"";
//
//    OtherPeopleViewController *other = [[OtherPeopleViewController alloc]init];
//    other.title = @"";
    
    ZLNavTabBarController *navTabBarController = [[ZLNavTabBarController alloc] init];
//    navTabBarController.subViewControllers = @[all, teacher,student,other];
    navTabBarController.subViewControllers = @[all];
    navTabBarController.navTabBarColor = [UIColor clearColor];
    navTabBarController.mainViewBounces = YES;
    navTabBarController.selectedToIndex = 1;
    navTabBarController.unchangedToIndex = 1;
    navTabBarController.showArrayButton = NO;
    [navTabBarController addParentController:self];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController]setTabBarHidden:YES animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
