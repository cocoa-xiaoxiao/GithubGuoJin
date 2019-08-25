//
//  StudentCheckListDetailViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/3/28.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "StudentCheckListDetailViewController.h"
#import "PhoneInfo.h"

@interface StudentCheckListDetailViewController (){
    int *number;
    
    CGFloat *width;
    
    CGFloat *height;
    
    NSMutableDictionary *dataDic;
    
    UIView *contentView;
    
    UIView *detailView;
    
    UIImageView *imgView;
    
    UIView *nameView;
    UILabel *nameLab;
    UIView *signinView;
    UILabel *signinPlaceLab;
    UILabel *signinDateLab;
    UILabel *signinStateLab;
    
    UIView *signoutView;
    UILabel *signoutPlaceLab;
    UILabel *signoutDateLab;
    UILabel *signoutStateLab;
    
    NSString *name;
}


@end

@implementation StudentCheckListDetailViewController


-(id) init_Value:(int)init_number width:(CGFloat *)init_width height:(CGFloat *)init_height dataDic:(NSMutableDictionary *)init_dic getName:(NSString *)init_name{
    self  = [super init];
    if(self != nil){
        name = @"";
        number = init_number;
        width = init_width;
        height = init_height;
        dataDic = init_dic;
        name = init_name;
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
    UIView *line = [[UIView alloc]init];
    line.frame = CGRectMake(*width * 0.05, *height - 1.5, *width * 0.95, 1.5);
    line.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [contentView addSubview:line];
    
    imgView = [[UIImageView alloc]init];
    imgView.frame = CGRectMake(*width * 0.05, *width * 0.02, *height * 0.25, *height * 0.25);
    imgView.image = kUserDefualtImage;//[UIImage imageNamed:@"gj_studentchecklist"];
    [contentView addSubview:imgView];
    
    nameView = [[UIView alloc]init];
    nameView.frame = CGRectMake(imgView.frame.size.width + imgView.frame.origin.x, imgView.frame.origin.y, *width * 0.9 - imgView.frame.size.width, *height * 0.2);
    [contentView addSubview:nameView];
    
    nameLab = [[UILabel alloc]init];
    nameLab.frame = CGRectMake(10, 0, nameView.frame.size.width * 0.5, nameView.frame.size.height);
    nameLab.text = name;
    nameLab.textColor = [UIColor blackColor];
    nameLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    [nameView addSubview:nameLab];
    
    signinView = [[UIView alloc]init];
    signinView.frame = CGRectMake(imgView.frame.size.width + imgView.frame.origin.x + 10, nameView.frame.size.height + nameView.frame.origin.y, *width * 0.9 - imgView.frame.size.width - 5, (*height * 0.8 - *width * 0.04)/2);
    [contentView addSubview:signinView];
    
    UIView *line1 = [[UIView alloc]init];
    line1.frame = CGRectMake(0, signinView.frame.size.height - 1, signinView.frame.size.width, 1);
    line1.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1];
    [signinView addSubview:line1];
    
    signoutView = [[UIView alloc]init];
    signoutView.frame = CGRectMake(imgView.frame.size.width + imgView.frame.origin.x + 10, signinView.frame.size.height + signinView.frame.origin.y, *width * 0.9 - imgView.frame.size.width - 5, (*height * 0.8 - *width * 0.04)/2);
    [contentView addSubview:signoutView];
    
    
    
    
    [self signinLayout];
    [self signoutLayout];
}



-(void) signinLayout{
    NSRange rang = {0,10};
    NSString *timeStartStr = @"";
    if([dataDic objectForKey:@"CheckInDate"] != [NSNull null]){
        NSString *timeStr = [[[[dataDic objectForKey:@"CheckInDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
        
        timeStartStr = [PhoneInfo timestampSwitchTime:[timeStr integerValue]  andFormatter:@"YYYY-MM-dd HH:mm:ss"];
    }else{
        timeStartStr = @"----";
    }
    
    
    signinDateLab = [[UILabel alloc]init];
    signinDateLab.frame = CGRectMake(0, 0, signinView.frame.size.width, signinView.frame.size.height / 3);
    signinDateLab.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
    if(![timeStartStr isEqualToString:@""])
        signinDateLab.text = [NSString stringWithFormat:@"签到时间：%@",timeStartStr];
    else
        signinDateLab.text = [NSString stringWithFormat:@"签到时间：%@",timeStartStr];
    signinDateLab.font = [UIFont systemFontOfSize:14.0];
    [signinView addSubview:signinDateLab];
    
    
    
    NSString *placeStr = @"";
    if([dataDic objectForKey:@"CheckInPlace"] != [NSNull null]){
        placeStr = [dataDic objectForKey:@"CheckInPlace"];
    }else{
        placeStr = @"----";
    }
    
    signinPlaceLab = [[UILabel alloc]init];
    signinPlaceLab.frame = CGRectMake(0, signinDateLab.frame.size.height + signinDateLab.frame.origin.y,signinView.frame.size.width, signinView.frame.size.height / 3);
    signinPlaceLab.text = [NSString stringWithFormat:@"签到地点：%@",placeStr];
    signinPlaceLab.font = [UIFont systemFontOfSize:14.0];
    signinPlaceLab.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
    [signinView addSubview:signinPlaceLab];
    
    
    NSString *stateStr = @"";
    UIColor *stateColor = nil;
    if([[dataDic objectForKey:@"CheckInConfirm"] boolValue] == true){
        stateStr = @"正常打卡";
        stateColor = [UIColor colorWithRed:35/255.0 green:179/255.0 blue:49/255.0 alpha:1];
    }else{
        stateStr = @"异常打卡";
        stateColor = [UIColor redColor];
    }
    
    signinStateLab = [[UILabel alloc]init];
    signinStateLab.frame = CGRectMake(0, signinPlaceLab.frame.size.height + signinPlaceLab.frame.origin.y,signinView.frame.size.width, signinView.frame.size.height / 3);
    signinStateLab.text = stateStr;
    signinStateLab.font = [UIFont systemFontOfSize:14.0];
    signinStateLab.textColor = stateColor;
    [signinView addSubview:signinStateLab];
}


-(void) signoutLayout{
    NSRange rang = {0,10};
    NSString *timeStartStr = @"";
    if([dataDic objectForKey:@"CheckOutDate"] != [NSNull null]){
        NSString *timeStr ;
        //[[[[dataDic objectForKey:@"CheckOutDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
        timeStr = [[dataDic objectForKey:@"CheckOutDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@")/" withString:@""];
        
        timeStartStr = [PhoneInfo timestampSwitchTime:[timeStr integerValue]  andFormatter:@"YYYY-MM-dd HH:mm:ss"];
    }else{
        timeStartStr = @"----";
    }
    
    
    signoutDateLab = [[UILabel alloc]init];
    signoutDateLab.frame = CGRectMake(0, 0, signoutView.frame.size.width, signoutView.frame.size.height / 3);
    signoutDateLab.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
    if(![timeStartStr isEqualToString:@""])
        signoutDateLab.text = [NSString stringWithFormat:@"签退时间：%@",timeStartStr];
    else
        signoutDateLab.text = [NSString stringWithFormat:@"签退时间：%@",timeStartStr];
    signoutDateLab.font = [UIFont systemFontOfSize:14.0];
    [signoutView addSubview:signoutDateLab];
    
    
    
    NSString *placeStr = @"";
    if([dataDic objectForKey:@"CheckOutPlace"] != [NSNull null]){
        placeStr = [dataDic objectForKey:@"CheckOutPlace"];
    }else{
        placeStr = @"----";
    }
    
    signoutPlaceLab = [[UILabel alloc]init];
    signoutPlaceLab.frame = CGRectMake(0, signoutDateLab.frame.size.height + signoutDateLab.frame.origin.y,signinView.frame.size.width, signoutView.frame.size.height / 3);
    signoutPlaceLab.text = [NSString stringWithFormat:@"签退地点：%@",placeStr];
    signoutPlaceLab.font = [UIFont systemFontOfSize:14.0];
    signoutPlaceLab.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
    [signoutView addSubview:signoutPlaceLab];
    
    
    NSString *stateStr = @"";
    UIColor *stateColor = nil;
    if([[dataDic objectForKey:@"CheckOutConfirm"] boolValue] == true){
        stateStr = @"已审核";
        stateColor = [UIColor colorWithRed:43/255.0 green:199/255.0 blue:158/255.0 alpha:1];
    }else{
        stateStr = @"未审核";
        stateColor = [UIColor redColor];
    }
    
    signoutStateLab = [[UILabel alloc]init];
    signoutStateLab.frame = CGRectMake(0, signoutPlaceLab.frame.size.height + signoutPlaceLab.frame.origin.y,signoutView.frame.size.width, signoutView.frame.size.height / 3);
    signoutStateLab.text = stateStr;
    signoutStateLab.font = [UIFont systemFontOfSize:14.0];
    signoutStateLab.textColor = stateColor;
    [signoutView addSubview:signoutStateLab];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
