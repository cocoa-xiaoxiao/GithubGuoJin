//
//  ServiceViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/1/12.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "ServiceViewController.h"

@interface ServiceViewController ()

@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,strong) UIImageView *ImgView;

@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1/255.0 green:137/255.0 blue:255/255.0 alpha:1];
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]
                                initWithTitle:@"服务"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:nil];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.leftBarButtonItem setWidth:20];
    self.navigationItem.title = @"";
    
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:20.0f],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self startLayout];
}


-(void) startLayout{
//    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_TABBAR, WIDTH_SCREEN, HEIGHT_SCREEN - HEIGHT_STATUSBAR - HEIGHT_TABBAR - HEIGHT_NAVBAR)];
//    [self.view addSubview:_webView];
//
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    //应优化为异步加载
//    NSURL *url = [NSURL URLWithString:@"https://desk.v5kf.com/desk/kehu.html?site=119545&human=0&ip=14.16.215.190&location=%7B%22countries%22%3A%22%E4%B8%AD%E5%9B%BD%22%2C%22province%22%3A%22%E5%B9%BF%E4%B8%9C%22%2C%22city%22%3A%22%22%2C%22county%22%3A%22%22%7D&url=http%3A%2F%2Fhzp1123.com%2FHome"];
//    NSURLRequest* request = [NSURLRequest requestWithURL:url];
//    [_webView loadRequest:request];
    
    
    _ImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_TABBAR, WIDTH_SCREEN, HEIGHT_SCREEN - HEIGHT_STATUSBAR - HEIGHT_TABBAR - HEIGHT_NAVBAR)];
    _ImgView.image = [UIImage imageNamed:@"gj_servicebg"];
    _ImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_ImgView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
