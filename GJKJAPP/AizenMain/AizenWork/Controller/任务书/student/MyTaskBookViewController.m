//
//  MyTaskBookViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/11.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MyTaskBookViewController.h"
#import "WorkBaseModel.h"
#import "MyTaskBookCustom1TableViewCell.h"
#import "MyTaskBookCustom2TableViewCell.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "People.h"
#import "PhoneInfo.h"
#import "NSString+Extension.h"
#import "LDPublicWebViewController.h"
@interface MyTaskBookViewController ()
{
    NSString *_fileurl;
}
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourceArray; //数据源
@end

@implementation MyTaskBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的任务书";
    [self startLayout];
    [self getDataSourceFromHttp];
}

-(void)getDataSourceFromHttp
{
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [_tableView addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    [HttpService GetMyTaskBookListByStudentID:CurrAdminID andActivityID:batchID and:20 and:1 success:^(id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"ResultType"] intValue] == 0 ) {
            NSArray *rows = responseObject[@"AppendData"][@"rows"];
            NSDictionary *firstDic = rows.firstObject;
            [HttpService GetProjectTaskBookConfigByActivityID:batchID success:^(id  _Nonnull responseObject) {
                [_activityIndicatorView stopAnimating];
                NSDictionary *SecondDict = responseObject[@"AppendData"];
                _fileurl = SecondDict[@"TemplateUrl"];
                [self combineWithFirstDict:firstDic andSectionDict:SecondDict];
                [self.tableView reloadData];
            } failure:^(NSError * _Nonnull error) {
                [_activityIndicatorView stopAnimating];
            }];
        }else{
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"暂无数据"] preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [_activityIndicatorView stopAnimating];
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
        }
    } failure:^(NSError * _Nonnull error) {
        [_activityIndicatorView stopAnimating];
    }];
    
}

-(void)startLayout
{
    _tableView = [[BaseTablewView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = RGB_HEX(0xFFB6C1, 1);
    [_tableView registerNib:[UINib nibWithNibName:@"MyTaskBookCustom1TableViewCell" bundle:nil] forCellReuseIdentifier:@"MyTaskBookCustom1CellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"MyTaskBookCustom2TableViewCell" bundle:nil] forCellReuseIdentifier:@"MyTaskBookCustom2CellID"];
    [self.view addSubview:_tableView];
    
    UIButton *lookWordDocumentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lookWordDocumentButton.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    [lookWordDocumentButton setTitle:@"查看Work文档" forState:UIControlStateNormal];
    [lookWordDocumentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    lookWordDocumentButton.backgroundColor = [UIColor colorWithRed:75/255.0 green:145/255.0 blue:255/255.0 alpha:1.0];
    [lookWordDocumentButton addTarget:self action:@selector(lookword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lookWordDocumentButton];
}
#pragma mark lazyload
-(NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc]init];
    }
    return _dataSourceArray;
}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    mytaskModel *model = self.dataSourceArray[indexPath.row];
    if (model.cellType == 1) {
        return 50.0f;
    }
    return 150.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    mytaskModel *model = self.dataSourceArray[indexPath.row];
    if (model.cellType == 1) {
        MyTaskBookCustom1TableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"MyTaskBookCustom1CellID"];
        cell1.nameLabel.text = model.title;
        cell1.teamButton.hidden = NO;
        [cell1.teamButton setTitle:model.isteam?@"团队合作":@"独立完成" forState:UIControlStateNormal];
        if (indexPath.row == 1) {
            cell1.teamButton.hidden = YES;
        }
        return cell1;
    }
    MyTaskBookCustom2TableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"MyTaskBookCustom2CellID"];
    cell2.titleLabel.text = model.detail;
    cell2.detailTextView.text = model.title;
    return cell2;
}
#pragma mark 返回组头的高度 : 第一组的头部一定要通过代理设置

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}



-(void)combineWithFirstDict:(NSDictionary *)firstDic andSectionDict:(NSDictionary *)SecondDict
{
    if ([[firstDic objectForKey:@"IsTeam"] boolValue]) {
        mytaskModel *model1 = [[mytaskModel alloc]init];
        model1.title = [firstDic objectForKey:@"ProjectName"];
        model1.cellType = 1;
        model1.isteam = [[firstDic objectForKey:@"IsTeam"] boolValue];
        mytaskModel *model2 = [[mytaskModel alloc]init];
        model2.title = [firstDic objectForKey:@"ProjectSubName"];
        model2.isteam = [[firstDic objectForKey:@"IsTeam"] boolValue];
        model2.cellType = 1;
        [self.dataSourceArray addObject:model1];
        [self.dataSourceArray addObject:model2];
    }else{
        mytaskModel *model1 = [[mytaskModel alloc]init];
        model1.title = [firstDic objectForKey:@"ProjectName"];
        model1.cellType = 1;
        [self.dataSourceArray addObject:model1];
    }
    if (![[firstDic objectForKey:@"Field1"] isKindOfClass:[NSNull class]]) {
        mytaskModel *model1 = [[mytaskModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field1"];
        model1.detail = [SecondDict objectForKey:@"Field1"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[firstDic objectForKey:@"Field2"] isKindOfClass:[NSNull class]]) {
        mytaskModel *model1 = [[mytaskModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field2"];
        model1.detail = [SecondDict objectForKey:@"Field2"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[firstDic objectForKey:@"Field3"] isKindOfClass:[NSNull class]]) {
        mytaskModel *model1 = [[mytaskModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field3"];
        model1.detail = [SecondDict objectForKey:@"Field3"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[firstDic objectForKey:@"Field4"] isKindOfClass:[NSNull class]]) {
        mytaskModel *model1 = [[mytaskModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field4"];
        model1.detail = [SecondDict objectForKey:@"Field4"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[firstDic objectForKey:@"Field5"] isKindOfClass:[NSNull class]]) {
        mytaskModel *model1 = [[mytaskModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field5"];
        model1.detail = [SecondDict objectForKey:@"Field5"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[firstDic objectForKey:@"Field6"] isKindOfClass:[NSNull class]]) {
        mytaskModel *model1 = [[mytaskModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field6"];
        model1.detail = [SecondDict objectForKey:@"Field6"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[firstDic objectForKey:@"Field7"] isKindOfClass:[NSNull class]]) {
        mytaskModel *model1 = [[mytaskModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field7"];
        model1.detail = [SecondDict objectForKey:@"Field7"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[firstDic objectForKey:@"Field8"] isKindOfClass:[NSNull class]]) {
        mytaskModel *model1 = [[mytaskModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field8"];
        model1.detail = [SecondDict objectForKey:@"Field8"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }

}

-(void)lookword:(UIButton *)sender
{
    NSString *url = [_fileurl fullImg];
    LDPublicWebViewController *web = [[LDPublicWebViewController alloc] init];
    web.webUrl = url;
    web.title = @"查看附件";
    [self.navigationController pushViewController:web animated:YES];
}
@end

@implementation mytaskModel

@end
