//
//  LeavePassViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/2/23.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "LeavePassViewController.h"
#import "LeavePassDetailViewController.h"
#import "LeavePassResultViewController.h"
#import "CommonMacro.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "People.h"
#import "PhoneInfo.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "LeaveUnPassDetailViewController.h"
#import "LeaveUnPassResultViewController.h"
@interface LeavePassViewController ()

@property(nonatomic,strong) UIScrollView *contentView;
@property(nonatomic,strong) NSMutableArray *dataArr;

@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

@end

@implementation LeavePassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _contentView = [[UIScrollView alloc]init];
    _contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_STATUSBAR - HEIGHT_NAVBAR - HEIGHT_TABBAR -  DOT_COORDINATE);
    _contentView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
    [self startLayout];
}

-(void) startLayout{
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 300)/2, 100, 100);
    [self.view addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiCheckWork/MyOverCheckLeaveApply?AdminID=%@&ActivityID=%@",kCacheHttpRoot,CurrAdminID,batchID];
    NSLog(@"%@",url);
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] intValue] == 0){
            [self handleData:jsonDic];
        }else{
            NSLog(@"无数据");
        }
    } failue:^(NSError *error) {
        NSLog(@"请求网络失败--请假待审核");
        [_activityIndicatorView stopAnimating];
    }];
}


-(void) handleData:(NSDictionary *)jsonDic{
    _dataArr = [[NSMutableArray alloc]init];
    NSString *account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *peopleArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",account]];
    People *peopleData = [peopleArr objectAtIndex:0];
    
    NSArray *dataArr = [jsonDic objectForKey:@"AppendData"];
    for(int i = 0;i<[dataArr count];i++){
        NSLog(@"%d",[[dataArr[i] objectForKey:@"State"] intValue]);
        //[[dataArr[i] objectForKey:@"State"] intValue] == 1
        if(YES){
            NSRange rang = {0,10};
            NSMutableDictionary *leaveDic = [[NSMutableDictionary alloc]init];
            [leaveDic setObject:[[dataArr[i] objectForKey:@"ID"] stringValue] forKey:@"id"];
            [leaveDic setObject:[dataArr[i] objectForKey:@"UserName"] forKey:@"name"];
            [leaveDic setObject:[dataArr[i] objectForKey:@"State"] forKey:@"State"];
            
            [leaveDic setObject:[[dataArr[i] objectForKey:@"LeaveType"] objectForKey:@"Description"] forKey:@"leavetype"];
            
            NSString *StartTime = [[[[dataArr[i] objectForKey:@"BeginDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
            NSString *EndTime = [[[[dataArr[i] objectForKey:@"EndDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
            
            int getTime = ([EndTime integerValue] - [StartTime integerValue]) / 60;
            [leaveDic setObject:[NSString stringWithFormat:@"%d",getTime] forKey:@"howlong"];
            
            
            NSString *timeStartStr = [[[[dataArr[i] objectForKey:@"BeginDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
            [leaveDic setObject:[PhoneInfo timestampSwitchTime:[timeStartStr integerValue]  andFormatter:@"YYYY-MM-dd"] forKey:@"applydate"];
            
            [leaveDic setObject:peopleData.USERNAME forKey:@"auditingman"];
            
            [leaveDic setObject:[PhoneInfo timestampSwitchTime:[StartTime integerValue]  andFormatter:@"YYYY-MM-dd"] forKey:@"startdate"];
            [leaveDic setObject:[PhoneInfo timestampSwitchTime:[EndTime integerValue]  andFormatter:@"YYYY-MM-dd"] forKey:@"enddate"];
            
            NSString *content = [dataArr[i] objectForKey:@"LeaveContent"] != [NSNull null]?[dataArr[i] objectForKey:@"LeaveContent"] :@"";
            [leaveDic setObject:content forKey:@"leavecontent"];
            
            [_dataArr addObject:leaveDic];
        }
    }
    
    
    CGFloat view_width = _contentView.frame.size.width;
    CGFloat view_height = _contentView.frame.size.height / 4;
    
    for(int i = 0;i<[_dataArr count];i++){
        
        NSInteger status =  [[_dataArr[i] objectForKey:@"State"] intValue];
        if (status == 2) {
            LeaveUnPassDetailViewController *view = [[LeaveUnPassDetailViewController alloc]init_Value:i width:&view_width height:&view_height dataDic:_dataArr[i]];
            view.view.frame = CGRectMake(0, i * view_height, view_width, view_height);
            UITapGestureRecognizer *detailClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detailActionUnPass:)];
            view.view.userInteractionEnabled = YES;
            detailClick.accessibilityValue = [NSString stringWithFormat:@"%d",i];
            [view.view addGestureRecognizer:detailClick];
            [_contentView addSubview:view.view];
        }
        else{
            LeavePassDetailViewController *view = [[LeavePassDetailViewController alloc]init_Value:i width:&view_width height:&view_height dataDic:_dataArr[i]];
            view.view.frame = CGRectMake(0, i * view_height, view_width, view_height);
            UITapGestureRecognizer *detailClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detailAction:)];
            view.view.userInteractionEnabled = YES;
            detailClick.accessibilityValue = [NSString stringWithFormat:@"%d",i];
            [view.view addGestureRecognizer:detailClick];
            [_contentView addSubview:view.view];
        }
               
    }
    
    _contentView.contentSize = CGSizeMake(self.view.frame.size.width, view_height * [_dataArr count]);
    
}


-(void) detailActionUnPass:(UITapGestureRecognizer *)sender{
    NSMutableDictionary *dataDic = [_dataArr objectAtIndex: [sender.accessibilityValue intValue]];
    LeaveUnPassResultViewController *result = [[LeaveUnPassResultViewController alloc]init];
    result.dataDic = dataDic;
    [self.navigationController pushViewController:result animated:YES];
}

-(void) detailAction:(UITapGestureRecognizer *)sender{
    NSMutableDictionary *dataDic = [_dataArr objectAtIndex: [sender.accessibilityValue intValue]];
    LeavePassResultViewController *result = [[LeavePassResultViewController alloc]init];
    result.dataDic = dataDic;
    [self.navigationController pushViewController:result animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end