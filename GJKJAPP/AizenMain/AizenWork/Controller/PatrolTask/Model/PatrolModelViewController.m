//
//  PatrolModelViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/14.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "PatrolModelViewController.h"
#import "VerticalCenterTextLabel.h"

@interface PatrolModelViewController (){
    int *number;
    
    CGFloat *width;
    
    CGFloat *height;
    
    NSMutableDictionary *dataDic;
    
    UIView *contentView;
    UIView *detailView;
    NSString *statusStr;
    
    UILabel *companyLab;
    UIImageView *companyImg;
    
    UIView *middleView;
    UILabel *manLab;
    UILabel *dateLab;
    UILabel *phoneLab;
    UILabel *addressLab;
    
    UIButton *recordBtn;
    UIButton *studentBtn;
    
    
    UIImageView *manImg;
    UIImageView *phoneImg;
    UIImageView *addressImg;
}

@end

@implementation PatrolModelViewController

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
    [self startLayout];
}


-(void) startLayout{
    contentView = [[UIView alloc]init];
    contentView.frame = CGRectMake(0, 0, *width, *height);
    [self.view addSubview:contentView];
    
    detailView = [[UIView alloc]init];
    detailView.frame = CGRectMake(contentView.frame.size.width * 0.02, contentView.frame.size.height * 0.1, contentView.frame.size.width * 0.96, contentView.frame.size.height * 0.9);
    detailView.layer.cornerRadius = 5;
    detailView.backgroundColor = [UIColor whiteColor];
    detailView.layer.masksToBounds = YES;
    [contentView addSubview:detailView];
    
    [self detailLayout];
}


-(void) detailLayout{
    companyImg = [[UIImageView alloc]init];
    companyImg.frame = CGRectMake(detailView.frame.size.width * 0.03,detailView.frame.size.width * 0.02 , detailView.frame.size.width * 0.08, detailView.frame.size.width * 0.08);
    companyImg.image = [UIImage imageNamed:@"gj_patrolcompanylogo"];
    [detailView addSubview:companyImg];
    
    
    companyLab = [[UILabel alloc]init];
    companyLab.frame = CGRectMake(companyImg.frame.size.width + companyImg.frame.origin.x + detailView.frame.size.width * 0.02, companyImg.frame.origin.y, detailView.frame.size.width * 0.37, detailView.frame.size.width * 0.08);
    companyLab.text = @"顺大资产有限公司";
    companyLab.font = [UIFont systemFontOfSize:15.0];
    companyLab.textColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];
    [detailView addSubview:companyLab];
    
    
    dateLab = [[UILabel alloc]init];
    dateLab.frame = CGRectMake(companyLab.frame.size.width + companyLab.frame.origin.x, companyLab.frame.origin.y, detailView.frame.size.width * 0.47, detailView.frame.size.width * 0.08);
    dateLab.textColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];
    dateLab.text = @"2018-05-14";
    dateLab.font = [UIFont systemFontOfSize:15.0];
    dateLab.textAlignment = UITextAlignmentRight;
    [detailView addSubview:dateLab];
    
    recordBtn = [[UIButton alloc]init];
    recordBtn.frame = CGRectMake(0, detailView.frame.size.height - detailView.frame.size.height * 0.28, detailView.frame.size.width * 0.5, detailView.frame.size.height * 0.28);
    [recordBtn setTitle:@"检查记录" forState:UIControlStateNormal];
    [recordBtn setTitleColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1] forState:UIControlStateNormal];
    recordBtn.font = [UIFont systemFontOfSize:16.0];
    [detailView addSubview:recordBtn];
    
    
    studentBtn = [[UIButton alloc]init];
    studentBtn.frame = CGRectMake(recordBtn.frame.size.width + recordBtn.frame.origin.x, recordBtn.frame.origin.y, detailView.frame.size.width * 0.5, detailView.frame.size.height * 0.28);
    [studentBtn setTitleColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1] forState:UIControlStateNormal];
    [studentBtn setTitle:@"学生名单" forState:UIControlStateNormal];
    studentBtn.font = [UIFont systemFontOfSize:16.0];
    [detailView addSubview:studentBtn];
    
    
    CALayer *topLayer = [[CALayer alloc]init];
    topLayer.frame = CGRectMake(0, 0, recordBtn.frame.size.width, 1);
    topLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [recordBtn.layer addSublayer:topLayer];
    
    CALayer *topLayer1 = [[CALayer alloc]init];
    topLayer1.frame = CGRectMake(0, 0, recordBtn.frame.size.width, 1);
    topLayer1.backgroundColor = [UIColor lightGrayColor].CGColor;
    [studentBtn.layer addSublayer:topLayer1];
    
    
    CALayer *lineLayer = [[CALayer alloc]init];
    lineLayer.frame = CGRectMake(recordBtn.frame.size.width, 0, 1, recordBtn.frame.size.height);
    lineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [recordBtn.layer addSublayer:lineLayer];
    
    
    middleView = [[UIView alloc]init];
    middleView.frame = CGRectMake(detailView.frame.size.width * 0.05, companyImg.frame.size.height + companyImg.frame.origin.y, detailView.frame.size.width * 0.9, detailView.frame.size.height * 0.4);
    [detailView addSubview:middleView];
    
    manImg = [[UIImageView alloc]init];
    manImg.frame = CGRectMake(0, 0, middleView.frame.size.height * 0.4, middleView.frame.size.height * 0.4);
    manImg.image = [UIImage imageNamed:@"gj_patrolqunzu"];
    [middleView addSubview:manImg];
    
    manLab = [[UILabel alloc]init];
    manLab.frame = CGRectMake(manImg.frame.origin.x + manImg.frame.size.width + middleView.frame.size.width * 0.02, 0, middleView.frame.size.width * 0.3, manImg.frame.size.height);
    manLab.text = @"杨小小";
    manLab.textColor = [UIColor blackColor];
    manLab.font = [UIFont systemFontOfSize:14.0];
    [middleView addSubview:manLab];
    
    phoneImg = [[UIImageView alloc]init];
    phoneImg.frame = CGRectMake(middleView.frame.size.width * 0.65, 0, middleView.frame.size.height * 0.4, middleView.frame.size.height * 0.4);
    phoneImg.image = [UIImage imageNamed:@"gj_patrolphone"];
    [middleView addSubview:phoneImg];
    
    phoneLab = [[UILabel alloc]init];
    phoneLab.frame = CGRectMake(phoneImg.frame.size.width + phoneImg.frame.origin.x + middleView.frame.size.width * 0.02, 0, middleView.frame.size.width * 0.3, middleView.frame.size.height * 0.4);
    phoneLab.font = [UIFont systemFontOfSize:14.0];
    phoneLab.text = @"13078441893";
    [middleView addSubview:phoneLab];
    
    
    
    addressImg = [[UIImageView alloc]init];
    addressImg.frame = CGRectMake(0, middleView.frame.size.height - middleView.frame.size.height * 0.4, middleView.frame.size.height * 0.4, middleView.frame.size.height * 0.4);
    addressImg.image = [UIImage imageNamed:@"gj_patrollocation"];
    [middleView addSubview:addressImg];
    
    
    addressLab = [[UILabel alloc]init];
    addressLab.frame = CGRectMake(addressImg.frame.size.width + addressImg.frame.origin.x + middleView.frame.size.width * 0.02, addressImg.frame.origin.y, middleView.frame.size.width * 0.8, addressImg.frame.size.height);
    addressLab.textColor = [UIColor blackColor];
    addressLab.text = @"广东省佛山市顺德区大良街道德胜东路顺德职业技术学院";
    addressLab.font = [UIFont systemFontOfSize:14.0];
    [middleView addSubview:addressLab];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
