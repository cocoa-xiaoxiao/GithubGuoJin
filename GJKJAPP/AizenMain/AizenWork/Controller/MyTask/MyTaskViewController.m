//
//  MyTaskViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/4/11.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MyTaskViewController.h"
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
#import "XXDetailTaskVC.h"

@interface MyTaskViewController ()

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

@end

@implementation MyTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的任务";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction:)];
    [backBtnItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = backBtnItem ;
    
    [self startLayout];
}


-(void)backAction:(UIBarButtonItem *)sender{
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
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
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiActivityTaskInfo/GetMyPrincipalTaskList?AdminID=%@&ActivityID=%@&TaskTitle=&rows=1000&page=1",kCacheHttpRoot,CurrAdminID,batchID];
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
    CGFloat width = _scrollView.frame.size.width;
    CGFloat height = _scrollView.frame.size.height / 4;

    for(int i = 0;i<[[sender objectForKey:@"rows"] count];i++){
        MyTaskDetailViewController *task = [[MyTaskDetailViewController alloc]init_Value:i width:&width height:&height dataDic:[[sender objectForKey:@"rows"] objectAtIndex:i]];
        task.view.frame = CGRectMake(0, i * height, width, height);
        UITapGestureRecognizer *taskTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taskAction:)];
        taskTap.accessibilityElements = [[sender objectForKey:@"rows"] objectAtIndex:i];
        [task.view addGestureRecognizer:taskTap];
        [_scrollView addSubview:task.view];
    }


    CGFloat scrollHeight = height * [[sender objectForKey:@"rows"] count];
    _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, scrollHeight);
}



-(void) taskAction:(UITapGestureRecognizer *)sender{
    NSMutableDictionary *dataDic = sender.accessibilityElements;
    
    XXDetailTaskVC *vc = [[XXDetailTaskVC alloc]init];
    vc.taskID = [dataDic objectForKey:@"ID"];
    vc.ActivityTaskID = [dataDic valueForKey:@"ActivityTaskID"];
    if ([vc.ActivityTaskID isKindOfClass:[NSNull class]]) {
        vc.ActivityTaskID = @"";
    }
    vc.flagRole = @"student";
    [self.navigationController pushViewController:vc animated:NO];
//    detailTask.updateBlock = ^(id info) {
//        [self handleHttp];
//    };
//    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:self.navigationItem.title style:UIBarButtonItemStylePlain target:nil action:nil];
//    [backBtn setTintColor:[UIColor whiteColor]];
//    self.navigationItem.backBarButtonItem = backBtn;
//    [self.navigationController pushViewController:detailTask animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
