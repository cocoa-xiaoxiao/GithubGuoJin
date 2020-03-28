//
//  MyStudentsViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/3/20.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MyStudentsViewController.h"
#import "RDVTabBarController.h"
#import "XHJAddressBook.h"
#import "PersonModel.h"
#import "PersonCell.h"
#import "AizenMD5.h"
#import "AizenStorage.h"
#import "AizenHttp.h"
#import "People.h"
#import "HandlePersonList.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "StudentDetailViewController.h"
#import "XOMyStuDSViewController.h"
#import "XOStuYSViewController.h"
#import "ZLNavTabBarController.h"

@interface MyStudentsViewController ()

@property(nonatomic,strong)NSMutableArray *listContent;
@property (strong, nonatomic) NSMutableArray *sectionTitles;

@property (strong, nonatomic) PersonModel *people;

@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong) XOStuYSViewController *tongguoVC;
@property (nonatomic, strong) XOMyStuDSViewController *daishenVC;
@property (nonatomic , strong) UIView * head;
@end

#define  mainWidth [UIScreen mainScreen].bounds.size.width
#define  mainHeigth  [UIScreen mainScreen].bounds.size.height


@implementation MyStudentsViewController{
    BaseTablewView *_tableShow;
    XHJAddressBook *_addBook;
}
-(void) detailLayout{
    
    XOMyStuDSViewController *daishenVC = [[XOMyStuDSViewController alloc] init];
    daishenVC.title = @"待审核";
    
    XOStuYSViewController *tongguoVC = [[XOStuYSViewController alloc] init];
    tongguoVC.title = @"已通过";
    
    ZLNavTabBarController *navTabBarController = [[ZLNavTabBarController alloc] init];
    navTabBarController.subViewControllers = @[tongguoVC,daishenVC];
    navTabBarController.navTabBarColor = [UIColor whiteColor];
    navTabBarController.mainViewBounces = YES;
    navTabBarController.selectedToIndex = 2;
    navTabBarController.unchangedToIndex = 1;
    navTabBarController.showArrayButton = NO;
    [navTabBarController addParentController:self];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
};

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self rdv_tabBarController]setTabBarHidden:YES animated:YES];
    self.title=@"我的学生";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction:)];
    [backBtnItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.hidesBackButton = YES;

    self.navigationItem.leftBarButtonItem = backBtnItem ;
    
    [self detailLayout];
    
}

-(void)backAction:(UIBarButtonItem *)sender{
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
