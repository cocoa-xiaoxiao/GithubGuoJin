//
//  NotProReviewViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/1/7.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "NotProReviewViewController.h"
#import "ProReviewTableViewCell.h"
#import "WorkBaseModel.h"
#import "IBCreatHelper.h"
#import "MainViewController.h"
#import "People.h"
#import "PhoneInfo.h"
#import "DGActivityIndicatorView.h"
#import "ReViewCommentViewController.h"
@interface NotProReviewViewController ()
{
    int _page;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableArray; //数据源
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@end

@implementation NotProReviewViewController

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
    [HttpService GetMyStudentApplyListAdminID:CurrAdminID andActivityID:batchID andStudentName:@"" and:10 and:_page success:^(id  _Nonnull responseObject) {
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
        ProReviewModel *model = [[ProReviewModel alloc]init];
        model.project = [dict objectForKey:@"ProjectName"];
        NSRange rang = {0,10};
        NSString *StartTime = [[[[dict objectForKey:@"CreateDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
        model.time = [PhoneInfo timestampSwitchTime:[StartTime integerValue] andFormatter:@"YYYY-MM-dd"];// HH:mm:ss
        model.proID = [[dict objectForKey:@"ID"] stringValue];
        model.student = [dict objectForKey:@"StudentName"];
        model.chachong = @"无";
        model.score = @"无";
        if (![[dict objectForKey:@"FinalScore"] isKindOfClass:[NSNull class]]) {
            model.score = [NSString stringWithFormat:@"%d",[[dict objectForKey:@"FinalScore"]intValue]];
        }
        if ([dict objectForKey:@"GeneralRate"]) {
            if (![[dict objectForKey:@"GeneralRate"] isKindOfClass:[NSNull class]]) {
                model.chachong = [dict objectForKey:@"GeneralRate"] ;
            }
        }
        if (![model.score isEqualToString:@"无"]) {
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
    ProReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProReviewCellID"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ProReviewTableViewCell" owner:self options:nil].firstObject;
    }
    ProReviewModel *model = self.tableArray[indexPath.row];
    cell.projectLabel.text = model.project;
    cell.timeLabel.text = [NSString stringWithFormat:@"%@",model.time];
    cell.studentLabel.text = [NSString stringWithFormat:@"学生:%@",model.student];;
    cell.chachongLabel.text = [NSString stringWithFormat:@"查重相似度:%@",model.chachong];
    cell.scoreLabel.text = [NSString stringWithFormat:@"评阅成绩:%@",model.score];
    return cell;
}
#pragma mark 返回组头的高度 : 第一组的头部一定要通过代理设置
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    MyReviewListModel *model = self.tableArray[indexPath.row];
    //    ReViewCommentViewController *vc = getControllerFromStoryBoard(@"Worker", @"reviewCommentSBID");
    //    vc.reviewID = model.rID;
    //    vc.editReview = 2;
    //    [self.navigationController pushViewController:vc animated:YES];
}
-(NSMutableArray *)tableArray
{
    if (!_tableArray) {
        _tableArray = [[NSMutableArray alloc]init];
    }
    return _tableArray;
}
@end
