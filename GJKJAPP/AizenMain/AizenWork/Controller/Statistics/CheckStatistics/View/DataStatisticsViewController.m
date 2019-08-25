//
//  DataStatisticsViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/8.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "DataStatisticsViewController.h"
#import "ZZCircleProgress.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "DGActivityIndicatorView.h"
#import "DetailListViewController.h"


#define ZZRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]


@interface DataStatisticsViewController (){
    ZZCircleProgress *circle;
}

@property(nonatomic,strong) UIView *contentView;

@property(nonatomic,strong) UIView *ChatView;
@property(nonatomic,strong) UIView *haveCountView;
@property(nonatomic,strong) UIView *leaveCountView;
@property(nonatomic,strong) UIView *dutyCountView;
@property(nonatomic,strong) UIView *normalView;

@end

@implementation DataStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self startLayout];
}

-(void) startLayout{
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_STATUSBAR - HEIGHT_NAVBAR - 44.0f);
    [self.view addSubview:_contentView];
    
    
    [self detailLayout];
}


-(void) detailLayout{
    _ChatView = [[UIView alloc]init];
    _ChatView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height * 0.6);
    _ChatView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_contentView addSubview:_ChatView];
    
    
    _haveCountView = [[UIView alloc]init];
    _haveCountView.frame = CGRectMake(0, _ChatView.frame.size.height + _ChatView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height * 0.1);
    _haveCountView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_haveCountView];
    
    UIView *line1 = [[UIView alloc]init];
    line1.frame = CGRectMake(0, _haveCountView.frame.size.height - 1, _contentView.frame.size.width, 1);
    line1.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_haveCountView addSubview:line1];
    
    
    _leaveCountView = [[UIView alloc]init];
    _leaveCountView.frame = CGRectMake(0, _haveCountView.frame.origin.y + _haveCountView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height * 0.1);
    _leaveCountView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_leaveCountView];
    
    UIView *line2 = [[UIView alloc]init];
    line2.frame = CGRectMake(0, _leaveCountView.frame.size.height - 1, _contentView.frame.size.width, 1);
    line2.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_leaveCountView addSubview:line2];
    
    
    _dutyCountView = [[UIView alloc]init];
    _dutyCountView.frame = CGRectMake(0, _leaveCountView.frame.origin.y + _leaveCountView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height * 0.1);
    _dutyCountView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_dutyCountView];
    
    UIView *line3 = [[UIView alloc]init];
    line3.frame = CGRectMake(0, _dutyCountView.frame.size.height - 1, _contentView.frame.size.width, 1);
    line3.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_dutyCountView addSubview:line3];
    
    
    _normalView = [[UIView alloc]init];
    _normalView.frame = CGRectMake(0, _dutyCountView.frame.origin.y + _dutyCountView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height * 0.1);
    _normalView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_normalView];
    
    
    [self setCircle];
    
    [self setHaveCountLayout];
    [self setLeaveCountLayout];
    [self setDutyCountLayout];
    [self setNormalCountLayout];
}


-(void) setCircle{
    CGFloat xCrack = _ChatView.frame.size.width * 0.15;
    CGFloat yCrack = (_ChatView.frame.size.height - _ChatView.frame.size.width * 0.7) / 2;
    CGFloat itemWidth = _ChatView.frame.size.width * 0.7;
    
    circle = [[ZZCircleProgress alloc] initWithFrame:CGRectMake(xCrack, yCrack, itemWidth, itemWidth) pathBackColor:nil pathFillColor:[UIColor colorWithRed:255/255.0 green:165/255.0 blue:0/255.0 alpha:1] startAngle:-255 strokeWidth:20];
    circle.progress = 0.6;
    circle.reduceValue = 30;
    [_ChatView addSubview:circle];
    
    UITapGestureRecognizer *circleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(circleAction:)];
    [circle addGestureRecognizer:circleTap];
}


-(void) setHaveCountLayout{
    UIImageView *haveCountImg = [[UIImageView alloc]init];
    haveCountImg.frame = CGRectMake(_haveCountView.frame.size.width * 0.05, _haveCountView.frame.size.height * 0.15, _haveCountView.frame.size.height * 0.7, _haveCountView.frame.size.height * 0.7);
    haveCountImg.image = [UIImage imageNamed:@"gj_statisticsshijian"];
    [_haveCountView addSubview:haveCountImg];
    
    
    UILabel *haveCountTitle = [[UILabel alloc]init];
    haveCountTitle.frame = CGRectMake(haveCountImg.frame.size.width + haveCountImg.frame.origin.x + _haveCountView.frame.size.width * 0.05, haveCountImg.frame.origin.y, _haveCountView.frame.size.width * 0.2, _haveCountView.frame.size.height * 0.7);
    haveCountTitle.text = @"应到人数:";
    haveCountTitle.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [_haveCountView addSubview:haveCountTitle];
    
    
    UILabel *haveCountPercent = [[UILabel alloc]init];
    haveCountPercent.frame = CGRectMake(haveCountTitle.frame.size.width + haveCountTitle.frame.origin.x + _haveCountView.frame.size.width * 0.1, haveCountTitle.frame.origin.y, _haveCountView.frame.size.width * 0.1, _haveCountView.frame.size.height * 0.7);
    haveCountPercent.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    haveCountPercent.text = @"60%";
    [_haveCountView addSubview:haveCountPercent];
    
    
    UILabel *haveCountVal = [[UILabel alloc]init];
    haveCountVal.frame = CGRectMake(_haveCountView.frame.size.width - _haveCountView.frame.size.width * 0.1 - _haveCountView.frame.size.width * 0.05, haveCountPercent.frame.origin.y, _haveCountView.frame.size.width * 0.1, _haveCountView.frame.size.height * 0.7);
    haveCountVal.textColor = [UIColor colorWithRed:255/255.0 green:165/255.0 blue:0/255.0 alpha:1];
    haveCountVal.text = @"23人";
    [_haveCountView addSubview:haveCountVal];
    
}

-(void) setLeaveCountLayout{
    UIImageView *leaveCountImg = [[UIImageView alloc]init];
    leaveCountImg.frame = CGRectMake(_leaveCountView.frame.size.width * 0.05, _leaveCountView.frame.size.height * 0.15, _leaveCountView.frame.size.height * 0.7, _leaveCountView.frame.size.height * 0.7);
    leaveCountImg.image = [UIImage imageNamed:@"gj_statisticsrili"];
    [_leaveCountView addSubview:leaveCountImg];
    
    
    UILabel *leaveCountTitle = [[UILabel alloc]init];
    leaveCountTitle.frame = CGRectMake(leaveCountImg.frame.size.width + leaveCountImg.frame.origin.x + _leaveCountView.frame.size.width * 0.05, leaveCountImg.frame.origin.y, _leaveCountView.frame.size.width * 0.2, _leaveCountView.frame.size.height * 0.7);
    leaveCountTitle.text = @"请假人数:";
    leaveCountTitle.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [_leaveCountView addSubview:leaveCountTitle];
    
    
    UILabel *leaveCountPercent = [[UILabel alloc]init];
    leaveCountPercent.frame = CGRectMake(leaveCountTitle.frame.size.width + leaveCountTitle.frame.origin.x + _leaveCountView.frame.size.width * 0.1, leaveCountTitle.frame.origin.y, _leaveCountView.frame.size.width * 0.1, _leaveCountView.frame.size.height * 0.7);
    leaveCountPercent.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    leaveCountPercent.text = @"60%";
    [_leaveCountView addSubview:leaveCountPercent];
    
    
    UILabel *leaveCountVal = [[UILabel alloc]init];
    leaveCountVal.frame = CGRectMake(_leaveCountView.frame.size.width - _leaveCountView.frame.size.width * 0.1 - _leaveCountView.frame.size.width * 0.05, leaveCountPercent.frame.origin.y, _leaveCountView.frame.size.width * 0.1, _leaveCountView.frame.size.height * 0.7);
    leaveCountVal.textColor = [UIColor colorWithRed:255/255.0 green:165/255.0 blue:0/255.0 alpha:1];
    leaveCountVal.text = @"23人";
    [_leaveCountView addSubview:leaveCountVal];
    
}

-(void) setDutyCountLayout{
    UIImageView *dutyCountImg = [[UIImageView alloc]init];
    dutyCountImg.frame = CGRectMake(_dutyCountView.frame.size.width * 0.05, _dutyCountView.frame.size.height * 0.15, _dutyCountView.frame.size.height * 0.7, _dutyCountView.frame.size.height * 0.7);
    dutyCountImg.image = [UIImage imageNamed:@"gj_statisticsshijian"];
    [_dutyCountView addSubview:dutyCountImg];
    
    
    UILabel *dutyCountTitle = [[UILabel alloc]init];
    dutyCountTitle.frame = CGRectMake(dutyCountImg.frame.size.width + dutyCountImg.frame.origin.x + _dutyCountView.frame.size.width * 0.05, dutyCountImg.frame.origin.y, _dutyCountView.frame.size.width * 0.2, _dutyCountView.frame.size.height * 0.7);
    dutyCountTitle.text = @"缺勤人数:";
    dutyCountTitle.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [_dutyCountView addSubview:dutyCountTitle];
    
    
    UILabel *dutyCountPercent = [[UILabel alloc]init];
    dutyCountPercent.frame = CGRectMake(dutyCountTitle.frame.size.width + dutyCountTitle.frame.origin.x + _dutyCountView.frame.size.width * 0.1, dutyCountTitle.frame.origin.y, _dutyCountView.frame.size.width * 0.1, _dutyCountView.frame.size.height * 0.7);
    dutyCountPercent.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    dutyCountPercent.text = @"60%";
    [_dutyCountView addSubview:dutyCountPercent];
    
    
    UILabel *dutyCountVal = [[UILabel alloc]init];
    dutyCountVal.frame = CGRectMake(_dutyCountView.frame.size.width - _dutyCountView.frame.size.width * 0.1 - _dutyCountView.frame.size.width * 0.05, dutyCountPercent.frame.origin.y, _dutyCountView.frame.size.width * 0.1, _dutyCountView.frame.size.height * 0.7);
    dutyCountVal.textColor = [UIColor colorWithRed:255/255.0 green:165/255.0 blue:0/255.0 alpha:1];
    dutyCountVal.text = @"23人";
    [_dutyCountView addSubview:dutyCountVal];
    
}

-(void) setNormalCountLayout{
    UIImageView *normalCountImg = [[UIImageView alloc]init];
    normalCountImg.frame = CGRectMake(_normalView.frame.size.width * 0.05, _normalView.frame.size.height * 0.15, _normalView.frame.size.height * 0.7, _normalView.frame.size.height * 0.7);
    normalCountImg.image = [UIImage imageNamed:@"gj_statisticsrili"];
    [_normalView addSubview:normalCountImg];
    
    
    UILabel *normalCountTitle = [[UILabel alloc]init];
    normalCountTitle.frame = CGRectMake(normalCountImg.frame.size.width + normalCountImg.frame.origin.x + _normalView.frame.size.width * 0.05, normalCountImg.frame.origin.y, _normalView.frame.size.width * 0.2, _normalView.frame.size.height * 0.7);
    normalCountTitle.text = @"正常人数:";
    normalCountTitle.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [_normalView addSubview:normalCountTitle];
    
    
    UILabel *normalCountPercent = [[UILabel alloc]init];
    normalCountPercent.frame = CGRectMake(normalCountTitle.frame.size.width + normalCountTitle.frame.origin.x + _normalView.frame.size.width * 0.1, normalCountTitle.frame.origin.y, _normalView.frame.size.width * 0.1, _normalView.frame.size.height * 0.7);
    normalCountPercent.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    normalCountPercent.text = @"60%";
    [_normalView addSubview:normalCountPercent];
    
    
    UILabel *normalCountVal = [[UILabel alloc]init];
    normalCountVal.frame = CGRectMake(_normalView.frame.size.width - _normalView.frame.size.width * 0.1 - _normalView.frame.size.width * 0.05, normalCountPercent.frame.origin.y, _normalView.frame.size.width * 0.1, _normalView.frame.size.height * 0.7);
    normalCountVal.textColor = [UIColor colorWithRed:255/255.0 green:165/255.0 blue:0/255.0 alpha:1];
    normalCountVal.text = @"23人";
    [_normalView addSubview:normalCountVal];
    
}

-(void) circleAction:(UITapGestureRecognizer *)sender{
    DetailListViewController *detail = [[DetailListViewController alloc]init];
    [self.navigationController pushViewController:detail animated:YES];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
