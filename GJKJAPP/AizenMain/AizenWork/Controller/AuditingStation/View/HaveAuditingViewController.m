//
//  HaveAuditingViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/4/16.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "HaveAuditingViewController.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "People.h"
#import "NoStationListViewController.h"
#import "MainViewController.h"
#import "HaveStationListViewController.h"
#import "DetailStationViewController.h"
@interface HaveAuditingViewController ()
{
    int _page;
}
@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIScrollView *scrollView;

@end

@implementation HaveAuditingViewController

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
//
//    WS(ws);
//    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [ws getDataSourceFromHttpIsFooterRefresh:NO];
//    }];
    
    
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
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipApplyEnterpriseInfo/GetMyCheckList?AdminID=%@&ActivityID=%@",kCacheHttpRoot,CurrAdminID,batchID];
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
            [self handleArr:[jsonDic objectForKey:@"AppendData"]];
        }
    } failue:^(NSError *error) {
        NSLog(@"请求失败--教师获取岗位审核");
    }];
}




-(void) handleArr:(NSMutableArray *)dataArr{
    NSMutableArray *resultArr = [[NSMutableArray alloc]init];
    for(int i = 0;i<[dataArr count];i++){
        NSDictionary *Dic = [dataArr objectAtIndex:i];
        if([[Dic objectForKey:@"CheckState"] integerValue] != 0){
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
//        NoStationListViewController *detailView = [[NoStationListViewController alloc]init_Value:i width:&width height:&height dataDic:[dataArr objectAtIndex:i]];
//        detailView.view.frame = CGRectMake(0, i * height, width, height);
//        [_scrollView addSubview:detailView.view];
        HaveStationListViewController *detailView = [[HaveStationListViewController alloc]init_Value:i width:&width height:&height dataDic:[dataArr objectAtIndex:i]];
        detailView.view.frame = CGRectMake(0, i * height, width, height);
        [_scrollView addSubview:detailView.view];
        UITapGestureRecognizer *taskTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(br_selectedDetail:)];
        taskTap.accessibilityElements = [dataArr objectAtIndex:i];//[[sender objectForKey:@"rows"] objectAtIndex:i];
        [detailView.view addGestureRecognizer:taskTap];
    }
    _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, height*dataArr.count);

}

- (void)br_selectedDetail:(UITapGestureRecognizer*)tap{
    DetailStationViewController *vc = [[DetailStationViewController alloc] init];
    NSDictionary *dic = (id)tap.accessibilityElements;
    vc.ID = dic[@"ID"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
