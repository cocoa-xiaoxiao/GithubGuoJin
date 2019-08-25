//
//  LeavePassDetailViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/2/24.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "LeavePassDetailViewController.h"

@interface LeavePassDetailViewController (){
    int *number;
    
    CGFloat *width;
    
    CGFloat *height;
    
    NSMutableDictionary *dataDic;
    
    UIView *contentView;
    
    UIImageView *ImgView;
    
    UILabel *nameLab,*leaveTotalLab,*applyDateLab,*auditingLab;
    
    UIButton *cancelBtn;
}

@end

@implementation LeavePassDetailViewController

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
    [self startLayout];
}

-(void) startLayout{
    contentView = [[UIView alloc]init];
    contentView.frame = CGRectMake(*width * 0.03, *height * 0.05, *width * 0.935, *height * 0.9);
    contentView.layer.cornerRadius = 10;
    contentView.layer.masksToBounds = 10;
    contentView.layer.borderColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1].CGColor;
    contentView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    contentView.layer.borderWidth = 1;
    [self.view addSubview:contentView];
    
    
    ImgView = [[UIImageView alloc]init];
    ImgView.frame = CGRectMake(contentView.frame.size.width * 0.05, contentView.frame.size.height * 0.1, contentView.frame.size.height * 0.4, contentView.frame.size.height * 0.4);
    ImgView.image = [UIImage imageNamed:@"gj_auditinghead"];
    [contentView addSubview:ImgView];
    
    nameLab = [[UILabel alloc]init];
    nameLab.frame = CGRectMake(ImgView.frame.size.width * 1.2 + ImgView.frame.origin.x, ImgView.frame.origin.y, contentView.frame.size.width * 0.3, ImgView.frame.size.height * 0.5);
    nameLab.text = [dataDic objectForKey:@"name"];
    nameLab.textColor = [UIColor colorWithRed:65/255.0 green:61/255.0 blue:61/255.0 alpha:1];
    [contentView addSubview:nameLab];
    
    leaveTotalLab = [[UILabel alloc]init];
    leaveTotalLab.frame = CGRectMake(nameLab.frame.origin.x, nameLab.frame.size.height + nameLab.frame.origin.y, contentView.frame.size.width * 0.6, ImgView.frame.size.height * 0.5);
    leaveTotalLab.text = [NSString stringWithFormat:@"请假时长:%@分钟",[dataDic objectForKey:@"howlong"]];
    leaveTotalLab.textColor = [UIColor colorWithRed:231/255.0 green:217/255.0 blue:204/255.0 alpha:1];
    [contentView addSubview:leaveTotalLab];
    
    
    applyDateLab = [[UILabel alloc]init];
    applyDateLab.frame = CGRectMake(ImgView.frame.origin.x, contentView.frame.size.height - contentView.frame.size.height * 0.3, contentView.frame.size.width * 0.45, contentView.frame.size.height * 0.2);
    applyDateLab.text = [NSString stringWithFormat:@"申请:%@",[dataDic objectForKey:@"applydate"]];
    applyDateLab.textColor = [UIColor colorWithRed:231/255.0 green:217/255.0 blue:204/255.0 alpha:1];
    [contentView addSubview:applyDateLab];
    
    
    auditingLab = [[UILabel alloc]init];
    auditingLab.frame = CGRectMake(applyDateLab.frame.origin.x + applyDateLab.frame.size.width, contentView.frame.size.height - contentView.frame.size.height * 0.3, contentView.frame.size.width * 0.45, contentView.frame.size.height * 0.2);
    auditingLab.textAlignment = UITextAlignmentRight;
    auditingLab.textColor = [UIColor colorWithRed:231/255.0 green:217/255.0 blue:204/255.0 alpha:1];
    auditingLab.text = [NSString stringWithFormat:@"审核人:%@",[dataDic objectForKey:@"auditingman"]];
    [contentView addSubview:auditingLab];
    
    cancelBtn = [[UIButton alloc]init];
    cancelBtn.frame = CGRectMake(contentView.frame.size.width * 0.75, ImgView.frame.origin.y, contentView.frame.size.width * 0.2, contentView.frame.size.height * 0.25);
    cancelBtn.layer.cornerRadius = 5;
    cancelBtn.layer.masksToBounds = YES;
    [cancelBtn setTitle:@"通过" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1] forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.layer.borderColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1].CGColor;
    cancelBtn.layer.borderWidth = 1;
    [contentView addSubview:cancelBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
