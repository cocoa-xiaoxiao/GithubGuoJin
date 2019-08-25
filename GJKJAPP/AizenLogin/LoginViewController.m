//
//  LoginViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/1/6.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "LoginViewController.h"
#import "MLPAutoCompleteTextField.h"
#import <QuartzCore/QuartzCore.h>
#import "ForgetViewController.h"
#import "MainViewController.h"
#import "AizenStorage.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "People.h"
#import "DBController.h"
#import "OutlookViewController.h"
#import "DGActivityIndicatorView.h"
#import "CCCache.h"
#import "AizenStorage.h"
#import "AppCache.h"
#import "RAlertView.h"
#import "PhoneInfo.h"
#import "MLPAutoCompleteTextFieldDataSource.h"
#import "MLPAutoCompleteTextFieldDelegate.h"
#import "AppDelegate.h"
#import "BaseViewController.h"
#import "ViewController.h"
@interface LoginViewController ()<MLPAutoCompleteTextFieldDelegate,MLPAutoCompleteTextFieldDataSource,UIAlertViewDelegate>

@property UIImageView *bgView;
@property UIView *maskView;
@property UIImageView *logoView;
@property UIImageView *logoView1;
@property UILabel *logoLab;
@property MLPAutoCompleteTextField *chooseField;
@property UITextField *accountField;
@property UITextField *pwdField;
@property UIButton *loginBtn;
@property CAAnimationGroup *groups;
@property UILabel *forgetPwdLab;
@property UILabel *regLab;
@property UILabel *serviceLab;
@property UITapGestureRecognizer *forgetEvent;
@property UITapGestureRecognizer *regEvent;
@property UITapGestureRecognizer *serviceEvent;
@property NSMutableArray *SchoolArr;
@property DGActivityIndicatorView *activityIndicatorView;

@property MainViewController *mainPag;

@property int totalSubModule;
@property NSMutableArray *subModuleDic;

@property NSMutableDictionary *batchDic;

//@property NSMutableArray *SchoolList;
@property (nonatomic, strong) NSMutableArray *SchoolList;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _SchoolList = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _totalSubModule = 0;
    _subModuleDic = [[NSMutableArray alloc]init];
    [self bgLayout];

}


-(void) bgLayout{
    
    NSString *pant = [[NSBundle mainBundle] pathForResource:@"bg102" ofType:@"jpg"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:pant];
    
    _bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [_bgView setImage:image];
    [_bgView setContentMode:UIViewContentModeScaleAspectFit];
    _bgView.userInteractionEnabled = YES;
    _bgView.contentMode = UIViewContentModeScaleAspectFill;
    _bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _bgView.clipsToBounds = YES;
    [self.view addSubview:_bgView];
    
    _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _bgView.frame.size.width, _bgView.frame.size.height)];
    _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    _maskView.userInteractionEnabled = YES;
    [_bgView addSubview:_maskView];
    //                [self startLayout];
    [self httpGetSchool];
    
    [self startLayout];
    
//    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
//    dispatch_async(concurrentQueue, ^{
//        __block UIImage *image = nil;
//        dispatch_sync(concurrentQueue, ^{
//            NSString *urlAsString = @"http://www.bmwdream.cn/Public/GJTEST/bg102.jpg";
//            NSURL *url = [NSURL URLWithString:urlAsString];
//            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//            NSError *downloadError = nil;
//            NSData *imageData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&downloadError];
//
//            if(downloadError == nil && imageData != nil){
//                image = [UIImage imageWithData:imageData];
//            }else if(downloadError != nil){
//                NSLog(@"Error happend = %@",downloadError);
//            }else{
//                NSLog(@"No data could get downloaded from the URL.");
//            }
//        });
//
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            if(image != nil){
//                _bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//                [_bgView setImage:image];
//                [_bgView setContentMode:UIViewContentModeScaleAspectFit];
//                _bgView.userInteractionEnabled = YES;
//                _bgView.contentMode = UIViewContentModeScaleAspectFill;
//                _bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//                _bgView.clipsToBounds = YES;
//                [self.view addSubview:_bgView];
//                [_bgView autorelease];
//
//                _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _bgView.frame.size.width, _bgView.frame.size.height)];
//                _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
//                _maskView.userInteractionEnabled = YES;
//                [_bgView addSubview:_maskView];
////                [self startLayout];
//                [self httpGetSchool];
//            }else{
//                NSLog(@"Image isn't downloaded.Nothing to display.");
//            }
//        });
//    });
//
}


-(void) httpGetSchool{
    
    //DO_MAIN
    NSString *urlString = [NSString stringWithFormat:@"http://120.78.148.58:98/jiekou/json/diaoyongxuexiao.ashx?Password=gjrjGJRJ"];

//    NSString *urlString = [NSString stringWithFormat:@"%@/jiekou/json/diaoyongxuexiao.ashx?Password=gjrjGJRJ",DO_MAIN];

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        //block 参数的解释
        //response 响应头的信息
        //data 我们所需要的真是的数据
        //connectionError 链接服务器的错误信息
        if (connectionError != nil) {
            /*
             {
             
             "number":"100000",
             
             "WeChat":"",
             
             "trial":"否",
             
             "term":"",
             
             "Schoolname":"顺德职业技术学院",
             
             "URL":"http://120.78.148.58",
             
             "Sign":"2018年1月1日",
             
             "Auditing":"2018年1月10日",
             
             "ensure":"2019年12月1日",
             
             "Date":"2018年6月8日"
             
             }
             */
            _SchoolList = [[NSMutableArray alloc] init];
            NSMutableDictionary *a_default_dict = [NSMutableDictionary dictionaryWithCapacity:0];
            [a_default_dict setObject:@"100000" forKey:@"number"];
            [a_default_dict setObject:@"顺德职业技术学院" forKey:@"Schoolname"];
            [a_default_dict setObject:@"http://120.78.148.58" forKey:@"URL"];
            [a_default_dict setObject:@"2018年1月10日" forKey:@"Sign"];
            [a_default_dict setObject:@"2019年12月1日" forKey:@"ensure"];
            [a_default_dict setObject:@"2018年6月8日" forKey:@"Date"];
            [_SchoolList addObject:a_default_dict];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取学校失败请重试" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
            alert.tag = kSuccessCodeTag;
            [alert show];
            return ;
        }
        NSString *jsonStr;
        jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonStr);
        NSDictionary *jsonDic = [PhoneInfo jsonDictWithString:jsonStr];
        
        _SchoolList = [jsonDic objectForKey:@"data"];
        _SchoolList = [_SchoolList mutableCopy];

    }];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == kSuccessCodeTag) {
        if (buttonIndex == 1) {
            [self httpGetSchool];
        }
    }
}






-(void) startLayout{
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[UIColor whiteColor]];
    _activityIndicatorView.frame = CGRectMake((_bgView.frame.size.width - 100)/2, (_bgView.frame.size.height - 100)/2, 100, 100);
    [_bgView addSubview:_activityIndicatorView];
    
    _SchoolArr = [[NSMutableArray alloc]init];
    
    _logoView = [[UIImageView alloc]initWithFrame:CGRectMake(_maskView.frame.size.width * 0.1, _maskView.frame.size.height * 0.1, _maskView.frame.size.width * 0.15, _maskView.frame.size.width * 0.15)];
    _logoView.image = [UIImage imageNamed:@"gj_loginlogo"];
    [_maskView addSubview:_logoView];
    _logoView.hidden = YES;
    
    _logoView1 = [[UIImageView alloc]initWithFrame:CGRectMake(_maskView.frame.size.width * 0.1, _maskView.frame.size.height * 0.1, _maskView.frame.size.width * 0.15, _maskView.frame.size.width * 0.15)];
    _logoView1.image = [UIImage imageNamed:@"gj_loginlogo"];
    [_maskView addSubview:_logoView1];
    _logoView1.hidden = YES;
    _logoLab = [[UILabel alloc]initWithFrame:CGRectMake(_logoView.frame.origin.x + _logoView.frame.size.width * 1.2, _logoView.frame.origin.y, _maskView.frame.size.width * 0.65, _maskView.frame.size.width * 0.15)];
    _logoLab.text = @"国 晋 云";
    _logoLab.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:32];
    _logoLab.textColor = [UIColor whiteColor];
    [_maskView addSubview:_logoLab];
    _logoLab.hidden = YES;
    [_logoView1.layer addAnimation:[self groups] forKey:nil];
    
    
    _chooseField = [[MLPAutoCompleteTextField alloc]initWithFrame:CGRectMake(_maskView.frame.size.width * 0.1, _logoView.frame.origin.y + _logoView.frame.size.height + _maskView.frame.size.width * 0.05, _maskView.frame.size.width * 0.8, _maskView.frame.size.width * 0.15) getView:_maskView];
    _chooseField.text = @"";
    _chooseField.font = [UIFont systemFontOfSize:24];
    NSString *chooseP = @"学校";
    NSMutableAttributedString *chooseAttr = [[NSMutableAttributedString alloc] initWithString:chooseP];
    [chooseAttr addAttribute:NSForegroundColorAttributeName
                       value:[UIColor colorWithRed:243/255.0 green:242/255.0 blue:240/255.0 alpha:1]
                       range:NSMakeRange(0, chooseP.length)];
    _chooseField.attributedPlaceholder = chooseAttr;
    _chooseField.textColor = [UIColor whiteColor];
    _chooseField.delegate = self;
    _chooseField.autoCompleteDataSource = self;
    [_maskView addSubview:_chooseField];
    
    _accountField = [[UITextField alloc]initWithFrame:CGRectMake(_maskView.frame.size.width * 0.1, _chooseField.frame.origin.y + _chooseField.frame.size.height ,_maskView.frame.size.width * 0.8, _maskView.frame.size.width * 0.15)];
    _accountField.text = @"";
    _accountField.font = [UIFont systemFontOfSize:24];
    NSString *accountP = @"学号／手机号／邮箱";
    NSMutableAttributedString *accountAttr = [[NSMutableAttributedString alloc] initWithString:accountP];
    [accountAttr addAttribute:NSForegroundColorAttributeName
                        value:[UIColor colorWithRed:243/255.0 green:242/255.0 blue:240/255.0 alpha:1]
                        range:NSMakeRange(0, accountP.length)];
    _accountField.attributedPlaceholder = accountAttr;
    _accountField.textColor = [UIColor whiteColor];
    _accountField.delegate = self;
    [_maskView addSubview:_accountField];
    
    _pwdField = [[UITextField alloc]initWithFrame:CGRectMake(_maskView.frame.size.width * 0.1, _accountField.frame.origin.y + _accountField.frame.size.height, _maskView.frame.size.width * 0.8, _maskView.frame.size.width * 0.15)];
    _pwdField.text = @"";
    _pwdField.font = [UIFont systemFontOfSize:24];
    NSString *pwdP = @"密码";
    NSMutableAttributedString *pwdAttr = [[NSMutableAttributedString alloc] initWithString:pwdP];
    [pwdAttr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithRed:243/255.0 green:242/255.0 blue:240/255.0 alpha:1]
                    range:NSMakeRange(0, pwdP.length)];
    _pwdField.attributedPlaceholder = pwdAttr;
    _pwdField.textColor = [UIColor whiteColor];
    _pwdField.secureTextEntry = YES;
    _pwdField.delegate = self;
    [_maskView addSubview:_pwdField];
    
    
    [_chooseField.layer addSublayer:[self setBottom:1 doView:_chooseField]];
    [_accountField.layer addSublayer:[self setBottom:1 doView:_accountField]];
    [_pwdField.layer addSublayer:[self setBottom:1 doView:_pwdField]];
    
    _loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(_maskView.frame.size.width * 0.1, _pwdField.frame.origin.y + _pwdField.frame.size.height * 1.5, _maskView.frame.size.width * 0.8, _maskView.frame.size.width * 0.12)];
    _loginBtn.backgroundColor = [UIColor colorWithRed:20/255.0 green:184/255.0 blue:247/255.0 alpha:0.8];
    _loginBtn.layer.cornerRadius = 5;
    [_loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
    [_maskView addSubview:_loginBtn];
    
    
    _forgetPwdLab = [[UILabel alloc]initWithFrame:CGRectMake(_maskView.frame.size.width * 0.1, _loginBtn.frame.size.height*1.2 + _loginBtn.frame.origin.y, _maskView.frame.size.width * 0.4, _maskView.frame.size.width * 0.05)];
    _forgetPwdLab.text = @"忘记密码？";
    _forgetPwdLab.textColor = [UIColor colorWithRed:20/255.0 green:184/255.0 blue:247/255.0 alpha:1];
    _forgetPwdLab.textAlignment = UITextAlignmentLeft;
    _forgetPwdLab.userInteractionEnabled = YES;
    [_maskView addSubview:_forgetPwdLab];
    
    _regLab = [[UILabel alloc]initWithFrame:CGRectMake(_forgetPwdLab.frame.origin.x + _forgetPwdLab.frame.size.width, _loginBtn.frame.size.height*1.2 + _loginBtn.frame.origin.y, _maskView.frame.size.width * 0.4, _maskView.frame.size.width * 0.05)];
    _regLab.text = @"新用户注册";
    _regLab.textColor = [UIColor colorWithRed:20/255.0 green:184/255.0 blue:247/255.0 alpha:1];
    _regLab.textAlignment = UITextAlignmentRight;
    _regLab.userInteractionEnabled = YES;
    [_maskView addSubview:_regLab];
    _regLab.hidden = YES;
    _serviceLab = [[UILabel alloc]initWithFrame:CGRectMake(_maskView.frame.size.width * 0.1, _maskView.frame.size.height - _maskView.frame.size.width * 0.2, _maskView.frame.size.width * 0.8, _maskView.frame.size.width * 0.1)];
    _serviceLab.textColor = [UIColor whiteColor];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"登录即代表阅读并同意服务条款"];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:20/255.0 green:184/255.0 blue:247/255.0 alpha:1] range:NSMakeRange(10, 4)];
    _serviceLab.attributedText = string;
    _serviceLab.textAlignment = UITextAlignmentCenter;
    _serviceLab.userInteractionEnabled = YES;
    [_maskView addSubview:_serviceLab];
    _serviceLab.hidden = YES;
    _forgetEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(forgetAction)];
    [_forgetPwdLab addGestureRecognizer:_forgetEvent];
    
    _regEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(regAction)];
    [_regLab addGestureRecognizer:_regEvent];
    
    _serviceEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(serviceAction)];
    [_serviceLab addGestureRecognizer:_serviceEvent];
    
    
    if([AizenStorage readUserDataWithKey:@"ChooseObj"])
        _chooseField.text = [NSString stringWithFormat:@"%@",[AizenStorage readUserDataWithKey:@"ChooseObj"]];
    else
        _chooseField.text = @"";
    //顺德职业技术学院
    
    
    if([AizenStorage readUserDataWithKey:@"Account"])
        _accountField.text = [NSString stringWithFormat:@"%@",[AizenStorage readUserDataWithKey:@"Account"]];
    else
        _accountField.text = @"";
        //201203053105
    
    
    if([AizenStorage readUserDataWithKey:@"Pwd"])
        _pwdField.text = [AizenStorage readUserDataWithKey:@"Pwd"];
    else
        _pwdField.text = @"";
        //13533999213
    
    
    
    
    /*动画制作开始*/
    
    
    /*动画制作结束*/
}

-(void) goLogin{
    
    NSString *chooseVal = _chooseField.text;
    NSString *accountVal = _accountField.text;
    NSString *pwdVal = _pwdField.text;
    
    
    
    if([chooseVal isEqualToString:@""] || [accountVal isEqualToString:@""] || [pwdVal isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请填写登录信息"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil,nil];
        [alert show];
    }else{
        [_activityIndicatorView startAnimating];

        /*登录前把所选择的学校数据全部记录-------------------start*/
        NSMutableDictionary *getCurrSchoolDic = [[NSMutableDictionary alloc]init];
        for(int x = 0;x<[_SchoolList count];x++){
            NSMutableDictionary *getDic = [_SchoolList objectAtIndex:x];
            if([[getDic objectForKey:@"Schoolname"] isEqualToString:chooseVal]){
                getCurrSchoolDic = getDic;
            }
        }
        
        if([getCurrSchoolDic count] == 0){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请认真填写学校名称" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            NSLog(@"%@",getCurrSchoolDic);
            NSString *CurrSchoolNumber = [getCurrSchoolDic objectForKey:@"number"];
            NSString *CurrSchoolName = [getCurrSchoolDic objectForKey:@"Schoolname"];
            NSString *CurrSchoolURL = [getCurrSchoolDic objectForKey:@"URL"];
            NSString *CurrSchoolBaseUrl = [NSString stringWithFormat:@"%@/ApiLogin",CurrSchoolURL];
            
            
            [AizenStorage writeUserDataWithKey:CurrSchoolNumber forKey:@"CurrSchoolNumber"];
            [AizenStorage writeUserDataWithKey:CurrSchoolName forKey:@"CurrSchoolName"];
            [AizenStorage writeUserDataWithKey:CurrSchoolURL forKey:@"DO_MAIN"];
            [AizenStorage writeUserDataWithKey:CurrSchoolBaseUrl forKey:@"BASIS_URL"];
            
            
            /*-----------------------登录请求-----------------------*/
            [_activityIndicatorView startAnimating];
            UInt64 currTime = [[NSDate date] timeIntervalSince1970]*1000;
            NSString *currTimeStr = [NSString stringWithFormat:@"%ld",currTime];

            NSString *md5Str = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@%@GJ%@",accountVal,currTimeStr,pwdVal]];

//            NSString *url = [NSString stringWithFormat:@"%@/Index?UserName=%@&Password=%@&TimeStamp=%@&Token=%@",BASIS_URL,accountVal,pwdVal,currTimeStr,md5Str];
            NSString *url = [NSString stringWithFormat:@"%@/Index?UserName=%@&Password=%@&TimeStamp=%@&Token=%@",[AizenStorage readUserDataWithKey:@"BASIS_URL"],accountVal,pwdVal,currTimeStr,md5Str];
            [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
                
                [_activityIndicatorView stopAnimating];

                NSDictionary *jsonDic = result;
                NSString *flagStr = [jsonDic objectForKey:@"Message"];
                if([flagStr isEqualToString:@"登录成功。"]){
                    NSDictionary *personData = [jsonDic objectForKey:@"AppendData"];
                    NSLog(@"%@",personData);
                    [self successLogin:personData account:accountVal pwd:pwdVal choose:chooseVal];
                }else{
                    /*登录失败*/
                    [self errorLogin:flagStr];
                }
            } failue:^(NSError *error) {
                NSLog(@"%@",error);
                [_activityIndicatorView stopAnimating];
                /*登录失败*/
                [self errorLogin:@"登录失败，请重试"];
            }];
        }
        
        

    }
    
}

+ (void)hadLogInRefrshData{
    
    NSMutableDictionary *tem= [BaseViewController br_getAppDelegate].batchDic;
     [tem removeAllObjects];
    
    NSMutableArray *_subModuleDic = [BaseViewController br_getAppDelegate].subModuleDic;
      [_subModuleDic removeAllObjects];
    
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    if (CurrAdminID != nil) {
        return;
    }
    NSDictionary *personData = @{@"ID":CurrAdminID};
    /*获取用户权限显示----顶层模块*/
    NSString *url = [NSString stringWithFormat:@"%@/TopModuleList?adminID=%@",[AizenStorage readUserDataWithKey:@"BASIS_URL"],[personData objectForKey:@"ID"]];
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        NSArray *jsonArr = result;
        if([jsonArr count] == 0){
            [LoginViewController errorLogin:@"该用户没有配置相关权限"];
        }else{
            [AizenStorage writeUserDataWithKey:[AppCache handleTopModuleArr:jsonArr] forKey:@"TopModule"];
            
            for(int i = 0;i<[jsonArr count];i++){
                NSString *topID = [jsonArr[i]objectForKey:@"ID"];
                NSString *adminID = [personData objectForKey:@"ID"];
                
                NSString *url = [NSString stringWithFormat:@"%@/ApiLogin/ModuleList?topID=%@&adminID=%@",kCacheHttpRoot,topID,adminID];
                NSLog(@"%@",url);
                [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
                    NSMutableArray *subJsonArr = result;
                    if ([subJsonArr isKindOfClass:[NSArray class]]) {
                        [self CheckClassHttpSubModule:jsonArr SubModule:subJsonArr TopId:topID UserId:[personData objectForKey:@"ID"]];
                    }
                    else{
                        [self CheckClassHttpSubModule:jsonArr SubModule:nil TopId:topID UserId:[personData objectForKey:@"ID"]];
                    }
                    
                } failue:^(NSError *error) {
                    NSLog(@"获取%@模块失败",[jsonArr[i]objectForKey:@"Name"]);
                }];
                
            }
        }
    } failue:^(NSError *error) {
        [self errorLogin:@"网络错误"];
    }];
    
    
}

-(void)successLogin:(NSDictionary *)personData account:(NSString *)account pwd:(NSString *)pwd choose:(NSString *)choose{
    NSLog(@"--------------------------------------%@",[personData objectForKey:@"ID"]);
    
    People *p = [People new];
    p.ACCOUNT = account;
    p.PWD = pwd;
    p.USERID = [personData objectForKey:@"ID"];
    p.USERNO = [personData objectForKey:@"UserNo"];
    p.USERNAME = [personData objectForKey:@"UserName"];
    p.PHONE = [personData objectForKey:@"Mobile"];
    p.EMAIL = [personData objectForKey:@"Email"];
    p.SEX = [personData objectForKey:@"Sex"];
    p.COLLEGEID = [personData objectForKey:@"CollegaID"];
    p.COLLEGENAME = [personData objectForKey:@"CollegaName"];
    p.SUBJECTID = [personData objectForKey:@"SubjectID"];
    p.SUBJECTNAME = [personData objectForKey:@"SubjectName"];
    p.GRADEID = [personData objectForKey:@"GradeID"];
    p.GRADENAME = [personData objectForKey:@"GradeName"];
    p.CLASSID = [personData objectForKey:@"ClassID"];
    p.CLASSNAME = [personData objectForKey:@"ClassName"];
    p.LASTLOGINDATE = [DBController stringWithDate:[NSDate date]];
    p.FactUrl = [personData objectForKey:@"FactUrl"];
    p.signUrl = [personData objectForKey:@"SignUrl"];
    /*判断是否已经存在数据*/
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",account]];
    if(existArr == nil){
        [p bg_save];
    }else{
        [p bg_updateWhere:[NSString stringWithFormat:@"where account='%@'",account]];
    }
    
    /*获取用户权限显示----顶层模块*/
    NSString *url = [NSString stringWithFormat:@"%@/TopModuleList?adminID=%@",[AizenStorage readUserDataWithKey:@"BASIS_URL"],[personData objectForKey:@"ID"]];
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        NSArray *jsonArr = result;
        if([jsonArr count] == 0){
            [self errorLogin:@"该用户没有配置相关权限"];
        }else{
            [AizenStorage writeUserDataWithKey:[AppCache handleTopModuleArr:jsonArr] forKey:@"TopModule"];
            
            for(int i = 0;i<[jsonArr count];i++){
                NSString *topID = [jsonArr[i]objectForKey:@"ID"];
                NSString *adminID = [personData objectForKey:@"ID"];
                
                NSString *url = [NSString stringWithFormat:@"%@/ApiLogin/ModuleList?topID=%@&adminID=%@",kCacheHttpRoot,topID,adminID];
                NSLog(@"%@",url);
                [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
                    NSMutableArray *subJsonArr = result;
                    if ([subJsonArr isKindOfClass:[NSArray class]]) {
                         [self CheckHttpSubModule:jsonArr SubModule:subJsonArr TopId:topID UserId:[personData objectForKey:@"ID"]];
                    }
                    else{
                        [self CheckHttpSubModule:jsonArr SubModule:nil TopId:topID UserId:[personData objectForKey:@"ID"]];
                    }
                } failue:^(NSError *error) {
                    NSLog(@"获取%@模块失败",[jsonArr[i]objectForKey:@"Name"]);
                }];
            }
        }
    } failue:^(NSError *error) {
        [self errorLogin:@"网络错误"];
    }];
    
    
    /*登录验证成功,把信息开始写入数据库*/
    
    [AizenStorage writeUserDataWithKey:choose forKey:@"ChooseObj"];
    [AizenStorage writeUserDataWithKey:account forKey:@"Account"];
    [AizenStorage writeUserDataWithKey:pwd forKey:@"Pwd"];
}



-(void)errorLogin:(NSString *)flagStr{
    UIAlertView *ErrorAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:flagStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [ErrorAlert show];
    [_activityIndicatorView stopAnimating];
}

+(void)errorLogin:(NSString *)flagStr{
    UIAlertView *ErrorAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:flagStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [ErrorAlert show];
}

-(void) forgetAction{
    NSString *schoolVal = _chooseField.text;
    NSString *accountVal = _accountField.text;
    if([schoolVal isEqualToString:@""] || [accountVal isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先填写账号与选择学校。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        NSLog(@"%@",schoolVal);
        _SchoolArr = [self possibleAutoCompleteSuggestionsForString:schoolVal];
        if([_SchoolArr containsObject:schoolVal]){
            //包含
//            ForgetViewController *forget = [[ForgetViewController alloc]init];
//            [self presentViewController:forget animated:YES completion:nil];
            OutlookViewController *outlook = [[OutlookViewController alloc]init];
            outlook.accountVal = accountVal;
            [self presentViewController:outlook animated:YES completion:nil];
        }else{
            //不包含
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"选择学校错误。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

-(void) regAction{
    RAlertView *alert = [[RAlertView alloc] initWithStyle:ConfirmAlert];
    alert.headerTitleLabel.text = @"提示";
    alert.contentTextLabel.attributedText = [TextHelper attributedStringForString:@"尚未开通，敬请期待。" lineSpacing:5];
    [alert.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [alert.confirmButton setBackgroundColor:[UIColor colorWithRed:20/255.0 green:184/255.0 blue:247/255.0 alpha:1]];
    alert.confirm = ^(){
        NSLog(@"Click on the Ok");
    };
}


-(void) serviceAction{
    RAlertView *alert = [[RAlertView alloc] initWithStyle:ConfirmAlert];
    alert.headerTitleLabel.text = @"提示";
    alert.contentTextLabel.attributedText = [TextHelper attributedStringForString:@"尚未开通，敬请期待。" lineSpacing:5];
    [alert.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [alert.confirmButton setBackgroundColor:[UIColor colorWithRed:20/255.0 green:184/255.0 blue:247/255.0 alpha:1]];
    alert.confirm = ^(){
        NSLog(@"Click on the Ok");
    };
}



-(CALayer *) setBottom:(CGFloat)width doView:(UITextField*)fieldView{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, fieldView.frame.size.height - width, fieldView.frame.size.width, width);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    return layer;
}


- (CAAnimationGroup *)groups {
    if (!_groups){
        CABasicAnimation * scaleAnim = [CABasicAnimation animation];
        scaleAnim.keyPath = @"transform.scale";
        scaleAnim.fromValue = @1;
        scaleAnim.toValue = @1.4;
        scaleAnim.duration = 2;
        
        CABasicAnimation *opacityAnim=[CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim.fromValue= @1;
        opacityAnim.toValue= @0.1;
        opacityAnim.duration= 2;
        
        _groups =[CAAnimationGroup animation];
        _groups.animations = @[scaleAnim,opacityAnim];
        _groups.removedOnCompletion = NO;
        _groups.fillMode = kCAFillModeForwards;
        _groups.duration = 2;
        _groups.repeatCount = FLT_MAX;
    }
    return _groups;
}







- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - MLPAutoCompleteTextField DataSource
- (NSMutableArray *)possibleAutoCompleteSuggestionsForString:(NSString *)string{
//    NSMutableArray *school =
//    @[@"顺德职业技术学院",
//      @"中山大学",
//      @"中南大学",
//      @"华南理工大学"];
    
    NSMutableArray *school = [[NSMutableArray alloc]init];
    for(int i = 0;i<[_SchoolList count];i++){
        NSMutableDictionary *getDic = [_SchoolList objectAtIndex:i];
        NSString *Schoolname = getDic[@"Schoolname"];
        if ([Schoolname rangeOfString:string].location != NSNotFound) {
            [school addObject:Schoolname];
        }
        else{
            if (string.length == 0) {
                [school addObject:Schoolname];
            }
        }
    }
    return school;
}


#pragma mark - MLPAutoCompleteTextField Delegate
- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
          shouldConfigureCell:(UITableViewCell *)cell
       withAutoCompleteString:(NSString *)autocompleteString
         withAttributedString:(NSAttributedString *)boldedString
            forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //This is your chance to customize an autocomplete tableview cell before it appears in the autocomplete tableview
    //    NSString *filename = [autocompleteString stringByAppendingString:@".png"];
    //    filename = [filename stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    //    filename = [filename stringByReplacingOccurrencesOfString:@"&" withString:@"and"];
    //    [cell.imageView setImage:[UIImage imageNamed:filename]];
    return YES;
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
  didSelectAutoCompleteString:(NSString *)selectedString
       withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject
            forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(selectedObject){
        NSLog(@"selected object from autocomplete menu %@ with string %@", selectedObject, [selectedObject autocompleteString]);
    } else {
        NSLog(@"selected string '%@' from autocomplete menu", selectedString);
    }
}





#pragma mark - HttpRespone

+ (void)CheckClassHttpSubModule:(NSArray *)jsonArr SubModule:(NSMutableArray *)subArr TopId:(NSString *)topID UserId:(NSString *)userid{
    /*获取请假类型*/
    NSString *url = [NSString stringWithFormat:@"%@/ApiSystem/GetLeaveType",[AizenStorage readUserDataWithKey:@"DO_MAIN"]];
    NSLog(@"%@",url);
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        NSDictionary *jsonDic = result;
        NSLog(@"%@",jsonDic);
        NSArray *dataArr = [jsonDic objectForKey:@"AppendData"];
        [AizenStorage writeUserDataWithKey:dataArr forKey:@"LeaveType"];
    } failue:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    NSMutableDictionary *tem= [BaseViewController br_getAppDelegate].batchDic;
   // [tem removeAllObjects];
    
    NSMutableArray *_subModuleDic = [BaseViewController br_getAppDelegate].subModuleDic;
  //  [_subModuleDic removeAllObjects];
    
    NSInteger _totalSubModule = [BaseViewController br_getAppDelegate].totalSubModule;
    
    NSString *batchUrl2 = [NSString stringWithFormat:@"%@/ApiActivity/GetActivityList?AdminID=%@&ActivityType=%@",[AizenStorage readUserDataWithKey:@"DO_MAIN"],userid,@"2"];
    [AizenHttp asynRequest:batchUrl2 httpMethod:@"GET" params:nil success:^(id result) {
        NSDictionary *jsonDic = result;
        NSArray *appendData1 = [jsonDic objectForKey:@"AppendData"];
        if(![appendData1 isKindOfClass:[NSNull class]]){
            [tem setObject:appendData1 forKey:@"sxgl"];
        }
        
        [AizenStorage writeUserDataWithKey:tem forKey:@"batch"];
        [LoginViewController setBatch:tem];
    } failue:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误--实习管理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    
    
    if([subArr count] != 0){
        NSMutableArray *getNewArr = [AppCache handleSubModuleArr:subArr];
        [_subModuleDic addObject:getNewArr];
    }
    
    _totalSubModule++;
    [BaseViewController br_getAppDelegate].totalSubModule = _totalSubModule;
    if(_totalSubModule == [jsonArr count]){
        [AizenStorage writeUserDataWithKey:_subModuleDic forKey:@"SubModule"];
        
        [AizenStorage writeUserBoolWithKey:YES forKey:@"isLogin"];
      
    }
    
    
}

- (void)CheckHttpSubModule:(NSArray *)jsonArr SubModule:(NSMutableArray *)subArr TopId:(NSString *)topID UserId:(NSString *)userid{
    
    /*获取请假类型*/
    NSString *url = [NSString stringWithFormat:@"%@/ApiSystem/GetLeaveType",[AizenStorage readUserDataWithKey:@"DO_MAIN"]];
    NSLog(@"%@",url);
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        NSDictionary *jsonDic = result;
        NSLog(@"%@",jsonDic);
        NSArray *dataArr = [jsonDic objectForKey:@"AppendData"];
        [AizenStorage writeUserDataWithKey:dataArr forKey:@"LeaveType"];
    } failue:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
    }];
    
    
    /*获取批次---学徒制*/
    _batchDic = [[NSMutableDictionary alloc]init];
    NSString *batchUrl1 = [NSString stringWithFormat:@"%@/ApiActivity/GetActivityList?AdminID=%@&ActivityType=%@",[AizenStorage readUserDataWithKey:@"DO_MAIN"],userid,@"1"];
    NSString *batchUrl2 = [NSString stringWithFormat:@"%@/ApiActivity/GetActivityList?AdminID=%@&ActivityType=%@",[AizenStorage readUserDataWithKey:@"DO_MAIN"],userid,@"2"];
    NSString *batchUrl3 = [NSString stringWithFormat:@"%@/ApiActivity/GetActivityList?AdminID=%@&ActivityType=%@",[AizenStorage readUserDataWithKey:@"DO_MAIN"],userid,@"3"];
    NSString *batchUrl4 = [NSString stringWithFormat:@"%@/ApiActivity/GetActivityList?AdminID=%@&ActivityType=%@",[AizenStorage readUserDataWithKey:@"DO_MAIN"],userid,@"4"];
    
    [AizenHttp asynRequest:batchUrl1 httpMethod:@"GET" params:nil success:^(id result) {
        NSDictionary *jsonDic = result;
        NSArray *appendData = [jsonDic objectForKey:@"AppendData"];
        if(![appendData isKindOfClass:[NSNull class]]){
            [_batchDic setObject:appendData forKey:@"xtz"];
        }

        [AizenHttp asynRequest:batchUrl2 httpMethod:@"GET" params:nil success:^(id result) {
            NSDictionary *jsonDic = result;
            NSArray *appendData1 = [jsonDic objectForKey:@"AppendData"];
            if(![appendData1 isKindOfClass:[NSNull class]]){
                [_batchDic setObject:appendData1 forKey:@"sxgl"];
            }
            [AizenHttp asynRequest:batchUrl3 httpMethod:@"GET" params:nil success:^(id result) {
                NSDictionary *jsonDic = result;
                NSArray *appendData2 = [jsonDic objectForKey:@"AppendData"];
                if(![appendData2 isKindOfClass:[NSNull class]]){
                    [_batchDic setObject:appendData2 forKey:@"lwgl"];
                }
                [AizenHttp asynRequest:batchUrl4 httpMethod:@"GET" params:nil success:^(id result) {
                    NSDictionary *jsonDic = result;
                    NSArray *appendData3 = [jsonDic objectForKey:@"AppendData"];
                    if(![appendData3 isKindOfClass:[NSNull class]]){
                        [_batchDic setObject:appendData3 forKey:@"hyhd"];
                    }
                    [AizenStorage writeUserDataWithKey:_batchDic forKey:@"batch"];
                    
                    [LoginViewController setBatch:_batchDic];
                } failue:^(NSError *error) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误--会议活动" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }];

            } failue:^(NSError *error) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误--论文管理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }];

        } failue:^(NSError *error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误--实习管理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }];

    } failue:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误--学徒制" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];


    if([subArr count] != 0){
        NSMutableArray *getNewArr = [AppCache handleSubModuleArr:subArr];
        [_subModuleDic addObject:getNewArr];
    }

    _totalSubModule++;
    if(_totalSubModule == [jsonArr count]){
        [AizenStorage writeUserDataWithKey:_subModuleDic forKey:@"SubModule"];

        [AizenStorage writeUserBoolWithKey:YES forKey:@"isLogin"];
        UITabBarController *tabbar = [ViewController getRootTabbar];
        [BaseViewController br_getAppDelegate].mainTabbar = tabbar;
        [self presentViewController:tabbar animated:YES completion:nil];
        [_activityIndicatorView stopAnimating];
    }
}


+(void)setBatch:(NSMutableDictionary *)sender{
    int num = 0;
    for(NSString *key in sender){
        NSMutableArray *arr = sender[key];
        num = num + [arr count];
    }
    NSLog(@"%@",sender);
    if(num == 1){
        NSString *batchID = @"";
        for(NSString *key in sender){
            NSMutableArray *arr = sender[key];
            if([arr count] == 1){
                batchID = [[arr[0] objectForKey:@"ActivityID"] stringValue];
            }
        }
        [AizenStorage writeUserDataWithKey:batchID forKey:@"batchID"];
    }
    
    
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
