//
//  TestSecondViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/2/20.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "TestSecondViewController.h"
#import "RDVTabBarController.h"

@interface TestSecondViewController ()

@property(nonatomic,strong) UIScrollView *contentView;
@property(nonatomic,strong) UIButton *submitBtn;

@property(nonatomic,strong) UIView *compayView;
@property(nonatomic,strong) UILabel *compayTitleLab;
@property(nonatomic,strong) UIView *compayContentView;
@property(nonatomic,strong) UILabel *xydmLab;
@property(nonatomic,strong) UITextField *xydmField;
@property(nonatomic,strong) UILabel *ygrsLab;
@property(nonatomic,strong) UITextField *ygrsField;
@property(nonatomic,strong) UILabel *djdzLab;
@property(nonatomic,strong) UITextField *djdzField;
@property(nonatomic,strong) UIView *compayLine1;
@property(nonatomic,strong) UIView *compayLine2;
@property(nonatomic,strong) UIView *compayLine3;
@property(nonatomic,strong) UILabel *compayImgLab;
@property(nonatomic,strong) UIImageView *compayImgView; 

@property(nonatomic,strong) UIView *staffView;
@property(nonatomic,strong) UILabel *staffTitleLab;
@property(nonatomic,strong) UIView *staffContentView;
@property(nonatomic,strong) UILabel *fzrLab;
@property(nonatomic,strong) UITextField *fzrField;
@property(nonatomic,strong) UILabel *fzrphoneLab;
@property(nonatomic,strong) UITextField *fzrphoneField;
@property(nonatomic,strong) UILabel *gwrsLab;
@property(nonatomic,strong) UITextField *gwrsField;
@property(nonatomic,strong) UILabel *gwmcLab;
@property(nonatomic,strong) UITextField *gwmcField;
@property(nonatomic,strong) UIView *staffLine1;
@property(nonatomic,strong) UIView *staffLine2;
@property(nonatomic,strong) UIView *staffLine3;

@property(nonatomic,strong) UIView *relationshipView;
@property(nonatomic,strong) UILabel *relationshipTitleLab;
@property(nonatomic,strong) UIView *relationshipContentView;



@end

@implementation TestSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"详细信息";
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];     
    
    [self startLayout];
}

-(void) startLayout{
    _contentView = [[UIScrollView alloc]init];
    _contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - (self.view.frame.size.height) * 0.08);
    _contentView.contentMode = UIViewContentModeTop;
    _contentView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_contentView];
    
    
    _compayView = [[UIView alloc]init];
    _compayView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height * 0.08 * 5);
    [_contentView addSubview:_compayView];
    
    
    _compayTitleLab = [[UILabel alloc]init];
    _compayTitleLab.frame = CGRectMake(_compayView.frame.size.width * 0.05, 0, _compayView.frame.size.width * 0.9, _contentView.frame.size.height * 0.08);
    _compayTitleLab.text = @"企业信息";
    _compayTitleLab.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [_compayView addSubview:_compayTitleLab];

    _compayContentView = [[UIView alloc]init];
    _compayContentView.frame = CGRectMake(0,_compayTitleLab.frame.size.height + _compayTitleLab.frame.origin.y, _compayView.frame.size.width, _compayView.frame.size.height - _compayTitleLab.frame.size.height);
    _compayContentView.backgroundColor = [UIColor whiteColor];
    [_compayView addSubview:_compayContentView];
    
    
    _staffView = [[UIView alloc]init];
    _staffView.frame = CGRectMake(0, _compayView.frame.size.height + _compayView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height * 0.08 * 5);
    [_contentView addSubview:_staffView];
    
    _staffTitleLab = [[UILabel alloc]init];
    _staffTitleLab.frame = CGRectMake(_staffView.frame.size.width * 0.05, 0, _staffView.frame.size.width * 0.9, _contentView.frame.size.height * 0.08);
    _staffTitleLab.text = @"岗位信息";
    _staffTitleLab.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [_staffView addSubview:_staffTitleLab];
    
    _staffContentView = [[UIView alloc]init];
    _staffContentView.frame = CGRectMake(0,_staffTitleLab.frame.size.height + _staffTitleLab.frame.origin.y, _staffView.frame.size.width, _staffView.frame.size.height - _staffTitleLab.frame.size.height);
    _staffContentView.backgroundColor = [UIColor whiteColor];
    [_staffView addSubview:_staffContentView];

    
    
    [self compayLayout];
    [self staffLayout];
    
    
    _submitBtn = [[UIButton alloc]init];
    _submitBtn.frame = CGRectMake(0, _contentView.frame.size.height + _contentView.frame.origin.y, self.view.frame.size.width, (self.view.frame.size.height) * 0.08);
    _submitBtn.backgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.view addSubview:_submitBtn];
}

-(void) compayLayout{
    _xydmLab = [[UILabel alloc]init];
    _xydmLab.frame = CGRectMake(_compayContentView.frame.size.width * 0.05, 0, _compayContentView.frame.size.width * 0.25, _contentView.frame.size.height * 0.08);
    _xydmLab.text = @"信用代码：";
    _xydmLab.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
    [_compayContentView addSubview:_xydmLab];
    
    
    _xydmField = [[UITextField alloc]init];
    _xydmField.frame = CGRectMake(_xydmLab.frame.size.width + _xydmLab.frame.origin.x, 0, _compayContentView.frame.size.width * 0.6, _contentView.frame.size.height * 0.08);
    _xydmField.placeholder = @"请输入信用代码";
    [_compayContentView addSubview:_xydmField];
    
    _compayLine1 = [[UIView alloc]init];
    _compayLine1.frame = CGRectMake(_compayContentView.frame.size.width * 0.05, _xydmLab.frame.size.height + _xydmLab.frame.origin.y - 1, _compayContentView.frame.size.width * 0.9, 1);
    _compayLine1.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1];
    [_compayContentView addSubview:_compayLine1];
    
    _ygrsLab = [[UILabel alloc]init];
    _ygrsLab.frame = CGRectMake(_compayContentView.frame.size.width * 0.05, _compayLine1.frame.size.height + _compayLine1.frame.origin.y, _compayContentView.frame.size.width * 0.25, _contentView.frame.size.height * 0.08);
    _ygrsLab.text = @"员工人数：";
    _ygrsLab.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
    [_compayContentView addSubview:_ygrsLab];
    
    _ygrsField = [[UITextField alloc]init];
    _ygrsField.frame = CGRectMake(_ygrsLab.frame.size.width + _ygrsLab.frame.origin.x, _compayLine1.frame.size.height + _compayLine1.frame.origin.y, _compayContentView.frame.size.width * 0.6, _contentView.frame.size.height * 0.08);
    _ygrsField.placeholder = @"请输入员工人数";
    [_compayContentView addSubview:_ygrsField];
    
    
    _compayLine2 = [[UIView alloc]init];
    _compayLine2.frame = CGRectMake(_compayContentView.frame.size.width * 0.05, _ygrsLab.frame.size.height + _ygrsLab.frame.origin.y - 1, _compayContentView.frame.size.width * 0.9, 1);
    _compayLine2.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1];
    [_compayContentView addSubview:_compayLine2];
    
    
    _djdzLab = [[UILabel alloc]init];
    _djdzLab.frame = CGRectMake(_compayContentView.frame.size.width * 0.05, _compayLine2.frame.size.height + _compayLine2.frame.origin.y, _compayContentView.frame.size.width * 0.25, _contentView.frame.size.height * 0.08);
    _djdzLab.text = @"登记地址：";
    _djdzLab.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
    [_compayContentView addSubview:_djdzLab];
    
    _djdzField = [[UITextField alloc]init];
    _djdzField.frame = CGRectMake(_djdzLab.frame.size.width + _djdzLab.frame.origin.x, _compayLine2.frame.size.height + _compayLine2.frame.origin.y, _compayContentView.frame.size.width * 0.6, _contentView.frame.size.height * 0.08);
    _djdzField.placeholder = @"请输入登记地址";
    [_compayContentView addSubview:_djdzField];
    
    
    _compayLine3 = [[UIView alloc]init];
    _compayLine3.frame = CGRectMake(_compayContentView.frame.size.width * 0.05, _djdzLab.frame.size.height + _djdzLab.frame.origin.y - 1, _compayContentView.frame.size.width * 0.9, 1);
    _compayLine3.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1];
    [_compayContentView addSubview:_compayLine3];
    
    
    _compayImgLab = [[UILabel alloc]init];
    _compayImgLab.frame = CGRectMake(_compayContentView.frame.size.width * 0.05, _compayLine3.frame.size.height + _compayLine3.frame.origin.y, _compayContentView.frame.size.width * 0.25, _contentView.frame.size.height * 0.08);
    _compayImgLab.text = @"企业照片：";
    _compayImgLab.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
    [_compayContentView addSubview:_compayImgLab];
    
    
    UIImageView *test = [[UIImageView alloc]init];
    test.frame = CGRectMake(_compayImgLab.frame.size.width + _compayImgLab.frame.origin.x, _compayLine3.frame.size.height + _compayLine3.frame.origin.y + _contentView.frame.size.height * 0.01, _contentView.frame.size.height * 0.06, _contentView.frame.size.height * 0.06);
    test.image = [UIImage imageNamed:@"gj_addimg"];
    [_compayContentView addSubview:test];

    
}


-(void) staffLayout{
    _fzrLab = [[UILabel alloc]init];
    _fzrLab.frame = CGRectMake(_staffContentView.frame.size.width * 0.05, 0, _staffContentView.frame.size.width * 0.3, _contentView.frame.size.height * 0.08);
    _fzrLab.text = @"负责人名称：";
    _fzrLab.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
    [_staffContentView addSubview:_fzrLab];
    
    
    _fzrField = [[UITextField alloc]init];
    _fzrField.frame = CGRectMake(_fzrLab.frame.size.width + _fzrLab.frame.origin.x, 0, _staffContentView.frame.size.width * 0.55, _contentView.frame.size.height * 0.08);
    _fzrField.placeholder = @"请输入负责人名称";
    [_staffContentView addSubview:_fzrField];
    
    _staffLine1 = [[UIView alloc]init];
    _staffLine1.frame = CGRectMake(_staffContentView.frame.size.width * 0.05, _fzrLab.frame.size.height + _fzrLab.frame.origin.y - 1, _staffContentView.frame.size.width * 0.9, 1);
    _staffLine1.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1];
    [_staffContentView addSubview:_staffLine1];
    
    _fzrphoneLab = [[UILabel alloc]init];
    _fzrphoneLab.frame = CGRectMake(_staffContentView.frame.size.width * 0.05, _staffLine1.frame.size.height + _staffLine1.frame.origin.y, _staffContentView.frame.size.width * 0.3, _contentView.frame.size.height * 0.08);
    _fzrphoneLab.text = @"负责人电话：";
    _fzrphoneLab.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
    [_staffContentView addSubview:_fzrphoneLab];
    
    _fzrphoneField = [[UITextField alloc]init];
    _fzrphoneField.frame = CGRectMake(_fzrphoneLab.frame.size.width + _fzrphoneLab.frame.origin.x, _staffLine1.frame.size.height + _staffLine1.frame.origin.y, _staffContentView.frame.size.width * 0.55, _contentView.frame.size.height * 0.08);
    _fzrphoneField.placeholder = @"请输入负责人电话";
    [_staffContentView addSubview:_fzrphoneField];
    
    
    _staffLine2 = [[UIView alloc]init];
    _staffLine2.frame = CGRectMake(_staffContentView.frame.size.width * 0.05, _fzrphoneLab.frame.size.height + _fzrphoneLab.frame.origin.y - 1, _staffContentView.frame.size.width * 0.9, 1);
    _staffLine2.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1];
    [_staffContentView addSubview:_staffLine2];
    
    
    _gwrsLab = [[UILabel alloc]init];
    _gwrsLab.frame = CGRectMake(_staffContentView.frame.size.width * 0.05, _staffLine2.frame.size.height + _staffLine2.frame.origin.y, _staffContentView.frame.size.width * 0.3, _contentView.frame.size.height * 0.08);
    _gwrsLab.text = @"岗位人数：";
    _gwrsLab.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
    [_staffContentView addSubview:_gwrsLab];
    
    _gwrsField = [[UITextField alloc]init];
    _gwrsField.frame = CGRectMake(_gwrsLab.frame.size.width + _gwrsLab.frame.origin.x, _staffLine2.frame.size.height + _staffLine2.frame.origin.y, _staffContentView.frame.size.width * 0.55, _contentView.frame.size.height * 0.08);
    _gwrsField.placeholder = @"请输入岗位人数";
    [_staffContentView addSubview:_gwrsField];
    
    
    _staffLine3 = [[UIView alloc]init];
    _staffLine3.frame = CGRectMake(_staffContentView.frame.size.width * 0.05, _gwrsLab.frame.size.height + _gwrsLab.frame.origin.y - 1, _staffContentView.frame.size.width * 0.9, 1);
    _staffLine3.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1];
    [_staffContentView addSubview:_staffLine3];
    
    _gwmcLab = [[UILabel alloc]init];
    _gwmcLab.frame = CGRectMake(_staffContentView.frame.size.width * 0.05, _staffLine3.frame.size.height + _staffLine3.frame.origin.y, _staffContentView.frame.size.width * 0.3, _contentView.frame.size.height * 0.08);
    _gwmcLab.text = @"岗位名称：";
    _gwmcLab.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
    [_staffContentView addSubview:_gwmcLab];
    
    _gwmcField = [[UITextField alloc]init];
    _gwmcField.frame = CGRectMake(_gwmcLab.frame.size.width + _gwmcLab.frame.origin.x, _staffLine3.frame.size.height + _staffLine3.frame.origin.y, _staffContentView.frame.size.width * 0.55, _contentView.frame.size.height * 0.08);
    _gwmcField.placeholder = @"请输入岗位名称";
    [_staffContentView addSubview:_gwmcField];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
