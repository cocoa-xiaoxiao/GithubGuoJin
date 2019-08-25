//
//  NotAuditingViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/4/16.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "NotAuditingViewController.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "DGActivityIndicatorView.h"
#import "People.h"
#import "NoStationListViewController.h"
#import "MainViewController.h"
#import "DetailStationViewController.h"
#import "PhoneInfo.h"
#import "MJRefresh.h"
@interface NotAuditingViewController ()
{
    int _page;
}
@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

@end

@implementation NotAuditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_STATUSBAR - HEIGHT_NAVBAR - 44.0f);
    [self.view addSubview:_contentView];
    
    [self startLayout];
}

-(void) startLayout{
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, _contentView.frame.size.height * 2);
    [_contentView addSubview:_scrollView];
//    WS(ws);
//    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [ws getDataSourceFromHttpIsFooterRefresh:NO];
//    }];
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [_contentView addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    
    
    
    [self getDataSourceFromHttpIsFooterRefresh:NO];
}



-(void) getDataSourceFromHttpIsFooterRefresh:(BOOL)FooterRefresh
{
    if (FooterRefresh == YES) {
        _page ++ ;
    }else{
        _page = 1;
    }
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipApplyEnterpriseInfo/MyStudentApplyList?AdminID=%@&ActivityID=%@",kCacheHttpRoot,CurrAdminID,batchID];
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
            [self handleArr:[jsonDic objectForKey:@"AppendData"]];
        }
        else{
            [BaseViewController br_showAlterMsg:jsonDic[@"Message"]];
        }
    } failue:^(NSError *error) {
        NSLog(@"请求失败--教师获取岗位审核");
        [_activityIndicatorView stopAnimating];
    }];
}




-(void) handleArr:(NSMutableArray *)dataArr{
    NSMutableArray *resultArr = [[NSMutableArray alloc]init];
    for(int i = 0;i<[dataArr count];i++){
        NSDictionary *Dic = [dataArr objectAtIndex:i];
        if([[Dic objectForKey:@"CheckState"] integerValue] == 0){
            [resultArr addObject:[dataArr objectAtIndex:i]];
        }
    }
    
    [self detailLayout:resultArr];
}


-(void) detailLayout:(NSMutableArray *)dataArr{
    
    dataArr = [GJToolsHelp processDictionaryIsNSNull:dataArr];

    CGFloat width = _scrollView.frame.size.width;
    CGFloat height = _scrollView.frame.size.height / 4;
    
    for(int i = 0;i<[dataArr count];i++){
        NoStationListViewController *detailView = [[NoStationListViewController alloc]init_Value:i width:&width height:&height dataDic:[dataArr objectAtIndex:i]];
        detailView.view.frame = CGRectMake(0, i * height, width, height);
        
        UITapGestureRecognizer *taskTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(br_selectedDetail:)];
        taskTap.accessibilityElements = [dataArr objectAtIndex:i];//[[sender objectForKey:@"rows"] objectAtIndex:i];
        [detailView.view addGestureRecognizer:taskTap];
        
        [_scrollView addSubview:detailView.view];
    }
}




- (void)br_selectedDetail:(UITapGestureRecognizer*)tap{
    DetailStationViewController *vc = [[DetailStationViewController alloc] init];
    NSDictionary *dic = (id)tap.accessibilityElements;
    vc.ID = dic[@"ID"];
    vc.isTeacher = YES;
    vc.updateBlock = ^(id info) {
        [self getDataSourceFromHttpIsFooterRefresh:NO];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
