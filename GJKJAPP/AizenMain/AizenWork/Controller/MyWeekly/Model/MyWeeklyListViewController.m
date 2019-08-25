//
//  MyWeeklyListViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/4/11.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MyWeeklyListViewController.h"
#import "PhoneInfo.h"

@interface MyWeeklyListViewController (){
    int *number;
    
    CGFloat *width;
    
    CGFloat *height;
    
    NSMutableDictionary *dataDic;
    
    UIView *contentView;
    
    UIView *detailView;
    
    UIImageView *imgView;
    
    UILabel *titleLab;
    UILabel *dateLab;
    UILabel *statusLab;
    UILabel *allLab;
}

@end

@implementation MyWeeklyListViewController

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
    [self.view addSubview:contentView];
    
    [self startLayout];
}

-(void) startLayout{
    detailView = [[UIView alloc]init];
    detailView.frame = CGRectMake(0, contentView.frame.size.height * 0.1, contentView.frame.size.width, contentView.frame.size.height * 0.9);
    detailView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:detailView];
    
    CALayer *layerTop = [CALayer layer];
    layerTop.frame = CGRectMake(0, 0, detailView.frame.size.width, 1);
    layerTop.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1].CGColor;
    [detailView.layer addSublayer:layerTop];
    
    
    CALayer *layerBottom = [CALayer layer];
    layerBottom.frame = CGRectMake(0, detailView.frame.size.height - 1,detailView.frame.size.width, 1);
    layerBottom.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1].CGColor;
    [detailView.layer addSublayer:layerBottom];
    
    
//    imgView = [[UIImageView alloc]init];
//    imgView.frame = CGRectMake(detailView.frame.size.width * 0.05, detailView.frame.size.width * 0.05, detailView.frame.size.width * 0.1, detailView.frame.size.width * 0.1);
//    imgView.layer.cornerRadius = detailView.frame.size.width * 0.1 / 2;
//    imgView.layer.masksToBounds = YES;
//    imgView.image = [UIImage imageNamed:@"gj_msglogo2"];
//    [detailView addSubview:imgView];
    
    
    titleLab = [[UILabel alloc]init];
    titleLab.frame = CGRectMake(detailView.frame.size.width * 0.05, detailView.frame.size.height * 0.15, detailView.frame.size.width * 0.78, detailView.frame.size.height * 0.3);
    titleLab.text = [dataDic objectForKey:@"WeeklyTitle"];
    titleLab.font = [UIFont systemFontOfSize:16.0];
    titleLab.textColor = [UIColor blackColor];
    [detailView addSubview:titleLab];
    
    
    NSRange rang = {0,10};
    
    NSString *DateTime = [[[[dataDic objectForKey:@"CreateDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
    
    if (DateTime == nil) {
        DateTime = [[[[dataDic objectForKey:@"UpdateDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
    }
    NSString *DateStr = [PhoneInfo timestampSwitchTime:[DateTime integerValue] andFormatter:@"yyyy-MM-dd hh:mm:ss"];
    
    dateLab = [[UILabel alloc]init];
    dateLab.frame = CGRectMake(titleLab.frame.origin.x, titleLab.frame.size.height + titleLab.frame.origin.y, titleLab.frame.size.width, detailView.frame.size.height * 0.25);
    dateLab.text = [NSString stringWithFormat:@"审批时间:%@",DateStr];
    dateLab.textColor = [UIColor lightGrayColor];
    dateLab.font = [UIFont systemFontOfSize:14.0];
    [detailView addSubview:dateLab];
    
    NSString *StateStr = @"";
    UIColor *showColor = nil;
    if([[dataDic objectForKey:@"CheckState"] integerValue] == 0){
        StateStr = @"待审核";
        dateLab.text = [NSString stringWithFormat:@"提交时间:%@",DateStr];
        showColor = [UIColor colorWithRed:247/255.0 green:181/255.0 blue:94/255.0 alpha:1];
    }else if([[dataDic objectForKey:@"CheckState"] integerValue] == 1){
        StateStr = @"已通过";
        showColor = [UIColor colorWithRed:23/255.0 green:194/255.0 blue:149/255.0 alpha:1];
    }else if([[dataDic objectForKey:@"CheckState"] integerValue] == 2){
        StateStr = @"不通过";
        showColor = [UIColor colorWithRed:229/255.0 green:38/255.0 blue:38/255.0 alpha:1];
    }
    statusLab = [[UILabel alloc]init];
    statusLab.frame = CGRectMake(dateLab.frame.origin.x, dateLab.frame.size.height + dateLab.frame.origin.y, detailView.frame.size.width * 0.33, detailView.frame.size.height * 0.25);
    statusLab.textColor = showColor;
    statusLab.font = [UIFont systemFontOfSize:14.0];
    statusLab.text = StateStr;
    [detailView addSubview:statusLab];
    
    
//    allLab = [[UILabel alloc]init];
//    allLab.frame = CGRectMake(statusLab.frame.origin.x + statusLab.frame.size.width, statusLab.frame.origin.y, detailView.frame.size.width * 0.45, detailView.frame.size.height * 0.25);
//    allLab.text = @"查看全文";
//    allLab.textColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
//    allLab.font = [UIFont systemFontOfSize:14.0];
//    allLab.textAlignment = UITextAlignmentRight;
//    [detailView addSubview:allLab];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
