//
//  MyTeacherViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/2/21.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "MyTeacherViewController.h"
#import "MyTeacherNotCheckViewController.h"
#import "MYTeacherHaveCheckViewController.h"
#import "ZLNavTabBarController.h"
#import "ChooseTeacherViewController.h"
@interface MyTeacherViewController ()

@end

@implementation MyTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的导师";
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    UIButton *leftCustomButton1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
    [leftCustomButton1 addTarget:self action:@selector(addTeacher:) forControlEvents:UIControlEventTouchUpInside];
    [leftCustomButton1.widthAnchor constraintEqualToConstant:33].active = YES;
    [leftCustomButton1.heightAnchor constraintEqualToConstant:33].active = YES;
    [leftCustomButton1 setImage:[UIImage imageNamed:@"iv_addicom"] forState:UIControlStateNormal];
    UIBarButtonItem * leftButtonItem1 =[[UIBarButtonItem alloc] initWithCustomView:leftCustomButton1];
    self.navigationItem.rightBarButtonItem = leftButtonItem1;
    [self startLayout];
}
-(void)addTeacher:(UIButton *)sender
{
    ChooseTeacherViewController *vc = [[ChooseTeacherViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}
-(void) startLayout{
    MyTeacherNotCheckViewController *notView = [[MyTeacherNotCheckViewController alloc] init];
    notView.title = @"待审核";
    
    MYTeacherHaveCheckViewController *haveView = [[MYTeacherHaveCheckViewController alloc] init];
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
