//
//  CheckProposalListViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/13.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "CheckProposalListViewController.h"
#import "HaveCheckProposalListViewController.h"
#import "NotCheckProposalListViewController.h"
#import "ZLNavTabBarController.h"
@interface CheckProposalListViewController ()

@end

@implementation CheckProposalListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"开题报告审核";
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self startLayout];
}
-(void) startLayout{
    HaveCheckProposalListViewController *notView = [[HaveCheckProposalListViewController alloc] init];
    notView.title = @"待审核";
    
    NotCheckProposalListViewController *haveView = [[NotCheckProposalListViewController alloc] init];
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
