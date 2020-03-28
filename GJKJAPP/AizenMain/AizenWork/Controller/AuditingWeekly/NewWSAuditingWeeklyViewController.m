//
//  NewWSAuditingWeeklyViewController.m
//  GJKJAPP
//
//  Created by 肖啸 on 2020/3/27.
//  Copyright © 2020 谭耀焯. All rights reserved.
//

#import "NewWSAuditingWeeklyViewController.h"
#import "AizenHttp.h"
#import "People.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "PersonModel.h"
#import "NewAuditingWeeklyTableViewCell.h"
#import "XXDetailTaskVC.h"
#import "NewDetailWeeklyViewController.h"
@interface NewWSAuditingWeeklyViewController (){
    int _page;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableArray; //数据源
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

@end

@implementation NewWSAuditingWeeklyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLayout];
    [self getDataSourceFromHttpIsFooterRefresh:NO];
}
-(void)startLayout
{

    _tableView = [[BaseTablewView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height- HEIGHT_STATUSBAR - HEIGHT_NAVBAR - 44.0f) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:@"NewAuditingWeeklyTableViewCell" bundle:nil] forCellReuseIdentifier:@"auditingweeklycellID"];
    [self.view addSubview:_tableView];
    WS(ws);
    [self addFreshPull:self.tableView withBlock:^(id info) {
        [ws getDataSourceFromHttpIsFooterRefresh:NO];
    }];
//    [self addFooterFresh:self.tableView withBlock:^(id info) {
//        [ws getDataSourceFromHttpIsFooterRefresh:YES];
//    }];
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 188)/2, 100, 100);
    [self.view addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
}
-(void)getDataSourceFromHttpIsFooterRefresh:(BOOL)FooterRefresh
{
    if (FooterRefresh == YES) {
        _page ++ ;
    }else{
        _page = 1;
    }
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    NSString *url = [NSString stringWithFormat:@"%@/ApiActivityWeekly/MyStudentWeeklyList?AdminID=%@&ActivityID=%@",kCacheHttpRoot,CurrAdminID,batchID];
    NSLog(@"%@",url);
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        self.tableArray = [jsonDic objectForKey:@"AppendData"];
        [self headerEndFreshPull];
        [self.tableView reloadData];
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败--获取我的申请记录");
    }];
    
}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *dict = self.tableArray[indexPath.row];
    NewAuditingWeeklyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"auditingweeklycellID"];
    [cell refreshAuditingWeeklyCellWithDict:dict];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.tableArray[indexPath.row];
    NewDetailWeeklyViewController *vc = getControllerFromStoryBoard(@"Weekly", @"detailweeklySBID");
    vc.ID = [dict objectForKey:@"ID"];
    vc.role = @"teacher";
    [self.navigationController pushViewController:vc animated:NO];
}
#pragma mark 返回组头的高度 : 第一组的头部一定要通过代理设置
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
-(NSMutableArray *)tableArray
{
    if (!_tableArray) {
        _tableArray = [[NSMutableArray alloc]init];
    }
    return _tableArray;
}


@end
