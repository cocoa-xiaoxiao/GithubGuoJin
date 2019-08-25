//
//  MsgServiceViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/1/23.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MsgServiceViewController.h"

@interface MsgServiceViewController ()

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIWebView *webView;

@end

@implementation MsgServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"国晋服务";
    [self startLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) startLayout{
    _contentView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _contentView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_contentView];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height - HEIGHT_TABBAR)];
    [_contentView addSubview:_webView];
    
    NSURL *url = [NSURL URLWithString:@"https://desk.v5kf.com/desk/kehu.html?site=119545&human=0&ip=14.16.215.190&location=%7B%22countries%22%3A%22%E4%B8%AD%E5%9B%BD%22%2C%22province%22%3A%22%E5%B9%BF%E4%B8%9C%22%2C%22city%22%3A%22%22%2C%22county%22%3A%22%22%7D&url=http%3A%2F%2Fhzp1123.com%2FHome"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}


@end
