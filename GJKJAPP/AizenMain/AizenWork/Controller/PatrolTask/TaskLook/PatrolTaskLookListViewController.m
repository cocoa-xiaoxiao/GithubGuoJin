//
//  PatrolTaskLookListViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/6/10.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "PatrolTaskLookListViewController.h"
#import "AizenHttp.h"
#import "AizenMD5.h"
#import "AizenStorage.h"
#import "DGActivityIndicatorView.h"
#import "RAlertView.h"
#import "TaskLookListModelViewController.h"
#import "MainViewController.h"
#import "People.h"
#import "PhoneInfo.h"
#import "PatrolTaskLookViewController.h"

@interface PatrolTaskLookListViewController ()

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIScrollView *dataScrollView;
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

@end

@implementation PatrolTaskLookListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"查看报告列表";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:self.navigationItem.title style:UIBarButtonItemStylePlain target:nil action:nil];
    [backBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.backBarButtonItem = backBtn;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self startLayout];
}


-(void) startLayout{
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, self.view.frame.size.width, self.view.frame.size.height - (HEIGHT_STATUSBAR + HEIGHT_NAVBAR));
    _contentView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
    
    _dataScrollView = [[UIScrollView alloc]init];
    _dataScrollView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    _dataScrollView.backgroundColor = [UIColor clearColor];
    _dataScrollView.delegate = self;
    [_contentView addSubview:_dataScrollView];
    
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [_dataScrollView addSubview:_activityIndicatorView];
    
    
    [self httpList];
}


-(void) httpList{
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSString *EnterpriseID = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"EnterpriseID"]];
    NSString *InspectionTeamID = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"InspectionTeamID"]];
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipInspectionTeamInfo/GetInternshipInspectionTeamRecordList?EnterpriseID=%@&TeamInfoID=%@&AdminID=%@&ActivityID=%@&rows=1000&page=1",kCacheHttpRoot,EnterpriseID,InspectionTeamID,CurrAdminID,batchID];
    NSLog(@"%@",url);
    
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
            [self handleList:jsonDic];
        }
    } failue:^(NSError *error) {
        NSLog(@"请求失败--获取巡察报告列表");
    }];
}



-(void) handleList:(NSDictionary *)sender{
    NSDictionary *getDic = [sender objectForKey:@"AppendData"];
    CGFloat widht = _contentView.frame.size.width;
    CGFloat height = _contentView.frame.size.height / 6;
    
    NSArray *getArr = [getDic objectForKey:@"rows"];
    for(int i = 0;i<[getArr count];i++){
        TaskLookListModelViewController *lookList = [[TaskLookListModelViewController alloc]init_Value:i width:&widht height:&height dataDic:[getArr objectAtIndex:i]];
        lookList.view.frame = CGRectMake(0, i * height, widht, height);
        UITapGestureRecognizer *detailTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detailAction:)];
        detailTap.accessibilityElements = [getArr objectAtIndex:i];
        [lookList.view addGestureRecognizer:detailTap];
        [_dataScrollView addSubview:lookList.view];
    }
    
    
    CGFloat scrollHeight = height * [getArr count];
    _dataScrollView.contentSize = CGSizeMake(_contentView.frame.size.width, scrollHeight);
}




-(void) detailAction:(UITapGestureRecognizer *)sender{
    PatrolTaskLookViewController *taskLook = [[PatrolTaskLookViewController alloc]init];
    taskLook.dataDic = sender.accessibilityElements;
    taskLook.frontDataDic = _dataDic;
    [self.navigationController pushViewController:taskLook animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
