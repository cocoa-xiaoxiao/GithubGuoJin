//
//  ProReviewViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/1/7.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "ProReviewViewController.h"
#import "HaveProReviewViewController.h"
#import "NotProReviewViewController.h"
#import "ZLNavTabBarController.h"
@interface ProReviewViewController ()

@end

@implementation ProReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评阅任务";
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self startLayout];
}
-(void) startLayout{
    HaveProReviewViewController *haveView = [[HaveProReviewViewController alloc] init];
    haveView.title = @"未评阅";
    
    NotProReviewViewController *notView = [[NotProReviewViewController alloc] init];
    notView.title = @"已评阅";
    
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
