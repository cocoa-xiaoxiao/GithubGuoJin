//
//  StatisticsModelViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/8.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "StatisticsModelViewController.h"

@interface StatisticsModelViewController (){
    int *number;
    
    CGFloat *width;
    
    CGFloat *height;
    
    NSMutableDictionary *dataDic;
    
    UIView *contentView;
    
    UIImageView *imgView;
    
    NSString *statusStr;
    
    UILabel *nameLab;
    UILabel *leaveLab;
    UILabel *auditingLab;
    UILabel *manLab;
    UIButton *statusBtn;
    UILabel *addressLab;
}

@end

@implementation StatisticsModelViewController

-(id) init_Value:(int)init_number width:(CGFloat *)init_width height:(CGFloat *)init_height dataDic:(NSMutableDictionary *)init_dic statusType:(NSString *)init_status{
    self  = [super init];
    if(self != nil){
        number = init_number;
        width = init_width;
        height = init_height;
        dataDic = init_dic;
        statusStr = init_status;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    contentView = [[UIView alloc]init];
    contentView.frame = CGRectMake(0, *height * 0.15, *width, *height * 0.85);
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    CALayer *topLine = [[CALayer alloc]init];
    topLine.frame = CGRectMake(0, 0, contentView.frame.size.width, 1);
    topLine.backgroundColor = [UIColor lightGrayColor].CGColor;
    [contentView.layer addSublayer:topLine];
    
    
    CALayer *bottomLine = [[CALayer alloc]init];
    bottomLine.frame = CGRectMake(0, contentView.frame.size.height - 1, contentView.frame.size.width, 1);
    bottomLine.backgroundColor = [UIColor lightGrayColor].CGColor;
    [contentView.layer addSublayer:bottomLine];
    
    
    [self startLayout];
}


-(void) startLayout{
    imgView = [[UIImageView alloc]init];
    imgView.frame = CGRectMake(contentView.frame.size.width * 0.05, contentView.frame.size.width * 0.05, contentView.frame.size.width * 0.1, contentView.frame.size.width * 0.1);
    imgView.image = [UIImage imageNamed:@"gj_statisticsman"];
    [contentView addSubview:imgView];
    
    
    nameLab = [[UILabel alloc]init];
    nameLab.frame = CGRectMake(imgView.frame.size.width + imgView.frame.origin.x + contentView.frame.size.width * 0.03, contentView.frame.size.width * 0.05, contentView.frame.size.width * 0.3, contentView.frame.size.width * 0.05);
    nameLab.text = @"张小三";
    nameLab.textColor = [UIColor blackColor];
    nameLab.font = [UIFont systemFontOfSize:14.0];
    [contentView addSubview:nameLab];
    
    leaveLab = [[UILabel alloc]init];
    leaveLab.frame = CGRectMake(nameLab.frame.origin.x, nameLab.frame.size.height + nameLab.frame.origin.y, contentView.frame.size.width * 0.3, contentView.frame.size.width * 0.05);
    leaveLab.textColor = [UIColor lightGrayColor];
    if([statusStr isEqualToString:@"leave"]){
        leaveLab.text = @"请假天数:10";
    }else if([statusStr isEqualToString:@"duty"]){
        leaveLab.text = @"连续缺勤:10";
    }else if([statusStr isEqualToString:@"normal"]){
        leaveLab.text = @"连续考勤:10";
    }
    leaveLab.font = [UIFont systemFontOfSize:13.0];
    [contentView addSubview:leaveLab];
    
    
    auditingLab = [[UILabel alloc]init];
    auditingLab.frame = CGRectMake(imgView.frame.origin.x, contentView.frame.size.height - contentView.frame.size.height * 0.3, contentView.frame.size.width * 0.55, contentView.frame.size.height * 0.2);
    auditingLab.textColor = [UIColor lightGrayColor];
    if([statusStr isEqualToString:@"leave"]){
        auditingLab.text = @"审核:2018-03-08";
    }else if([statusStr isEqualToString:@"duty"]){
        auditingLab.text = @"最近打卡:2018-03-08";
    }else if([statusStr isEqualToString:@"normal"]){
        auditingLab.text = @"打卡时间:2018-03-08 07:30";
    }
    auditingLab.font = [UIFont systemFontOfSize:14.0];
    [contentView addSubview:auditingLab];
    
    manLab = [[UILabel alloc]init];
    manLab.frame = CGRectMake(contentView.frame.size.width * 0.6, auditingLab.frame.origin.y, contentView.frame.size.width * 0.35, auditingLab.frame.size.height);
    if([statusStr isEqualToString:@"leave"]){
        manLab.text = @"审核人:谭老师";
    }else if([statusStr isEqualToString:@"duty"]){
        manLab.text = @"指导老师:谭老师";
    }else if([statusStr isEqualToString:@"normal"]){
        manLab.text = @"指导老师:谭老师";
    }
    manLab.textAlignment = UITextAlignmentRight;
    manLab.textColor = [UIColor lightGrayColor];
    manLab.font = [UIFont systemFontOfSize:14.0];
    [contentView addSubview:manLab];
    
    
    
    statusBtn = [[UIButton alloc]init];
    statusBtn.frame = CGRectMake(contentView.frame.size.width - contentView.frame.size.width * 0.2 - contentView.frame.size.width * 0.05, nameLab.frame.origin.y, contentView.frame.size.width * 0.2, contentView.frame.size.height * 0.25);
    statusBtn.layer.cornerRadius = 5;
    statusBtn.layer.masksToBounds = YES;
    [contentView addSubview:statusBtn];
    
    
    
    if([statusStr isEqualToString:@"leave"]){
        /*判断状态*/
        if((int)number%2 == 0){
            [statusBtn setTitle:@"不通过" forState:UIControlStateNormal];
            statusBtn.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
            statusBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            statusBtn.layer.borderWidth = 1;
        }else{
            [statusBtn setTitle:@"通过" forState:UIControlStateNormal];
            statusBtn.backgroundColor = [UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1];
        }
    }else if([statusStr isEqualToString:@"duty"]){
        /*判断状态*/
        if((int)number%2 == 0){
            [statusBtn setTitle:@"已提醒" forState:UIControlStateNormal];
            statusBtn.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
            statusBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            statusBtn.layer.borderWidth = 1;
        }else{
            [statusBtn setTitle:@"提醒" forState:UIControlStateNormal];
            statusBtn.backgroundColor = [UIColor colorWithRed:50/255.0 green:205/255.0 blue:50/255.0 alpha:1];
        }
    }else if([statusStr isEqualToString:@"normal"]){
        /*判断状态*/
        if((int)number%2 == 0){
            [statusBtn setTitle:@"已点赞" forState:UIControlStateNormal];
            statusBtn.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
            statusBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            statusBtn.layer.borderWidth = 1;
        }else{
            [statusBtn setTitle:@"点赞" forState:UIControlStateNormal];
            statusBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:69/255.0 blue:0/255.0 alpha:1];
        }
    }
    
    
    if([statusStr isEqualToString:@"normal"]){
        addressLab = [[UILabel alloc]init];
        addressLab.frame = CGRectMake(contentView.frame.size.width * 0.05, auditingLab.frame.origin.y - contentView.frame.size.height * 0.2, contentView.frame.size.width * 0.9, contentView.frame.size.height * 0.2);
        addressLab.text = @"最近打卡:广东省佛山市顺德区德胜东路";
        addressLab.textColor = [UIColor lightGrayColor];
        addressLab.font = [UIFont systemFontOfSize:14.0];
        [contentView addSubview:addressLab];
    }
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
