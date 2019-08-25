//
//  HaveStationListViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/4/21.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "HaveStationListViewController.h"
#import "PhoneInfo.h"

@interface HaveStationListViewController (){
    int *number;
    
    CGFloat *width;
    
    CGFloat *height;
    
    NSMutableDictionary *dataDic;
    
    UIView *contentView;
    
    UIView *detailView;
    
    UIImageView *imgView;
    
    UILabel *titleLab;
    UILabel *companyLab;
    UILabel *dateLab;
    UILabel *stationLab;
    UILabel *teacherLab;
    UILabel *emailLab;
    UILabel *phoneLab;
    UILabel *statusLab;
    
}


@end

@implementation HaveStationListViewController

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
    //    imgView.frame = CGRectMake(detailView.frame.size.width * 0.05, detailView.frame.size.width * 0.05, detailView.frame.size.height * 0.3, detailView.frame.size.height * 0.3);
    //    imgView.layer.cornerRadius = detailView.frame.size.height * 0.3 / 2;
    //    imgView.layer.masksToBounds = YES;
    //    imgView.image = [UIImage imageNamed:@"gj_msglogo2"];
    //    [detailView addSubview:imgView];
    
    NSString *titleStr = [NSString stringWithFormat:@"%@-%@",[dataDic objectForKey:@"UserName"],[dataDic objectForKey:@"PositionName"]];
    titleLab = [[UILabel alloc]init];
    titleLab.frame = CGRectMake(detailView.frame.size.width * 0.05, 0, detailView.frame.size.width * 0.5, detailView.frame.size.height * 0.25);
    titleLab.text = titleStr;
    titleLab.font = [UIFont systemFontOfSize:16.0];
    titleLab.textColor = [UIColor blackColor];
    [detailView addSubview:titleLab];
    
    NSRange rang = {0,10};
    NSString *StartTime = [[[[dataDic objectForKey:@"CreateDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
    dateLab = [[UILabel alloc]init];
    dateLab.frame = CGRectMake(titleLab.xo_width, 0, detailView.frame.size.width * 0.47, detailView.frame.size.height * 0.25);
    dateLab.text = [NSString stringWithFormat:@"%@",[PhoneInfo timestampSwitchTime:[StartTime integerValue] andFormatter:@"YYYY-MM-dd HH:mm:ss"]];
    dateLab.textColor = [UIColor lightGrayColor];
    dateLab.font = [UIFont systemFontOfSize:14.0];
    dateLab.textAlignment = NSTextAlignmentRight;
    [detailView addSubview:dateLab];
    
    CALayer *titleBottom = [CALayer layer];
    titleBottom.frame = CGRectMake(0, titleLab.xo_bottomY - 1 , detailView.frame.size.width, 1);
    titleBottom.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1].CGColor;
    [detailView.layer addSublayer:titleBottom];
    
    companyLab = [[UILabel alloc]init];
    companyLab.frame = CGRectMake(titleLab.frame.origin.x, titleLab.xo_bottomY , detailView.frame.size.width * 0.74, detailView.frame.size.height * 0.15);
    companyLab.text = [NSString stringWithFormat:@"企业名称:%@",[dataDic objectForKey:@"EnterpriseName"]];
    companyLab.textColor = [UIColor lightGrayColor];
    companyLab.font = [UIFont systemFontOfSize:14.0];
    [detailView addSubview:companyLab];
    
    NSString *comeTime = [dataDic objectForKey:@"ComeWorkDate"];
    if (comeTime.length > 0) {
        comeTime = [[[[dataDic objectForKey:@"ComeWorkDate"]stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
    }
    stationLab = [[UILabel alloc]init];
    stationLab.frame = CGRectMake(titleLab.frame.origin.x, companyLab.xo_bottomY , detailView.frame.size.width * 0.65, detailView.frame.size.height * 0.15);
    stationLab.text = [NSString stringWithFormat:@"到岗日期:%@",[PhoneInfo timestampSwitchTime:[comeTime integerValue] andFormatter:@"YYYY-MM-dd HH:mm:ss"]];
    stationLab.textColor = [UIColor lightGrayColor];
    stationLab.font = [UIFont systemFontOfSize:14.0];
    [detailView addSubview:stationLab];
    
    
    teacherLab = [[UILabel alloc]init];
    teacherLab.frame = CGRectMake(titleLab.frame.origin.x, stationLab.xo_bottomY , detailView.frame.size.width * 0.5, detailView.frame.size.height * 0.15);
    teacherLab.text = [NSString stringWithFormat:@"企业师傅:%@",[dataDic objectForKey:@"LinkManName"]];
    teacherLab.textColor = [UIColor lightGrayColor];
    teacherLab.font = [UIFont systemFontOfSize:14.0];
    [detailView addSubview:teacherLab];
    
    
    phoneLab = [[UILabel alloc]init];
    phoneLab.frame = CGRectMake(titleLab.frame.origin.x, teacherLab.xo_bottomY , detailView.frame.size.width * 0.5, detailView.frame.size.height * 0.15);
    phoneLab.text = [NSString stringWithFormat:@"师傅电话:%@",[dataDic objectForKey:@"LinkManMobile"]];
    phoneLab.textColor = [UIColor lightGrayColor];
    phoneLab.font = [UIFont systemFontOfSize:14.0];
    [detailView addSubview:phoneLab];
    
    emailLab = [[UILabel alloc]init];
    emailLab.frame = CGRectMake(titleLab.frame.origin.x, phoneLab.xo_bottomY , detailView.frame.size.width * 0.5, detailView.frame.size.height * 0.15);
    emailLab.text = [NSString stringWithFormat:@"师傅邮箱:%@",[dataDic objectForKey:@"LinkManEmail"]];
    emailLab.textColor = [UIColor lightGrayColor];
    emailLab.font = [UIFont systemFontOfSize:14.0];
    [detailView addSubview:emailLab];
    
    
    
    
    NSString *stateStr = @"";
    UIColor *stateColor = nil;
    if([[[dataDic objectForKey:@"CheckState"] stringValue] isEqualToString:@"0"]){
        stateStr = @"未审核";
        stateColor = [UIColor colorWithRed:225/255.0 green:205/255.0 blue:33/255.0 alpha:1];
    }else if([[[dataDic objectForKey:@"CheckState"] stringValue] isEqualToString:@"1"]){
        stateStr = @"通过";
        stateColor = [UIColor colorWithRed:33/255.0 green:225/255.0 blue:101/255.0 alpha:1];
    }else if([[[dataDic objectForKey:@"CheckState"] stringValue] isEqualToString:@"2"]){
        stateStr = @"不通过";
        stateColor = [UIColor colorWithRed:225/255.0 green:60/255.0 blue:33/255.0 alpha:1];
    }else if([[[dataDic objectForKey:@"CheckState"] stringValue] isEqualToString:@"5"]){
        stateStr = @"已过期";
        stateColor = [UIColor colorWithRed:225/255.0 green:60/255.0 blue:33/255.0 alpha:1];
    }
    
    statusLab = [[UILabel alloc]init];
    statusLab.frame = CGRectMake(teacherLab.xo_width, detailView.xo_height*0.55, detailView.frame.size.width * 0.47, detailView.frame.size.height * 0.2);
    statusLab.text = stateStr;
    statusLab.textColor = stateColor;
    statusLab.font = [UIFont systemFontOfSize:15.0];
    statusLab.textAlignment = NSTextAlignmentRight;
    [detailView addSubview:statusLab];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
