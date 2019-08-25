//
//  PersonTaskViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/16.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "PersonTaskViewController.h"
#import "RDVTabBarController.h"
#import "RAlertView.h"
#import "DGActivityIndicatorView.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "People.h"
#import "CZPickerView.h"
#import "MyTaskDetailViewController.h"
#import "MainViewController.h"
#import "DetailTaskViewController.h"
#import "TeacherDetailTaskViewController.h"

@interface PersonTaskViewController ()

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

@end

@implementation PersonTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *title = [NSString stringWithFormat:@"%@的任务",[_getDic objectForKey:@"UserName"]];
    self.navigationItem.title = title;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    
    [self startLayout];
}


-(void) startLayout{
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_STATUSBAR - HEIGHT_NAVBAR);
    [self.view addSubview:_contentView];
    
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    [_contentView addSubview:_scrollView];
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [_scrollView addSubview:_activityIndicatorView];
    
    
    [self handleHttp];
}


-(void) handleHttp{
    
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiActivityTaskInfo/GetMyPrincipalTaskList?AdminID=%@&ActivityID=%@&TaskTitle=&rows=1000&page=1",kCacheHttpRoot,[_getDic objectForKey:@"StudentID"],batchID];
    NSLog(@"%@",url);
    [_activityIndicatorView startAnimating];
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
            [self handleOtherView:[jsonDic objectForKey:@"AppendData"]];
        }
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败--我负责的任务");
    }];

    
}



-(void) handleOtherView:(NSMutableDictionary *)sender{
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    
    for(int x = 0;x<[[sender objectForKey:@"rows"] count];x++){
        if([[[[sender objectForKey:@"rows"] objectAtIndex:x] objectForKey:@"State"] integerValue] == 0){
            [dataArr addObject:[[sender objectForKey:@"rows"] objectAtIndex:x]];
        }
    }
    
    CGFloat width = _scrollView.frame.size.width;
    CGFloat height = _scrollView.frame.size.height / 5;
    
    for(int i = 0;i<[dataArr count];i++){
        MyTaskDetailViewController *task = [[MyTaskDetailViewController alloc]init_Value:i width:&width height:&height dataDic:[dataArr objectAtIndex:i]];
        task.view.frame = CGRectMake(0, i * height, width, height);
        UITapGestureRecognizer *taskTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taskAction:)];
        taskTap.accessibilityElements = [dataArr objectAtIndex:i];
        [task.view addGestureRecognizer:taskTap];
        [_scrollView addSubview:task.view];
    }
    
    
    CGFloat scrollHeight = height * [[sender objectForKey:@"rows"] count];
    _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, scrollHeight);
}



-(void) taskAction:(UITapGestureRecognizer *)sender{
    NSMutableDictionary *dataDic = sender.accessibilityElements;
    TeacherDetailTaskViewController *detailTask = [[TeacherDetailTaskViewController alloc]init];
    detailTask.taskID = [dataDic objectForKey:@"ID"];
    detailTask.flagRole = @"teacher";
    [self.navigationController pushViewController:detailTask animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
