//
//  PersonViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/4/12.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "PersonViewController.h"

@interface PersonViewController (){
    int *number;
    
    CGFloat *width;
    
    CGFloat *height;
    
    NSMutableDictionary *dataDic;
    
    UIView *contentView;
    
    UIView *detailView;
    
    UIImageView *imgView;
    
    UILabel *nameLab;
}

@end

@implementation PersonViewController

-(id) init_Value:(int)init_number width:(CGFloat *)init_width height:(CGFloat *)init_height dataDic:(NSMutableDictionary *)init_dic{
    self  = [super init];
    if(self != nil){
        number = init_number;
        width = init_width;
        height = init_height;
        dataDic = init_dic;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    contentView = [[UIView alloc]init];
    contentView.frame = CGRectMake(0, 0, *width, *height);
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    [self startLayout];
}

-(void) startLayout{
    
    CALayer *bottomLayer = [CALayer layer];
    bottomLayer.frame = CGRectMake(contentView.frame.size.width * 0.1, contentView.frame.size.height - 1, contentView.frame.size.width, 1);
    bottomLayer.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1].CGColor;
    [contentView.layer addSublayer:bottomLayer];
    
    
    imgView = [[UIImageView alloc]init];
    imgView.frame = CGRectMake(contentView.frame.size.width * 0.05, contentView.frame.size.height * 0.15, contentView.frame.size.height * 0.7, contentView.frame.size.height * 0.7);
    imgView.image = [UIImage imageNamed:@"gj_msglogo2"];
    imgView.layer.cornerRadius = contentView.frame.size.height * 0.7 / 2;
    imgView.layer.masksToBounds = YES;
    [contentView addSubview:imgView];
    
    
    nameLab = [[UILabel alloc]init];
    nameLab.frame = CGRectMake(imgView.frame.size.width + imgView.frame.origin.x + contentView.frame.size.width * 0.05, contentView.frame.size.height * 0.2, contentView.frame.size.width * 0.5, contentView.frame.size.height * 0.6);
    nameLab.text = [dataDic objectForKey:@"UserName"];
    nameLab.textColor = [UIColor blackColor];
    nameLab.font = [UIFont systemFontOfSize:18.0];
    [contentView addSubview:nameLab];
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
