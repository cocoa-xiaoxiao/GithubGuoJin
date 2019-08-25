//
//  NCCheckReportViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/4/3.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "NCCheckReportViewController.h"
#import "CheckReportTableViewCell.h"
#import "WorkBaseModel.h"
#import "IBCreatHelper.h"
#import "MainViewController.h"
#import "People.h"
#import "PhoneInfo.h"
#import "DGActivityIndicatorView.h"
#import "ReViewCommentViewController.h"
#import "LWReadViewController.h"
#import "Toast+UIView.h"
#import "GJShenheViewController.h"
#import "ReportDetailViewController.h"
@interface NCCheckReportViewController (){
    int _page;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableArray; //数据源
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@end

@implementation NCCheckReportViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLayout];
    [self getDataSourceFromHttpIsFooterRefresh:NO];
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
    NSString *activity = [AizenStorage readUserDataWithKey:@"batchID"];
    NSString *batchID = getObj.COLLEGEID.stringValue;
    [_activityIndicatorView startAnimating];
    [HttpService GetNoCheckTeamRecordList:batchID ActivityID:activity Rows:20 and:1 success:^(id  _Nonnull responseObject) {
        if (FooterRefresh == YES) {
            [self.tableArray addObjectsFromArray:[self detailLayout:[responseObject objectForKey:@"AppendData"][@"rows"]]];
        }else{
            self.tableArray = [[self detailLayout:[responseObject objectForKey:@"AppendData"][@"rows"]] mutableCopy];
        }
        [self.tableView reloadData];
        [self headerEndFreshPull];
        [_activityIndicatorView stopAnimating];
    } failure:^(NSError * _Nonnull error) {
        [self headerEndFreshPull];
        [_activityIndicatorView stopAnimating];
    }];
}
-(NSArray *) detailLayout:(NSArray *)dataArr{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < dataArr.count; i++) {
        NSDictionary *dict = dataArr[i];
        checkReportModel *model = [[checkReportModel alloc]init];
        model.RecordTitle = [dict objectForKey:@"RecordTitle"];
        NSRange rang = {0,10};
        NSString *StartTime = [[[[dict objectForKey:@"CreateDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
        model.CreateDate = [PhoneInfo timestampSwitchTime:[StartTime integerValue] andFormatter:@"YYYY-MM-dd"];// HH:mm:ss
        model.UserName = [dict objectForKey:@"UserName"];
        model.ID=[dict objectForKey:@"ID"];
        model.CheckState = [[dict objectForKey:@"CheckState"] intValue];
        model.SubsidyTitle = [dict objectForKey:@"SubsidyTitle"];
        model.EnterpriseName= [dict objectForKey:@"EnterpriseName"];
        model.RecordPlace = [dict objectForKey:@"RecordPlace"];
        [array addObject:model];
    }
    return array;
}
-(void)startLayout
{
    
    _tableView = [[BaseTablewView alloc]initWithFrame:CGRectMake(0, 0, self.view.xo_width, self.view.xo_height-50-_navHeight()-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 110;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    WS(ws);
    [self addFreshPull:self.tableView withBlock:^(id info) {
        [ws getDataSourceFromHttpIsFooterRefresh:NO];
    }];
    [self addFooterFresh:self.tableView withBlock:^(id info) {
        [ws getDataSourceFromHttpIsFooterRefresh:YES];
    }];
    [self.view addSubview:_tableView];
    //旋转
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [self.view addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    
    UIButton *passBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    passBtn.frame = CGRectMake(0, _tableView.xo_bottomY, self.view.xo_width, 50);
    [passBtn setTitle:@"审核" forState:UIControlStateNormal];
    [passBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [passBtn setBackgroundColor:[UIColor blueColor]];
    [passBtn addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:passBtn];
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    checkReportModel *model = self.tableArray[indexPath.row];
    CheckReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reportCellID"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"CheckReportTableViewCell" owner:self options:nil].firstObject;
    }
    cell.biaotiLb.text = model.RecordTitle;
    cell.timeLb.text = model.CreateDate;
    cell.xunchaLb.text = [NSString stringWithFormat:@"巡查人:%@",model.UserName];
    cell.zhuangtaiLb.text = [NSString stringWithFormat:@"状态:%@",@"未审核"];
    cell.pianquLb.text = [NSString stringWithFormat:@"片区:%@",model.SubsidyTitle];
    cell.danweiLb.text = [NSString stringWithFormat:@"单位:%@",model.EnterpriseName];
    cell.dizhiLb.text = [NSString stringWithFormat:@"定位:%@",model.RecordPlace];
    [cell.xuanzeBtn setImage:[UIImage imageNamed:model.select?@"select":@"noselect"] forState:UIControlStateNormal];
    __weak typeof(self)weakself = self;
    cell.block = ^(UITableViewCell * _Nonnull scell, checkReportModel * _Nonnull smodel) {
        model.select = !model.select;
        [weakself.tableView reloadData];
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}
#pragma mark 返回组头的高度 : 第一组的头部一定要通过代理设置
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    checkReportModel *model = self.tableArray[indexPath.row];
    ReportDetailViewController *taskLook = [[ReportDetailViewController alloc]init];
    taskLook.recordID = model.ID;
    NSString *activity = [AizenStorage readUserDataWithKey:@"batchID"];
    taskLook.teamId = activity;
    taskLook.shenhe = 1;
    [self.navigationController pushViewController:taskLook animated:YES];
}


-(NSMutableArray *)tableArray
{
    if (!_tableArray) {
        _tableArray = [[NSMutableArray alloc]init];
    }
    return _tableArray;
}

-(void)check
{
    GJShenheViewController *vc = getControllerFromStoryBoard(@"Worker", @"myshenheSbID");
    NSMutableString *string = [[NSMutableString alloc]init];
    for (checkReportModel *model in self.tableArray) {
        if (model.select == 1) {
            if (string.length >1 ) {
                [string appendFormat:@",%@",model.ID];
            }
            else{
                [string appendFormat:@"%@",model.ID];
            }
        }
        
    }
    if (string.length <1) {
        [self.view makeToast:@"请选择需要审核的报告" duration:1.0 position:@"center"];
        return;
    }
    vc.pid = [string copy];
    vc.shenheType = shenheType_report;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
