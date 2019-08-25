//
//  StudentDetailViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/10.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "StudentDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface StudentDetailViewController ()

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIView *topImgView;
@property(nonatomic,strong) UIView *infoView;

@property(nonatomic,strong) UIView *imgBGView;
@property(nonatomic,strong) UIImageView *imgHeadView;
@property(nonatomic,strong) UIImageView *imgBackView;

@property(nonatomic,strong) UIView *contentView1;
@property(nonatomic,strong) UILabel *contentLab1;

@property(nonatomic,strong) UIView *contentView2;
@property(nonatomic,strong) UILabel *contentLab2;

@property(nonatomic,strong) UIView *contentView3;
@property(nonatomic,strong) UILabel *contentLab3;


@property(nonatomic,strong) UILabel *waterLab;




@end

@implementation StudentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
    [self startLayout];
}

-(void) startLayout{
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height);
    _contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
    
    _topImgView = [[UIView alloc]init];
    _topImgView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height * 0.2);
    
    [_contentView addSubview:_topImgView];
    
    
    _infoView = [[UIView alloc]init];
    _infoView.frame = CGRectMake(0, _contentView.frame.size.height * 0.2, _contentView.frame.size.width, _contentView.frame.size.height * 0.25);
    _infoView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_infoView];
    
    [self setColor:_topImgView];

    [self ArcLayout:_infoView];
    
    
    /*--------------------------------布局---------------------------------*/
    _imgBackView = [[UIImageView alloc]init];
    _imgBackView.frame = CGRectMake(10, HEIGHT_STATUSBAR + (HEIGHT_NAVBAR - _topImgView.frame.size.width * 0.08) / 2, _topImgView.frame.size.width * 0.08, _topImgView.frame.size.width * 0.08);
    UITapGestureRecognizer *BackTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BackAction:)];
    [_imgBackView addGestureRecognizer:BackTap];
    _imgBackView.userInteractionEnabled = YES;
//    _imgBackView.image = [UIImage imageNamed:@"icon_navigate_back"];
    [_topImgView addSubview:_imgBackView];
    UIImageView *backItem = [[UIImageView alloc] init];
    backItem.image = [UIImage imageNamed:@"icon_navigate_back"];
    [_imgBackView addSubview:backItem];
    [backItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.centerY.equalTo(self.imgBackView);
    }];
//    sadasdasd
    
    
    
    _imgBGView = [[UIView alloc]init];
    _imgBGView.frame = CGRectMake(0, 0, _topImgView.frame.size.width * 0.2, _topImgView.frame.size.width * 0.2);
    _imgBGView.backgroundColor = [UIColor whiteColor];
    _imgBGView.layer.cornerRadius = _topImgView.frame.size.width * 0.2 / 2;
    _imgBGView.layer.masksToBounds = YES;
    _imgBGView.center = CGPointMake(_topImgView.frame.size.width * 0.5, -_infoView.frame.size.height * 0.2);
    [_infoView addSubview:_imgBGView];
    
    _imgHeadView = [[UIImageView alloc]init];
    _imgHeadView.frame = CGRectMake(_imgBGView.frame.size.width * 0.05, _imgBGView.frame.size.width * 0.05, _imgBGView.frame.size.width * 0.9, _imgBGView.frame.size.width * 0.9);
    _imgHeadView.layer.cornerRadius = _imgBGView.frame.size.width * 0.9 / 2;
    _imgHeadView.layer.masksToBounds = YES;
//    _imgHeadView.image = [UIImage imageNamed:@"gj_msglogo3"];
    NSString *head_url = self.person.headerUrl;
    [_imgHeadView sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"gj_msglogo3"]];
    [_imgBGView addSubview:_imgHeadView];
    
    
    
    _contentView1 = [[UIView alloc]init];
    _contentView1.frame = CGRectMake(_infoView.frame.size.width * 0.05, 0, _infoView.frame.size.width * 0.9, _infoView.frame.size.height / 3);
    [self BottomLine:_contentView1];
    [_infoView addSubview:_contentView1];
    
    
    _contentLab1 = [[UILabel alloc]init];
    _contentLab1.frame = CGRectMake(0, _contentView1.frame.size.height * 0.1, _contentView1.frame.size.width, _contentView1.frame.size.height * 0.8);
    _contentLab1.text = [NSString stringWithFormat:@"学生姓名：%@",_person.name1];
    _contentLab1.textColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1];
    _contentLab1.font = [UIFont systemFontOfSize:18.0];
    [_contentView1 addSubview:_contentLab1];
    
    
    
    
    _contentView2 = [[UIView alloc]init];
    _contentView2.frame = CGRectMake(_infoView.frame.size.width * 0.05, _contentView1.frame.size.height + _contentView1.frame.origin.y, _infoView.frame.size.width * 0.9, _infoView.frame.size.height / 3);
    [self BottomLine:_contentView2];
    [_infoView addSubview:_contentView2];
    
    _contentLab2 = [[UILabel alloc]init];
    _contentLab2.frame = CGRectMake(0, _contentView2.frame.size.height * 0.1, _contentView2.frame.size.width, _contentView2.frame.size.height * 0.8);
    _contentLab2.text = [NSString stringWithFormat:@"学生手机：%@",_person.phoneNumber];
    _contentLab2.textColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1];
    _contentLab2.font = [UIFont systemFontOfSize:18.0];
    [_contentView2 addSubview:_contentLab2];
    
    UIButton *call_tel_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [call_tel_btn setImage:[UIImage imageNamed:@"call_tel"] forState:UIControlStateNormal];
    [_contentView2 addSubview:call_tel_btn];
    [call_tel_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView2);
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    call_tel_btn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [call_tel_btn addTarget:self action:@selector(br_selectedCallTelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _contentView3 = [[UIView alloc]init];
    _contentView3.frame = CGRectMake(_infoView.frame.size.width * 0.05, _contentView2.frame.size.height + _contentView2.frame.origin.y, _infoView.frame.size.width * 0.9, _infoView.frame.size.height / 3);
    [_infoView addSubview:_contentView3];
    
    _contentLab3 = [[UILabel alloc]init];
    _contentLab3.frame = CGRectMake(0, _contentView3.frame.size.height * 0.1, _contentView3.frame.size.width, _contentView3.frame.size.height * 0.8);
    _contentLab3.text = [NSString stringWithFormat:@"学生邮箱：%@",_person.email];
    _contentLab3.textColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1];
    _contentLab3.font = [UIFont systemFontOfSize:18.0];
    [_contentView3 addSubview:_contentLab3];
    
    
    _waterLab = [[UILabel alloc]init];
    _waterLab.frame = CGRectMake(0, _contentView.frame.size.height * 0.9, _contentView.frame.size.width, _contentView.frame.size.height * 0.1);
    _waterLab.text = @"© 2018 GJKJ Inc";
    _waterLab.textColor = [UIColor lightGrayColor];
    _waterLab.font = [UIFont systemFontOfSize:16.0];
    _waterLab.textAlignment = UITextAlignmentCenter;
    [_contentView addSubview:_waterLab];
    
}
- (void)br_selectedCallTelAction:(UIButton *)sender{
   
    
    NSString *phoneNumber = self.person.phoneNumber;
    NSString *number = phoneNumber;
    number = [NSString stringWithFormat:@"是否拨打:%@",number];
  
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNumber];
    //            NSLog(@"str======%@",str);
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        /// 10及其以上系统
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
    } else {
        /// 10以下系统
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

-(void) setColor:(UIView *) sender{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:1/255.0 green:160/255.0 blue:255/255.0 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1].CGColor];
    
//    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:37/255.0 green:170/255.0 blue:178/255.0 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:45/255.0 green:207/255.0 blue:197/255.0 alpha:1].CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, sender.frame.size.width, sender.frame.size.height);
    [sender.layer addSublayer:gradientLayer];
}




-(void) ArcLayout:(UIView *)sender{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addQuadCurveToPoint:CGPointMake(sender.frame.size.width, 0) controlPoint:CGPointMake(sender.frame.size.width * 0.5, -sender.frame.size.height * 0.4)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    shapeLayer.lineWidth = 1;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    [sender.layer addSublayer:shapeLayer];
}



-(void) BackAction:(UITapGestureRecognizer *)sender{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) BottomLine:(UIView *)sender{
    CALayer *bottomlayer = [[CALayer alloc]init];
    bottomlayer.frame = CGRectMake(0, sender.frame.size.height - 1, sender.frame.size.width, 1);
    bottomlayer.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1].CGColor;
    [sender.layer addSublayer:bottomlayer];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
