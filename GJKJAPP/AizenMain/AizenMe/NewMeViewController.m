//
//  NewMeViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/19.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "NewMeViewController.h"
#import "AizenHttp.h"
#import "AizenMD5.h"
#import "AizenStorage.h"
#import "DGActivityIndicatorView.h"
#import "RDVTabBarController.h"
#import "PhoneInfo.h"
#import "People.h"
#import "LoginViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BRMoifyUserInfoViewController.h"
#import "MyLeaveRecordViewController.h"
#import "LDPublicWebViewController.h"

@interface NewMeViewController ()<UIAlertViewDelegate>

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIView *floatView;
@property(nonatomic,strong) UIView *bottomDetailView;

@property LoginViewController *loginCtl;
@property People *peopleData;
@property NSString *chooseVal;


@property(nonatomic,strong) UIView *personView;
@property(nonatomic,strong) UILabel *personTitleLab;
@property(nonatomic,strong) UIImageView *personImg;
@property(nonatomic,strong) UILabel *personNameLab;
@property(nonatomic,strong) UIView *personBottomView;


@property(nonatomic,strong) UIView *scView;
@property(nonatomic,strong) UIView *txlView;
@property(nonatomic,strong) UIView *scDetailView;
@property(nonatomic,strong) UIView *txlDetailView;
@property(nonatomic,strong) UIImageView *scImgView;
@property(nonatomic,strong) UIImageView *txlImgView;
@property(nonatomic,strong) UILabel *scLab;
@property(nonatomic,strong) UILabel *txlLab;


/*----------------------DetailView--------------------------*/
@property(nonatomic,strong) UIView *bottomTitleView;
@property(nonatomic,strong) UIView *leftLineView;
@property(nonatomic,strong) UIView *rightLineView;
@property(nonatomic,strong) UILabel *centerTitleLab;
@property(nonatomic,strong) UIView *leftPointView;
@property(nonatomic,strong) UIView *rightPointView;

@property(nonatomic,strong) UIView *personInfoView;
@property(nonatomic,strong) UIView *personInfo1;
@property(nonatomic,strong) UIImageView *personImg1;
@property(nonatomic,strong) UILabel *personLab1;

@property(nonatomic,strong) UIView *personInfo2;
@property(nonatomic,strong) UIImageView *personImg2;
@property(nonatomic,strong) UILabel *personLab2;

@property(nonatomic,strong) UIView *personInfo3;
@property(nonatomic,strong) UIImageView *personImg3;
@property(nonatomic,strong) UILabel *personLab3;

@property(nonatomic,strong) UIView *personInfo4;
@property(nonatomic,strong) UIImageView *personImg4;
@property(nonatomic,strong) UILabel *personLab4;

@property(nonatomic,strong) UIButton *getOutBtn;


@end

@implementation NewMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
//    //隐藏顶部导航栏
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = @"";
   


    NSString *account = [AizenStorage readUserDataWithKey:@"Account"];
    _chooseVal = [AizenStorage readUserDataWithKey:@"ChooseObj"];
    NSArray *peopleArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",account]];
    _peopleData = [peopleArr objectAtIndex:0];
    
    [self startLayout];
}


-(void) startLayout{
    _contentView = [[UIView alloc]init];
    _contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    _contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_TABBAR);
    [self.view addSubview:_contentView];
    
    
    _topView = [[UIView alloc]init];
    _topView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height * 0.35);
    [_contentView addSubview:_topView];
    [self setColor:_topView];
    
    _bottomView = [[UIView alloc]init];
    _bottomView.frame = CGRectMake(0, _topView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height - _topView.frame.size.height);
    _bottomView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [_contentView addSubview:_bottomView];
    
    [self detailLayout];
    
    UIButton *setting = [UIButton buttonWithType:UIButtonTypeSystem];
    [setting setImage:[UIImage imageNamed:@"userInfo_eidt"] forState:UIControlStateNormal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"userInfo_eidt"] style:UIBarButtonItemStyleDone target:self action:@selector(br_toEidt)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
//    [_contentView addSubview:setting];
//    setting.tintColor = [UIColor whiteColor];
//    [setting mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_offset(-10);
//        make.top.equalTo(self.contentView.mas_top).offset(20);
//        make.size.mas_offset(CGSizeMake(40, 40));
//
//    }];
//    [setting addTarget:self action:@selector(br_toEidt) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)br_toEidt{
//    MyLeaveRecordViewController *vc1 = [[MyLeaveRecordViewController alloc] init];
    BRMoifyUserInfoViewController *vc = [[BRMoifyUserInfoViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.updateBlock = ^(id info) {
        
        NSString *account = [AizenStorage readUserDataWithKey:@"Account"];
        _chooseVal = [AizenStorage readUserDataWithKey:@"ChooseObj"];
        NSArray *peopleArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",account]];
        _peopleData = [peopleArr objectAtIndex:0];
        [self detailLayout];
    };
    [self.navigationController pushViewController:vc animated:YES];
//    vc1.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc1 animated:YES];
}


-(void) detailLayout{
    [_personView removeFromSuperview];
    
    _personView = [[UIView alloc]init];
    _personView.frame = CGRectMake(_topView.frame.size.width * 0.03, _topView.frame.size.height * 0.3, _topView.frame.size.width * 0.94, _topView.frame.size.height * 0.7);
    _personView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    _personView.layer.cornerRadius = 5;
    _personView.layer.masksToBounds = YES;
    [_topView addSubview:_personView];
    
    
    _personTitleLab = [[UILabel alloc]init];
    _personTitleLab.frame = CGRectMake(_topView.frame.size.width * 0.25, HEIGHT_STATUSBAR, _topView.frame.size.width * 0.5, _topView.frame.size.height * 0.15);
    _personTitleLab.text = @"我的";
    _personTitleLab.textColor = [UIColor whiteColor];
    _personTitleLab.textAlignment = UITextAlignmentCenter;
    _personTitleLab.font = [UIFont systemFontOfSize:18.0];
    [_topView addSubview:_personTitleLab];
    
    
    _personImg = [[UIImageView alloc]init];
    _personImg.frame = CGRectMake(_personView.frame.size.width * 0.425, _personView.frame.size.height * 0.1, _personView.frame.size.width * 0.15, _personView.frame.size.width * 0.15);
    _personImg.layer.cornerRadius = _personView.frame.size.width * 0.15 / 2;
    _personImg.layer.masksToBounds = YES;
    //kUserDefualtImage
//    _personImg.image = [UIImage imageNamed:@"gj_msglogo2"];
    if (_peopleData.FactUrl == nil || [_peopleData.FactUrl isKindOfClass:[NSNull class]]) {
        _peopleData.FactUrl = @"";
    }
    [_personImg sd_setImageWithURL:[NSURL URLWithString:[_peopleData.FactUrl fullImg]] placeholderImage:kUserDefualtImage];
    [_personView addSubview:_personImg];
    
    
    _personNameLab = [[UILabel alloc]init];
    _personNameLab.frame = CGRectMake(_personView.frame.size.width * 0.3, _personImg.frame.size.height + _personImg.frame.origin.y, _personView.frame.size.width * 0.4, _personView.frame.size.height * 0.2);
    _personNameLab.textAlignment = UITextAlignmentCenter;
    _personNameLab.text = _peopleData.USERNAME;
    [_personView addSubview:_personNameLab];
    
    
    
    _personBottomView = [[UIView alloc]init];
    _personBottomView.frame = CGRectMake(0, _personView.frame.size.height * 0.7, _personView.frame.size.width, _personView.frame.size.height * 0.3);
    _personBottomView.backgroundColor = [UIColor colorWithRed:253/255.0 green:253/255.0 blue:253/255.0 alpha:1];
    [_personView addSubview:_personBottomView];
    
    CALayer *topLayer = [[CALayer alloc]init];
    topLayer.frame = CGRectMake(0, 0, _personBottomView.frame.size.width, 1);
    topLayer.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1].CGColor;
    [_personBottomView.layer addSublayer:topLayer];
    
    
    
    _scView = [[UIView alloc]init];
    _scView.frame = CGRectMake(0, 0, _personBottomView.frame.size.width / 2, _personBottomView.frame.size.height);
    [_personBottomView addSubview:_scView];
    
    _scDetailView = [[UIView alloc]init];
    _scDetailView.frame = CGRectMake(_scView.frame.size.width * 0.3, _scView.frame.size.height * 0.25, _scView.frame.size.width * 0.4, _scView.frame.size.height * 0.5);
    [_scView addSubview:_scDetailView];
    
    _scImgView = [[UIImageView alloc]init];
    _scImgView.frame = CGRectMake(0, 0, _scDetailView.frame.size.height, _scDetailView.frame.size.height);
   // _scImgView.image = [UIImage imageNamed:@"gj_shoucang"];
    [_scDetailView addSubview:_scImgView];
    
    
    
    
    
    _scLab = [[UILabel alloc]init];
    _scLab.frame = CGRectMake(_scImgView.frame.size.width, 0, _scDetailView.frame.size.width - _scImgView.frame.size.width, _scDetailView.frame.size.height);
    _scLab.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    _scLab.text = @"收藏";
    _scLab.font = [UIFont systemFontOfSize:15.0];
    _scLab.textAlignment = UITextAlignmentCenter;
    [_scDetailView addSubview:_scLab];
    
    
    _txlView = [[UIView alloc]init];
    _txlView.frame = CGRectMake(_scView.frame.size.width, 0, _personBottomView.frame.size.width / 2, _personBottomView.frame.size.height);
    [_personBottomView addSubview:_txlView];
    
    _txlDetailView = [[UIView alloc]init];
    _txlDetailView.frame = CGRectMake(_txlView.frame.size.width * 0.3, _txlView.frame.size.height * 0.25, _txlView.frame.size.width * 0.4, _txlView.frame.size.height * 0.5);
    [_txlView addSubview:_txlDetailView];
    
    _txlImgView = [[UIImageView alloc]init];
    _txlImgView.frame = CGRectMake(0, _txlDetailView.frame.size.height * 0.1, _txlDetailView.frame.size.height * 0.8, _txlDetailView.frame.size.height * 0.8);
    _txlImgView.image = [UIImage imageNamed:@"gj_huiyuan"];
    [_txlDetailView addSubview:_txlImgView];
    
    
    _txlLab = [[UILabel alloc]init];
    _txlLab.frame = CGRectMake(_txlImgView.frame.size.width, 0, _txlDetailView.frame.size.width - _txlImgView.frame.size.width, _txlDetailView.frame.size.height);
    _txlLab.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    _txlLab.text = @"超级";
    _txlLab.textAlignment = UITextAlignmentCenter;
    _txlLab.font = [UIFont systemFontOfSize:15.0];
    [_txlDetailView addSubview:_txlLab];
    
    
    CALayer *leftLayer = [[CALayer alloc]init];
    leftLayer.frame = CGRectMake(_scView.frame.size.width - 1, 0, 1, _scView.frame.size.height);
    leftLayer.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1].CGColor;
    [_scView.layer addSublayer:leftLayer];
    
    
    
    _bottomDetailView = [[UIView alloc]init];
    _bottomDetailView.frame = CGRectMake(_bottomView.frame.size.width * 0.03, _bottomView.frame.size.height * 0.05, _bottomView.frame.size.width * 0.94, _bottomView.frame.size.height * 0.85);
    [_bottomView addSubview:_bottomDetailView];
    
    _bottomTitleView = [[UIView alloc]init];
    _bottomTitleView.frame = CGRectMake(_bottomDetailView.frame.size.width * 0.25, 0, _bottomDetailView.frame.size.width * 0.5, _bottomDetailView.frame.size.height * 0.08);
    [_bottomDetailView addSubview:_bottomTitleView];
    
    _centerTitleLab = [[UILabel alloc]init];
    _centerTitleLab.frame = CGRectMake(_bottomTitleView.frame.size.width * 0.1, 0, _bottomTitleView.frame.size.width * 0.8, _bottomTitleView.frame.size.height);
    _centerTitleLab.text = @"「个人信息」";
    _centerTitleLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    _centerTitleLab.textColor = [UIColor blackColor];
    _centerTitleLab.textAlignment = UITextAlignmentCenter;
    [_bottomTitleView addSubview:_centerTitleLab];
    
    _leftLineView = [[UIView alloc]init];
    _leftLineView.frame = CGRectMake(0, _bottomTitleView.frame.size.height / 2 - 0.75, _bottomTitleView.frame.size.width * 0.16, 1.5);
    _leftLineView.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    [_bottomTitleView addSubview:_leftLineView];
    
    
    _leftPointView = [[UIView alloc]init];
    _leftPointView.frame = CGRectMake(_leftLineView.frame.size.width + 2, _bottomTitleView.frame.size.height / 2 - 1.5, 3, 3);
    _leftPointView.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    _leftPointView.layer.cornerRadius = 3 / 2;
    _leftPointView.layer.masksToBounds = YES;
    [_bottomTitleView addSubview:_leftPointView];
    
    _rightLineView = [[UIView alloc]init];
    _rightLineView.frame = CGRectMake(_bottomTitleView.frame.size.width - _bottomTitleView.frame.size.width * 0.16, _bottomTitleView.frame.size.height / 2 - 0.75, _bottomTitleView.frame.size.width * 0.16, 1.5);
    _rightLineView.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    [_bottomTitleView addSubview:_rightLineView];
    
    _rightPointView = [[UIView alloc]init];
    _rightPointView.frame = CGRectMake(_bottomTitleView.frame.size.width - _bottomTitleView.frame.size.width * 0.16 - 2 - 3, _bottomTitleView.frame.size.height / 2 - 1.5, 3, 3);
    _rightPointView.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    _rightPointView.layer.cornerRadius = 3 / 2;
    _rightPointView.layer.masksToBounds = YES;
    [_bottomTitleView addSubview:_rightPointView];
    
    
    _personInfoView = [[UIView alloc]init];
    _personInfoView.frame = CGRectMake(0, _bottomDetailView.frame.size.height * 0.1, _bottomDetailView.frame.size.width,_bottomDetailView.frame.size.height * 0.8);
    [_bottomDetailView addSubview:_personInfoView];
    
    
    _personInfo1 = [[UIView alloc]init];
    _personInfo1.frame = CGRectMake(0, 0, _personInfoView.frame.size.width, _personInfoView.frame.size.height * 0.12);
    [_personInfoView addSubview:_personInfo1];
    
    _personImg1 = [[UIImageView alloc]init];
    _personImg1.frame = CGRectMake(0, _personInfo1.frame.size.height * 0.1, _personInfo1.frame.size.height * 0.8, _personInfo1.frame.size.height * 0.8);
    _personImg1.image = [UIImage imageNamed:@"gj_meaccount"];
    [_personInfo1 addSubview:_personImg1];
    
    _personLab1 = [[UILabel alloc]init];
    _personLab1.frame = CGRectMake(_personImg1.frame.size.width + _personInfo1.frame.size.width * 0.05, 0, _personInfo1.frame.size.width - _personInfo1.frame.size.height * 0.8 - _personInfo1.frame.size.width * 0.05, _personInfo1.frame.size.height);
    _personLab1.text = _peopleData.USERNO;
    _personLab1.textColor = [UIColor blackColor];
    _personLab1.font = [UIFont systemFontOfSize:18.0];
    _personLab1.textColor = [UIColor blackColor];
    [_personInfo1 addSubview:_personLab1];
    
    
    
    _personInfo2 = [[UIView alloc]init];
    _personInfo2.frame = CGRectMake(0, _personInfo1.frame.size.height, _personInfoView.frame.size.width, _personInfoView.frame.size.height * 0.12);
    [_personInfoView addSubview:_personInfo2];
    
    
    _personImg2 = [[UIImageView alloc]init];
    _personImg2.frame = CGRectMake(0, _personInfo2.frame.size.height * 0.1, _personInfo2.frame.size.height * 0.8, _personInfo2.frame.size.height * 0.8);
    _personImg2.image = [UIImage imageNamed:@"gj_meperson"];
    [_personInfo2 addSubview:_personImg2];
    
    _personLab2 = [[UILabel alloc]init];
    _personLab2.frame = CGRectMake(_personImg2.frame.size.width + _personInfo2.frame.size.width * 0.05, 0, _personInfo2.frame.size.width - _personInfo2.frame.size.height * 0.8 - _personInfo2.frame.size.width * 0.05, _personInfo2.frame.size.height);
    _personLab2.text = [NSString stringWithFormat:@"%@",_peopleData.SEX == nil ? @"":_peopleData.SEX];
    _personLab2.textColor = [UIColor blackColor];
    _personLab2.font = [UIFont systemFontOfSize:18.0];
    _personLab2.textColor = [UIColor blackColor];
    [_personInfo2 addSubview:_personLab2];
    
    
    _personInfo3 = [[UIView alloc]init];
    _personInfo3.frame = CGRectMake(0, _personInfo2.frame.size.height + _personInfo2.frame.origin.y, _personInfoView.frame.size.width, _personInfoView.frame.size.height * 0.12);
    [_personInfoView addSubview:_personInfo3];
    
    
    _personImg3 = [[UIImageView alloc]init];
    _personImg3.frame = CGRectMake(0, _personInfo3.frame.size.height * 0.1, _personInfo3.frame.size.height * 0.8, _personInfo3.frame.size.height * 0.8);
    _personImg3.image = [UIImage imageNamed:@"gj_mephone"];
    [_personInfo3 addSubview:_personImg3];
    
    _personLab3 = [[UILabel alloc]init];
    _personLab3.frame = CGRectMake(_personImg3.frame.size.width + _personInfo3.frame.size.width * 0.05, 0, _personInfo3.frame.size.width - _personInfo3.frame.size.height * 0.8 - _personInfo3.frame.size.width * 0.05, _personInfo3.frame.size.height);
    _personLab3.text = _peopleData.PHONE;
    _personLab3.textColor = [UIColor blackColor];
    _personLab3.font = [UIFont systemFontOfSize:18.0];
    _personLab3.textColor = [UIColor blackColor];
    [_personInfo3 addSubview:_personLab3];
    
    
    
    _personInfo4 = [[UIView alloc]init];
    _personInfo4.frame = CGRectMake(0, _personInfo3.frame.size.height + _personInfo3.frame.origin.y, _personInfoView.frame.size.width, _personInfoView.frame.size.height * 0.12);
    [_personInfoView addSubview:_personInfo4];
    
    
    _personImg4 = [[UIImageView alloc]init];
    _personImg4.frame = CGRectMake(0, _personInfo4.frame.size.height * 0.1, _personInfo4.frame.size.height * 0.8, _personInfo4.frame.size.height * 0.8);
    _personImg4.image = [UIImage imageNamed:@"gj_medepartment"];
    [_personInfo4 addSubview:_personImg4];
    
    _personLab4 = [[UILabel alloc]init];
    _personLab4.frame = CGRectMake(_personImg4.frame.size.width + _personInfo4.frame.size.width * 0.05, 0, _personInfo4.frame.size.width - _personInfo4.frame.size.height * 0.8 - _personInfo4.frame.size.width * 0.05, _personInfo4.frame.size.height);
    _personLab4.text = _chooseVal;
    _personLab4.textColor = [UIColor blackColor];
    _personLab4.font = [UIFont systemFontOfSize:18.0];
    _personLab4.textColor = [UIColor blackColor];
    [_personInfo4 addSubview:_personLab4];
    //center_yinshi
    UIImageView *yinshi_logo = [[UIImageView alloc] init];
    yinshi_logo.image = [UIImage imageNamed:@"center_yinshi"];
    [_personInfoView addSubview:yinshi_logo];
    
    [yinshi_logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_personInfo4).offset(0);
        make.top.equalTo(_personInfo4.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(_personInfo4.frame.size.height * 0.7, _personInfo4.frame.size.height * 0.7));

    }];
    
    UIButton *yinshi = [UIButton buttonWithType:UIButtonTypeCustom];
    [yinshi setTitle:@"隐私权政策" forState:UIControlStateNormal];
    [yinshi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //http://fs.ipractice.cn/0Privacy/guojinyun_privacy.html
    [_personInfoView addSubview:yinshi];
    [yinshi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_personLab4.mas_left);
        make.centerY.equalTo(yinshi_logo);
        make.height.mas_equalTo(30);
    }];
    [yinshi addTarget:self action:@selector(br_toYingShiAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _getOutBtn = [[UIButton alloc]init];
    _getOutBtn.frame = CGRectMake(0, _personInfoView.frame.size.height - _personInfoView.frame.size.height * 0.18, _personInfoView.frame.size.width, _personInfoView.frame.size.height * 0.18);
    _getOutBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:149/255.0 blue:255/255.0 alpha:1];
    _getOutBtn.layer.cornerRadius = 5;
    _getOutBtn.layer.masksToBounds = YES;
    [_getOutBtn addTarget:self action:@selector(getOutAction:) forControlEvents:UIControlEventTouchUpInside];
    [_getOutBtn setTitle:@"退出" forState:UIControlStateNormal];
    _getOutBtn.font = [UIFont fontWithName:@"Helvetica-Bold" size:22.0];
    [_personInfoView addSubview:_getOutBtn];
    
    
    
    [self setBtnColor:_getOutBtn];
    
}
-(void)br_toYingShiAction{
    NSString *url = @"http://fs.ipractice.cn/0Privacy/guojinyun_privacy.html";
    LDPublicWebViewController *web = [[LDPublicWebViewController alloc] init];
    web.webUrl = url;
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

-(void) getOutAction:(UIButton *)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定退出系统吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1;
    [alert show];
}


-(void) setColor:(UIView *) sender{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:0/255.0 green:149/255.0 blue:255/255.0 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:240/255.0 green:248/255.0 blue:255/255.0 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:248/255. green:248/255.0 blue:248/255.0 alpha:1].CGColor];
    gradientLayer.locations = @[@0.8, @0.9, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, sender.frame.size.width, sender.frame.size.height);
    [sender.layer addSublayer:gradientLayer];
}


-(void) setBtnColor:(UIButton *) sender{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:0/255.0 green:149/255.0 blue:255/255.0 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:0/255.0 green:135/255.0 blue:255/255.0 alpha:1].CGColor];
    gradientLayer.locations = @[@0.3, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, sender.frame.size.width, sender.frame.size.height);
    [sender.layer addSublayer:gradientLayer];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 1:
            if(buttonIndex == 1){
                [AizenStorage removeUserDataWithkey:@"TopModule"];
                [AizenStorage removeUserDataWithkey:@"SubModule"];
                [AizenStorage removeUserDataWithkey:@"isLogin"];
                [AizenStorage removeUserDataWithkey:@"batch"];
                [AizenStorage removeUserDataWithkey:@"batchID"];
                _loginCtl = [[LoginViewController alloc]init];
//                _loginCtl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                _loginCtl.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:_loginCtl animated:YES completion:nil];
            }
            break;
        case 2:
            NSLog(@"设置按钮");
            break;
        default:
            break;
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
