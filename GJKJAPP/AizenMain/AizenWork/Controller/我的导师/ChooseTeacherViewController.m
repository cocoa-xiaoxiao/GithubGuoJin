//
//  ChooseTeacherViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/2/22.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "ChooseTeacherViewController.h"
#import "AizenHttp.h"
#import "People.h"
#import "DGActivityIndicatorView.h"
#import "BRContantPeopleModel.h"
#import "WorkBaseModel.h"
#import "StudentDetailViewController.h"
#import "PersonModel.h"
#import "MyteacherTableViewCell.h"
@interface ChooseTeacherViewController ()
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableArray; //数据源
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@end

@implementation ChooseTeacherViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择导师";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self startLayout];
    [self getDataSourceFromHttp];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}
-(void)startLayout
{
    _tableView = [[BaseTablewView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 80;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerNib:[UINib nibWithNibName:@"MyteacherTableViewCell" bundle:nil] forCellReuseIdentifier:@"laoshiCellID"];
    [self.view addSubview:_tableView];
}
-(void)getDataSourceFromHttp
{
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    NSString *url = [NSString stringWithFormat:@"%@/ApiActivity/GetTeacherListByActivityID?AdminID=%@&ActivityID=%@",kCacheHttpRoot,@"281",@"1"];
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
    for (int i = 0; i < dataArr.count; i++) {
        NSDictionary *dict = dataArr[i];
        PersonModel *model = [[PersonModel alloc]init];
        model.headerUrl = [NSString checkNull:[dict objectForKey:@"InFactUrl"]];
        model.name1 = [dict objectForKey:@"InUserName"];
        model.phoneNumber = [NSString checkNull:[dict objectForKey:@"InMobile"]];;
        model.friendId = [dict objectForKey:@"TeacherID"];
        [self.tableArray addObject:model];
    }
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
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"确定要选择该导师?"] preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
        NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
        People *getObj = existArr[0];
        NSString *CurrAdminID = [getObj.USERID stringValue];
        NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
        NSString *url = [NSString stringWithFormat:@"%@/ApiActivity/StudentApplyTeacher?AdminID=%@&ActivityID=%@&TeacherID=%@",kCacheHttpRoot,@"281",@"1",model.friendId];
        NSLog(@"%@",url);
        [_activityIndicatorView startAnimating];
        [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
            [_activityIndicatorView stopAnimating];
            NSDictionary *jsonDic = result;
            [self.navigationController popViewControllerAnimated:YES];
        } failue:^(NSError *error) {
            [_activityIndicatorView stopAnimating];
            NSLog(@"请求失败--获取我的申请记录");
        }];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
-(NSMutableArray *)tableArray
{
    if (!_tableArray) {
        _tableArray = [[NSMutableArray alloc]init];
    }
    return _tableArray;
}


@end
