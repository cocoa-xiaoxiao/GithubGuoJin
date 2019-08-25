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

@interface AddStationThreeViewController ()

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
    self.navigationItem.title = @"添加入职信息";
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
    _contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
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
    _titleView.frame = CGRectMake(0, 0, _contentView.frame.size.width, height * 0.05);
    [_scrollView addSubview:_titleView];
    
    _titleLab = [[UILabel alloc]init];
    _titleLab.frame = CGRectMake(_titleView.frame.size.width * 0.05, 0, _titleView.frame.size.width * 0.45, _titleView.frame.size.height);
    _titleLab.text = @"指导教师";
    _titleLab.font = [UIFont systemFontOfSize:13.0];
    _titleLab.textColor = [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1];
    [_scrollView addSubview:_titleLab];
    
    
    _teacherView = [[UIView alloc]init];
    _teacherView.frame = CGRectMake(0, _titleView.frame.origin.y + _titleView.frame.size.height, _contentView.frame.size.width, height * 0.08);
    _teacherView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_teacherView];
    
    _teacherLab = [[UILabel alloc]init];
    _teacherLab.frame = CGRectMake(_teacherView.frame.size.width * 0.05, 0, _teacherView.frame.size.width * 0.45, _teacherView.frame.size.height);
    _teacherLab.text = @"企业指导师傅";
    _teacherLab.textColor = [UIColor blackColor];
    _teacherLab.font = [UIFont systemFontOfSize:18.0];
    [_teacherView addSubview:_teacherLab];
    
    
    _teacherField = [[UILabel alloc]init];
    _teacherField.frame = CGRectMake(_teacherLab.frame.origin.x + _teacherLab.frame.size.width, 0, _teacherView.frame.size.width * 0.45, _teacherView.frame.size.height);
    _teacherField.text = @"请输入";
    _teacherField.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:205/255.0 alpha:1];
    _teacherField.textAlignment = UITextAlignmentRight;
    _teacherField.font = [UIFont systemFontOfSize:18.0];
    _teacherField.userInteractionEnabled = YES;
    UITapGestureRecognizer *teacherTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teacherAction:)];
    [_teacherField addGestureRecognizer:teacherTap];
    [_teacherView addSubview:_teacherField];
    
    UIView * line1 = [[UIView alloc]init];
    line1.frame = CGRectMake(_teacherView.frame.size.width * 0.05, _teacherView.frame.size.height - 1, _teacherView.frame.size.width * 0.95, 1);
    line1.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_teacherView addSubview:line1];
    
    
    
    _mobileView = [[UIView alloc]init];
    _mobileView.frame = CGRectMake(0, _teacherView.frame.origin.y + _teacherView.frame.size.height, _contentView.frame.size.width, height * 0.08);
    _mobileView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_mobileView];
    
    _mobileLab = [[UILabel alloc]init];
    _mobileLab.frame = CGRectMake(_mobileView.frame.size.width * 0.05, 0, _mobileView.frame.size.width * 0.45, _mobileView.frame.size.height);
    _mobileLab.text = @"师傅手机";
    _mobileLab.textColor = [UIColor blackColor];
    _mobileLab.font = [UIFont systemFontOfSize:18.0];
    [_mobileView addSubview:_mobileLab];
    
    
    _mobileField = [[BaseTextFeild alloc]init];
    _mobileField.frame = CGRectMake(_mobileLab.frame.origin.x + _mobileLab.frame.size.width, 0, _mobileView.frame.size.width * 0.45, _mobileView.frame.size.height);
    _mobileField.placeholder = @"请输入";
    _mobileField.textAlignment = UITextAlignmentRight;
    _mobileField.font = [UIFont systemFontOfSize:18.0];
    [_mobileView addSubview:_mobileField];
    _mobileField.delegate = self;
    _mobileField.keyboardType = UIKeyboardTypeNumberPad;
    
    UIView * line2 = [[UIView alloc]init];
    line2.frame = CGRectMake(_mobileView.frame.size.width * 0.05, _mobileView.frame.size.height - 1, _mobileView.frame.size.width * 0.95, 1);
    line2.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_mobileView addSubview:line2];
    
    
    _phoneView = [[UIView alloc]init];
    _phoneView.frame = CGRectMake(0, _mobileView.frame.origin.y + _mobileView.frame.size.height, _contentView.frame.size.width, height * 0.08);
    _phoneView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_phoneView];
    
    _phoneLab = [[UILabel alloc]init];
    _phoneLab.frame = CGRectMake(_phoneView.frame.size.width * 0.05, 0, _phoneView.frame.size.width * 0.45, _phoneView.frame.size.height);
    _phoneLab.text = @"师傅固话";
    _phoneLab.textColor = [UIColor blackColor];
    _phoneLab.font = [UIFont systemFontOfSize:18.0];
    [_phoneView addSubview:_phoneLab];
    
    
    _phoneField = [[BaseTextFeild alloc]init];
    _phoneField.frame = CGRectMake(_phoneLab.frame.origin.x + _phoneLab.frame.size.width, 0, _phoneView.frame.size.width * 0.45, _phoneView.frame.size.height);
    _phoneField.placeholder = @"请输入";
    _phoneField.textAlignment = UITextAlignmentRight;
    _phoneField.font = [UIFont systemFontOfSize:18.0];
    [_phoneView addSubview:_phoneField];
    _phoneField.delegate = self;
    UIView * line3 = [[UIView alloc]init];
    line3.frame = CGRectMake(_phoneView.frame.size.width * 0.05, _phoneView.frame.size.height - 1, _phoneView.frame.size.width * 0.95, 1);
    line3.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_phoneView addSubview:line3];
    
    
    _emailView = [[UIView alloc]init];
    _emailView.frame = CGRectMake(0, _phoneView.frame.origin.y + _phoneView.frame.size.height, _contentView.frame.size.width, height * 0.08);
    _emailView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_emailView];
    
    _emailLab = [[UILabel alloc]init];
    _emailLab.frame = CGRectMake(_emailView.frame.size.width * 0.05, 0, _emailView.frame.size.width * 0.45, _emailView.frame.size.height);
    _emailLab.text = @"师傅邮箱";
    _emailLab.textColor = [UIColor blackColor];
    _emailLab.font = [UIFont systemFontOfSize:18.0];
    [_emailView addSubview:_emailLab];
    
    
    _emailField = [[BaseTextFeild alloc]init];
    _emailField.frame = CGRectMake(_emailLab.frame.origin.x + _emailLab.frame.size.width, 0, _emailView.frame.size.width * 0.45, _emailView.frame.size.height);
    _emailField.placeholder = @"请输入";
    _emailField.textAlignment = UITextAlignmentRight;
    _emailField.font = [UIFont systemFontOfSize:18.0];
    [_emailView addSubview:_emailField];
    _emailField.delegate = self;
    _emailField.keyboardType = UIKeyboardTypeEmailAddress;
    
    UIView * line4 = [[UIView alloc]init];
    line4.frame = CGRectMake(_emailView.frame.size.width * 0.05, _emailView.frame.size.height - 1, _emailView.frame.size.width * 0.95, 1);
    line4.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_emailView addSubview:line4];
    

    
    _bottomView = [[UIView alloc]init];
    _bottomView.frame = CGRectMake(0, _emailView.frame.size.height + _emailView.frame.origin.y, _contentView.frame.size.width, height * 0.05);
    [_scrollView addSubview:_bottomView];
    
    _bottomLab = [[UILabel alloc]init];
    _bottomLab.frame = CGRectMake(_bottomView.frame.size.width * 0.05, 0, _bottomView.frame.size.width * 0.45, _bottomView.frame.size.height);
    _bottomLab.text = @"第三步，共五步";
    _bottomLab.font = [UIFont systemFontOfSize:13.0];
    _bottomLab.textColor = [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1];
    [_bottomView addSubview:_bottomLab];
    
    
    
//    CGFloat scrollHeight = _titleView.frame.size.height + _teacherView.frame.size.height + _mobileView.frame.size.height + _phoneView.frame.size.height + _emailView.frame.size.height + _offerView.frame.size.height + _dateView.frame.size.height + _liveView.frame.size.height + _eatView.frame.size.height + _instrView.frame.size.height + _bottomView.frame.size.height;
//    _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, scrollHeight);
    
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
