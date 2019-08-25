//
//  HaveMyReviewListViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/13.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "HaveMyReviewListViewController.h"
#import "MyReviewListViewCell.h"
#import "WorkBaseModel.h"
#import "MyProjectDetailViewController.h"
#import "IBCreatHelper.h"
#import "MainViewController.h"
#import "People.h"
#import "PhoneInfo.h"
#import "DGActivityIndicatorView.h"
#import "ReViewCommentViewController.h"
@interface HaveMyReviewListViewController ()
{
    int _page;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableArray; //数据源
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@end

@implementation HaveMyReviewListViewController
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
    [HttpService GetMyReviewList:CurrAdminID with:batchID with:@"" with:@"" with:2 and:10 and:_page success:^(id  _Nonnull responseObject) {
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
        MyReviewListModel *model = [[MyReviewListModel alloc]init];
        model.rname = [dict objectForKey:@"ProjectName"];
        NSRange rang = {0,10};
        NSString *StartTime = [[[[dict objectForKey:@"CreateDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
        model.rtime = [PhoneInfo timestampSwitchTime:[StartTime integerValue] andFormatter:@"YYYY-MM-dd"];// HH:mm:ss
        model.rID = [[dict objectForKey:@"ID"] stringValue];
        model.rsource = [dict objectForKey:@"StudentName"];
        model.rteacher = [dict objectForKey:@"TeacherName"];
        model.rplcae = [dict objectForKey:@"InspectionTeamPlace"];
        model.rstate = @"无";
        model.rscore = @"无";
        if (![[dict objectForKey:@"FinalScore"] isKindOfClass:[NSNull class]]) {
            model.rscore = [dict objectForKey:@"FinalScore"];
        }
        if ([dict objectForKey:@"GeneralRate"]) {
            if (![[dict objectForKey:@"GeneralRate"] isKindOfClass:[NSNull class]]) {
                model.rstate = [dict objectForKey:@"GeneralRate"] ;
            }
        }
        [array addObject:model];
    }
    return array;
}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyReviewListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyReviewListCellID"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MyReviewListViewCell" owner:self options:nil].firstObject;
    }
    MyReviewListModel *model = self.tableArray[indexPath.row];
    cell.rnameLabel.text = [NSString checkNull:model.rname];
    cell.rtimeLabel.text = [NSString stringWithFormat:@"答辩日期:%@",model.rtime];
    cell.rsourceLabel.text = [NSString stringWithFormat:@"学生姓名:%@",model.rsource];;
    cell.rteacherLabel.text = [NSString stringWithFormat:@"导师:%@",model.rteacher];
    cell.rplaceLabel.text = [NSString stringWithFormat:@"地点:%@",model.rplcae];
    cell.rstateLabel.text = [NSString stringWithFormat:@"查重相似度:%@",model.rstate];
    cell.rscoreLabel.text = [NSString stringWithFormat:@"答辩成绩:%@",model.rscore];
    return cell;
}
#pragma mark 返回组头的高度 : 第一组的头部一定要通过代理设置
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyReviewListModel *model = self.tableArray[indexPath.row];
    ReViewCommentViewController *vc = getControllerFromStoryBoard(@"Worker", @"reviewCommentSBID");
    vc.reviewID = model.rID;
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
