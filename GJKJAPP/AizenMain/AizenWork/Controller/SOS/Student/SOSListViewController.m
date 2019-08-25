//
//  SOSListViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/2/12.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "SOSListViewController.h"
#import "GJSOSRecordListTableViewCell.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "GJASOSDetailViewController.h"
#import "WorkBaseModel.h"
#import "PhoneInfo.h"
@interface SOSListViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@end

@implementation SOSListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getNewData];
    [self.view addSubview:self.tableView];
    self.title = @"SOS记录";
}

-(void)getNewData
{
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [self.tableView addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    [HttpService GetSOSListDataWithRows:20 and:1 success:^(id  _Nonnull jsonDic) {
        [self detailLayout:[jsonDic objectForKey:@"AppendData"]];
        [_activityIndicatorView stopAnimating];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [_activityIndicatorView stopAnimating];
    }];
}
-(void) detailLayout:(NSArray *)dataArr{
    for (int i = 0 ; i < dataArr.count; i++) {
        NSDictionary *dict = dataArr[i];
        SOSListModel *model = [[SOSListModel alloc]init];
        model.sosName = [dict objectForKey:@"UserName"];
        model.sosPlace = [dict objectForKey:@"WarnPlace"];
        model.warnReason = [dict objectForKey:@"WarnTitle"];
        model.sosID = [dict objectForKey:@"ID"];
        model.ishandle = [[dict objectForKey:@"IsHandle"] boolValue];
        NSRange rang = {0,10};
        NSString *StartTime = [[[[dict objectForKey:@"WarnDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
        model.time = [PhoneInfo timestampSwitchTime:[StartTime integerValue] andFormatter:@"YYYY-MM-dd HH:mm:ss"];
        [self.listArray addObject:model];
    }
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}
-(NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc]init];
    }
    return _listArray;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [GJSOSRecordListTableViewCell br_getUITableViewCellHeight];;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GJSOSRecordListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GJSOSRecordListTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GJSOSRecordListTableViewCell" owner:self options:nil] firstObject];
    }
    [cell refreshUIWithModel:self.listArray[indexPath.section]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SOSListModel *model =  self.listArray[indexPath.section];
    GJASOSDetailViewController *vc = [[GJASOSDetailViewController alloc] init];
    vc.sosID = model.sosID;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
