//
//  OutlookViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/2/5.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "OutlookViewController.h"
#import "AizenHttp.h"
#import "DevicepwdViewController.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"

@interface OutlookViewController ()<UIAlertViewDelegate>

@property(nonatomic,retain)UIView *topView;
@property(nonatomic,retain)UIView *contentView;
@property(nonatomic,retain)UIImageView *goBackImgView;
@property(nonatomic,retain)UILabel *titleLab;
@property(nonatomic,retain)UILabel *tipLab;
@property(nonatomic,retain)UITextField *questionField;
@property(nonatomic,retain)UITextField *answerField;
@property(nonatomic,retain)UIView *lineView;
@property(nonatomic,retain)UIButton *subBtn;

@property(nonatomic,retain)NSString *trueAnswer;
@property(nonatomic,retain)NSNumber *USERID;
@property DGActivityIndicatorView *activityIndicatorView;

@end

@implementation OutlookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self startLayout];
}


-(void)startLayout{
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 100)/2, 100, 100);
    [self.view addSubview:_activityIndicatorView];
    
    
    _topView = [[UIView alloc]init];
    _topView.frame = CGRectMake(0, 0, self.view.frame.size.width, HEIGHT_STATUSBAR + HEIGHT_TABBAR);
    _topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topView];
    
    
    _goBackImgView = [[UIImageView alloc]init];
    _goBackImgView.frame = CGRectMake(_topView.frame.size.width * 0.05, HEIGHT_STATUSBAR + (HEIGHT_TABBAR - _topView.frame.size.height * 0.4)/2, _topView.frame.size.height * 0.4, _topView.frame.size.height * 0.4);
    _goBackImgView.image = [UIImage imageNamed:@"gj_gobacklogo1"];
    UITapGestureRecognizer *goBack = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goBackAction:)];
    [_goBackImgView addGestureRecognizer:goBack];
    _goBackImgView.userInteractionEnabled = YES;
    [_topView addSubview:_goBackImgView];
    
    
    _titleLab = [[UILabel alloc]init];
    _titleLab.frame = CGRectMake(_topView.frame.size.width * 0.25, _goBackImgView.frame.origin.y, _topView.frame.size.width * 0.5, _topView.frame.size.height * 0.4);
    _titleLab.textColor = [UIColor colorWithRed:52/255.0 green:57/255.0 blue:63/255.0 alpha:1];
    _titleLab.text = @"忘记密码";
    _titleLab.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:20];
    _titleLab.textAlignment = UITextAlignmentCenter;
    [_topView addSubview:_titleLab];
    
    
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, _topView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_TABBAR - HEIGHT_STATUSBAR);
    [self.view addSubview:_contentView];
    
    _tipLab = [[UILabel alloc]init];
    _tipLab.frame = CGRectMake(_contentView.frame.size.width * 0.05, 0, _contentView.frame.size.width * 0.9, _contentView.frame.size.height * 0.05);
    _tipLab.text = @"请正确回答安全问题，然后进行重置密码，请牢记密码";
    _tipLab.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    _tipLab.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:13];
    [_contentView addSubview:_tipLab];
    
    
    _questionField = [[UITextField alloc]init];
    _questionField.frame = CGRectMake(0, _tipLab.frame.origin.y + _tipLab.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height * 0.08);
    _questionField.backgroundColor = [UIColor whiteColor];
    UIImageView *questionImg = [[UIImageView alloc]init];
    questionImg.frame = CGRectMake(0, 0, _contentView.frame.size.height * 0.05, _contentView.frame.size.height * 0.05);
    questionImg.image = [UIImage imageNamed:@"gj_problem1"];
    _questionField.leftView = questionImg;
    _questionField.leftViewMode=UITextFieldViewModeAlways;
    _questionField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _questionField.userInteractionEnabled = NO;
    [_contentView addSubview:_questionField];
    
    _lineView = [[UIView alloc]init];
    _lineView.frame = CGRectMake(_contentView.frame.size.width * 0.1, _questionField.frame.origin.y + _questionField.frame.size.height, _contentView.frame.size.width * 0.9, 1);
    _lineView.backgroundColor = [UIColor grayColor];
    [_contentView addSubview:_lineView];
    
    
    _answerField = [[UITextField alloc]init];
    _answerField.frame = CGRectMake(0, _lineView.frame.origin.y + _lineView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height * 0.08);
    _answerField.backgroundColor = [UIColor whiteColor];
    UIImageView *answerImg = [[UIImageView alloc]init];
    answerImg.image = [UIImage imageNamed:@"gj_answer2"];
    answerImg.frame = CGRectMake(0, 0, _contentView.frame.size.height * 0.05, _contentView.frame.size.height * 0.05);
    _answerField.leftView = answerImg;
    _answerField.leftViewMode = UITextFieldViewModeAlways;
    _answerField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _answerField.placeholder = @"请输入答案";
    [_contentView addSubview:_answerField];
    
    
    _subBtn = [[UIButton alloc]init];
    _subBtn.frame = CGRectMake(_contentView.frame.size.width * 0.025, _answerField.frame.origin.y + _answerField.frame.size.height * 1.5, _contentView.frame.size.width * 0.95, _contentView.frame.size.height * 0.09);
    [_subBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _subBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:142/255.0 blue:255/255.0 alpha:1];
    _subBtn.layer.cornerRadius = 5;
    _subBtn.layer.masksToBounds = YES;
    [_subBtn addTarget:self action:@selector(answerAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_subBtn];
    
    [_activityIndicatorView startAnimating];
    NSString *url = [NSString stringWithFormat:@"%@/GetAnswer?UserName=%@",BASIS_URL,_accountVal];
    NSLog(@"%@",url);
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        NSDictionary *jsonDic = result;
        NSDictionary *AppendData = [jsonDic objectForKey:@"AppendData"];

        if([AppendData objectForKey:@"Question"] == [NSNull null]){
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有设置安全问题。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertView.tag = 2;
            alertView.delegate = self;
            [alertView show];
        }else{
            _questionField.text = [AppendData objectForKey:@"Question"];
            _trueAnswer = [AppendData objectForKey:@"Answer"];
            _USERID = [AppendData objectForKey:@"ID"];
        }
        [_activityIndicatorView stopAnimating];
    } failue:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 1;
        alertView.delegate = self;
        [alertView show];
        [_activityIndicatorView stopAnimating];
    }];
}


-(void)answerAction:(UIButton *)sender{
    if([_answerField.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请回答安全问题" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 3;
        alertView.delegate = self;
        [alertView show];
    }else{
        if([_answerField.text isEqualToString:_trueAnswer]){
            DevicepwdViewController *device = [[DevicepwdViewController alloc]init];
            device.USERID = _USERID;
            device.USERNAME = _accountVal;
            [self presentViewController:device animated:YES completion:nil];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"回答错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertView.tag = 4;
            alertView.delegate = self;
            [alertView show];
        }
    }
}


#pragma mark UIAlertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 2){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


-(void)goBackAction:(UITapGestureRecognizer *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
