//
//  NotFinalizationListViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/13.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "NotFinalizationListViewController.h"
#import "FinalizationListTableViewCell.h"
#import "WorkBaseModel.h"
#import "MyProjectDetailViewController.h"
#import "IBCreatHelper.h"
#import "MainViewController.h"
#import "People.h"
#import "PhoneInfo.h"
#import "DGActivityIndicatorView.h"
#import "LDPublicWebViewController.h"
@interface NotFinalizationListViewController ()
{
    int _page;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableArray; //数据源
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@end

@implementation NotFinalizationListViewController
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
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    [HttpService GetMyOverProjectFinalizationCheckListFromUpdater:CurrAdminID andActivityID:batchID andStudentName:@"" and:10 and:_page success:^(id  _Nonnull responseObject) {
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
        FinalizationListModel *model = [[FinalizationListModel alloc]init];
        model.fname = [dict objectForKey:@"ProjectName"];
        NSRange rang = {0,10};
        NSString *StartTime = [[[[dict objectForKey:@"CreateDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
        model.ftime = [PhoneInfo timestampSwitchTime:[StartTime integerValue] andFormatter:@"YYYY-MM-dd"];// HH:mm:ss
        model.fID = [[dict objectForKey:@"ID"] stringValue];
        model.fsource = [dict objectForKey:@"StudentName"];
        if ([[dict objectForKey:@"ProjectName"]isEqualToString:[dict objectForKey:@"ProjectSubName"]]) {
            model.fteam = @"否";
        }else{
            model.fteam = @"是";
        }
        if ([[dict objectForKey:@"CheckState"] intValue] == 0) {
            model.fcheck = @"审核中";
        }else if ([[dict objectForKey:@"CheckState"] intValue]==1)
        {
            model.fcheck = @"审核通过";
        }else if([[dict objectForKey:@"CheckState"] intValue]==2){
            model.fcheck = @"审核未通过";
        }else{
            model.fcheck = @"已作废";
        }
        model.fscore = @"无";
        model.fstate = @"无";
        if (![[dict objectForKey:@"FinalScore"] isKindOfClass:[NSNull class]]) {
            model.fscore = [dict objectForKey:@"FinalScore"];
        }
        if (![[dict objectForKey:@"GeneralRate"] isKindOfClass:[NSNull class]]) {
            model.fstate = [dict objectForKey:@"GeneralRate"] ;
        }
       model.wordUrl = [dict objectForKey:@"FileUrl"];
        [array addObject:model];
    }
    return array;
}
-(void)startLayout
{
    _tableView = [[BaseTablewView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height- HEIGHT_STATUSBAR - HEIGHT_NAVBAR - 44.0f) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 110;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = RGB_HEX(0xFFB6C1, 1);
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
}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FinalizationListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FinalizationListCellID"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"FinalizationListTableViewCell" owner:self options:nil].firstObject;
    }
    FinalizationListModel *model = self.tableArray[indexPath.row];
    cell.fnameLabel.text = model.fname;
    cell.ftimeLabel.text = [NSString stringWithFormat:@"提交时间:%@",model.ftime];
    cell.fsourceLabel.text = [NSString stringWithFormat:@"学生姓名:%@",model.fsource];;
    cell.fteamLabel.text = [NSString stringWithFormat:@"是否团队:%@",model.fteam];
    cell.fcheckLabel.text = [NSString stringWithFormat:@"导师审阅:%@",model.fcheck];
    cell.fstateLabel.text = [NSString stringWithFormat:@"查重相似度:%@",model.fstate];
    cell.fscoreLabel.text = [NSString stringWithFormat:@"答辩成绩:%@",model.fscore];
    return cell;
}
#pragma mark 返回组头的高度 : 第一组的头部一定要通过代理设置
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FinalizationListModel *model = self.tableArray[indexPath.row];
    NSString *url = model.wordUrl.fullImg;
    LDPublicWebViewController *web = [[LDPublicWebViewController alloc] init];
    web.webUrl = url;
    web.title = @"查看附件";
    [self.navigationController pushViewController:web animated:YES];
}
-(NSMutableArray *)tableArray
{
    if (!_tableArray) {
        _tableArray = [[NSMutableArray alloc]init];
    }
    return _tableArray;
}

@end
