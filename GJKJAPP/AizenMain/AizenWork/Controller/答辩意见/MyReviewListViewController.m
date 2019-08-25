//
//  MyReviewListViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/13.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MyReviewListViewController.h"
#import "HaveMyReviewListViewController.h"
#import "NotMyReviewListViewController.h"
#import "ZLNavTabBarController.h"
@interface MyReviewListViewController ()

@end

@implementation MyReviewListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"答辩意见";
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self startLayout];
}
-(void) startLayout{
    HaveMyReviewListViewController *notView = [[HaveMyReviewListViewController alloc] init];
    notView.title = @"未撰写";
    
    NotMyReviewListViewController *haveView = [[NotMyReviewListViewController alloc] init];
    haveView.title = @"已撰写";
    
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
