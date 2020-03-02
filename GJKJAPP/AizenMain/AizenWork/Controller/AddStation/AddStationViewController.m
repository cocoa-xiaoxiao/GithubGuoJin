//
//  AddStationViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/3/1.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "AddStationViewController.h"
#import "RDVTabBarController.h"
#import "RadioBoxFun.h"
#import "RAlertView.h"
#import "AddStationTwoViewController.h"
#import "CompanyDetailViewController.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import <IQKeyboardManager/IQPreviousNextView.h>

#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface AddStationViewController ()

@property(nonatomic,strong) UIView *contentView;

@property(nonatomic,strong) UIView *titleView;
@property(nonatomic,retain) UILabel *titleLab;

@property(nonatomic,strong) UIView *companyView;
@property(nonatomic,strong) UILabel *companyLab;
@property(nonatomic,strong) UILabel *companyField; //企业名称

@property(nonatomic,strong) UIView *companyCodeView;
@property(nonatomic,strong) UILabel *companyCodeLab;
@property(nonatomic,strong) BaseTextFeild *companyCodeField;//企业代码

@property(nonatomic,strong) UIView *peopleCountView;
@property(nonatomic,strong) UILabel *peopleCountLab;
@property(nonatomic,strong) BaseTextFeild *peopleCountField; //人数

@property(nonatomic,strong) UIView *addressView;
@property(nonatomic,strong) UILabel *addressLab;
@property(nonatomic,strong) BaseTextFeild *addressField; //企业地址

@property(nonatomic,strong) UIView *baseView;
@property(nonatomic,strong) UILabel *baseLab;
@property(nonatomic,strong) UIView *baseField;
@property(nonatomic,strong) UISwitch *baseSwitch; //是否基地实习

@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UILabel *bottomLab;

@property(nonatomic,strong) UIButton *nextBtn;


@property(nonatomic,strong) NSString *uploadID; //企业ID
@property(nonatomic,strong) NSString *uploadQYName; //企业名字
@property(nonatomic,strong) NSString *uploadQYCode; //企业代码
@property(nonatomic,strong) NSString *uploadQYTotal; //企业人数
@property(nonatomic,strong) NSString *uploadQYAddress; //企业地址


@end

@implementation AddStationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"企业提交";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    _getCompanyDic = [[NSDictionary alloc]init];
    [self startLayout];
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = backBtnItem ;
}

-(void) startLayout{
    _contentView = [[IQPreviousNextView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, self.view.frame.size.width, self.view.frame.size.height - (HEIGHT_STATUSBAR + HEIGHT_NAVBAR));
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.userInteractionEnabled = YES;
    [self.view addSubview:_contentView];
    
    _nextBtn = [[UIButton alloc]init];
    _nextBtn.frame = CGRectMake(0, _contentView.frame.size.height - HEIGHT_TABBAR, _contentView.frame.size.width, HEIGHT_TABBAR);
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBtn.backgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    [_nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_nextBtn];
    
    _titleView = [[UIView alloc]init];
    _titleView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height * 0.08);
    [_contentView addSubview:_titleView];
    
    _titleLab = [[UILabel alloc]init];
    _titleLab.frame = CGRectMake(_titleView.frame.size.width * 0.05, 0, _titleView.frame.size.width * 0.45, _titleView.frame.size.height);
    _titleLab.text = @"企业信息";
    _titleLab.font = [UIFont systemFontOfSize:18.0];
    _titleLab.textColor = [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1];
    [_titleView addSubview:_titleLab];
    
    _companyView = [self normalView];
    _companyView.frame = CGRectMake(_contentView.frame.size.width * 0.02 , _titleView.frame.origin.y + _titleView.frame.size.height, _contentView.frame.size.width * 0.96, _contentView.frame.size.height * 0.08);
    _companyView.backgroundColor = [UIColor whiteColor];
    _companyView.userInteractionEnabled = YES;
    [_contentView addSubview:_companyView];

    _companyField = [[UILabel alloc]init];
    _companyField.frame = CGRectMake(_companyView.size.height * 0.85 , 0, _companyView.frame.size.width * 0.45, _companyView.frame.size.height);
    _companyField.text = @"请输入企业名称";
    _companyField.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:205/255.0 alpha:1];
    _companyField.textAlignment = NSTextAlignmentLeft;
    _companyField.font = [UIFont systemFontOfSize:16.0];
    _companyField.userInteractionEnabled = YES;
    UITapGestureRecognizer *companyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyAction:)];
    [_companyField addGestureRecognizer:companyTap];
    [_companyView addSubview:_companyField];

    _companyCodeView = [self normalView];
    _companyCodeView.frame = CGRectMake(_contentView.frame.size.width * 0.02 , _companyView.xo_bottomY + _contentView.xo_width * 0.03, _contentView.frame.size.width * 0.96, _contentView.frame.size.height * 0.08);
    _companyCodeView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_companyCodeView];

    _companyCodeField = [[BaseTextFeild alloc]init];
    _companyCodeField.frame = CGRectMake(_companyCodeView.size.height * 0.85 , 0, _companyCodeView.frame.size.width * 0.45, _companyCodeView.frame.size.height);
    _companyCodeField.placeholder = @"请输入统一信用代码";
    _companyCodeField.textAlignment = NSTextAlignmentLeft;
    _companyCodeField.font = [UIFont systemFontOfSize:16.0];
    [_companyCodeView addSubview:_companyCodeField];
    _companyCodeField.delegate = self;

    _addressView = [self normalView];
    _addressView.frame = CGRectMake(_contentView.frame.size.width * 0.02 , _companyCodeView.xo_bottomY + _contentView.xo_width * 0.03, _contentView.frame.size.width * 0.96, _contentView.frame.size.height * 0.08);
    _addressView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_addressView];

    _addressField = [[BaseTextFeild alloc]init];
    _addressField.frame = CGRectMake(_addressView.size.height * 0.85 , 0, _companyCodeView.frame.size.width * 0.45, _companyCodeView.frame.size.height);
    _addressField.placeholder = @"请输入企业地址";
    _addressField.textAlignment = NSTextAlignmentLeft;
    _addressField.font = [UIFont systemFontOfSize:16.0];
    [_addressView addSubview:_addressField];
    _addressField.delegate = self;

    _peopleCountView = [self normalView];
    _peopleCountView.frame = CGRectMake(_contentView.frame.size.width * 0.02 , _addressView.xo_bottomY + _contentView.xo_width * 0.03, _contentView.frame.size.width * 0.96, _contentView.frame.size.height * 0.08);
    _peopleCountView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_peopleCountView];

    _peopleCountField = [[BaseTextFeild alloc]init];
    _peopleCountField.frame = CGRectMake(_peopleCountView.size.height * 0.85 , 0, _companyCodeView.frame.size.width * 0.45, _companyCodeView.frame.size.height);
    _peopleCountField.placeholder = @"请输入职工总数";
    _peopleCountField.textAlignment = NSTextAlignmentLeft;
    _peopleCountField.font = [UIFont systemFontOfSize:16.0];
    [_peopleCountView addSubview:_peopleCountField];
    _peopleCountField.delegate = self;
    _peopleCountField.keyboardType = UIKeyboardTypeNumberPad;

    _baseView = [self normalView];
    _baseView.frame = CGRectMake(_contentView.frame.size.width * 0.02 , _peopleCountView.xo_bottomY + _contentView.xo_width * 0.03, _contentView.frame.size.width * 0.96, _contentView.frame.size.height * 0.08);
    _baseView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_baseView];

    _baseLab = [[UILabel alloc]init];
    _baseLab.frame = CGRectMake(_peopleCountView.size.height * 0.85, 0, _baseView.frame.size.width * 0.45, _baseView.frame.size.height);
    _baseLab.text = @"是否实习基地";
    _baseLab.textColor = [UIColor blackColor];
    _baseLab.font = [UIFont systemFontOfSize:16.0];
    [_baseView addSubview:_baseLab];


    _baseField = [[UIView alloc]init];
    _baseField.frame = CGRectMake(_baseLab.frame.origin.x + _baseLab.frame.size.width, 0, _baseView.frame.size.width * 0.40, _baseView.frame.size.height);
    [_baseView addSubview:_baseField];
    
    _baseSwitch = [[UISwitch alloc]init];
    _baseSwitch.frame = CGRectMake(_baseField.frame.size.width * 0.7,0, _baseField.frame.size.width * 0.3, _baseView.frame.size.height);
    _baseSwitch.on = NO;
    _baseSwitch.xo_centerY = _baseField.center.y;
    [_baseField addSubview:_baseSwitch];


    _bottomView = [[UIView alloc]init];
    _bottomView.frame = CGRectMake(0, _baseView.frame.size.height + _baseView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height * 0.08);
    [_contentView addSubview:_bottomView];

    _bottomLab = [[UILabel alloc]init];
    _bottomLab.frame = CGRectMake(_bottomView.frame.size.width * 0.05, 0, _bottomView.frame.size.width * 0.45, _bottomView.frame.size.height);
    _bottomLab.text = @"第一步，共五步";
    _bottomLab.font = [UIFont systemFontOfSize:13.0];
    _bottomLab.textColor = [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1];
    [_bottomView addSubview:_bottomLab];
    
}

-(UIView *)normalView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,_contentView.frame.size.width * 0.96, _contentView.frame.size.height * 0.08)];
    view.layer.cornerRadius = 5;
    view.layer.borderWidth = 2.f;
    view.layer.borderColor = RGB_HEX(0xEBEBEB, 1).CGColor;
    
    UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, view.size.height * 0.10, view.size.height * 0.8, view.size.height * 0.8)];
    imagev.image = [UIImage imageNamed:@"ic_findpws_warnlog"];
    [view addSubview:imagev];
    
    return view;
}

- (NSString *)br_jduagehadNilData{
    
    NSString * msg = @"";
    if (_uploadQYName == NULL || [_uploadQYName isEqualToString:@""] || _uploadQYName == nil) {
        msg = @"请输入企业名称";
        return msg;
    }
    if (_companyCodeField.text.length == 0) {
        msg = @"请输入企业代码";
        return msg;
    }
    
    if (_addressField.text.length == 0) {
        
        msg = @"请输入企业地址";
        return msg;
    }
    if (_peopleCountField.text.integerValue <= 0) {
        msg = @"请输入员工总数";
        return msg;

    }
    return msg;
    
}

-(void)nextAction:(UIButton *)sender{
    NSLog(@"%@",_uploadQYName);
    
    NSString *msg = [self br_jduagehadNilData];
    if(msg.length > 0){
        RAlertView *alert = [[RAlertView alloc]initWithStyle:SimpleAlert];
        alert.headerTitleLabel.text = @"提示";
        alert.contentTextLabel.text = msg;
        alert.isClickBackgroundCloseWindow = YES;
    }else{
        AddStationTwoViewController *two = [[AddStationTwoViewController alloc]init];
        two.uploadID = _uploadID;
        two.uploadQYName = _uploadQYName;
        two.uploadQYCode = _companyCodeField.text;
        two.uploadQYAddress = _addressField.text;
        two.uploadQYTotal = _peopleCountField.text;
        two.uploadQYFlag = _baseSwitch.on;
        [self.navigationController pushViewController:two animated:YES];
    }
}


-(void)backAction:(UIBarButtonItem *)sender{
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) companyAction:(UITapGestureRecognizer *)sender{
    CompanyDetailViewController *companyDetail = [[CompanyDetailViewController alloc]init];
    [self.navigationController pushViewController:companyDetail animated:YES];
}


-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"%@",_getCompanyDic);
    [self br_resetAllTextFeild];
    if([_getCompanyDic objectForKey:@"ID"]){
        if([[_getCompanyDic objectForKey:@"ID"] isEqualToString:@"0"]){
            _companyField.text = [_getCompanyDic objectForKey:@"EnterpriseName"];
            _companyField.textColor = [UIColor blackColor];
            
            _uploadID = [_getCompanyDic objectForKey:@"ID"];
            _uploadQYName = _companyField.text;
            
            _baseSwitch.userInteractionEnabled = YES;
            _baseSwitch.on = NO;
            _companyCodeField.userInteractionEnabled = YES;
            _addressField.userInteractionEnabled = YES;
            _peopleCountField.userInteractionEnabled = YES;
            
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSString *enterpriseID = [_getCompanyDic objectForKey:@"ID"];
            NSString *enterpriseName = [_getCompanyDic objectForKey:@"EnterpriseName"];
            _companyField.text = enterpriseName;
            _companyField.textColor = [UIColor blackColor];
            
            _uploadID = [_getCompanyDic objectForKey:@"ID"];
            _uploadQYName = _companyField.text;
            
            NSString *url = [NSString stringWithFormat:@"%@/ApiEnterpriseInfo/GetEnterpriseInfo?EnterpriseID=%@",kCacheHttpRoot,enterpriseID];
            [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSDictionary *jsonDic = result;
                if([[jsonDic objectForKey:@"ResultType"] intValue] == 0){
                    [self handleOtherData:[[jsonDic objectForKey:@"AppendData"] objectAtIndex:0]];
                }
            } failue:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"请求失败--获取企业信息");
            }];
            
        }
    }
}

- (void)br_resetAllTextFeild{
    _companyField.text = @"请输入企业名称";
    _companyField.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:205/255.0 alpha:1];
    _uploadID = nil;
    _uploadQYName = nil;
    _uploadQYCode = nil;
    _uploadQYAddress = nil;
    _uploadQYTotal =  nil;
    
    _companyCodeField.text = nil;
    _addressField.text = nil;
    _peopleCountField.text = nil;

}


-(void) handleOtherData:(NSDictionary *)dataDic{
    
    dataDic = [GJToolsHelp processDictionaryIsNSNull:dataDic];
    _companyCodeField.text = [dataDic objectForKey:@"CreditCode"];
    
    NSString *StaffTotal = [dataDic objectForKey:@"StaffTotal"];
    if (![StaffTotal isKindOfClass:[NSString class]]) {
        StaffTotal = [NSString stringWithFormat:@"%@",StaffTotal];
    }

    _addressField.text = StaffTotal;//[dataDic objectForKey:@"Address"];
    
    _peopleCountField.text = [[dataDic objectForKey:@"StaffTotal"] stringValue];
    _baseSwitch.on = [[dataDic objectForKey:@"IsPracticeBase"] boolValue];
    _baseSwitch.userInteractionEnabled = NO;
    _uploadQYCode = _companyCodeField.text;
    _uploadQYAddress = _addressField.text;
    _uploadQYTotal = _peopleCountField.text;
    
    _companyCodeField.userInteractionEnabled = NO;
    _addressField.userInteractionEnabled = NO;
    _peopleCountField.userInteractionEnabled = NO;

    
  //  asdasd
    
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}



- (BOOL)textFieldShouldReturn:(BaseTextFeild *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
