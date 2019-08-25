//
//  AuditingStudentWeeklyViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/4/24.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "AuditingStudentWeeklyViewController.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "DGActivityIndicatorView.h"
#import "People.h"
#import "MainViewController.h"
#import "MyWeeklyListViewController.h"
#import "DetailWeeklyViewController.h"


@interface AuditingStudentWeeklyViewController ()

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

@end

@implementation AuditingStudentWeeklyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = [NSString stringWithFormat:@"%@的周记",[_dataDic objectForKey:@"UserName"]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self startLayout];
    
    
    
}


-(void) startLayout{
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_STATUSBAR - HEIGHT_NAVBAR);
    [self.view addSubview:_contentView];
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((_contentView.frame.size.width - 100)/2, (_contentView.frame.size.height - 200)/2, 100, 100);
    [_contentView addSubview:_activityIndicatorView];
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    [_contentView addSubview:_scrollView];
    
    [self handleHttp];
}


-(void) handleHttp{
    [_activityIndicatorView startAnimating];
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiActivityWeekly/GetMyWeeklyList?AdminID=%@&ActivityID=%@",kCacheHttpRoot,[[_dataDic objectForKey:@"StudentID"] stringValue],batchID];

    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        [self detailLayout:[jsonDic objectForKey:@"AppendData"]];
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败--获取我的周记");
    }];
}



-(void) detailLayout:(NSArray *)dataArr{
    dataArr = [GJToolsHelp processDictionaryIsNSNull:dataArr];

    CGFloat width = _scrollView.frame.size.width;
    CGFloat height = _scrollView.frame.size.height / 5;
    
    for(int i = 0;i<[dataArr count];i++){
        MyWeeklyListViewController *weekly = [[MyWeeklyListViewController alloc]init_Value:i width:&width height:&height dataDic:[dataArr objectAtIndex:i]];
        weekly.view.frame = CGRectMake(0, i * height, width, height);
        UITapGestureRecognizer *weeklyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weeklyAction:)];
        weeklyTap.accessibilityElements = [dataArr objectAtIndex:i];
        [weekly.view addGestureRecognizer:weeklyTap];
        [_scrollView addSubview:weekly.view];
    }
    
    
    CGFloat scrollHeight = height * [dataArr count];
    _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, scrollHeight);
    
}


-(void) weeklyAction:(UITapGestureRecognizer *)sender{
    NSDictionary *getDic = sender.accessibilityElements;
    DetailWeeklyViewController *detail = [[DetailWeeklyViewController alloc]init];
    detail.ID = [[getDic objectForKey:@"ID"] stringValue];
    detail.flagRole = @"teacher";
    [self.navigationController pushViewController:detail animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
