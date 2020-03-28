//
//  MyApplyEnterpriseListViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/4/10.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MyApplyEnterpriseListViewController.h"
#import "RDVTabBarController.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "DGActivityIndicatorView.h"
#import "People.h"
#import "MainViewController.h"
#import "MyApplyDetailViewController.h"
#import "DetailStationViewController.h"
#import "ModifyStationViewController.h"
#import "NewStationDetailViewController.h"
#import "NewModifyStationViewController.h"

@interface MyApplyEnterpriseListViewController ()

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;


@end

@implementation MyApplyEnterpriseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的申请";
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
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 1.1);
    [self.view addSubview:_scrollView];
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [_scrollView addSubview:_activityIndicatorView];
    
    
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipApplyEnterpriseInfo/GetMyApplyList?AdminID=%@&ActivityID=%@",kCacheHttpRoot,CurrAdminID,batchID];
    NSLog(@"%@",url);
    [_activityIndicatorView startAnimating];
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        [self detailLayout:[jsonDic objectForKey:@"AppendData"]];
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败--获取我的申请记录");
    }];
    

}



-(void) detailLayout:(NSArray *)dataArr{
    
    dataArr = [GJToolsHelp processDictionaryIsNSNull:dataArr];

    CGFloat width = _scrollView.frame.size.width;
    CGFloat height = _scrollView.frame.size.height / 4;
    
    for(int i = 0;i<[dataArr count];i++){
        MyApplyDetailViewController *detailView = [[MyApplyDetailViewController alloc]init_Value:i width:&width height:&height dataDic:[dataArr objectAtIndex:i]];
        detailView.view.frame = CGRectMake(0, i * height, width, height);
        UITapGestureRecognizer *applyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(applyAction:)];
        applyTap.accessibilityElements = [dataArr objectAtIndex:i];
        [detailView.view addGestureRecognizer:applyTap];
        [_scrollView addSubview:detailView.view];
    }
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, height * dataArr.count);

}



-(void) applyAction:(UITapGestureRecognizer *)sender{
    NSDictionary *getDic = sender.accessibilityElements;
    if([[[getDic objectForKey:@"CheckState"] stringValue] isEqualToString:@"0"]){
        NewModifyStationViewController *vc = getControllerFromStoryBoard(@"Station", @"ModifystationDetailID");
        vc.ID = getDic[@"ID"];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NewStationDetailViewController *vc = getControllerFromStoryBoard(@"Station", @"stationDetailID");
        vc.ischenck = NO;
        vc.role = @"student";
        vc.ID = getDic[@"ID"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
