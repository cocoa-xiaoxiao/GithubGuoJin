//
//  PatrolTaskViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/14.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "PatrolTaskViewController.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "DGActivityIndicatorView.h"
#import "RDVTabBarController.h"
#import "ZLNavTabBarController.h"
#import "PatrolObjViewController.h"
#import "PatrolGroupViewController.h"

@interface PatrolTaskViewController ()

@property(nonatomic,strong) UIView *contentView;


@end

@implementation PatrolTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    self.navigationItem.title = @"巡察任务";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction:)];
    [backBtnItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = backBtnItem ;
    
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:self.navigationItem.title style:UIBarButtonItemStylePlain target:nil action:nil];
    [backBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.backBarButtonItem = backBtn;
    
    
    [self detailLayout];
}


-(void)backAction:(UIBarButtonItem *)sender{
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) detailLayout{
    
    PatrolObjViewController *obj = [[PatrolObjViewController alloc]init];
    
    obj.title = @"巡察对象";
    
    PatrolGroupViewController *group = [[PatrolGroupViewController alloc]init];
    group.title = @"我的小组";
    
    ZLNavTabBarController *navTabBarController = [[ZLNavTabBarController alloc] init];
    navTabBarController.subViewControllers = @[obj, group];
    navTabBarController.navTabBarColor = [UIColor whiteColor];
    navTabBarController.mainViewBounces = YES;
    navTabBarController.selectedToIndex = 2;
    navTabBarController.unchangedToIndex = 1;
    navTabBarController.showArrayButton = NO;
    [navTabBarController addParentController:self];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
};




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
