//
//  SignAuditModelViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/3/27.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "SignAuditModelViewController.h"
#import "PhoneInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface SignAuditModelViewController (){
    int *number;
    
    CGFloat *width;
    
    CGFloat *height;
    
    NSMutableDictionary *dataDic;
    
    UIView *contentView;
    
    UIView *detailView;
    
    UIImageView *imgView;
    
    UILabel *nameLab;
    
    UILabel *timeLab;
    
    UILabel *addressLab;
    
    BOOL ischeckIn;
}

@end

@implementation SignAuditModelViewController

-(id) init_Value:(int)init_number width:(CGFloat *)init_width height:(CGFloat *)init_height dataDic:(NSMutableDictionary *)init_dic ischeckIn:(BOOL)checkIn{
    self  = [super init];
    if(self != nil){
        number = init_number;
        width = init_width;
        height = init_height;
        dataDic = init_dic;
        ischeckIn = checkIn;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    contentView = [[UIView alloc]init];
    contentView.frame = CGRectMake(0, 0, *(width), *(height));
    [self.view addSubview:contentView];
    
    [self startLayout];
}

-(void) startLayout{
    detailView = [[UIView alloc]init];
    detailView.frame = CGRectMake(contentView.frame.size.width * 0.05, contentView.frame.size.height * 0.1, contentView.frame.size.width * 0.9, contentView.frame.size.height * 0.8);
    detailView.layer.cornerRadius = 10;
    detailView.layer.masksToBounds = YES;
    detailView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
    detailView.layer.borderWidth = 1.5;
    [contentView addSubview:detailView];
    
    
    imgView = [[UIImageView alloc]init];
    imgView.frame = CGRectMake(detailView.frame.size.height * 0.15, detailView.frame.size.height * 0.15, detailView.frame.size.height * 0.7, detailView.frame.size.height * 0.7);
    NSString *faceUrl = [dataDic objectForKey:@"FactUrl"];
    if (faceUrl.length == 0) {
        faceUrl = @"";
    }
    NSURL *url = [NSURL URLWithString:faceUrl];
   // imgView.image = [UIImage imageNamed:@"gj_signunaudit"];
    [imgView sd_setImageWithURL:url placeholderImage:kUserDefualtImage];
    imgView.layer.cornerRadius = imgView.frame.size.height / 2.0;
    imgView.clipsToBounds = YES;
    [detailView addSubview:imgView];
    
    nameLab = [[UILabel alloc]init];
    nameLab.frame = CGRectMake(imgView.frame.size.width * 1.2 + imgView.frame.origin.x, imgView.frame.origin.y, detailView.frame.size.width * 0.3, imgView.frame.size.height * 0.4);
    nameLab.textColor = [UIColor blackColor];
    nameLab.text = [dataDic objectForKey:@"UserName"];
    nameLab.font = [UIFont fontWithName:@"STHeiti SC" size:18.0];
    [detailView addSubview:nameLab];
    
    NSRange rang = {0,10};
    NSString *CheckInData = [dataDic objectForKey:@"CheckInDate"];
    NSString *CheckOutDate = [dataDic objectForKey:@"CheckOutDate"];
    NSString *timeStartStr = [[[CheckInData stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
    NSString *timeEndStr = [[[CheckOutDate stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];

    
    timeLab = [[UILabel alloc]init];
    timeLab.frame = CGRectMake(nameLab.frame.origin.x, nameLab.frame.size.height + nameLab.frame.origin.y, detailView.frame.size.width * 0.7, imgView.frame.size.height * 0.3);
    
    if (ischeckIn) {
        if ([timeStartStr integerValue] > 0) {
         timeLab.text = [NSString stringWithFormat:@"打卡时间:%@",[PhoneInfo timestampSwitchTime:[timeStartStr integerValue]  andFormatter:@"YYYY-MM-dd HH:mm:ss"]];
            timeLab.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
        }else{
            timeLab.text = @"未打卡";
            timeLab.textColor = [UIColor systemPinkColor];
        }
    }else{
        if ([timeEndStr integerValue] > 0) {
         timeLab.text = [NSString stringWithFormat:@"打卡时间:%@",[PhoneInfo timestampSwitchTime:[timeEndStr integerValue]  andFormatter:@"YYYY-MM-dd HH:mm:ss"]];
            timeLab.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
        }else{
            timeLab.text = @"未打卡";
            timeLab.textColor = [UIColor systemPinkColor];
        }
    }
    
    
    timeLab.font = [UIFont systemFontOfSize:13.0];
    
    [detailView addSubview:timeLab];
    
    
    addressLab = [[UILabel alloc]init];
    addressLab.frame = CGRectMake(nameLab.frame.origin.x, timeLab.frame.size.height + timeLab.frame.origin.y, detailView.frame.size.width * 0.7, imgView.frame.size.height * 0.3);
    addressLab.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    addressLab.font = [UIFont systemFontOfSize:13.0];
    NSString * inPlace = [NSString checkNull:[dataDic objectForKey:@"CheckInPlace"]];
    if (!ischeckIn) {
        inPlace = [NSString checkNull:[dataDic objectForKey:@"CheckOutPlace"]];
    }
    addressLab.text = [NSString stringWithFormat:@"打卡地点:%@",inPlace];
    [detailView addSubview:addressLab];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
