//
//  DevicepwdViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/2/5.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "DevicepwdViewController.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "LoginViewController.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"

@interface DevicepwdViewController ()<UIAlertViewDelegate>

@property(nonatomic,retain)UIView *topView;
@property(nonatomic,retain)UIView *contentView;
@property(nonatomic,retain)UIImageView *goBackImgView;
@property(nonatomic,retain)UILabel *titleLab;
@property(nonatomic,retain)UILabel *tipLab;
@property(nonatomic,retain)UITextField *questionField;
@property(nonatomic,retain)UITextField *answerField;
@property(nonatomic,retain)UIView *lineView;
@property(nonatomic,retain)UIButton *subBtn;
@property(nonatomic,retain)DGActivityIndicatorView *animationView;

@end

@implementation DevicepwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self startLayout];
}


-(void)startLayout{
    _animationView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"0092ff"]];
    _animationView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 100)/2, 100, 100);
    [self.view addSubview:_animationView];
    
    
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
    _titleLab.text = @"重置密码";
    _titleLab.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:20];
    _titleLab.textAlignment = UITextAlignmentCenter;
    [_topView addSubview:_titleLab];
    
    
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, _topView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_TABBAR - HEIGHT_STATUSBAR);
    [self.view addSubview:_contentView];
    
    _tipLab = [[UILabel alloc]init];
    _tipLab.frame = CGRectMake(_contentView.frame.size.width * 0.05, 0, _contentView.frame.size.width * 0.9, _contentView.frame.size.height * 0.05);
    _tipLab.text = @"重置密码后，请牢记密码";
    _tipLab.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    _tipLab.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:13];
    [_contentView addSubview:_tipLab];
    
    
    _questionField = [[UITextField alloc]init];
    _questionField.frame = CGRectMake(0, _tipLab.frame.origin.y + _tipLab.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height * 0.08);
    _questionField.backgroundColor = [UIColor whiteColor];
    _questionField.placeholder = @"输入新的密码";
    UIImageView *questionImg = [[UIImageView alloc]init];
    questionImg.frame = CGRectMake(0, 0, _contentView.frame.size.height * 0.06, _contentView.frame.size.height * 0.06);
    questionImg.image = [UIImage imageNamed:@"gj_devicepwd"];
    _questionField.leftView = questionImg;
    _questionField.leftViewMode=UITextFieldViewModeAlways;
    _questionField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _questionField.secureTextEntry = YES;
    [_contentView addSubview:_questionField];
    
    _lineView = [[UIView alloc]init];
    _lineView.frame = CGRectMake(_contentView.frame.size.width * 0.1, _questionField.frame.origin.y + _questionField.frame.size.height, _contentView.frame.size.width * 0.9, 1);
    _lineView.backgroundColor = [UIColor grayColor];
    [_contentView addSubview:_lineView];
    
    
    _answerField = [[UITextField alloc]init];
    _answerField.frame = CGRectMake(0, _lineView.frame.origin.y + _lineView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height * 0.08);
    _answerField.backgroundColor = [UIColor whiteColor];
    _answerField.placeholder = @"再次输入新密码";
    UIImageView *answerImg = [[UIImageView alloc]init];
    answerImg.frame = CGRectMake(0, 0, _contentView.frame.size.height * 0.06, _contentView.frame.size.height * 0.06);
    answerImg.image = [UIImage imageNamed:@"gj_devicepwd"];
    _answerField.leftViewMode=UITextFieldViewModeAlways;
    _answerField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _answerField.leftView = answerImg;
    _answerField.secureTextEntry = YES;
    [_contentView addSubview:_answerField];
    
    
    _subBtn = [[UIButton alloc]init];
    _subBtn.frame = CGRectMake(_contentView.frame.size.width * 0.025, _answerField.frame.origin.y + _answerField.frame.size.height * 1.5, _contentView.frame.size.width * 0.95, _contentView.frame.size.height * 0.09);
    [_subBtn setTitle:@"确定" forState:UIControlStateNormal];
    _subBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:142/255.0 blue:255/255.0 alpha:1];
    _subBtn.layer.cornerRadius = 5;
    _subBtn.layer.masksToBounds = YES;
    [_subBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_subBtn];
}


-(void)confirmAction:(UIButton *)sender{
//    [_animationView startAnimating];
    if([_questionField.text isEqualToString:@""] || [_answerField.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写新的密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else if(![_questionField.text isEqualToString:_answerField.text]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"两次输入新密码不一致" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        NSString *UserName = _USERNAME;
        NSString *LoginID = [_USERID stringValue];
        
        UInt64 currTime = [[NSDate date] timeIntervalSince1970]*1000;
        NSString *currTimeStr = [NSString stringWithFormat:@"%ld",currTime];
        
        NSString *md5Str = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@%@GJPWD%@",UserName,currTimeStr,_questionField.text]];

        NSString *url = [NSString stringWithFormat:@"%@/ChangePWDByForget?LoginID=%@&NewPassword=%@&TimeStamp=%@&Token=%@",BASIS_URL,LoginID,_questionField.text,currTimeStr,md5Str];
        NSLog(@"%@",url);
        
        [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
            NSDictionary *jsonDic = result;
            if([[jsonDic objectForKey:@"Message"] isEqualToString:@"修改密码成功！"]){
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[jsonDic objectForKey:@"Message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alertView.tag = 1;
                [alertView show];
                [_animationView stopAnimating];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[jsonDic objectForKey:@"Message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                [_animationView stopAnimating];
            }
        } failue:^(NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [_animationView stopAnimating];
        }];
        
        
    }
}


-(void)goBackAction:(UITapGestureRecognizer *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark UIAlertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1){
        LoginViewController *login = getControllerFromStoryBoard(@"Mine", @"myloginStoryID");
        [self presentViewController:login animated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
