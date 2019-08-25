//
//  MyWeeklyViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/4/11.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MyWeeklyViewController.h"
#import "RDVTabBarController.h"
#import "RAlertView.h"
#import "DGActivityIndicatorView.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "People.h"
#import "CZPickerView.h"
#import "MyWeeklyListViewController.h"
#import "WriteWeeklyViewController.h"
#import "MainViewController.h"
#import "ModifyWeeklyViewController.h"

@interface MyWeeklyViewController ()

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIButton *writeWeeklyBtn;

@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

@end

@implementation MyWeeklyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的周记";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction:)];
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
    _scrollView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height - HEIGHT_TABBAR);
    [_contentView addSubview:_scrollView];
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [_scrollView addSubview:_activityIndicatorView];
    
    
    _writeWeeklyBtn = [[UIButton alloc]init];
    _writeWeeklyBtn.frame = CGRectMake(0, _scrollView.frame.origin.y + _scrollView.frame.size.height, _contentView.frame.size.width, HEIGHT_TABBAR);
    _writeWeeklyBtn.backgroundColor = [UIColor colorWithRed:23/255.0 green:194/255.0 blue:149/255.0 alpha:1];
    [_writeWeeklyBtn setTitle:@"写周记" forState:UIControlStateNormal];
    _writeWeeklyBtn.font = [UIFont systemFontOfSize:20.0];
    [_writeWeeklyBtn addTarget:self action:@selector(writeWeeklyAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_writeWeeklyBtn];
    
    
    [self handleHttp];
}

-(void) handleHttp{
    [_activityIndicatorView startAnimating];
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiActivityWeekly/GetMyWeeklyList?AdminID=%@&ActivityID=%@",kCacheHttpRoot,CurrAdminID,batchID];
    NSLog(@"%@",url);
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0)
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

    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
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
    NSDictionary *dataDic = sender.accessibilityElements;
    
    NSInteger CheckState = [dataDic[@"CheckState"] integerValue];
    ModifyWeeklyViewController *modify = [[ModifyWeeklyViewController alloc]init];

    if (CheckState == 0 || CheckState == 2) {
        //2 拒绝
        modify.isCanEidt = YES;
       
    }
    modify.dataDic = dataDic;
    [self.navigationController pushViewController:modify animated:YES];
//    else if (CheckState == 2){//拒绝
//        ModifyWeeklyViewController *modify = [[ModifyWeeklyViewController alloc]init];
//        modify.dataDic = dataDic;
//        [self.navigationController pushViewController:modify animated:YES];
//    }
//    if([[[dataDic objectForKey:@"CheckState"] stringValue] isEqualToString:@"0"]){
//        ModifyWeeklyViewController *modify = [[ModifyWeeklyViewController alloc]init];
//        modify.dataDic = dataDic;
//        [self.navigationController pushViewController:modify animated:YES];
//    }else{
//        
//    }
}



-(void) writeWeeklyAction:(UIButton *)sender{
    WriteWeeklyViewController *write = [[WriteWeeklyViewController alloc]init];
    write.updateBlock = ^(id info) {
        [self handleHttp];
    };
    [self.navigationController pushViewController:write animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
