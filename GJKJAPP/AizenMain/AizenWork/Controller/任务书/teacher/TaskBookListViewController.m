//
//  TaskBookListViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/13.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "TaskBookListViewController.h"
#import "HaveTaskBookListViewController.h"
#import "NotTaskBookListViewController.h"
#import "ZLNavTabBarController.h"
@interface TaskBookListViewController ()

@end

@implementation TaskBookListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"下达任务书";
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self startLayout];
}
-(void) startLayout{
    HaveTaskBookListViewController *haveView = [[HaveTaskBookListViewController alloc] init];
    haveView.title = @"已下达";
    
    NotTaskBookListViewController *notView = [[NotTaskBookListViewController alloc] init];
    notView.title = @"未下达";
    
    ZLNavTabBarController *navTabBarController = [[ZLNavTabBarController alloc] init];
    navTabBarController.subViewControllers = @[haveView, notView];
    navTabBarController.navTabBarColor = [UIColor clearColor];
    navTabBarController.mainViewBounces = YES;
    navTabBarController.selectedToIndex = 2;
    navTabBarController.unchangedToIndex = 1;
    navTabBarController.showArrayButton = NO;
    [navTabBarController addParentController:self];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
@end
