//
//  MyTaskDetailViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/4/12.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MyTaskDetailViewController.h"
#import "PhoneInfo.h"

@interface MyTaskDetailViewController (){
    int *number;
    
    CGFloat *width;
    
    CGFloat *height;
    
    NSMutableDictionary *dataDic;
    
    UIView *contentView;
    
    UIView *detailView;
    
    UIImageView *imgView;
    
    

    UIImageView *tipImgView;
    
    
    UILabel *nameLab;
    UILabel *chaoqiLab;
    UILabel *shenkerenLab;
    UILabel *titleLab;
    UILabel *dateLab;
    UILabel *statusLab;
    UILabel *pinfenLab;
}

@end

@implementation MyTaskDetailViewController

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
    
    CALayer *topLayer = [CALayer layer];
    topLayer.frame = CGRectMake(0, 0, detailView.frame.size.width, 1);
    topLayer.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor;
    [detailView.layer addSublayer:topLayer];
    
    
    CALayer *bottomLayer = [CALayer layer];
    bottomLayer.frame = CGRectMake(0, detailView.frame.size.height - 1, detailView.frame.size.width, 1);
    bottomLayer.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor;
    [detailView.layer addSublayer:bottomLayer];
    
    
    [self detailLayout];
    
}



-(void) detailLayout{
    
    
//    imgView = [[UIImageView alloc]init];
//    imgView.frame = CGRectMake(detailView.frame.size.width * 0.05, detailView.frame.size.width * 0.05, detailView.frame.size.width * 0.1, detailView.frame.size.width * 0.1);
//    imgView.image = [UIImage imageNamed:@"gj_msglogo2"];
//    imgView.layer.cornerRadius = detailView.frame.size.width * 0.1 / 2;
//    imgView.layer.masksToBounds = YES;
//    [detailView addSubview:imgView];
    
    titleLab = [[UILabel alloc]init];
    titleLab.frame = CGRectMake(detailView.frame.size.width * 0.05, detailView.frame.size.width * 0.05, detailView.frame.size.width * 0.8, detailView.frame.size.height * 0.2);
    titleLab.text = [dataDic objectForKey:@"TaskTitle"];
    titleLab.font = [UIFont systemFontOfSize:16.0];
    [detailView addSubview:titleLab];
    
    
    CALayer *sepLayer = [CALayer layer];
    sepLayer.frame = CGRectMake(0, titleLab.xo_bottomY + 5 , detailView.frame.size.width, 1);
    sepLayer.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor;
    [detailView.layer addSublayer:sepLayer];
    
    
    nameLab = [[UILabel alloc]init];
    nameLab.frame = CGRectMake(titleLab.xo_x, sepLayer.frame.origin.y + detailView.frame.size.width * 0.03 , detailView.frame.size.width * 0.30, detailView.frame.size.height * 0.2);
    nameLab.attributedText =  [NSAttributedString xo_changeFontWithFont:[UIFont systemFontOfSize:12] totalStr:[NSString stringWithFormat:@"负责人：%@",[dataDic objectForKey:@"StudentName"]] andChangeStingArray:@[[dataDic objectForKey:@"StudentName"]]andColor:[UIColor blueColor]];;
    nameLab.font = [UIFont systemFontOfSize:12.0];
    [detailView addSubview:nameLab];
    
    NSRange rang = {0,10};
    NSString *DateTime = [[[[dataDic objectForKey:@"EndDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
    NSString *DateStr = [PhoneInfo timestampSwitchTime:[DateTime integerValue] andFormatter:@"yyyy-MM-dd"];
    
    NSString *currTime = [PhoneInfo getNowTimeTimestamp3];
    
    int timeCount =  ([DateTime integerValue] + (24 * 60 * 60) - 1) - [currTime integerValue] / 1000;
    
    chaoqiLab = [[UILabel alloc]init];
    chaoqiLab.frame = CGRectMake(nameLab.frame.origin.x + nameLab.xo_width, nameLab.xo_y, detailView.frame.size.width * 0.30, detailView.frame.size.height * 0.2);
    chaoqiLab.attributedText = [NSAttributedString xo_changeFontWithFont:[UIFont systemFontOfSize:12] totalStr:@"超期：否" andChangeStingArray:@[@"否"]andColor:[UIColor blueColor]];
    NSString *yuqi = [NSString stringWithFormat:@"%d天",abs(timeCount / (24 * 60 * 60) - 1)];
    if (timeCount <0) {
        chaoqiLab.attributedText = [NSAttributedString xo_changeFontWithFont:[UIFont systemFontOfSize:12] totalStr:[NSString stringWithFormat:@"超期：%@",yuqi] andChangeStingArray:@[yuqi]andColor:[UIColor redColor]];
    }
    chaoqiLab.font = [UIFont systemFontOfSize:12.0];
    [detailView addSubview:chaoqiLab];
    
    
    
    
    NSString *createDateTime = [[[[dataDic objectForKey:@"CreateDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
    NSString *createDateStr = [PhoneInfo timestampSwitchTime:[createDateTime integerValue] andFormatter:@"yyyy-MM-dd"];
    
    dateLab = [[UILabel alloc]init];
    dateLab.frame = CGRectMake(chaoqiLab.frame.origin.x + chaoqiLab.xo_width, nameLab.xo_y, detailView.frame.size.width * 0.30, detailView.frame.size.height * 0.2);
    dateLab.attributedText = [NSAttributedString xo_changeFontWithFont:[UIFont systemFontOfSize:12] totalStr:[NSString stringWithFormat:@"提交：%@",createDateStr] andChangeStingArray:@[createDateStr]andColor:[UIColor blueColor]];
    dateLab.font = [UIFont systemFontOfSize:12.0];
    [detailView addSubview:dateLab];
    
    
    NSString *checkName = [NSString checkNull:[dataDic objectForKey:@"CheckName"]];
    shenkerenLab = [[UILabel alloc]init];
    shenkerenLab.frame = CGRectMake(titleLab.xo_x, nameLab.xo_bottomY, detailView.frame.size.width * 0.30, detailView.frame.size.height * 0.2);
    shenkerenLab.attributedText = [NSAttributedString xo_changeFontWithFont:[UIFont systemFontOfSize:12] totalStr:[NSString stringWithFormat:@"审核人：%@",checkName] andChangeStingArray:@[checkName]andColor:[UIColor blueColor]];
    shenkerenLab.font = [UIFont systemFontOfSize:12.0];
    [detailView addSubview:shenkerenLab];
    
    
    
    
    
    NSString *statusStr = @"";
    UIColor *statusColor = nil;
    if([[dataDic objectForKey:@"State"] integerValue] == -1){
        statusStr = @"未提交";
        statusColor = [UIColor colorWithRed:232/255.0 green:79/255.0 blue:32/255.0 alpha:1];
    }else if([[dataDic objectForKey:@"State"] integerValue] == 0){
        statusStr = @"未审核";
        statusColor = [UIColor colorWithRed:234/255.0 green:218/255.0 blue:35/255.0 alpha:1];
        
    }else if([[dataDic objectForKey:@"State"] integerValue] == 1){
        statusStr = @"审核通过";
        statusColor = [UIColor colorWithRed:47/255.0 green:222/255.0 blue:51/255.0 alpha:1];
    }else if([[dataDic objectForKey:@"State"] integerValue] == 2){
        statusStr = @"审核不通过";
        statusColor = [UIColor colorWithRed:231/255.0 green:144/255.0 blue:41/255.0 alpha:1];
    }else if([[dataDic objectForKey:@"State"] integerValue] == 3){
        statusStr = @"反审";
        statusColor = [UIColor colorWithRed:231/255.0 green:144/255.0 blue:41/255.0 alpha:1];
    }else if([[dataDic objectForKey:@"State"] integerValue] == 4){
        statusStr = @"转审";
        statusColor = [UIColor colorWithRed:231/255.0 green:144/255.0 blue:41/255.0 alpha:1];
    }else if([[dataDic objectForKey:@"State"] integerValue] == 5){
        statusStr = @"过期";
        statusColor = [UIColor colorWithRed:231/255.0 green:144/255.0 blue:41/255.0 alpha:1];
    }
    
    
    statusLab = [[UILabel alloc]init];
    statusLab.frame = CGRectMake(shenkerenLab.frame.origin.x + shenkerenLab.xo_width, shenkerenLab.xo_y, detailView.frame.size.width * 0.30, detailView.frame.size.height * 0.2);
    statusLab.font = [UIFont systemFontOfSize:12.0];
    statusLab.attributedText = [NSAttributedString xo_changeFontWithFont:[UIFont systemFontOfSize:12] totalStr:[NSString stringWithFormat:@"状态：%@",statusStr] andChangeStingArray:@[statusStr]andColor:statusColor];
    [detailView addSubview:statusLab];
    
    NSString *score = @"无";
    if ([[dataDic objectForKey:@"State"] integerValue] > 0) {
        score = [NSString stringWithFormat:@"%@",[NSString checkNull:[dataDic objectForKey:@"FinalScore"]]];
    }
    pinfenLab = [[UILabel alloc]init];
    pinfenLab.frame = CGRectMake(statusLab.frame.origin.x + statusLab.xo_width, shenkerenLab.xo_y, detailView.frame.size.width * 0.30, detailView.frame.size.height * 0.2);
    pinfenLab.attributedText = [NSAttributedString xo_changeFontWithFont:[UIFont systemFontOfSize:12] totalStr:[NSString stringWithFormat:@"评分：%@",score] andChangeStingArray:@[score]andColor:[UIColor redColor]];
    pinfenLab.font = [UIFont systemFontOfSize:12.0];
    [detailView addSubview:pinfenLab];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
