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
@property (nonatomic,weak)IBOutlet UIView *maskView;
@property UIImageView *logoView;
@property UIImageView *logoView1;
@property UILabel *logoLab;
@property (nonatomic,weak) IBOutlet MLPAutoCompleteTextField *chooseField;
@property (nonatomic,weak) IBOutlet UITextField *accountField;
@property (nonatomic,weak) IBOutlet UITextField *pwdField;
@property UIButton *loginBtn;
@property CAAnimationGroup *groups;
@property UILabel *forgetPwdLab;
@property UILabel *regLab;
@property UILabel *serviceLab;
@property UITapGestureRecognizer *forgetEvent;
@property UITapGestureRecognizer *regEvent;
@property UITapGestureRecognizer *serviceEvent;
@property NSMutableArray *SchoolArr;

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
    [self httpGetSchool];
    [self startLayout];
}
-(void) httpGetSchool{
    
    NSString *urlString = [NSString stringWithFormat:@"http://120.78.148.58:98/jiekou/json/diaoyongxuexiao.ashx?Password=gjrjGJRJ"];
    [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:urlString parameters:@{} success:^(id  _Nonnull responseObject) {
        NSArray *data = [responseObject objectForKey:@"data"];
        if (data.count > 0) {
            _SchoolList = [data mutableCopy];
        }else{
            
        }
    } failure:^(NSError * _Nonnull error) {
        
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
    _chooseField.autoCompleteDataSource = self;
    _chooseField.maskView = self.maskView;
    if([AizenStorage readUserDataWithKey:@"ChooseObj"])
        _chooseField.text = [NSString stringWithFormat:@"%@",[AizenStorage readUserDataWithKey:@"ChooseObj"]];
    else
        _chooseField.text = @"";
    //顺德职业技术学院
    if([AizenStorage readUserDataWithKey:@"Account"])
        _accountField.text = [NSString stringWithFormat:@"%@",[AizenStorage readUserDataWithKey:@"Account"]];
    else
        _accountField.text = @"";
    if([AizenStorage readUserDataWithKey:@"Pwd"])
        _pwdField.text = [AizenStorage readUserDataWithKey:@"Pwd"];
    else
        _pwdField.text = @"";
}

-(IBAction) goLogin{
    
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
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

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
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UInt64 currTime = [[NSDate date] timeIntervalSince1970]*1000;
            NSString *currTimeStr = [NSString stringWithFormat:@"%ld",currTime];

            NSString *md5Str = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@%@GJ%@",accountVal,currTimeStr,pwdVal]];

//            NSString *url = [NSString stringWithFormat:@"%@/Index?UserName=%@&Password=%@&TimeStamp=%@&Token=%@",BASIS_URL,accountVal,pwdVal,currTimeStr,md5Str];
            NSString *url = [NSString stringWithFormat:@"%@/Index?UserName=%@&Password=%@&TimeStamp=%@&Token=%@",[AizenStorage readUserDataWithKey:@"BASIS_URL"],accountVal,pwdVal,currTimeStr,md5Str];
            [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];

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
                [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

+(void)errorLogin:(NSString *)flagStr{
    UIAlertView *ErrorAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:flagStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [ErrorAlert show];
}

-(IBAction)forgetAction{
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
        tabbar.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:tabbar animated:YES completion:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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


@end
