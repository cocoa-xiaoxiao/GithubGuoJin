//
//  NotCheckProListViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/13.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "NotTaskBookListViewController.h"
#import "WorkBaseModel.h"
#import "TaskBookListTableViewCell.h"
#import "MyProjectDetailViewController.h"
#import "IBCreatHelper.h"
#import "MainViewController.h"
#import "People.h"
#import "PhoneInfo.h"
#import "DGActivityIndicatorView.h"
#import "MyStudentTaskBookDetailViewController.h"
@interface NotTaskBookListViewController ()
{
    int _page;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableArray; //数据源
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@end

@implementation NotTaskBookListViewController

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
    [HttpService GetMyStudentTaskBookListFromUpdater:CurrAdminID andActivityID:batchID and:10 and:_page success:^(id  _Nonnull responseObject) {
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
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0 ; i < dataArr.count; i++) {
        NSDictionary *dict = dataArr[i];
        taskBookListModel *model = [[taskBookListModel alloc]init];
        model.bname = [dict objectForKey:@"ProjectName"];
        NSRange rang = {0,10};
        NSString *StartTime = [[[[NSString checkNull:[dict objectForKey:@"CreateDate"]] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
        model.btime = [PhoneInfo timestampSwitchTime:[StartTime integerValue] andFormatter:@"YYYY-MM-dd"];// HH:mm:ss
        model.bID = [dict objectForKey:@"ProjectDocumentID"];
        model.bsource = [dict objectForKey:@"UserName"];
        if ([[NSString checkNull:[dict objectForKey:@"ProjectName"]]isEqualToString:[dict objectForKey:@"ProjectSubName"]]) {
            model.bteam = @"否";
        }else{
            model.bteam = @"是";
        }
        model.bstate = [dict objectForKey:@"CheckStateName"];
        model.subtitle = [dict objectForKey:@"ProjectSubName"];
        if ([model.bstate isEqualToString:@"未下达"]) {
            [array addObject:model];
        }
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
    TaskBookListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskBookListCellID"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"TaskBookListTableViewCell" owner:self options:nil].firstObject;
    }
    taskBookListModel *model = self.tableArray[indexPath.row];
    cell.bnameLabel.text = model.bname;
    cell.btimeLabel.text = [NSString stringWithFormat:@"日期:%@",model.btime];
    cell.bsourceLabel.text = [NSString stringWithFormat:@"学生:%@",model.bsource];;
    cell.bteamLabel.text = [NSString stringWithFormat:@"团队:%@",model.bteam];
    cell.bstateLabel.text = [NSString stringWithFormat:@"状态:%@",model.bstate];
    return cell;
}
#pragma mark 返回组头的高度 : 第一组的头部一定要通过代理设置
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    taskBookListModel *model = self.tableArray[indexPath.row];
    MyStudentTaskBookDetailViewController *vc = [[MyStudentTaskBookDetailViewController alloc]init];
    vc.topModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}
-(NSMutableArray *)tableArray
{
    if (!_tableArray) {
        _tableArray = [[NSMutableArray alloc]init];
    }
    return _tableArray;
}
@end
