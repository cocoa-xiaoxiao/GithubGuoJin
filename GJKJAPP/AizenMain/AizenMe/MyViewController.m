//
//  MyViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/1/23.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MyViewController.h"
#import "LoginViewController.h"
#import "AizenStorage.h"
#import "People.h"

@interface MyViewController ()<UIScrollViewDelegate,UIAlertViewDelegate>

@property UIScrollView *scrollView;
@property UIImageView *topImgView;
@property UIView *contentView;

@property UIView *ImgShowView;
@property UILabel *NameLab;
@property UILabel *GroupLab;
@property UIView *accountView;
@property UIView *personInfoView;
@property UIView *phoneView;
@property UIView *departmentView;
@property UIView *btnView;

@property LoginViewController *loginCtl;
@property People *peopleData;
@property NSString *chooseVal;


@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //隐藏顶部导航栏
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationItem.title = @"";
    
    NSString *account = [AizenStorage readUserDataWithKey:@"Account"];
    _chooseVal = [AizenStorage readUserDataWithKey:@"ChooseObj"];
    NSArray *peopleArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",account]];
    _peopleData = [peopleArr objectAtIndex:0];
    
    [self startLayout];
}


-(void) startLayout{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -HEIGHT_NAVBAR-HEIGHT_STATUSBAR, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + HEIGHT_STATUSBAR + HEIGHT_TABBAR)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 1);
    [self.view addSubview:_scrollView];
    
    _topImgView = [[UIImageView alloc] init];
    _topImgView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _scrollView.frame.size.height * 0.3);
    _topImgView.contentMode = UIViewContentModeScaleAspectFill;
    _topImgView.image = [UIImage imageNamed:@"gj_metopbg"];
    [_scrollView addSubview:_topImgView];
    
    
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, _topImgView.frame.size.height + _topImgView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height * 0.7)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_contentView];
    
    
    _ImgShowView = [[UIView alloc]initWithFrame:CGRectMake(0, -_scrollView.frame.size.height * 0.05, _scrollView.frame.size.width, _scrollView.frame.size.height * 0.1)];
    [_contentView addSubview:_ImgShowView];
    
    UIView *ImgbgView = [[UIView alloc]initWithFrame:CGRectMake((_ImgShowView.frame.size.width-_ImgShowView.frame.size.height)/2, 0, _ImgShowView.frame.size.height, _ImgShowView.frame.size.height)];
    ImgbgView.backgroundColor = [UIColor whiteColor];
    ImgbgView.layer.cornerRadius = _ImgShowView.frame.size.height / 2;
    ImgbgView.layer.masksToBounds = YES;
    [_ImgShowView addSubview:ImgbgView];
    
    UIImageView *ImgHeaderView = [[UIImageView alloc]initWithFrame:CGRectMake(ImgbgView.frame.size.width * 0.05, ImgbgView.frame.size.width * 0.05, ImgbgView.frame.size.width * 0.9, ImgbgView.frame.size.width * 0.9)];
    ImgHeaderView.image = [UIImage imageNamed:@"gj_msglogo2"];
    ImgHeaderView.layer.masksToBounds = YES;
    ImgHeaderView.layer.cornerRadius = ImgbgView.frame.size.width * 0.9 / 2;
    [ImgbgView addSubview:ImgHeaderView];
    
    _NameLab = [[UILabel alloc]initWithFrame:CGRectMake(_ImgShowView.frame.size.width * 0.35, _ImgShowView.frame.origin.y + _ImgShowView.frame.size.height + 5, _ImgShowView.frame.size.width * 0.3, 20)];
    _NameLab.text = _peopleData.USERNAME;
    _NameLab.textColor = [UIColor blackColor];
    _NameLab.font = [UIFont systemFontOfSize:18.0];
    _NameLab.textAlignment = UITextAlignmentCenter;
    [_contentView addSubview:_NameLab];
    
    _GroupLab = [[UILabel alloc]initWithFrame:CGRectMake(_ImgShowView.frame.size.width * 0.25, _NameLab.frame.origin.y + _NameLab.frame.size.height + 5, _ImgShowView.frame.size.width * 0.5, 20)];
    _GroupLab.text = _peopleData.CLASSNAME;
    _GroupLab.textAlignment = UITextAlignmentCenter;
    _GroupLab.font = [UIFont systemFontOfSize:15.0];
    _GroupLab.textColor = [UIColor colorWithRed:109/255.0 green:115/255.0 blue:119/255.0 alpha:1];
    [_contentView addSubview:_GroupLab];
    
    [self detailLayout];
}


-(void) detailLayout{
    _accountView = [[UIView alloc]initWithFrame:CGRectMake(_contentView.frame.size.width * 0.05, _GroupLab.frame.origin.y + _GroupLab.frame.size.height + 20, _contentView.frame.size.width * 0.9, _contentView.frame.size.height * 0.06)];
//    _accountView.backgroundColor = [UIColor redColor];
    [_contentView addSubview:_accountView];
    
    _personInfoView = [[UIView alloc]initWithFrame:CGRectMake(_contentView.frame.size.width * 0.05, _accountView.frame.origin.y + _accountView.frame.size.height, _contentView.frame.size.width * 0.9, _contentView.frame.size.height * 0.06)];
//    _personInfoView.backgroundColor = [UIColor blueColor];
    [_contentView addSubview:_personInfoView];
    
    _phoneView = [[UIView alloc]initWithFrame:CGRectMake(_contentView.frame.size.width * 0.05, _personInfoView.frame.size.height + _personInfoView.frame.origin.y, _contentView.frame.size.width * 0.9, _contentView.frame.size.height * 0.06)];
//    _phoneView.backgroundColor = [UIColor orangeColor];
    [_contentView addSubview:_phoneView];
    
    _departmentView = [[UIView alloc]initWithFrame:CGRectMake(_contentView.frame.size.width * 0.05, _phoneView.frame.size.height + _phoneView.frame.origin.y, _contentView.frame.size.width * 0.9, _contentView.frame.size.height * 0.06)];
//    _departmentView.backgroundColor = [UIColor greenColor];
    [_contentView addSubview:_departmentView];
    
    
    _btnView = [[UIView alloc]initWithFrame:CGRectMake(_contentView.frame.size.width * 0.05,_departmentView.frame.size.height * 1.5 + _departmentView.frame.origin.y, _contentView.frame.size.width * 0.9, _contentView.frame.size.height * 0.15)];
//    _btnView.backgroundColor = [UIColor blueColor];
    [_contentView addSubview:_btnView];
    
    
    UIImageView *accountImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _accountView.frame.size.height * 0.1, _accountView.frame.size.height * 0.8, _accountView.frame.size.height * 0.8)];
    accountImgView.image = [UIImage imageNamed:@"gj_meaccount"];
    [_accountView addSubview:accountImgView];
    
    UILabel *accountLab = [[UILabel alloc]initWithFrame:CGRectMake(accountImgView.frame.size.width * 1.5 + accountImgView.frame.origin.x, _accountView.frame.size.height * 0.1, _accountView.frame.size.width * 0.5, _accountView.frame.size.height * 0.8)];
    accountLab.text = _peopleData.USERNO;
    accountLab.textColor = [UIColor blackColor];
    accountLab.font = [UIFont systemFontOfSize:18.0];
    [_accountView addSubview:accountLab];
    
    
    UIImageView *personImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _personInfoView.frame.size.height * 0.15, _personInfoView.frame.size.height * 0.7, _personInfoView.frame.size.height * 0.7)];
    personImgView.image = [UIImage imageNamed:@"gj_meperson"];
    [_personInfoView addSubview:personImgView];
    
    UILabel *personLab = [[UILabel alloc]initWithFrame:CGRectMake(personImgView.frame.size.width * 1.7 + personImgView.frame.origin.x, _personInfoView.frame.size.height * 0.1, _personInfoView.frame.size.width * 0.8, _personInfoView.frame.size.height * 0.9)];
    personLab.text = [NSString stringWithFormat:@"%@  %@",_peopleData.SEX,_chooseVal];
    personLab.font = [UIFont systemFontOfSize:18.0];
    [_personInfoView addSubview:personLab];
    
    
    UIImageView *phoneImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _phoneView.frame.size.height * 0.1, _phoneView.frame.size.height * 0.8, _phoneView.frame.size.height * 0.8)];
    phoneImgView.image = [UIImage imageNamed:@"gj_mephone"];
    [_phoneView addSubview:phoneImgView];
    
    UILabel *phoneLab = [[UILabel alloc]initWithFrame:CGRectMake(phoneImgView.frame.size.width * 1.5 + phoneImgView.frame.origin.x, _phoneView.frame.size.height * 0.1, _phoneView.frame.size.width * 0.5, _phoneView.frame.size.height * 0.8)];
    phoneLab.text = _peopleData.PHONE;
    phoneLab.font = [UIFont systemFontOfSize:18.0];
    phoneLab.textColor = [UIColor blackColor];
    [_phoneView addSubview:phoneLab];
    
    
    UIImageView *departmentImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _departmentView.frame.size.height * 0.1, _departmentView.frame.size.height * 0.8, _departmentView.frame.size.height * 0.8)];
    departmentImgView.image = [UIImage imageNamed:@"gj_medepartment"];
    [_departmentView addSubview:departmentImgView];
    
    
    UILabel *departmentLab = [[UILabel alloc]initWithFrame:CGRectMake(departmentImgView.frame.size.width * 1.5, _departmentView.frame.size.height * 0.1, _departmentView.frame.size.width * 0.5, _departmentView.frame.size.height * 0.8)];
    departmentLab.text = _peopleData.COLLEGENAME;
    departmentLab.textColor = [UIColor blackColor];
    departmentLab.font = [UIFont systemFontOfSize:18.0];
    [_departmentView addSubview:departmentLab];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(_contentView.frame.size.width * 0.05, _departmentView.frame.size.height * 1.1 + _departmentView.frame.origin.y, _contentView.frame.size.width * 0.95, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:226/255.0 green:227/255.0 blue:227/255.0 alpha:1];
    [_contentView addSubview:lineView];
    
    
    UIButton *setBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, _btnView.frame.size.height * 0.2, _btnView.frame.size.width * 0.45, _btnView.frame.size.height * 0.6)];
    setBtn.layer.cornerRadius = 10;
    setBtn.layer.masksToBounds = YES;
    [setBtn setTitle:@"设置" forState:UIControlStateNormal];
    setBtn.layer.borderColor = [UIColor grayColor].CGColor;
    setBtn.layer.borderWidth = 1;
    [setBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    setBtn.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    [_btnView addSubview:setBtn];
    
    
    UIButton *logoutBtn = [[UIButton alloc]initWithFrame:CGRectMake(_btnView.frame.size.width - _btnView.frame.size.width * 0.45, _btnView.frame.size.height * 0.2, _btnView.frame.size.width * 0.45, _btnView.frame.size.height * 0.6)];
    logoutBtn.layer.cornerRadius = 10;
    logoutBtn.layer.masksToBounds = YES;
    [logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    logoutBtn.backgroundColor = [UIColor colorWithRed:30/255.0 green:185/255.0 blue:242/255.0 alpha:1];
    [_btnView addSubview:logoutBtn];
    
    
    UITapGestureRecognizer *setTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setAction:)];
    [setBtn addGestureRecognizer:setTap];
    
    
    UITapGestureRecognizer *logoutTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(logoutAction:)];
    [logoutBtn addGestureRecognizer:logoutTap];
}



-(void) setAction:(UITapGestureRecognizer *)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设置功能，敬请期待。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag = 2;
    [alert show];
}

-(void) logoutAction:(UITapGestureRecognizer *)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定退出系统吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1;
    [alert show];
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
                _loginCtl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
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
