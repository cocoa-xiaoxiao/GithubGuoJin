//
//  PatrolModelXViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/6/5.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "PatrolModelXViewController.h"
#import "PhoneInfo.h"
#import "PatrolObjViewController.h"
#import "PatrolStudentListViewController.h"
@interface PatrolModelXViewController (){
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
    UILabel *reportLab;
    
    UIButton *recordBtn;
    UIButton *lookRecordBtn;
    UIButton *studentBtn;
    
    
    UIImageView *manImg;
    UIImageView *phoneImg;
    UIImageView *addressImg;
    
    
    
}


@end

@implementation PatrolModelXViewController

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
    self.view.userInteractionEnabled = YES;
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
    companyImg.image = [UIImage imageNamed:@"gj_patrolcompany"];
    [detailView addSubview:companyImg];
    
    
    companyLab = [[UILabel alloc]init];
    companyLab.frame = CGRectMake(companyImg.frame.size.width + companyImg.frame.origin.x + detailView.frame.size.width * 0.02, companyImg.frame.origin.y, detailView.frame.size.width * 0.5, detailView.frame.size.width * 0.08);
    companyLab.text = [dataDic objectForKey:@"EnterpriseName"];
    companyLab.font = [UIFont systemFontOfSize:15.0];
    companyLab.textColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];
    [detailView addSubview:companyLab];
    
    
    dateLab = [[UILabel alloc]init];
    dateLab.frame = CGRectMake(companyLab.frame.size.width + companyLab.frame.origin.x, companyLab.frame.origin.y, detailView.frame.size.width * 0.47, detailView.frame.size.width * 0.08);
    dateLab.textColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];
    NSString *dateStr = [PhoneInfo handleDateStr:[dataDic objectForKey:@"EndDate"] handleFormat:@"yyyy-MM-dd"];
    dateLab.text = [NSString stringWithFormat:@"限期:%@",dateStr];
    dateLab.font = [UIFont systemFontOfSize:15.0];
    dateLab.textAlignment = UITextAlignmentRight;
    [detailView addSubview:dateLab];
    [dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.centerY.equalTo(companyLab);
    }];

    recordBtn = [[UIButton alloc]init];
    recordBtn.frame = CGRectMake(0, detailView.frame.size.height - detailView.frame.size.height * 0.28, detailView.frame.size.width / 3, detailView.frame.size.height * 0.28);
    [recordBtn setTitle:@"提交报告" forState:UIControlStateNormal];
    [recordBtn setTitleColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1] forState:UIControlStateNormal];
    recordBtn.font = [UIFont systemFontOfSize:16.0];
    [detailView addSubview:recordBtn];
//    recordBtn.hidden = YES;
    
    lookRecordBtn = [[UIButton alloc]init];
    lookRecordBtn.frame = CGRectMake(detailView.frame.size.width / 3, detailView.frame.size.height - detailView.frame.size.height * 0.28, detailView.frame.size.width / 3, detailView.frame.size.height * 0.28);
    [lookRecordBtn setTitle:@"查看报告" forState:UIControlStateNormal];
    [lookRecordBtn setTitleColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1] forState:UIControlStateNormal];
    lookRecordBtn.font = [UIFont systemFontOfSize:16.0];
    [detailView addSubview:lookRecordBtn];
//    lookRecordBtn.hidden = YES;
    
    studentBtn = [[UIButton alloc]init];
    studentBtn.frame = CGRectMake(lookRecordBtn.frame.size.width + lookRecordBtn.frame.origin.x, lookRecordBtn.frame.origin.y, detailView.frame.size.width / 3, detailView.frame.size.height * 0.28);
    [studentBtn setTitleColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1] forState:UIControlStateNormal];
    [studentBtn setTitle:@"学生名单" forState:UIControlStateNormal];
    studentBtn.font = [UIFont systemFontOfSize:16.0];
    [detailView addSubview:studentBtn];
  //  [studentBtn addTarget:self action:@selector(br_toStudent:) forControlEvents:UIControlEventTouchUpInside];
    studentBtn.accessibilityLabel = (id)dataDic;
    
//    CALayer *topLayer = [[CALayer alloc]init];
//    topLayer.frame = CGRectMake(0, 0, recordBtn.frame.size.width, 1);
//    topLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
//    [recordBtn.layer addSublayer:topLayer];
//
//    CALayer *topLayer1 = [[CALayer alloc]init];
//    topLayer1.frame = CGRectMake(0, 0, detailView.frame.size.width, 1);
//    topLayer1.backgroundColor = [UIColor lightGrayColor].CGColor;
//    [studentBtn.layer addSublayer:topLayer1];
//
//    CALayer *topLayer2 = [[CALayer alloc]init];
//    topLayer2.frame = CGRectMake(0, 0, lookRecordBtn.frame.size.width, 1);
//    topLayer2.backgroundColor = [UIColor lightGrayColor].CGColor;
//    [lookRecordBtn.layer addSublayer:topLayer2];
//
//
//    CALayer *lineLayer = [[CALayer alloc]init];
//    lineLayer.frame = CGRectMake(recordBtn.frame.size.width, 0, 1, recordBtn.frame.size.height);
//    lineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
//    [recordBtn.layer addSublayer:lineLayer];
    
    
//    CALayer *lineLayer1 = [[CALayer alloc]init];
//    lineLayer1.frame = CGRectMake(0, 0, 1, studentBtn.frame.size.height);
//    lineLayer1.backgroundColor = [UIColor lightGrayColor].CGColor;
//    [studentBtn.layer addSublayer:lineLayer1];
    
    
    UILabel *line = [UILabel new];
    line.backgroundColor = [UIColor lightGrayColor];
    [detailView addSubview:line];
    line.frame = CGRectMake(0, (studentBtn.frame.origin.y), detailView.frame.size.width, 1);
    
    [recordBtn addTarget:[PatrolObjViewController class] action:@selector(recordAction:) forControlEvents:UIControlEventTouchUpInside];
    recordBtn.accessibilityElements = dataDic;
    
    [lookRecordBtn addTarget:[PatrolObjViewController class] action:@selector(lookRecordAction:) forControlEvents:UIControlEventTouchUpInside];
    lookRecordBtn.accessibilityElements = dataDic;
    
    [studentBtn addTarget:[PatrolObjViewController class] action:@selector(studentAction:) forControlEvents:UIControlEventTouchUpInside];
    studentBtn.accessibilityElements = dataDic;
//    [studentBtn addTarget:self action:@selector(br_toStudent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    middleView = [[UIView alloc]init];
    middleView.frame = CGRectMake(companyLab.frame.origin.x, companyImg.frame.size.height + companyImg.frame.origin.y, detailView.frame.size.width * 0.9, detailView.frame.size.height * 0.4);
    [detailView addSubview:middleView];
    
    
    manLab = [[UILabel alloc]init];
    manLab.frame = CGRectMake(0, middleView.frame.size.height * 0.1, middleView.frame.size.width * 0.5, middleView.frame.size.height * 0.4);
    manLab.text = [NSString stringWithFormat:@"学生人数:%@",[dataDic objectForKey:@"studentTotal"]];
    manLab.font = [UIFont systemFontOfSize:14.0];
    [middleView addSubview:manLab];
    
    reportLab = [[UILabel alloc]init];
    reportLab.frame = CGRectMake(middleView.frame.size.width * 0.5, manLab.frame.origin.y, middleView.frame.size.width * 0.5, middleView.frame.size.height * 0.4);
    NSString *reportStr = [NSString stringWithFormat:@"报告数量:%@",[dataDic objectForKey:@"reportTotal"]];
    reportLab.text = reportStr;
    reportLab.textAlignment = UITextAlignmentRight;
    reportLab.font = [UIFont systemFontOfSize:14.0];
    [middleView addSubview:reportLab];
    [reportLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(dateLab);
        make.centerY.equalTo(manLab);
    }];
    
//    addressImg = [[UIImageView alloc]init];
//    addressImg.frame = CGRectMake(0, middleView.frame.size.height - middleView.frame.size.height * 0.4, middleView.frame.size.height * 0, middleView.frame.size.height * 0.4);
//    addressImg.image = [UIImage imageNamed:@"gj_patrolqunzu"];
//    [middleView addSubview:addressImg];
//
    
    addressLab = [[UILabel alloc]init];
//    addressLab.frame = CGRectMake(addressImg.frame.size.width + addressImg.frame.origin.x + middleView.frame.size.width * 0.02, addressImg.frame.origin.y, middleView.frame.size.width * 0.8, addressImg.frame.size.height);
    addressLab.frame = CGRectMake(0, CGRectGetMaxY(manLab.frame) + 2.0, middleView.frame.size.width * 0.8, 24);

    addressLab.textColor = [UIColor blackColor];
    addressLab.text = [NSString stringWithFormat:@"巡察小组:%@",[dataDic objectForKey:@"InspectionTeamName"]];
    addressLab.font = [UIFont systemFontOfSize:14.0];
    [middleView addSubview:addressLab];
    
}
- (void)br_toStudent:(UIButton*)sender{
    
    //[self.dataDic objectForKey:@"EnterpriseID"],[self.dataDic objectForKey:@"batchID"]
    PatrolStudentListViewController *vc = [[PatrolStudentListViewController alloc] init];
   // vc.dataDic = (id)sender.accessibilityLabel;
    //PatrolStudentListViewController
    NSMutableDictionary *getDic = sender.accessibilityElements;
    vc.dataDic = getDic;
    [self.lastVC.navigationController pushViewController:vc animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
