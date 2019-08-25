//
//  SpinnerViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/2/8.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "SpinnerViewController.h"

@interface SpinnerViewController (){
    
    CGFloat *width;
    CGFloat *height;
    
    UIView *showView;
    UIView *lineView;
    UIImageView *ImgView;
}

@property(nonatomic,strong) NSMutableDictionary *oneData;
@property(nonatomic,strong) UILabel *titleLab;

@end

@implementation SpinnerViewController

-(id) initData:(NSMutableDictionary *)data viewWidth:(CGFloat *)init_width viewHeight:(CGFloat *)init_height{
    self = [super init];
    if(self != nil){
        _oneData = data;
        width = init_width;
        height = init_height;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    showView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, *(width), *(height))];
    [self.view addSubview:showView];
    
    //    ImgView = [[UIImageView alloc]initWithFrame:CGRectMake(*(width) * 0.05, *(height) * 0.15, *(height) * 0.7, *(height) * 0.7)];
    //    ImgView.image = [UIImage imageNamed:@"gj_refresh"];
    //    [showView addSubview:ImgView];
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, *(height) * 0.1, *(width), *(height) * 0.8)];
    _titleLab.textColor = [UIColor blackColor];
    _titleLab.textColor = [UIColor blueColor];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont boldSystemFontOfSize:17];
    _titleLab.text = [_oneData objectForKey:@"Name"];
    [showView addSubview:_titleLab];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(*(width) * 0.1, *(height) - 1, *(width) * 0.8, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
    [self.view addSubview:lineView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
