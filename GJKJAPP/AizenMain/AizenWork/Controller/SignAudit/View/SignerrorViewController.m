//
//  SignerrorViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/3/26.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "SignerrorViewController.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "AizenHttp.h"
#import "AizenMD5.h"
#import "AizenStorage.h"
#import "People.h"
#import "PhoneInfo.h"
#import "RAlertView.h"
#import "SignAuditModelViewController.h"
#import "SignerrorDetailViewController.h"

@interface SignerrorViewController ()

@property(nonatomic,strong)DGActivityIndicatorView *activityIndicatorView;
@property(nonatomic,strong)UIScrollView *scrollView;

@end

@implementation SignerrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 300)/2, 100, 100);
    [self.view addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_STATUSBAR - HEIGHT_NAVBAR - 44.0f)];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 2);
    _scrollView.userInteractionEnabled = YES;
    [self.view addSubview:_scrollView];
    [self startLayout];
}


-(void) startLayout{
  
    
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    NSString *CurrDate = [PhoneInfo getCurrentTimes:@"yyyy-MM-dd"];
    NSString *url = [NSString stringWithFormat:@"%@/ApiCheckWork/GetMyStudentCheckList?AdminID=%@&ActivityID=%@&CheckDate=%@",kCacheHttpRoot,CurrAdminID,batchID,CurrDate];
    NSLog(@"%@",url);
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] intValue] == 0){
            NSArray *dataArr = [jsonDic objectForKey:@"AppendData"];
            [self setLayout:dataArr];
        }else{
//            RAlertView *alert = [[RAlertView alloc] initWithStyle:SimpleAlert width:0.8];
//            alert.isClickBackgroundCloseWindow = YES;
//            alert.contentTextLabel.text = [jsonDic objectForKey:@"Message"];
        }
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败--签到审批");
    }];
}



-(void) setLayout:(NSArray *)dataArr{
    CGFloat view_width = _scrollView.frame.size.width;
    CGFloat view_height = _scrollView.frame.size.height / 4;
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int x = 0;
    for(int i = 0;i<[dataArr count];i++){
        NSMutableDictionary *dataDic = dataArr[i];
//        if( [[dataDic objectForKey:@"CheckOutDate"] boolValue] == false && [dataDic objectForKey:@"CheckOutDate"] != [NSNull null]){
            SignAuditModelViewController *modelView = [[SignAuditModelViewController alloc]init_Value:i width:&view_width height:&view_height dataDic:dataArr[i] ischeckIn:NO];
            modelView.view.frame = CGRectMake(0, x * view_height, view_width, view_height);
            UITapGestureRecognizer *TapClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detailAction:)];
            TapClick.accessibilityElements = dataArr[i];
            [modelView.view addGestureRecognizer:TapClick];
            [_scrollView addSubview:modelView.view];
            x++;
//        }
    }
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width,dataArr.count * view_height);

}


-(void) detailAction:(UITapGestureRecognizer *)sender{
    NSDictionary *getArr = sender.accessibilityElements;
    NSRange rang = {0,10};
    NSString *CheckOutDate = [getArr objectForKey:@"CheckOutDate"];
    NSString *timeEndStr = [[[CheckOutDate stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
    if ([timeEndStr integerValue] < 0 ) {
        [BaseViewController br_showAlterMsg:@"尚未打卡!"];
    }
    else{
        SignerrorDetailViewController *successDetail = [[SignerrorDetailViewController alloc]init];
        successDetail.getArr = getArr;
        successDetail.updateBlock = ^(id info) {
            [self startLayout];
        };
        [self.navigationController pushViewController:successDetail animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
