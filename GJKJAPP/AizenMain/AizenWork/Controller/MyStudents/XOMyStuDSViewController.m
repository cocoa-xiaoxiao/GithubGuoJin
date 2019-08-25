//
//  XOMyStuDSViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/6/5.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "XOMyStuDSViewController.h"
#import "AizenHttp.h"
#import "People.h"
#import "DGActivityIndicatorView.h"
#import "BRContantPeopleModel.h"
#import "WorkBaseModel.h"
#import "StudentDetailViewController.h"
#import "PersonModel.h"
#import "XOMyStdTableViewCell.h"
#import "MainViewController.h"
@interface XOMyStuDSViewController (){
    int _page;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableArray; //数据源
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@end

@implementation XOMyStuDSViewController
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
    [_tableView registerNib:[UINib nibWithNibName:@"XOMyStdTableViewCell" bundle:nil] forCellReuseIdentifier:@"studentCellID"];
    [self.view addSubview:_tableView];
    WS(ws);
    [self addFreshPull:self.tableView withBlock:^(id info) {
        [ws getDataSourceFromHttpIsFooterRefresh:NO];
    }];
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 100 - 88)/2, 100, 100);
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
    NSString *url = [NSString stringWithFormat:@"%@/ApiActivity/GetMyCheckList?AdminID=%@&ActivityID=%@",kCacheHttpRoot,CurrAdminID,batchID];
    NSLog(@"%@",url);
    [_activityIndicatorView startAnimating];
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        if (FooterRefresh == YES) {
            [self.tableArray addObjectsFromArray:[self detailLayout:[jsonDic objectForKey:@"AppendData"]]];
        }else{
            self.tableArray = [[self detailLayout:[jsonDic objectForKey:@"AppendData"]] mutableCopy];
        }
        [self headerEndFreshPull];
        [self.tableView reloadData];
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败--获取我的申请记录");
    }];
}
-(NSArray *) detailLayout:(NSArray *)dataArr{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i = 0; i < dataArr.count; i++) {
        NSDictionary *dict = dataArr[i];
        PersonModel *model = [[PersonModel alloc]init];
        model.headerUrl = [NSString checkNull:[dict objectForKey:@"FactUrl"]];
        model.name1 = [dict objectForKey:@"UserName"];
        model.phoneNumber = [NSString checkNull:[dict objectForKey:@"Mobile"]];;
        model.tel = [dict objectForKey:@"EnterpriseName"];
        [array addObject:model];
    }
    return array;
}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonModel *model = self.tableArray[indexPath.row];
    XOMyStdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studentCellID"];
    [cell.imgv br_SDWebSetImageWithURLString:model.headerUrl.fullImg placeholderImage:[UIImage imageNamed:@"myphoto"]];
    cell.telLb.text = model.phoneNumber;
    cell.namelb.text = model.name1;
    cell.sxlb.text = model.tel;
    return cell;
}
#pragma mark 返回组头的高度 : 第一组的头部一定要通过代理设置
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
