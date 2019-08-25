//
//  MyStudentTaskBookDetailViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/1/4.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "MyStudentTaskBookDetailViewController.h"
#import "MyTaskBookCustom1TableViewCell.h"
#import "MyTaskBookCustom2TableViewCell.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "People.h"
#import "PhoneInfo.h"
#import "NSString+Extension.h"
#import "AizenMD5.h"
#import "Toast+UIView.h"
@interface MyStudentTaskBookDetailViewController ()<MyCustom2TableCellDelegate>
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourceArray; //数据源
@end

@implementation MyStudentTaskBookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务书";
    [self startLayout];
    [self getDataSourceFromHttp];
}

-(void)getDataSourceFromHttp
{
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [self.view addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    [HttpService GetProjectTaskBookConfigByActivityID:batchID success:^(id  _Nonnull responseObject) {
        NSDictionary *SecondDict = responseObject[@"AppendData"];
        [HttpService GetProjectTaskBookByID:self.topModel.bID success:^(id  _Nonnull responseObject) {
            [_activityIndicatorView stopAnimating];
            NSArray *rows = responseObject[@"AppendData"][@"rows"];
            NSDictionary *firstDic = rows.firstObject;
            [self combineWithFirstDict:firstDic andSectionDict:SecondDict];
            [self.tableView reloadData];
        } failure:^(NSError * _Nonnull error) {
            [_activityIndicatorView stopAnimating];
            [self combineWithFirstDict:@{} andSectionDict:SecondDict];
            [self.tableView reloadData];
        }];
    } failure:^(NSError * _Nonnull error) {
        [_activityIndicatorView stopAnimating];
    }];
}
-(void)startLayout
{
    _tableView = [[BaseTablewView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerNib:[UINib nibWithNibName:@"MyTaskBookCustom1TableViewCell" bundle:nil] forCellReuseIdentifier:@"MyTaskBookCustom1CellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"MyTaskBookCustom2TableViewCell" bundle:nil] forCellReuseIdentifier:@"MyTaskBookCustom2CellID"];
    [self.view addSubview:_tableView];
    
    UIButton *lookWordDocumentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lookWordDocumentButton.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    [lookWordDocumentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    lookWordDocumentButton.backgroundColor = [UIColor colorWithRed:75/255.0 green:145/255.0 blue:255/255.0 alpha:1.0];
    [lookWordDocumentButton addTarget:self action:@selector(xiada:) forControlEvents:UIControlEventTouchUpInside];
    if ([self.topModel.bstate isEqualToString:@"审核中"]) {
        _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    }else{
        _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height- 50);
        [self.view addSubview:lookWordDocumentButton];
        if ([self.topModel.bstate isEqualToString:@"审核通过"]) {
            [lookWordDocumentButton setTitle:@"查看Work文档" forState:UIControlStateNormal];
        }else if ([self.topModel.bstate isEqualToString:@"审核不通过"])
        {
            [lookWordDocumentButton setTitle:@"修改任务书" forState:UIControlStateNormal];
        }else if ([self.topModel.bstate isEqualToString:@"未下达"])
        {
            [lookWordDocumentButton setTitle:@"下达任务书" forState:UIControlStateNormal];
        }
    }
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
    mystudentTaskModel *model = self.dataSourceArray[indexPath.row];
    if (model.cellType == 1) {
        return 50.0f;
    }
    return 150.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    mystudentTaskModel *model = self.dataSourceArray[indexPath.row];
    if (model.cellType == 1) {
        MyTaskBookCustom1TableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"MyTaskBookCustom1CellID"];
        if ([self.topModel.bteam isEqualToString:@"是"]) {
            if (indexPath.row == 0) {
                cell1.nameLabel.text = self.topModel.bname;
                cell1.teamButton.hidden = NO;
                [cell1.teamButton setTitle:@"团队合作" forState:UIControlStateNormal];
            }else{
                cell1.nameLabel.text = self.topModel.subtitle;
                cell1.teamButton.hidden = YES;
            }
        }else{
            cell1.nameLabel.text = self.topModel.bname;
            cell1.teamButton.hidden = NO;
            [cell1.teamButton setTitle:@"独立完成" forState:UIControlStateNormal];
        }
        return cell1;
    }
    MyTaskBookCustom2TableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"MyTaskBookCustom2CellID"];
    cell2.titleLabel.text = model.detail;
    cell2.detailTextView.text = model.title;
    cell2.indexPath = indexPath;
    if ([self.topModel.bstate isEqualToString:@"未下达"]||[self.topModel.bstate isEqualToString:@"审核不通过"]) {
        cell2.detailTextView.editable = YES;
    }
    cell2.delegate = self;
    return cell2;
}
-(void)textViewEditEndAndTextString:(NSString *)text andIndex:(NSIndexPath *)index
{
    mystudentTaskModel *model = self.dataSourceArray[index.row];
    model.title = text;
}
#pragma mark 返回组头的高度 : 第一组的头部一定要通过代理设置

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}



-(void)combineWithFirstDict:(NSDictionary *)firstDic andSectionDict:(NSDictionary *)SecondDict
{
    if ([self.topModel.bteam isEqualToString:@"是"]) {
        mystudentTaskModel *model1 = [[mystudentTaskModel alloc]init];
        model1.title = [firstDic objectForKey:@"ProjectName"];
        model1.cellType = 1;
        model1.isteam = [[firstDic objectForKey:@"IsTeam"] boolValue];
        mystudentTaskModel *model2 = [[mystudentTaskModel alloc]init];
        model2.title = [firstDic objectForKey:@"ProjectSubName"];
        model2.isteam = [[firstDic objectForKey:@"IsTeam"] boolValue];
        model2.cellType = 1;
        [self.dataSourceArray addObject:model1];
        [self.dataSourceArray addObject:model2];
    }else{
        mystudentTaskModel *model1 = [[mystudentTaskModel alloc]init];
        model1.title = [firstDic objectForKey:@"ProjectName"];
        model1.cellType = 1;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field1"] isKindOfClass:[NSNull class]]) {
        mystudentTaskModel *model1 = [[mystudentTaskModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field1"];
        model1.detail = [SecondDict objectForKey:@"Field1"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field2"] isKindOfClass:[NSNull class]]) {
        mystudentTaskModel *model1 = [[mystudentTaskModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field2"];
        model1.detail = [SecondDict objectForKey:@"Field2"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field3"] isKindOfClass:[NSNull class]]) {
        mystudentTaskModel *model1 = [[mystudentTaskModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field3"];
        model1.detail = [SecondDict objectForKey:@"Field3"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field4"] isKindOfClass:[NSNull class]]) {
        mystudentTaskModel *model1 = [[mystudentTaskModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field4"];
        model1.detail = [SecondDict objectForKey:@"Field4"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field5"] isKindOfClass:[NSNull class]]) {
        mystudentTaskModel *model1 = [[mystudentTaskModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field5"];
        model1.detail = [SecondDict objectForKey:@"Field5"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field6"] isKindOfClass:[NSNull class]]) {
        mystudentTaskModel *model1 = [[mystudentTaskModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field6"];
        model1.detail = [SecondDict objectForKey:@"Field6"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field7"] isKindOfClass:[NSNull class]]) {
        mystudentTaskModel *model1 = [[mystudentTaskModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field7"];
        model1.detail = [SecondDict objectForKey:@"Field7"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field8"] isKindOfClass:[NSNull class]]) {
        mystudentTaskModel *model1 = [[mystudentTaskModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field8"];
        model1.detail = [SecondDict objectForKey:@"Field8"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    
}

-(void)xiada:(UIButton *)sender
{
    NSMutableArray *detailAA = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.dataSourceArray.count; i++) {
        mystudentTaskModel *model = self.dataSourceArray[i];
        if (model.cellType == 2) {
            if (model.title == nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写完整数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                return;
            }
            [detailAA addObject:model.title];
        }
    }
    NSString *f1 = @"";
    NSString *f2 = @"";
    NSString *f3 = @"";
    NSString *f4 = @"";
    NSString *f5 = @"";
    NSString *f6 = @"";
    NSString *f7 = @"";
    NSString *f8 = @"";
    for (int i = 0; i< detailAA.count; i++) {
        if (i == 0) {
            f1 = [detailAA objectAtIndex:0];
        }
        if (i == 1) {
            f2 = [detailAA objectAtIndex:1];
        }
        if (i == 2) {
            f3 = [detailAA objectAtIndex:2];
        }
        if (i == 3) {
            f4 = [detailAA objectAtIndex:3];
        }
        if (i == 4) {
            f5 = [detailAA objectAtIndex:4];
        }
        if (i == 5) {
            f6 = [detailAA objectAtIndex:5];
        }
        if (i == 6) {
            f7 = [detailAA objectAtIndex:6];
        }
        if (i == 7) {
            f8 = [detailAA objectAtIndex:7];
        }
    }
    
    [_activityIndicatorView startAnimating];
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    UInt64 currTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *currTimeStr = [NSString stringWithFormat:@"%ld",currTime];
    NSString *md5Str = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@GJProjectDocuments%@",CurrAdminID,currTimeStr]];
    if ([sender.titleLabel.text isEqualToString:@"下达任务书"]) {
        
        [HttpService TaskBookCreateByStudentID:CurrAdminID andActivityID:batchID andDocumentTitle:self.topModel.bname andSubmit:YES andTimeStamp:currTimeStr andToken:md5Str Field1:f1 Field2:f2 Field3:f3 Field4:f4 Field5:f5 Field6:f6 Field7:f7 Field8:f8 success:^(NSDictionary *resp) {
            NSString *msg = [resp objectForKey:@"Message"];
            if ([[resp objectForKey:@"ResultType"] intValue] == 0) {
                [self.navigationController popViewControllerAnimated:YES];
                [[UIApplication sharedApplication].keyWindow makeToast:msg duration:2.0 position:@"bottom"];
            }else{
                [self.view makeToast:msg duration:1.0 position:@"center"];
            }
            [_activityIndicatorView stopAnimating];
        } failure:^(NSError * _Nonnull error) {
            [_activityIndicatorView stopAnimating];
        }];
    }else if ([sender.titleLabel.text isEqualToString:@"修改任务书"])
    {
        [HttpService TaskBookModifyByStudentID:CurrAdminID fromID:self.topModel.bID andActivityID:batchID andDocumentTitle:self.topModel.bname andSubmit:YES andTimeStamp:currTimeStr andToken:md5Str Field1:f1 Field2:f2 Field3:f3 Field4:f4 Field5:f5 Field6:f6 Field7:f7 Field8:f8 success:^(NSDictionary *resp) {
            [_activityIndicatorView stopAnimating];
            NSString *msg = [resp objectForKey:@"Message"];
            if ([[resp objectForKey:@"ResultType"] intValue] == 0) {
                [self.navigationController popViewControllerAnimated:YES];
                [[UIApplication sharedApplication].keyWindow makeToast:msg duration:2.0 position:@"bottom"];
            }else{
                [self.view makeToast:msg duration:1.0 position:@"center"];
            }
            
        } failure:^(NSError * _Nonnull error) {
            [_activityIndicatorView stopAnimating];
        }];
    }else{
        
    }
}
@end

@implementation mystudentTaskModel

@end
