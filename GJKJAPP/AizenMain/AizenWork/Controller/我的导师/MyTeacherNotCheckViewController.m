
//  MyTeacherNotCheckViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/2/21.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "MyTeacherNotCheckViewController.h"
#import "WorkBaseModel.h"
#import "MyProjectDetailViewController.h"
#import "IBCreatHelper.h"
#import "MainViewController.h"
#import "People.h"
#import "PhoneInfo.h"
#import "DGActivityIndicatorView.h"
#import "AizenHttp.h"
#import "StudentDetailViewController.h"
#import "PersonModel.h"
#import "MyteacherTableViewCell.h"
@interface MyTeacherNotCheckViewController ()
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableArray; //数据源
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@end

@implementation MyTeacherNotCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLayout];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getDataSourceFromHttp];
}

-(void)getDataSourceFromHttp
{
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    NSString *url = [NSString stringWithFormat:@"%@/ApiActivity/GetMyApplyList?AdminID=%@&ActivityID=%@",kCacheHttpRoot,CurrAdminID,batchID];
    NSLog(@"%@",url);
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        [self detailLayout:[jsonDic objectForKey:@"AppendData"]];
        [self.tableView reloadData];
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败--获取我的申请记录");
    }];
}
-(void) detailLayout:(NSArray *)dataArr{
    [self.tableArray removeAllObjects];
    for (int i = 0; i < dataArr.count; i++) {
        NSDictionary *dict = dataArr[i];
        PersonModel *model = [[PersonModel alloc]init];
        model.headerUrl = [NSString checkNull:[dict objectForKey:@"InFactUrl"]];
        model.name1 = [dict objectForKey:@"InUserName"];
        model.phoneNumber = [NSString checkNull:[dict objectForKey:@"InMobile"]];;
        model.tel = [dict objectForKey:@"EnterpriseName"];
        model.CheckState = [[dict objectForKey:@"CheckState"] intValue];
        if (!model.CheckState) {
            [self.tableArray addObject:model];
        }
    }
}
-(void)startLayout
{
    _tableView = [[BaseTablewView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height- HEIGHT_STATUSBAR - HEIGHT_NAVBAR - 44.0f) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 80;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerNib:[UINib nibWithNibName:@"MyteacherTableViewCell" bundle:nil] forCellReuseIdentifier:@"laoshiCellID"];
    [_tableView br_configFitIos11AdjustNo];
    [self.view addSubview:_tableView];
    
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
    PersonModel *model = self.tableArray[indexPath.row];
    MyteacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"laoshiCellID"];
    [cell.headImgView br_SDWebSetImageWithURLString:model.headerUrl.fullImg placeholderImage:[UIImage imageNamed:@"myphoto"]];
    cell.phoneLab.text = model.phoneNumber;
    cell.nameLabel.text = model.name1;
    return cell;
}
#pragma mark 返回组头的高度 : 第一组的头部一定要通过代理设置
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonModel *model = self.tableArray[indexPath.row];
    StudentDetailViewController *student = [[StudentDetailViewController alloc]init];
    student.person = model;
    [self.navigationController pushViewController:student animated:YES];
}
-(NSMutableArray *)tableArray
{
    if (!_tableArray) {
        _tableArray = [[NSMutableArray alloc]init];
    }
    return _tableArray;
}


@end
