//
//  AddStationThreeViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/3/2.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "AddStationThreeViewController.h"
#import "AddStationFourViewController.h"
#import "TeacherDetailViewController.h"
#import "RAlertView.h"
#import <IQKeyboardManager/IQPreviousNextView.h>

#define MAINHEIGHT [UIScreen mainScreen].bounds.size.height - HEIGHT_STATUSBAR - HEIGHT_NAVBAR

@interface AddStationThreeViewController ()<UITextFieldDelegate>

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIView *scrollView;

@property(nonatomic,strong) UIView *titleView;
@property(nonatomic,strong) UILabel *titleLab;

@property(nonatomic,strong) UIView *teacherView;
@property(nonatomic,strong) UILabel *teacherLab;
@property(nonatomic,strong) UILabel *teacherField;

@property(nonatomic,strong) UIView *mobileView;
@property(nonatomic,strong) UILabel *mobileLab;
@property(nonatomic,strong) BaseTextFeild *mobileField;

@property(nonatomic,strong) UIView *phoneView;
@property(nonatomic,strong) UILabel *phoneLab;
@property(nonatomic,strong) BaseTextFeild *phoneField;

@property(nonatomic,strong) UIView *emailView;
@property(nonatomic,strong) UILabel *emailLab;
@property(nonatomic,strong) BaseTextFeild *emailField;

@property(nonatomic,strong) UIView *offerView;
@property(nonatomic,strong) UILabel *offerLab;
@property(nonatomic,strong) BaseTextFeild *offerField;

@property(nonatomic,strong) UIView *dateView;
@property(nonatomic,strong) UILabel *dateLab;
@property(nonatomic,strong) BaseTextFeild *dateField;

@property(nonatomic,strong) UIView *liveView;
@property(nonatomic,strong) UILabel *liveLab;
@property(nonatomic,strong) BaseTextFeild *liveField;

@property(nonatomic,strong) UIView *eatView;
@property(nonatomic,strong) UILabel *eatLab;
@property(nonatomic,strong) BaseTextFeild *eatField;

@property(nonatomic,strong) UIView *instrView;
@property(nonatomic,strong) UILabel *instrLab;
@property(nonatomic,strong) UITextView *instrField;

@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UILabel *bottomLab;

@property(nonatomic,strong) UIButton *nextBtn;

@property(nonatomic,strong) NSString *uploadJSID;
@property(nonatomic,strong) NSString *uploadJSName;
@property(nonatomic,strong) NSString *uploadJSPhone;
@property(nonatomic,strong) NSString *uploadJSTel;
@property(nonatomic,strong) NSString *uploadJSEmail;

@end

@implementation AddStationThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"企业提交";
    _getStationDic = [GJToolsHelp processDictionaryIsNSNull:_getStationDic];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    NSLog(@"%@",_uploadStationID);
    NSLog(@"%f",MAINHEIGHT);
    
    
    self.view.userInteractionEnabled = YES;
    
    [self startLayout];
}


-(void) startLayout{
    _contentView = [[IQPreviousNextView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, self.view.frame.size.width, self.view.frame.size.height - (HEIGHT_NAVBAR + HEIGHT_STATUSBAR + HEIGHT_TABBAR));
    _contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contentView];
    
    
    _scrollView = [[UIView alloc]init];
    _scrollView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
//    _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, _contentView.frame.size.height * 1.5);
    [_contentView addSubview:_scrollView];
    
    
    _nextBtn = [[UIButton alloc]init];
    _nextBtn.frame = CGRectMake(0, _contentView.frame.origin.y + _contentView.frame.size.height, _contentView.frame.size.width, HEIGHT_TABBAR);
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBtn.backgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    [_nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    
    [self detailLayout];
}

-(void) detailLayout{
    CGFloat height = MAINHEIGHT;
    
    _titleView = [[UIView alloc]init];
    _titleView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height * 0.08);
    [_contentView addSubview:_titleView];
    
    _titleLab = [[UILabel alloc]init];
    _titleLab.frame = CGRectMake(_titleView.frame.size.width * 0.05, 0, _titleView.frame.size.width * 0.45, _titleView.frame.size.height);
    _titleLab.text = @"指导老师";
    _titleLab.font = [UIFont systemFontOfSize:18.0];
    _titleLab.textColor = [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1];
    [_titleView addSubview:_titleLab];
    
    
    _teacherView = [self normalView];
    _teacherView.frame = CGRectMake(_contentView.frame.size.width * 0.02 , _titleView.frame.origin.y + _titleView.frame.size.height, _contentView.frame.size.width * 0.96, _contentView.frame.size.height * 0.08);
    _teacherView.backgroundColor = [UIColor whiteColor];
    _teacherView.userInteractionEnabled = YES;
    [_contentView addSubview:_teacherView];

    _teacherField = [[UILabel alloc]init];
    _teacherField.frame = CGRectMake(_teacherView.size.height * 0.85 , 0, _teacherView.frame.size.width * 0.45, _teacherView.frame.size.height);
    _teacherField.text = @"请输入企业指导老师";
    _teacherField.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:205/255.0 alpha:1];
    _teacherField.textAlignment = NSTextAlignmentLeft;
    _teacherField.font = [UIFont systemFontOfSize:16.0];
    _teacherField.userInteractionEnabled = YES;
    UITapGestureRecognizer *companyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teacherAction:)];
    [_teacherField addGestureRecognizer:companyTap];
    [_teacherView addSubview:_teacherField];
//收集
    _mobileView = [self normalView];
    _mobileView.frame = CGRectMake(_contentView.frame.size.width * 0.02 , _teacherView.xo_bottomY + _contentView.xo_width * 0.03, _contentView.frame.size.width * 0.96, _contentView.frame.size.height * 0.08);
    _mobileView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_mobileView];

    _mobileField = [[BaseTextFeild alloc]init];
    _mobileField.frame = CGRectMake(_mobileView.size.height * 0.85 , 0, _mobileView.frame.size.width * 0.45, _mobileView.frame.size.height);
    _mobileField.placeholder = @"请输入企业老师手机";
    _mobileField.textAlignment = NSTextAlignmentLeft;
    _mobileField.font = [UIFont systemFontOfSize:16.0];
    [_mobileView addSubview:_mobileField];
    _mobileField.delegate = self;
// j固定电话
    _phoneView = [self normalView];
    _phoneView.frame = CGRectMake(_contentView.frame.size.width * 0.02 , _mobileView.xo_bottomY + _contentView.xo_width * 0.03, _contentView.frame.size.width * 0.96, _contentView.frame.size.height * 0.08);
    _phoneView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_phoneView];

    _phoneField = [[BaseTextFeild alloc]init];
    _phoneField.frame = CGRectMake(_mobileView.size.height * 0.85 , 0, _mobileView.frame.size.width * 0.45, _mobileView.frame.size.height);
    _phoneField.placeholder = @"请输入企业老师座机";
    _phoneField.textAlignment = NSTextAlignmentLeft;
    _phoneField.font = [UIFont systemFontOfSize:16.0];
    [_phoneView addSubview:_phoneField];
    _phoneField.delegate = self;
//邮箱
    _emailView = [self normalView];
    _emailView.frame = CGRectMake(_contentView.frame.size.width * 0.02 , _phoneView.xo_bottomY + _contentView.xo_width * 0.03, _contentView.frame.size.width * 0.96, _contentView.frame.size.height * 0.08);
    _emailView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_emailView];

    _emailField = [[BaseTextFeild alloc]init];
    _emailField.frame = CGRectMake(_mobileView.size.height * 0.85 , 0, _mobileView.frame.size.width * 0.45, _mobileView.frame.size.height);
    _emailField.placeholder = @"请输入企业老师邮箱";
    _emailField.textAlignment = NSTextAlignmentLeft;
    _emailField.font = [UIFont systemFontOfSize:16.0];
    [_emailView addSubview:_emailField];
    _emailField.delegate = self;
    
    _bottomView = [[UIView alloc]init];
    _bottomView.frame = CGRectMake(0, _emailView.frame.size.height + _emailView.frame.origin.y, _contentView.frame.size.width, height * 0.08);
    [_scrollView addSubview:_bottomView];
    
    _bottomLab = [[UILabel alloc]init];
    _bottomLab.frame = CGRectMake(_bottomView.frame.size.width * 0.05, 0, _bottomView.frame.size.width * 0.45, _bottomView.frame.size.height);
    _bottomLab.text = @"第三步，共五步";
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
    
    NSString *msg= @"";
    if (_uploadJSName == NULL || _uploadJSName == nil || _uploadJSName.length == 0) {
        msg = @"请输入指导师傅";
        return msg;
    }
    if (_mobileField.text.length == 0) {
        msg = @"请输入师傅手机";
        return msg;
    }
    
    if (_phoneField.text.length == 0) {
        msg = @"";
        _phoneField.text = @"";
        //return msg;
    }
    
    if (_emailField.text.length == 0) {
        
        msg = @"请输入师傅邮箱";
        return msg;
    }
//    _teacherField.text = [_getStationDic objectForKey:@"ManName"];
//    _teacherField.textColor = [UIColor blackColor];
//
//    NSString *mobileStr = [_getStationDic objectForKey:@"ManMobile"];
//    _mobileField.text = mobileStr;
//
//    NSString *emailStr = [_getStationDic objectForKey:@"ManEmail"];
//    _emailField.text = emailStr;
    return msg;
}
-(void) nextAction:(UIButton *)sender{
    
    NSString *msg = [self br_jduagehadNilData];
    if(msg.length > 0){
        RAlertView *alert = [[RAlertView alloc]initWithStyle:SimpleAlert];
        alert.headerTitleLabel.text = @"提示";
        alert.contentTextLabel.text = msg;
        alert.isClickBackgroundCloseWindow = YES;
    }else{
        AddStationFourViewController *four = [[AddStationFourViewController alloc]init];
        four.uploadID = _uploadID;
        four.uploadQYName = _uploadQYName;
        four.uploadQYCode = _uploadQYCode;
        four.uploadQYAddress = _uploadQYAddress;
        four.uploadQYTotal = _uploadQYTotal;
        four.uploadQYFlag = _uploadQYFlag;
        
        four.uploadStationID = _uploadStationID;
        four.uploadStationName = _uploadStationName;
        four.uploadStationTotal = _uploadStationTotal;
        four.uploadStationIntro = _uploadStationIntro;
        
        four.uploadJSID = _uploadJSID;
        four.uploadJSName = _teacherField.text;
        four.uploadJSPhone = _mobileField.text;//_uploadJSPhone;
        four.uploadJSTel = _phoneField.text;//_uploadJSTel;
        four.uploadJSEmail = _emailField.text;//_uploadJSEmail;
        
        [self.navigationController pushViewController:four animated:YES];
    }
}



-(void) teacherAction:(UITapGestureRecognizer *)sender{
    TeacherDetailViewController *teacher = [[TeacherDetailViewController alloc]init];
    teacher.uploadStationID = _uploadStationID;
    
    [self.navigationController pushViewController:teacher animated:YES];
}


-(void) viewDidAppear:(BOOL)animated{
    if([_getStationDic objectForKey:@"ID"]){
        NSLog(@"%@",_getStationDic);
        _getStationDic = [GJToolsHelp processDictionaryIsNSNull:_getStationDic];
        if([[_getStationDic objectForKey:@"ID"] isEqualToString:@"0"]){
            _teacherField.text = [_getStationDic objectForKey:@"ManName"];
            _teacherField.textColor = [UIColor blackColor];
            
            _uploadJSID = @"0";
            _uploadJSName = [_getStationDic objectForKey:@"ManName"];
        }else{
            _teacherField.text = [_getStationDic objectForKey:@"ManName"];
            _teacherField.textColor = [UIColor blackColor];
            
            NSString *mobileStr = [_getStationDic objectForKey:@"ManMobile"];
            _mobileField.text = mobileStr;
            
            NSString *emailStr = [_getStationDic objectForKey:@"ManEmail"];
            _emailField.text = emailStr;
            
            _uploadJSID = [_getStationDic objectForKey:@"ID"];
            _uploadJSName = [_getStationDic objectForKey:@"ManName"];
            _uploadJSPhone = [_getStationDic objectForKey:@"ManMobile"];
            _uploadJSEmail = [_getStationDic objectForKey:@"ManEmail"];
            _uploadJSTel = [_getStationDic objectForKey:@"ManTel"];
            
            _phoneField.text = _uploadJSTel;

        }
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
