//
//  ViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/1/6.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

/***********************************欢迎页***********************************/

#import "ViewController.h"
#import "AizenHttp.h"
#import "LoginViewController.h"
#import "AizenStorage.h"
#import "MainViewController.h"
#import "People.h"
#import "AizenStorage.h"
#import "AppCache.h"

#import "NewMsgViewController.h"
#import "NewWorkViewController.h"
#import "ServiceViewController.h"
#import "NewMeViewController.h"
#import "BaseNavigationController.h"
#import "IBCreatHelper.h"
#import "GJMineViewController.h"
@interface ViewController ()<UIAlertViewDelegate>

@property UIImageView *logoImg;
@property UILabel *tipLab;
@property UILabel *footerLab;
@property LoginViewController *loginCtl;
@property MainViewController *mainPag;

@property NSMutableArray *SchoolArr;

@property int totalSubModule;
@property NSMutableArray *subModuleDic;

@property NSMutableDictionary *batchDic;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _totalSubModule = 0;
    _subModuleDic = [[NSMutableArray alloc]init];
    if ([AizenStorage readUserDataWithKey:@"isFIrstApp"] == nil) {
        NSURL *ruel = [NSURL URLWithString:@"https://www.baidu.com/"];
        NSURLSessionDataTask *tak = [NSURLSession.sharedSession dataTaskWithURL:ruel completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
        }];
        [tak resume];
        [AizenStorage writeUserBoolWithKey:YES forKey:@"isFIrstApp"];
    }
    
    // Do any additional setup after loading the view, typically from a nib.
    [self startLayout];
}

-(void) startLayout{
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _logoImg = [[UIImageView alloc]initWithFrame:CGRectMake(viewWidth * 0.25, viewHeight * 0.2, viewWidth * 0.5, viewWidth * 0.4)];
    _logoImg.alpha = 0;
    UIImage *logoImage = [UIImage imageNamed:@"lauch_logo"];
    [_logoImg setImage:logoImage];
    _logoImg.backgroundColor = [UIColor redColor];
    [self.view addSubview:_logoImg];
    
    _tipLab = [[UILabel alloc]initWithFrame:CGRectMake(viewWidth * 0.25, _logoImg.frame.origin.y + _logoImg.frame.size.height+20, viewWidth * 0.5, 30)];
    _tipLab.text = @"国  晋  云";
    _tipLab.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:18];
    _tipLab.textAlignment = UITextAlignmentCenter;
    _tipLab.alpha = 0;
    [self.view addSubview:_tipLab];
    
    
    _footerLab = [[UILabel alloc]initWithFrame:CGRectMake(viewWidth * 0.1, viewHeight - 60, viewWidth * 0.8, 30)];
    _footerLab.textAlignment = UITextAlignmentCenter;
    _footerLab.textColor = [UIColor grayColor];
    _footerLab.text = @"© 2018 GJKJ Inc";
    _footerLab.font = [UIFont fontWithName:@"" size:12];
    [self.view addSubview:_footerLab];
    
    [UIView beginAnimations:@"invisible" context:nil];
    [UIView setAnimationDuration:1.5f];
    _logoImg.alpha = 1;
    _tipLab.alpha = 1;
    [UIView commitAnimations];

    if([AizenStorage readUserDataWithKey:@"isLogin"]){
        [self performSelector:@selector(goMain) withObject:nil afterDelay:2];

        [self hadLogInRefrshData];
    }else{
        [self performSelector:@selector(goLogin) withObject:nil afterDelay:2];
    }
   
//    //app 第一次网络问题
//    if let url = URL(string: "https://www.baidu.com/"){
//        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
//
//        }
//        dataTask.resume()
//
//    }
    
    /*这里启用数据库模式*/
    //bg_setDebug(YES);
}

-(void) goLogin{
    _loginCtl = getControllerFromStoryBoard(@"Mine", @"myloginStoryID");
    _loginCtl.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:_loginCtl animated:YES completion:nil];
}

+(UITabBarController *)getRootTabbar{
    NewMsgViewController *msg = [[NewMsgViewController alloc] init];
    BaseNavigationController *msg_nav = [[BaseNavigationController alloc] initWithRootViewController:msg];
    msg.tabBarItem.title = @"消息";
    msg.tabBarItem.image = [UIImage imageNamed:@"tabber_msg"];
    
    
    NewWorkViewController *work = [[NewWorkViewController alloc] init];
    BaseNavigationController *wok_nav = [[BaseNavigationController alloc] initWithRootViewController:work];
    work.tabBarItem.title = @"工作台";
    work.tabBarItem.image = [UIImage imageNamed:@"tabber_work"];
    

    GJMineViewController *mine = getInitialFromStoryBoard(@"Mine");
    BaseNavigationController *mine_nav = [[BaseNavigationController alloc] initWithRootViewController:mine];
    mine.tabBarItem.title = @"我的";
    mine.tabBarItem.image = [UIImage imageNamed:@"tabber_me"];
    
    UITabBarController *tabbar = [[UITabBarController alloc] init];
    tabbar.viewControllers = @[msg_nav,wok_nav,mine_nav];
    tabbar.tabBar.tintColor = kAppMainColor;
    tabbar.tabBar.translucent = NO;
    
//    tabbar.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    tabbar.modalPresentationStyle = UIModalPresentationFullScreen;
    return tabbar;
}
-(void) goMain{
    
    
   
    UITabBarController *tabbar = [ViewController getRootTabbar];
//    _mainPag = [[MainViewController alloc]init];
//    _mainPag.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [BaseViewController br_getAppDelegate].mainTabbar = tabbar;
    [self presentViewController:tabbar animated:YES completion:nil];
}

- (void)hadLogInRefrshData{
    
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    if (CurrAdminID == nil) {
        return;
    }
    NSDictionary *personData = @{@"ID":CurrAdminID};
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
    
    
}

#pragma mark - HttpRespone
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
    
    
    NSLog(@"%@",batchUrl1);
    NSLog(@"%@",batchUrl2);
    NSLog(@"%@",batchUrl3);
    NSLog(@"%@",batchUrl4);
    [AizenHttp asynRequest:batchUrl1 httpMethod:@"GET" params:nil success:^(id result) {
        NSDictionary *jsonDic = result;
        NSArray *appendData = [jsonDic objectForKey:@"AppendData"];
        if(![appendData isKindOfClass:[NSNull class]])
            [_batchDic setObject:appendData forKey:@"xtz"];
        
        [AizenHttp asynRequest:batchUrl2 httpMethod:@"GET" params:nil success:^(id result) {
            NSDictionary *jsonDic = result;
            NSArray *appendData1 = [jsonDic objectForKey:@"AppendData"];
            if(![appendData1 isKindOfClass:[NSNull class]])
                [_batchDic setObject:appendData1 forKey:@"sxgl"];
            
            [AizenHttp asynRequest:batchUrl3 httpMethod:@"GET" params:nil success:^(id result) {
                NSDictionary *jsonDic = result;
                NSArray *appendData2 = [jsonDic objectForKey:@"AppendData"];
                if(![appendData2 isKindOfClass:[NSNull class]]){
                    [_batchDic setObject:appendData2 forKey:@"lwgl"];
                }
                [AizenHttp asynRequest:batchUrl4 httpMethod:@"GET" params:nil success:^(id result) {
                    NSDictionary *jsonDic = result;
                    NSArray *appendData3 = [jsonDic objectForKey:@"AppendData"];
                    if(![appendData3 isKindOfClass:[NSNull class]])
                        [_batchDic setObject:appendData3 forKey:@"hyhd"];
                    [AizenStorage writeUserDataWithKey:_batchDic forKey:@"batch"];
                    [self setBatch:_batchDic];
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
    }
}
-(void) setBatch:(NSMutableDictionary *)sender{
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
-(void)errorLogin:(NSString *)flagStr{
    UIAlertView *ErrorAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:flagStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    ErrorAlert.tag = 100;
    [ErrorAlert show];
   // [_activityIndicatorView stopAnimating];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        [self dismissViewControllerAnimated:NO completion:nil];
        [self goLogin];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
