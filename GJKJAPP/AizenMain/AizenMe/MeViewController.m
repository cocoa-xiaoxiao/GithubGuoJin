//
//  MeViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/1/12.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MeViewController.h"

@interface MeViewController ()<UIScrollViewDelegate>

@property UIScrollView *scrollView;
@property UIView *cardView;
@property UIView *personView;
@property UIView *lineView;
@property UIView *setView;
@property UILabel *nameLab;
@property UILabel *departmentLab;
@property UILabel *statusLab;
@property UIImageView *headView;
@property UIImageView *statusView;
@property UIView *cardLineView;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    //隐藏顶部导航栏
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationItem.title = @"";
    
    [self startLayout];
    
}

-(void) startLayout{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_TABBAR)];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 1);
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    
    _cardView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.05, - HEIGHT_TABBAR / 2, self.view.frame.size.width * 0.9, self.view.frame.size.height * 0.3)];
    _cardView.layer.cornerRadius = 8;
    _cardView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:231/255.0 blue:231/255.0 alpha:1].CGColor;
    _cardView.layer.borderWidth = 1;
    _cardView.layer.shadowOpacity = 0.5;// 阴影透明度
    _cardView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    _cardView.layer.shadowRadius = 7;
    [_scrollView addSubview:_cardView];
    
    
    _personView = [[UIView alloc]initWithFrame:CGRectMake(0, _cardView.frame.size.height * 1.05 + _cardView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height * 0.07 * 4)];
    [_scrollView addSubview:_personView];
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _personView.frame.size.height + _personView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height * 0.01)];
    _lineView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [_scrollView addSubview:_lineView];
    
    
    _setView = [[UIView alloc]initWithFrame:CGRectMake(0, _lineView.frame.size.height + _lineView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height * 0.07)];
    [_scrollView addSubview:_setView];
    
    [self detailLayout];
    
}


-(void) detailLayout{
    _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(_cardView.frame.size.width * 0.05, _cardView.frame.size.height * 0.1, _cardView.frame.size.width * 0.45, _cardView.frame.size.height * 0.2)];
    _nameLab.text = @"张小二";
    _nameLab.textColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1];
    _nameLab.font = [UIFont fontWithName:@"Courier-Oblique" size:20];
    [_cardView addSubview:_nameLab];
    
    
    _headView = [[UIImageView alloc]initWithFrame:CGRectMake(_cardView.frame.size.width * 0.95 - _cardView.frame.size.width * 0.2, _cardView.frame.size.height * 0.1, _cardView.frame.size.width * 0.2, _cardView.frame.size.width * 0.2)];
    _headView.image = [UIImage imageNamed:@"gj_msglogo2"];
    _headView.layer.cornerRadius = _headView.frame.size.width / 2;
    _headView.layer.masksToBounds = YES;
    [_cardView addSubview:_headView];
    
    _cardLineView = [[UIView alloc]initWithFrame:CGRectMake(_cardView.frame.size.width * 0.05, _cardView.frame.size.height * 0.8, _cardView.frame.size.width * 0.9, 1)];
    _cardLineView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [_cardView addSubview:_cardLineView];
    
    _departmentLab = [[UILabel alloc]initWithFrame:CGRectMake(_cardView.frame.size.width * 0.05, _cardLineView.frame.origin.y - _cardView.frame.size.height * 0.2, _cardView.frame.size.width * 0.9, _cardView.frame.size.height * 0.15)];
    _departmentLab.text = @"软件技术1班";
    _departmentLab.textColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1];
    _departmentLab.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:18];
    [_cardView addSubview:_departmentLab];
    
    UIImageView *roleImgView = [[UIImageView alloc]initWithFrame:CGRectMake(_departmentLab.frame.origin.x, _departmentLab.frame.origin.y - _departmentLab.frame.size.height * 1.2, _cardView.frame.size.height * 0.12, _cardView.frame.size.height * 0.12)];
    roleImgView.image = [UIImage imageNamed:@"gj_merole"];
    [_cardView addSubview:roleImgView];
    
    UILabel *roleLab = [[UILabel alloc]initWithFrame:CGRectMake(roleImgView.frame.size.width * 1.5 + roleImgView.frame.origin.x, roleImgView.frame.origin.y, _cardView.frame.size.width * 0.2, roleImgView.frame.size.height)];
    roleLab.text = @"学生";
    roleLab.font = [UIFont systemFontOfSize:14.0];
    roleLab.textColor = [UIColor colorWithRed:190/255.0 green:193/255.0 blue:195/255.0 alpha:1];
    [_cardView addSubview:roleLab];
    
    _statusView = [[UIImageView alloc]initWithFrame:CGRectMake(_cardView.frame.size.width * 0.05, _cardLineView.frame.origin.y + _cardView.frame.size.height * 0.05,_cardView.frame.size.height * 0.1, _cardView.frame.size.height * 0.1)];
    _statusView.image = [UIImage imageNamed:@"gj_worklogo"];
    [_cardView addSubview:_statusView];
    
    _statusLab = [[UILabel alloc]initWithFrame:CGRectMake(_statusView.frame.size.width * 1.5 + _statusView.frame.origin.x, _statusView.frame.origin.y, _cardView.frame.size.width * 0.5, _cardView.frame.size.height * 0.1)];
    _statusLab.text = @"上下班";
    _statusLab.textColor = [UIColor grayColor];
    _statusLab.font = [UIFont systemFontOfSize:15];
    [_cardView addSubview:_statusLab];
    
    
    /*--------------------------------性别设计------------------------------------*/
    UIView *sexView = [[UIView alloc]initWithFrame:CGRectMake(_personView.frame.size.width * 0.05, 0, _personView.frame.size.width * 0.95,_scrollView.frame.size.height * 0.07)];
    [_personView addSubview:sexView];
    
    UIImageView *sexImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, sexView.frame.size.height * 0.1, sexView.frame.size.height * 0.8, sexView.frame.size.height * 0.8)];
    sexImgView.image = [UIImage imageNamed:@"gj_sexmale"];
    [sexView addSubview:sexImgView];
    
    UILabel *sexLab = [[UILabel alloc]initWithFrame:CGRectMake(sexImgView.frame.size.width * 1.5 + sexImgView.frame.origin.x, sexImgView.frame.origin.y, sexView.frame.size.width * 0.5, sexView.frame.size.height * 0.8)];
    sexLab.text = @"男";
    sexLab.font = [UIFont systemFontOfSize:17.0];
    sexLab.textColor = [UIColor colorWithRed:54/255.0 green:59/255.0 blue:64/255.0 alpha:1];
    [sexView addSubview:sexLab];
    
    UIView *sexLine = [[UIView alloc]initWithFrame:CGRectMake(0, sexView.frame.size.height - 1, sexView.frame.size.width, 1)];
    sexLine.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    [sexView addSubview:sexLine];
    
    
    UIImageView *sexMoreView = [[UIImageView alloc]initWithFrame:CGRectMake(sexView.frame.size.width - sexView.frame.size.height * 0.6 - _personView.frame.size.width * 0.05, sexView.frame.size.height * 0.2, sexView.frame.size.height * 0.6, sexView.frame.size.height * 0.6)];
    sexMoreView.image = [UIImage imageNamed:@"gj_memore"];
    [sexView addSubview:sexMoreView];
    
    
    /*--------------------------------出生设计------------------------------------*/
    UIView *birthView = [[UIView alloc]initWithFrame:CGRectMake(_personView.frame.size.width * 0.05, sexView.frame.size.height, _personView.frame.size.width * 0.95,_scrollView.frame.size.height * 0.07)];
    [_personView addSubview:birthView];
    
    UIImageView *birthImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, birthView.frame.size.height * 0.1, birthView.frame.size.height * 0.8, birthView.frame.size.height * 0.8)];
    birthImgView.image = [UIImage imageNamed:@"gj_mebirth"];
    [birthView addSubview:birthImgView];
    
    UILabel *birthLab = [[UILabel alloc]initWithFrame:CGRectMake(birthImgView.frame.size.width * 1.5 + birthImgView.frame.origin.x, birthImgView.frame.origin.y, birthView.frame.size.width * 0.5, birthView.frame.size.height * 0.8)];
    birthLab.text = @"1990-1-1";
    birthLab.font = [UIFont systemFontOfSize:17.0];
    birthLab.textColor = [UIColor colorWithRed:54/255.0 green:59/255.0 blue:64/255.0 alpha:1];
    [birthView addSubview:birthLab];
    
    UIView *birthLine = [[UIView alloc]initWithFrame:CGRectMake(0, birthView.frame.size.height - 1, birthView.frame.size.width, 1)];
    birthLine.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    [birthView addSubview:birthLine];
    
    UIImageView *birthMoreView = [[UIImageView alloc]initWithFrame:CGRectMake(birthView.frame.size.width - birthView.frame.size.height * 0.6 - _personView.frame.size.width * 0.05, birthView.frame.size.height * 0.2, birthView.frame.size.height * 0.6, birthView.frame.size.height * 0.6)];
    birthMoreView.image = [UIImage imageNamed:@"gj_memore"];
    [birthView addSubview:birthMoreView];
    
    /*--------------------------------重置密码设计------------------------------------*/
    UIView *resetView = [[UIView alloc]initWithFrame:CGRectMake(_personView.frame.size.width * 0.05, birthView.frame.size.height + birthView.frame.origin.y, _personView.frame.size.width * 0.95,_scrollView.frame.size.height * 0.07)];
    [_personView addSubview:resetView];
    
    UIImageView *resetImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, resetView.frame.size.height * 0.1, resetView.frame.size.height * 0.8, resetView.frame.size.height * 0.8)];
    resetImgView.image = [UIImage imageNamed:@"gj_mereset"];
    [resetView addSubview:resetImgView];
    
    UILabel *resetLab = [[UILabel alloc]initWithFrame:CGRectMake(resetImgView.frame.size.width * 1.5 + resetImgView.frame.origin.x, resetImgView.frame.origin.y, resetView.frame.size.width * 0.5, resetView.frame.size.height * 0.8)];
    resetLab.text = @"重置密码";
    resetLab.font = [UIFont systemFontOfSize:17.0];
    resetLab.textColor = [UIColor colorWithRed:54/255.0 green:59/255.0 blue:64/255.0 alpha:1];
    [resetView addSubview:resetLab];
    
    UIView *resetLine = [[UIView alloc]initWithFrame:CGRectMake(0, resetView.frame.size.height - 1, resetView.frame.size.width, 1)];
    resetLine.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    [resetView addSubview:resetLine];
    
    UIImageView *resetMoreView = [[UIImageView alloc]initWithFrame:CGRectMake(resetView.frame.size.width - resetView.frame.size.height * 0.6 - _personView.frame.size.width * 0.05, resetView.frame.size.height * 0.2, resetView.frame.size.height * 0.6, resetView.frame.size.height * 0.6)];
    resetMoreView.image = [UIImage imageNamed:@"gj_memore"];
    [resetView addSubview:resetMoreView];
    
    
    
    /*--------------------------------重置密码设计------------------------------------*/
    UIView *helpView = [[UIView alloc]initWithFrame:CGRectMake(_personView.frame.size.width * 0.05, resetView.frame.size.height + resetView.frame.origin.y, _personView.frame.size.width * 0.95,_scrollView.frame.size.height * 0.07)];
    [_personView addSubview:helpView];
    
    UIImageView *helpImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, helpView.frame.size.height * 0.1, helpView.frame.size.height * 0.8, helpView.frame.size.height * 0.8)];
    helpImgView.image = [UIImage imageNamed:@"gj_mehelp"];
    [helpView addSubview:helpImgView];
    
    UILabel *helpLab = [[UILabel alloc]initWithFrame:CGRectMake(helpImgView.frame.size.width * 1.5 + helpImgView.frame.origin.x, helpImgView.frame.origin.y, helpView.frame.size.width * 0.5, helpView.frame.size.height * 0.8)];
    helpLab.text = @"帮助";
    helpLab.font = [UIFont systemFontOfSize:17.0];
    helpLab.textColor = [UIColor colorWithRed:54/255.0 green:59/255.0 blue:64/255.0 alpha:1];
    [helpView addSubview:helpLab];
    
    
    UIImageView *helpMoreView = [[UIImageView alloc]initWithFrame:CGRectMake(helpView.frame.size.width - helpView.frame.size.height * 0.6 - _personView.frame.size.width * 0.05, helpView.frame.size.height * 0.2, helpView.frame.size.height * 0.6, helpView.frame.size.height * 0.6)];
    helpMoreView.image = [UIImage imageNamed:@"gj_memore"];
    [helpView addSubview:helpMoreView];
    
    
    /*--------------------------------设置设计------------------------------------*/
    UIView *allsetView = [[UIView alloc]initWithFrame:CGRectMake(_setView.frame.size.width * 0.05, 0, _setView.frame.size.width * 0.95,_scrollView.frame.size.height * 0.07)];
    [_setView addSubview:allsetView];
    
    UIImageView *allsetImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, allsetView.frame.size.height * 0.1, allsetView.frame.size.height * 0.8, allsetView.frame.size.height * 0.8)];
    allsetImgView.image = [UIImage imageNamed:@"gj_meset"];
    [allsetView addSubview:allsetImgView];
    
    UILabel *allsetLab = [[UILabel alloc]initWithFrame:CGRectMake(allsetImgView.frame.size.width * 1.5 + allsetImgView.frame.origin.x, allsetImgView.frame.origin.y, allsetView.frame.size.width * 0.5, allsetView.frame.size.height * 0.8)];
    allsetLab.text = @"设置";
    allsetLab.font = [UIFont systemFontOfSize:17.0];
    allsetLab.textColor = [UIColor colorWithRed:54/255.0 green:59/255.0 blue:64/255.0 alpha:1];
    [allsetView addSubview:allsetLab];
    
    UIImageView *allsetMoreView = [[UIImageView alloc]initWithFrame:CGRectMake(allsetView.frame.size.width - allsetView.frame.size.height * 0.6 - _setView.frame.size.width * 0.05, allsetView.frame.size.height * 0.2, allsetView.frame.size.height * 0.6, allsetView.frame.size.height * 0.6)];
    allsetMoreView.image = [UIImage imageNamed:@"gj_memore"];
    [allsetView addSubview:allsetMoreView];
    
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    if (translation.y < 0) {
        /*向上拉*/
        
    } else {
        /*向下拉*/
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
