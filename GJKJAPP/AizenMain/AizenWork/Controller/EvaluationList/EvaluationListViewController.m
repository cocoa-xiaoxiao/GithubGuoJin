//
//  EvaluationListViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/6/13.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "EvaluationListViewController.h"
#import "RDVTabBarController.h"
#import "DGActivityIndicatorView.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "People.h"

@interface EvaluationListViewController ()<UIWebViewDelegate>

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIWebView *webView;

@end

@implementation EvaluationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的评价任务";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction:)];
    [backBtnItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = backBtnItem ;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [self startLayout];
}


-(void) startLayout{
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, self.view.frame.size.width, self.view.frame.size.height - (HEIGHT_NAVBAR + HEIGHT_STATUSBAR));
    _contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contentView];
    
    
    
    _webView = [[UIWebView alloc]init];
    _webView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    _webView.delegate = self;
    [_contentView addSubview:_webView];
    
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    
    NSString *handleUrl = [NSString stringWithFormat:@"http://bobby.jt-makeup.com/index.php/Home/Index?AdminID=%@",CurrAdminID];
    NSURL *webUrl = [NSURL URLWithString:handleUrl];
    NSURLRequest *webRequest = [NSURLRequest requestWithURL:webUrl];
    [_webView loadRequest:webRequest];
    
    
    int x = arc4random() % 10;
    NSLog(@"弹出：%d",x);
    if(x = 0){
        /*弹出推广*/
        NSString * urlStr = [NSString stringWithFormat:@"http://%@",@"www.bmwdream.cn"];
        NSURL *url = [NSURL URLWithString:urlStr];
        if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                [[UIApplication sharedApplication] openURL:url options:@{}
                                         completionHandler:^(BOOL success) {
                                             NSLog(@"Open %d",success);
                                         }];
            } else {
                BOOL success = [[UIApplication sharedApplication] openURL:url];
                NSLog(@"Open  %d",success);
            }
            
        } else{
            bool can = [[UIApplication sharedApplication] canOpenURL:url];
            if(can){
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
    
    
    
}



-(void)backAction:(UIBarButtonItem *)sender{
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
