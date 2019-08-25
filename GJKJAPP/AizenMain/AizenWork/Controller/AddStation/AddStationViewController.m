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
#import "DGActivityIndicatorView.h"
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
@property(nonatomic,strong) UILabel *companyField;

@property(nonatomic,strong) UIView *companyCodeView;
@property(nonatomic,strong) UILabel *companyCodeLab;
@property(nonatomic,strong) BaseTextFeild *companyCodeField;

@property(nonatomic,strong) UIView *peopleCountView;
@property(nonatomic,strong) UILabel *peopleCountLab;
@property(nonatomic,strong) BaseTextFeild *peopleCountField;

@property(nonatomic,strong) UIView *addressView;
@property(nonatomic,strong) UILabel *addressLab;
@property(nonatomic,strong) BaseTextFeild *addressField;

@property(nonatomic,strong) UIView *baseView;
@property(nonatomic,strong) UILabel *baseLab;
@property(nonatomic,strong) UIView *baseField;
@property(nonatomic,strong) UISwitch *baseSwitch;

@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UILabel *bottomLab;

@property(nonatomic,strong) UIButton *nextBtn;
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;


@property(nonatomic,strong) NSString *uploadID;
@property(nonatomic,strong) NSString *uploadQYName;
@property(nonatomic,strong) NSString *uploadQYCode;
@property(nonatomic,strong) NSString *uploadQYTotal;
@property(nonatomic,strong) NSString *uploadQYAddress;


@end

@implementation AddStationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"添加企业信息";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    _getCompanyDic = [[NSDictionary alloc]init];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    [self startLayout];
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = backBtnItem ;
}

-(void) startLayout{
    _contentView = [[IQPreviousNextView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, self.view.frame.size.width, self.view.frame.size.height - (HEIGHT_STATUSBAR + HEIGHT_NAVBAR));
    _contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    _contentView.userInteractionEnabled = YES;
    [self.view addSubview:_contentView];
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[UIColor grayColor]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [_contentView addSubview:_activityIndicatorView];
    
    
    _nextBtn = [[UIButton alloc]init];
    _nextBtn.frame = CGRectMake(0, _contentView.frame.size.height - HEIGHT_TABBAR, _contentView.frame.size.width, HEIGHT_TABBAR);
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBtn.backgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    [_nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_nextBtn];
    
    _titleView = [[UIView alloc]init];
    _titleView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height * 0.05);
    [_contentView addSubview:_titleView];
    
    _titleLab = [[UILabel alloc]init];
    _titleLab.frame = CGRectMake(_titleView.frame.size.width * 0.05, 0, _titleView.frame.size.width * 0.45, _titleView.frame.size.height);
    _titleLab.text = @"企业信息";
    _titleLab.font = [UIFont systemFontOfSize:13.0];
    _titleLab.textColor = [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1];
    [_titleView addSubview:_titleLab];
    
    _companyView = [[UIView alloc]init];
    _companyView.frame = CGRectMake(0, _titleView.frame.origin.y + _titleView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height * 0.08);
    _companyView.backgroundColor = [UIColor whiteColor];
    _companyView.userInteractionEnabled = YES;
    [_contentView addSubview:_companyView];

    _companyLab = [[UILabel alloc]init];
    _companyLab.frame = CGRectMake(_companyView.frame.size.width * 0.05, 0, _companyView.frame.size.width * 0.45, _companyView.frame.size.height);
    _companyLab.text = @"企业名称";
    _companyLab.textColor = [UIColor blackColor];
    _companyLab.font = [UIFont systemFontOfSize:18.0];
    [_companyView addSubview:_companyLab];


    _companyField = [[UILabel alloc]init];
    _companyField.frame = CGRectMake(_companyLab.frame.origin.x + _companyLab.frame.size.width, 0, _companyView.frame.size.width * 0.45, _companyView.frame.size.height);
    _companyField.text = @"请输入";
    _companyField.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:205/255.0 alpha:1];
    _companyField.textAlignment = UITextAlignmentRight;
    _companyField.font = [UIFont systemFontOfSize:18.0];
    _companyField.userInteractionEnabled = YES;
    UITapGestureRecognizer *companyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyAction:)];
    [_companyField addGestureRecognizer:companyTap];
    [_companyView addSubview:_companyField];
    

    UIView * line1 = [[UIView alloc]init];
    line1.frame = CGRectMake(_companyView.frame.size.width * 0.05, _companyView.frame.size.height - 1, _companyView.frame.size.width * 0.95, 1);
    line1.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_companyView addSubview:line1];


    _companyCodeView = [[UIView alloc]init];
    _companyCodeView.frame = CGRectMake(0, _companyView.frame.origin.y + _companyView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height * 0.08);
    _companyCodeView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_companyCodeView];

    _companyCodeLab = [[UILabel alloc]init];
    _companyCodeLab.frame = CGRectMake(_companyCodeView.frame.size.width * 0.05, 0, _companyCodeView.frame.size.width * 0.45, _companyCodeView.frame.size.height);
    _companyCodeLab.text = @"企业代码";
    _companyCodeLab.textColor = [UIColor blackColor];
    _companyCodeLab.font = [UIFont systemFontOfSize:18.0];
    [_companyCodeView addSubview:_companyCodeLab];


    _companyCodeField = [[BaseTextFeild alloc]init];
    _companyCodeField.frame = CGRectMake(_companyCodeLab.frame.origin.x + _companyCodeLab.frame.size.width, 0, _companyCodeView.frame.size.width * 0.45, _companyCodeView.frame.size.height);
    _companyCodeField.placeholder = @"请输入";
    _companyCodeField.textAlignment = UITextAlignmentRight;
    _companyCodeField.font = [UIFont systemFontOfSize:18.0];
    [_companyCodeView addSubview:_companyCodeField];
    _companyCodeField.delegate = self;



    UIView * line2 = [[UIView alloc]init];
    line2.frame = CGRectMake(_companyCodeView.frame.size.width * 0.05, _companyCodeView.frame.size.height - 1, _companyCodeView.frame.size.width * 0.95, 1);
    line2.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_companyCodeView addSubview:line2];


    _addressView = [[UIView alloc]init];
    _addressView.frame = CGRectMake(0, _companyCodeView.frame.origin.y + _companyCodeView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height * 0.08);
    _addressView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_addressView];

    _addressLab = [[UILabel alloc]init];
    _addressLab.frame = CGRectMake(_addressView.frame.size.width * 0.05, 0, _addressView.frame.size.width * 0.45, _addressView.frame.size.height);
    _addressLab.text = @"企业地址";
    _addressLab.textColor = [UIColor blackColor];
    _addressLab.font = [UIFont systemFontOfSize:18.0];
    [_addressView addSubview:_addressLab];


    _addressField = [[BaseTextFeild alloc]init];
    _addressField.frame = CGRectMake(_addressLab.frame.origin.x + _addressLab.frame.size.width, 0, _addressView.frame.size.width * 0.45, _addressView.frame.size.height);
    _addressField.placeholder = @"请输入";
    _addressField.textAlignment = UITextAlignmentRight;
    _addressField.font = [UIFont systemFontOfSize:18.0];
    [_addressView addSubview:_addressField];
    _addressField.delegate = self;


    UIView * line3 = [[UIView alloc]init];
    line3.frame = CGRectMake(_addressView.frame.size.width * 0.05, _addressView.frame.size.height - 1, _addressView.frame.size.width * 0.95, 1);
    line3.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_addressView addSubview:line3];


    _peopleCountView = [[UIView alloc]init];
    _peopleCountView.frame = CGRectMake(0, _addressView.frame.origin.y + _addressView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height * 0.08);
    _peopleCountView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_peopleCountView];

    _peopleCountLab = [[UILabel alloc]init];
    _peopleCountLab.frame = CGRectMake(_peopleCountView.frame.size.width * 0.05, 0, _peopleCountView.frame.size.width * 0.45, _peopleCountView.frame.size.height);
    _peopleCountLab.text = @"员工总数";
    _peopleCountLab.textColor = [UIColor blackColor];
    _peopleCountLab.font = [UIFont systemFontOfSize:18.0];
    [_peopleCountView addSubview:_peopleCountLab];


    _peopleCountField = [[BaseTextFeild alloc]init];
    _peopleCountField.frame = CGRectMake(_peopleCountLab.frame.origin.x + _peopleCountLab.frame.size.width, 0, _peopleCountView.frame.size.width * 0.45, _peopleCountView.frame.size.height);
    _peopleCountField.placeholder = @"请输入";
    _peopleCountField.textAlignment = UITextAlignmentRight;
    _peopleCountField.font = [UIFont systemFontOfSize:18.0];
    [_peopleCountView addSubview:_peopleCountField];
    _peopleCountField.delegate = self;
    _peopleCountField.keyboardType = UIKeyboardTypeNumberPad;
    UIView * line4 = [[UIView alloc]init];
    line4.frame = CGRectMake(_peopleCountView.frame.size.width * 0.05, _peopleCountView.frame.size.height - 1, _peopleCountView.frame.size.width * 0.95, 1);
    line4.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_peopleCountView addSubview:line4];


    _baseView = [[UIView alloc]init];
    _baseView.frame = CGRectMake(0, _peopleCountView.frame.origin.y + _peopleCountView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height * 0.08);
    _baseView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_baseView];

    _baseLab = [[UILabel alloc]init];
    _baseLab.frame = CGRectMake(_baseView.frame.size.width * 0.05, 0, _baseView.frame.size.width * 0.45, _baseView.frame.size.height);
    _baseLab.text = @"是否实习基地";
    _baseLab.textColor = [UIColor blackColor];
    _baseLab.font = [UIFont systemFontOfSize:18.0];
    [_baseView addSubview:_baseLab];


    _baseField = [[UIView alloc]init];
    _baseField.frame = CGRectMake(_baseLab.frame.origin.x + _baseLab.frame.size.width, 0, _baseView.frame.size.width * 0.45, _baseView.frame.size.height);
    [_baseView addSubview:_baseField];
    
    _baseSwitch = [[UISwitch alloc]init];
    _baseSwitch.frame = CGRectMake(_baseField.frame.size.width * 0.7, _baseField.frame.size.height * 0.15, _baseField.frame.size.width * 0.3, _baseField.frame.size.height * 0.7);
    _baseSwitch.on = NO;
    [_baseField addSubview:_baseSwitch];


    _bottomView = [[UIView alloc]init];
    _bottomView.frame = CGRectMake(0, _baseView.frame.size.height + _baseView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height * 0.05);
    [_contentView addSubview:_bottomView];

    _bottomLab = [[UILabel alloc]init];
    _bottomLab.frame = CGRectMake(_bottomView.frame.size.width * 0.05, 0, _bottomView.frame.size.width * 0.45, _bottomView.frame.size.height);
    _bottomLab.text = @"第一步，共五步";
    _bottomLab.font = [UIFont systemFontOfSize:13.0];
    _bottomLab.textColor = [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1];
    [_bottomView addSubview:_bottomLab];
    
}

- (NSString *)br_jduagehadNilData{
    
    NSString * msg = @"";
    if (_uploadQYName == NULL || [_uploadQYName isEqualToString:@""] || _uploadQYName == nil) {
        msg = @"请输入企业名称";
        return msg;
    }
//    if (_companyCodeField.text.length == 0) {
//        msg = @"请输入企业代码";
//        return msg;
//    }
    
    if (_addressField.text.length == 0) {
        
        msg = @"请输入企业地址";
        return msg;
    }
//    if (_peopleCountField.text.integerValue <= 0) {
//        msg = @"请输入员工总数";
//        return msg;
//
//    }
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
            [_activityIndicatorView startAnimating];
            NSString *enterpriseID = [_getCompanyDic objectForKey:@"ID"];
            NSString *enterpriseName = [_getCompanyDic objectForKey:@"EnterpriseName"];
            _companyField.text = enterpriseName;
            _companyField.textColor = [UIColor blackColor];
            
            _uploadID = [_getCompanyDic objectForKey:@"ID"];
            _uploadQYName = _companyField.text;
            
            NSString *url = [NSString stringWithFormat:@"%@/ApiEnterpriseInfo/GetEnterpriseInfo?EnterpriseID=%@",kCacheHttpRoot,enterpriseID];
            [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
                [_activityIndicatorView stopAnimating];
                NSDictionary *jsonDic = result;
                if([[jsonDic objectForKey:@"ResultType"] intValue] == 0){
                    [self handleOtherData:[[jsonDic objectForKey:@"AppendData"] objectAtIndex:0]];
                }
            } failue:^(NSError *error) {
                [_activityIndicatorView stopAnimating];
                NSLog(@"请求失败--获取企业信息");
            }];
            
        }
    }
}

- (void)br_resetAllTextFeild{
    _companyField.text = @"请输入";
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
