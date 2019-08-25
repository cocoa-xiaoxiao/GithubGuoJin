//
//  LeaveStatisticsViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/8.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "LeaveStatisticsViewController.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "StatisticsModelViewController.h"

@interface LeaveStatisticsViewController ()<UISearchBarDelegate>

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UISearchBar *searchBar;

@end

@implementation LeaveStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self startLayout];
}

-(void) startLayout{
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_STATUSBAR - HEIGHT_NAVBAR - 44.0f);
    _contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, _contentView.frame.size.height * 2);
    [_contentView addSubview:_scrollView];
    
    [self searchLayout];
    
}

-(void) searchLayout{
    _searchBar = [[UISearchBar alloc]init];
    _searchBar.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height * 0.08);
    _searchBar.showsCancelButton = NO;
    _searchBar.delegate = self;
    [_scrollView addSubview:_searchBar];
    
    [self listLayout];
}



-(void) listLayout{
    CGFloat width = _contentView.frame.size.width;
    CGFloat height = _contentView.frame.size.height / 4;
    
    
    for(int i = 0;i<10;i++){
        StatisticsModelViewController *statistics = [[StatisticsModelViewController alloc]init_Value:i width:&width height:&height dataDic:[[NSMutableDictionary alloc]init] statusType:@"leave"];
        statistics.view.frame = CGRectMake(0, _searchBar.frame.size.height + i * height, width, height);
        [_scrollView addSubview:statistics.view];
    }
    
}







#pragma mark -- UISearchBarDelegate
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%@",searchBar.text);
    [self.view endEditing:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
