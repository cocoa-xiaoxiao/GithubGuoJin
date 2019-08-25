//
//  LeaveCheckViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/2/23.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "LeaveAuditViewController.h"
#import "SCNavTabBarController.h"
#import "RDVTabBarController.h"
#import "AuditingViewController.h"
#import "LeavePassViewController.h"
#import "LeaveUnPassViewController.h"

@interface LeaveAuditViewController ()

@end

@implementation LeaveAuditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"请假审核";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction:)];
    [backBtnItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = backBtnItem ;
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:self.navigationItem.title style:UIBarButtonItemStylePlain target:nil action:nil];
    [backBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.backBarButtonItem = backBtn;
    
    
    // Do any additional setup after loading the view.
    AuditingViewController *oneViewController = [[AuditingViewController alloc] init];
    oneViewController.title = @"待审核";
    
    LeavePassViewController *twoViewController = [[LeavePassViewController alloc] init];
    twoViewController.title = @"已审核";
    
//    LeaveUnPassViewController *threeViewController = [[LeaveUnPassViewController alloc] init];
//    threeViewController.title = @"未通过";
//
//    UIViewController *fourViewController = [[UIViewController alloc] init];
//    fourViewController.title = @"天府之国";
//    fourViewController.view.backgroundColor = [UIColor whiteColor];
//
//    UIViewController *fiveViewController = [[UIViewController alloc] init];
//    fiveViewController.title = @"四川省";
//    fiveViewController.view.backgroundColor = [UIColor whiteColor];
//
//    UIViewController *sixViewController = [[UIViewController alloc] init];
//    sixViewController.title = @"政治";
//    sixViewController.view.backgroundColor = [UIColor whiteColor];
//
//    UIViewController *sevenViewController = [[UIViewController alloc] init];
//    sevenViewController.title = @"国际新闻";
//    sevenViewController.view.backgroundColor = [UIColor whiteColor];
//
//    UIViewController *eightViewController = [[UIViewController alloc] init];
//    eightViewController.title = @"自媒体";
//    eightViewController.view.backgroundColor = [UIColor whiteColor];
//
//    UIViewController *ninghtViewController = [[UIViewController alloc] init];
//    ninghtViewController.title = @"科技";
//    ninghtViewController.view.backgroundColor = [UIColor whiteColor];
    
//    NSArray *vcs  = @[oneViewController, twoViewController, threeViewController, fourViewController, fiveViewController, sixViewController, sevenViewController, eightViewController, ninghtViewController];
    
        NSArray *vcs  = @[oneViewController, twoViewController];
    
    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] initWithSubViewControllers:vcs];
    navTabBarController.navTabBarColor = [UIColor whiteColor];
    navTabBarController.navTabBarFont = [UIFont systemFontOfSize: 12];
    //    navTabBarController.navTabBarColor = [UIColor colorWithRed:0.5 green:0.5 blue:1 alpha:1];
    //    navTabBarController.navTabBarSelectedTextColor = [UIColor colorWithRed:0.8 green:0.5 blue:0.5 alpha:1];
    //    navTabBarController.navTabBarTextFont = [UIFont systemFontOfSize: 20 ];
    //    navTabBarController.navTabBarItemSpace = 40;
    //    navTabBarController.navTabBarHeight = 50;
//        CGRect rect = [UIScreen mainScreen].bounds;
//    navTabBarController.navTabBarItemWidth = WIDTH_SCREEN / 2.0; //rect.size.width/3;
    navTabBarController.canPopAllItemMenu = YES;
    [navTabBarController addParentController: self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)backAction:(UIBarButtonItem *)sender{
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
