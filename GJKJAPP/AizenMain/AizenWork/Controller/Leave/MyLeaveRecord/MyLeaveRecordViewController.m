//
//  MyLeaveRecordViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/3/29.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MyLeaveRecordViewController.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "DGActivityIndicatorView.h"
#import "RAlertView.h"
#import "MainViewController.h"
#import "People.h"
#import "MyLeaveRecordDetailViewController.h"
#import "StudentLeaveWaitViewController.h"
#import "StudentLeavePassViewController.h"
#import "StudentLeaveUnPassViewController.h"
#import "PhoneInfo.h"

@interface MyLeaveRecordViewController ()

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

@end

@implementation MyLeaveRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"请假记录";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self startLayout];
}



-(void) startLayout{
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 2);
    _scrollView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    [self.view addSubview:_scrollView];
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [_scrollView addSubview:_activityIndicatorView];
    
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiCheckWork/MyLeaveApply?ActivityID=%@&AdminID=%@",kCacheHttpRoot,batchID,CurrAdminID];
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] intValue] == 0){
            [self handleData:[jsonDic objectForKey:@"AppendData"]];
        }
    } failue:^(NSError *error) {
        NSLog(@"请求失败--我的请假列表");
    }];
}

-(void) handleData:(NSArray *)dataArr{
    CGFloat width = _scrollView.frame.size.width;
    CGFloat height = _scrollView.frame.size.height / 4;
    
    for(int i = 0;i<[dataArr count];i++){
        MyLeaveRecordDetailViewController *detail = [[MyLeaveRecordDetailViewController alloc]init_Value:i width:&width height:&height dataDic:dataArr[i]];
        detail.view.frame = CGRectMake(0, i * height, width, height);
        UITapGestureRecognizer *detailTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detailAction:)];
        NSDictionary *getDic = dataArr[i];
        detailTap.accessibilityElements = getDic;
        [detail.view addGestureRecognizer:detailTap];
        [_scrollView addSubview:detail.view];
    }
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, height * [dataArr count]);
    
}



-(void) detailAction:(UITapGestureRecognizer *)sender{
    NSDictionary *getDic = sender.accessibilityElements;
    
    if([[getDic objectForKey:@"State"] intValue] == 0){
        StudentLeaveWaitViewController *audit = [[StudentLeaveWaitViewController alloc]init];
        audit.dataDic = [self handleDic:getDic];
        [self.navigationController pushViewController:audit animated:YES];
    }else if([[getDic objectForKey:@"State"] intValue] == 1){
        StudentLeavePassViewController *pass = [[StudentLeavePassViewController alloc]init];
        pass.dataDic = [self handleDic:getDic];
        [self.navigationController pushViewController:pass animated:YES];
    }else if([[getDic objectForKey:@"State"] intValue] == 2){
        StudentLeaveUnPassViewController *unpass = [[StudentLeaveUnPassViewController alloc]init];
        unpass.dataDic = [self handleDic:getDic];
        [self.navigationController pushViewController:unpass animated:YES];
    }
}



-(NSMutableDictionary *)handleDic:(NSMutableDictionary *)sender{
    NSString *account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *peopleArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",account]];
    People *peopleData = [peopleArr objectAtIndex:0];
    
    NSRange rang = {0,10};
    NSMutableDictionary *leaveDic = [[NSMutableDictionary alloc]init];
    [leaveDic setObject:[[sender objectForKey:@"ID"] stringValue] forKey:@"id"];
    [leaveDic setObject:[sender objectForKey:@"UserName"] forKey:@"name"];

    [leaveDic setObject:[[sender objectForKey:@"LeaveType"] objectForKey:@"DictionaryName"] forKey:@"leavetype"];

    NSString *StartTime = [[[[sender objectForKey:@"BeginDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
    NSString *EndTime = [[[[sender objectForKey:@"EndDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];

    int getTime = ([EndTime integerValue] - [StartTime integerValue]) / 60;
    [leaveDic setObject:[NSString stringWithFormat:@"%d",getTime] forKey:@"howlong"];


    NSString *timeStartStr = [[[[sender objectForKey:@"BeginDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
    [leaveDic setObject:[PhoneInfo timestampSwitchTime:[timeStartStr integerValue]  andFormatter:@"YYYY-MM-dd"] forKey:@"applydate"];

    [leaveDic setObject:peopleData.USERNAME forKey:@"auditingman"];

    [leaveDic setObject:[PhoneInfo timestampSwitchTime:[StartTime integerValue]  andFormatter:@"YYYY-MM-dd"] forKey:@"startdate"];
    [leaveDic setObject:[PhoneInfo timestampSwitchTime:[EndTime integerValue]  andFormatter:@"YYYY-MM-dd"] forKey:@"enddate"];

    NSString *content = [sender objectForKey:@"LeaveContent"] != [NSNull null]?[sender objectForKey:@"LeaveContent"] :@"";
    [leaveDic setObject:content forKey:@"leavecontent"];
    
    return leaveDic;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
