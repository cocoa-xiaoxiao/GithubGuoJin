//
//  MyLeaveRecordDetailViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/3/30.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MyLeaveRecordDetailViewController.h"
#import "PhoneInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MyLeaveRecordDetailViewController (){
    int *number;
    
    CGFloat *width;
    
    CGFloat *height;
    
    NSMutableDictionary *dataDic;
    
    UIView *contentView;
    
    UIView *detailView;
    
    UIImageView *imgView;
    
    UILabel *titleLab;
    UILabel *typeLab;
    UILabel *startLab;
    UILabel *endLab;
    UILabel *dateLab;
    UILabel *stateLab;
    
}

@end

@implementation MyLeaveRecordDetailViewController


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
    
    imgView = [[UIImageView alloc]init];
    imgView.frame = CGRectMake(detailView.frame.size.width * 0.05, detailView.frame.size.width * 0.05, detailView.frame.size.width * 0.1, detailView.frame.size.width * 0.1);
    NSString *FactUrl = [dataDic objectForKey:@"FactUrl"];
    if ([FactUrl isKindOfClass:[NSNull class]]) {
        FactUrl = @"";
    }
    if (FactUrl == nil) {
        FactUrl = @"";
    }
    NSURL *url = [NSURL URLWithString:FactUrl.fullImg];
    [imgView sd_setImageWithURL:url placeholderImage:kUserDefualtImage];
//    imgView.image = [UIImage imageNamed:@"gj_msglogo2"];
    imgView.layer.cornerRadius = detailView.frame.size.width * 0.05;
    imgView.layer.masksToBounds = YES;
    [detailView addSubview:imgView];
    //FactUrl
    
    
    
    titleLab = [[UILabel alloc]init];
    titleLab.frame = CGRectMake(imgView.frame.size.width + imgView.frame.origin.x + detailView.frame.size.width * 0.05, imgView.frame.origin.y, detailView.frame.size.width * 0.45, detailView.frame.size.height * 0.1);
    titleLab.text = [NSString stringWithFormat:@"%@的请假",[dataDic objectForKey:@"UserName"]];
    titleLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    titleLab.font = [UIFont systemFontOfSize:18.0];
    [detailView addSubview:titleLab];
    
    
    typeLab = [[UILabel alloc]init];
    typeLab.frame = CGRectMake(titleLab.frame.origin.x, titleLab.frame.origin.y + titleLab.frame.size.height + detailView.frame.size.width * 0.05, detailView.frame.size.width * 0.5, detailView.frame.size.height * 0.12);
    typeLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    typeLab.text = [NSString stringWithFormat:@"请假类型：%@",[[dataDic objectForKey:@"LeaveType"] objectForKey:@"DictionaryName"]];
    typeLab.font = [UIFont systemFontOfSize:14.0];
    [detailView addSubview:typeLab];
    
    
    NSRange rang = {0,10};
    NSString *starttimeStr = [[[[dataDic objectForKey:@"BeginDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
    
    NSString *endtimeStr = [[[[dataDic objectForKey:@"EndDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
    
    startLab = [[UILabel alloc]init];
    startLab.frame = CGRectMake(typeLab.frame.origin.x, typeLab.frame.size.height + typeLab.frame.origin.y, detailView.frame.size.width * 0.8, detailView.frame.size.height * 0.12);
    
//    startLab.text = [NSString stringWithFormat:@"开始时间：%@",[PhoneInfo timestampSwitchTime:[starttimeStr integerValue]  andFormatter:@"YYYY-MM-dd HH:mm:ss"]];
    startLab.text = [NSString stringWithFormat:@"开始时间：%@",[PhoneInfo timestampSwitchTime:[starttimeStr integerValue]  andFormatter:@"YYYY-MM-dd"]];

    startLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    startLab.font = [UIFont systemFontOfSize:14.0];
    [detailView addSubview:startLab];
    
    
    endLab = [[UILabel alloc]init];
    endLab.frame = CGRectMake(startLab.frame.origin.x, startLab.frame.origin.y + startLab.frame.size.height, detailView.frame.size.width * 0.8, detailView.frame.size.height * 0.12);
//    endLab.text = [NSString stringWithFormat:@"结束时间：%@",[PhoneInfo timestampSwitchTime:[endtimeStr integerValue]  andFormatter:@"YYYY-MM-dd HH:mm:ss"]];
    endLab.text = [NSString stringWithFormat:@"结束时间：%@",[PhoneInfo timestampSwitchTime:[endtimeStr integerValue]  andFormatter:@"YYYY-MM-dd"]];

    endLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    endLab.font = [UIFont systemFontOfSize:14.0];
    [detailView addSubview:endLab];
    
    NSString *stateStr = @"";
    UIColor *stateColor = nil;
    if([[dataDic objectForKey:@"State"] intValue] == 0){
        stateStr = @"待审批";
        stateColor = [UIColor colorWithRed:235/255.0 green:178/255.0 blue:102/255.0 alpha:1];
    }else if([[dataDic objectForKey:@"State"] intValue] == 1){
        stateStr = @"审批通过";
        stateColor = [UIColor colorWithRed:23/255.0 green:194/255.0 blue:149/255.0 alpha:1];
    }else if([[dataDic objectForKey:@"State"] intValue] == 2){
        stateStr = @"审批拒绝";
        stateColor = [UIColor colorWithRed:244/255.0 green:143/255.0 blue:127/255.0 alpha:1];
    }
    
    stateLab = [[UILabel alloc]init];
    stateLab.frame = CGRectMake(endLab.frame.origin.x, detailView.frame.size.height - detailView.frame.size.width * 0.05 - detailView.frame.size.height * 0.1, detailView.frame.size.width * 0.8, detailView.frame.size.height * 0.1);
    stateLab.font = [UIFont systemFontOfSize:14.0];
    stateLab.text = stateStr;
    stateLab.textColor = stateColor;
    [detailView addSubview:stateLab];
    
    //CheckDate
//    NSString *datetimeStr = [[[[dataDic objectForKey:@"LeaveType"] objectForKey:@"CreateDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""];
    NSString *datetimeStr = [[[dataDic objectForKey:@"CheckDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""];

    NSInteger datetime_ = datetimeStr.integerValue / 1000;
    
    dateLab = [[UILabel alloc]init];
    dateLab.frame = CGRectMake(titleLab.frame.origin.x + titleLab.frame.size.width, titleLab.frame.origin.y, detailView.frame.size.width * 0.3, detailView.frame.size.height * 0.1);
    dateLab.font = [UIFont systemFontOfSize:14.0];
    dateLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    dateLab.textAlignment = UITextAlignmentRight;
    dateLab.text = [PhoneInfo timestampSwitchTime:datetime_  andFormatter:@"YYYY-MM-dd"];
    [detailView addSubview:dateLab];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
