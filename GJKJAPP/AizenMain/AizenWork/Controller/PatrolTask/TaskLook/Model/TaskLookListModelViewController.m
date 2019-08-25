//
//  TaskLookListModelViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/6/10.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "TaskLookListModelViewController.h"
#import "PhoneInfo.h"

@interface TaskLookListModelViewController (){
    int *number;
    
    CGFloat *width;
    
    CGFloat *height;
    
    NSMutableDictionary *dataDic;
    
    UIView *contentView;
    UIImageView *imgView;
    UILabel *titleLab;
    UILabel *dateLab;
    UILabel *personLab;
    UILabel *statusLab;
}



@end

@implementation TaskLookListModelViewController

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
    contentView.frame = CGRectMake(0, 0, *width, *height * 0.85);
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    CALayer *topLine = [[CALayer alloc]init];
    topLine.frame = CGRectMake(0, 0, contentView.frame.size.width, 1);
    topLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
    [contentView.layer addSublayer:topLine];
    
    
    CALayer *bottomLine = [[CALayer alloc]init];
    bottomLine.frame = CGRectMake(0, contentView.frame.size.height - 1, contentView.frame.size.width, 1);
    bottomLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
    [contentView.layer addSublayer:bottomLine];
    
    
    imgView = [[UIImageView alloc]init];
    imgView.frame = CGRectMake(contentView.frame.size.height * 0.1, contentView.frame.size.height * 0.1, contentView.frame.size.height * 0.4, contentView.frame.size.height * 0.4);
    imgView.image = [UIImage imageNamed:@"gj_msglogo2"];
    imgView.layer.cornerRadius = contentView.frame.size.height * 0.2;
    imgView.clipsToBounds = YES;
    [contentView addSubview:imgView];
    
    
    titleLab = [[UILabel alloc]init];
    titleLab.frame = CGRectMake(imgView.frame.origin.x + imgView.frame.size.width, imgView.frame.origin.y, contentView.frame.size.width * 0.5, contentView.frame.size.height * 0.3);
    titleLab.textColor = [UIColor blackColor];
    titleLab.font = [UIFont systemFontOfSize:16.0];
    titleLab.text = [NSString stringWithFormat:@"标题：%@",[dataDic objectForKey:@"RecordTitle"]];
    [contentView addSubview:titleLab];
    
    personLab = [[UILabel alloc]init];
    personLab.frame = CGRectMake(titleLab.frame.origin.x, titleLab.frame.origin.y + titleLab.frame.size.height, contentView.frame.size.width * 0.5, contentView.frame.size.height * 0.3);
    personLab.textColor = [UIColor lightGrayColor];
    personLab.text = [NSString stringWithFormat:@"提交人：%@",[dataDic objectForKey:@"UserName"]];
    personLab.font = [UIFont systemFontOfSize:14.0];
    [contentView addSubview:personLab];
    
    statusLab = [[UILabel alloc]init];
    statusLab.frame = CGRectMake(personLab.frame.origin.x, personLab.frame.origin.y + personLab.frame.size.height, contentView.frame.size.width * 0.2, contentView.frame.size.height * 0.3);
    statusLab.font = [UIFont systemFontOfSize:14.0];
    [contentView addSubview:statusLab];
    
    dateLab = [[UILabel alloc]init];
    dateLab.frame = CGRectMake(statusLab.frame.origin.x + statusLab.frame.size.width, statusLab.frame.origin.y, contentView.frame.size.width - (contentView.frame.size.height * 0.1 * 2 + imgView.frame.size.width + statusLab.frame.size.width), contentView.frame.size.height * 0.3);
    dateLab.textAlignment = UITextAlignmentRight;
    dateLab.font = [UIFont systemFontOfSize:14.0];
    dateLab.textColor = [UIColor lightGrayColor];
    dateLab.text = [NSString stringWithFormat:@"提交时间：%@",[PhoneInfo handleDateStr:[dataDic objectForKey:@"CreateDate"] handleFormat:@"yyyy-MM-dd"]];
    [contentView addSubview:dateLab];
    
    NSString *statusStr = @"";
    UIColor *statusColor = nil;
    if([[dataDic objectForKey:@"CheckState"] integerValue] == 0){
        statusStr = @"未审核";
        statusColor = [UIColor colorWithRed:243/255.0 green:44/255.0 blue:44/255.0 alpha:1];
    }else if([[dataDic objectForKey:@"CheckState"] integerValue] == 1){
        statusStr = @"已审核";
        statusColor = [UIColor colorWithRed:44/255.0 green:243/255.0 blue:81/255.0 alpha:1];
    }else if([[dataDic objectForKey:@"CheckState"] integerValue] == 2){
        statusStr = @"";
    }else if([[dataDic objectForKey:@"CheckState"] integerValue] == 3){
        statusStr = @"";
    }else if([[dataDic objectForKey:@"CheckState"] integerValue] == 4){
        statusStr = @"";
    }else if([[dataDic objectForKey:@"CheckState"] integerValue] == 5){
        statusStr = @"";
    }
    statusLab.text = statusStr;
    statusLab.textColor = statusColor;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
