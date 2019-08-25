//
//  MyProposalDetailViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/11.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MyProposalDetailViewController.h"
#import "WorkBaseModel.h"
#import "MyTaskBookCustom1TableViewCell.h"
#import "MyTaskBookCustom2TableViewCell.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "People.h"
#import "PhoneInfo.h"
#import "NSString+Extension.h"
#import "AizenMD5.h"
#import "Toast+UIView.h"
@interface MyProposalDetailViewController ()<MyCustom2TableCellDelegate>
{
    BOOL _canEdit;
    BOOL _isteam;
    int _checkState;
    NSString *_firstSubID;
    NSString *_SecondSubID;
    NSString *_DocumentTitle;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourceArray; //数据源
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIButton *submitButton;
@end

@implementation MyProposalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开题详情";
    [self startLayout];
    [self getDataSourceFromHttp];
}
-(void)getDataSourceFromHttp
{
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [self.view addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    
    [HttpService ReportIsAllowAdd:CurrAdminID and:batchID success:^(id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"ResultType"]intValue]==0) {
            _canEdit = YES;
            _firstSubID = [responseObject objectForKey:@"AppendData"];
        }else{
            _canEdit = NO;
        }
        [HttpService GetProjectDocumentsConfigByActivityID:batchID success:^(id  _Nonnull responseObject) {
            NSDictionary *SecondDict = responseObject[@"AppendData"];
            
            [HttpService GetMyProjectDoumentListByStudentID:CurrAdminID andActivityID:batchID and:20 and:1 success:^(id  _Nonnull responseObject) {
                 [_activityIndicatorView stopAnimating];
                NSArray *rows = responseObject[@"AppendData"][@"rows"];
                NSDictionary *firstDic = rows.firstObject;
                [self combineWithFirstDict:firstDic andSectionDict:SecondDict];
                [self.tableView reloadData];
            } failure:^(NSError * _Nonnull error) {
                 [_activityIndicatorView stopAnimating];
            }];
        } failure:^(NSError * _Nonnull error) {
             [_activityIndicatorView stopAnimating];
        }];
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
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitButton.backgroundColor = [UIColor colorWithRed:75/255.0 green:145/255.0 blue:255/255.0 alpha:1.0];
    [_submitButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitButton];
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
    myProposalModel *model = self.dataSourceArray[indexPath.row];
    if (model.cellType == 1) {
        return 50.0f;
    }
    return 150.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    myProposalModel *model = self.dataSourceArray[indexPath.row];
    if (model.cellType == 1) {
        MyTaskBookCustom1TableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"MyTaskBookCustom1CellID"];
        cell1.nameLabel.text = model.title;
        cell1.teamButton.hidden = NO;
        [cell1.teamButton setTitle:_isteam?@"团队合作":@"独立完成" forState:UIControlStateNormal];
        if (indexPath.row == 1) {
            cell1.teamButton.hidden = YES;
        }
        return cell1;
    }
    MyTaskBookCustom2TableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"MyTaskBookCustom2CellID"];
    cell2.titleLabel.text = model.detail;
    cell2.detailTextView.text = model.title;
    if (_canEdit) {
        cell2.detailTextView.editable = YES;
    }else{
        if (_checkState == 2) {
            cell2.detailTextView.editable = YES;
        }
    }
    cell2.delegate = self;
    cell2.indexPath = indexPath;
    return cell2;
}
-(void)textViewEditEndAndTextString:(NSString *)text andIndex:(NSIndexPath *)index
{
    myProposalModel  *model = self.dataSourceArray[index.row];
    model.title = text;
}
#pragma mark 返回组头的高度 : 第一组的头部一定要通过代理设置

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}


-(void)combineWithFirstDict:(NSDictionary *)firstDic andSectionDict:(NSDictionary *)SecondDict
{
    _isteam = [[firstDic objectForKey:@"IsTeam"] boolValue];
    _checkState = [[firstDic objectForKey:@"CheckState"] intValue];
    _SecondSubID = [firstDic objectForKey:@"ID"];
    _DocumentTitle = [firstDic objectForKey:@"ProjectName"];;
    if (!_canEdit) {
        if (_checkState == 2) {
            [_submitButton setTitle:@"修改" forState:UIControlStateNormal];
        }else{
            self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            _submitButton.hidden = YES;
        }
    }
    if (_isteam == YES) {
        myProposalModel *model1 = [[myProposalModel alloc]init];
        model1.title = [firstDic objectForKey:@"ProjectName"];
        model1.cellType = 1;
        myProposalModel *model2 = [[myProposalModel alloc]init];
        model2.title = [firstDic objectForKey:@"ProjectSubName"];
        model2.cellType = 1;
        [self.dataSourceArray addObject:model1];
        [self.dataSourceArray addObject:model2];
    }else{
        myProposalModel *model1 = [[myProposalModel alloc]init];
        model1.title = [firstDic objectForKey:@"ProjectName"];
        model1.cellType = 1;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field1"] isKindOfClass:[NSNull class]]) {
        myProposalModel *model1 = [[myProposalModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field1"];
        model1.detail = [SecondDict objectForKey:@"Field1"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field2"] isKindOfClass:[NSNull class]]) {
        myProposalModel *model1 = [[myProposalModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field2"];
        model1.detail = [SecondDict objectForKey:@"Field2"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field3"] isKindOfClass:[NSNull class]]) {
        myProposalModel *model1 = [[myProposalModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field3"];
        model1.detail = [SecondDict objectForKey:@"Field3"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field4"] isKindOfClass:[NSNull class]]) {
        myProposalModel *model1 = [[myProposalModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field4"];
        model1.detail = [SecondDict objectForKey:@"Field4"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field5"] isKindOfClass:[NSNull class]]) {
        myProposalModel *model1 = [[myProposalModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field5"];
        model1.detail = [SecondDict objectForKey:@"Field5"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field6"] isKindOfClass:[NSNull class]]) {
        myProposalModel *model1 = [[myProposalModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field6"];
        model1.detail = [SecondDict objectForKey:@"Field6"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field7"] isKindOfClass:[NSNull class]]) {
        myProposalModel *model1 = [[myProposalModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field7"];
        model1.detail = [SecondDict objectForKey:@"Field7"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field8"] isKindOfClass:[NSNull class]]) {
        myProposalModel *model1 = [[myProposalModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field8"];
        model1.detail = [SecondDict objectForKey:@"Field8"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    
}
-(void)submit:(UIButton *)sender
{
    NSMutableArray *detailAA = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.dataSourceArray.count; i++) {
        myProposalModel *model = self.dataSourceArray[i];
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
    if ([sender.titleLabel.text isEqualToString:@"提交"]) {
        [HttpService ReportCreateByStudentID:CurrAdminID andActivityID:batchID andProjectApplyID:_firstSubID andDocumentTitle:_DocumentTitle andSubmit:YES andTimeStamp:currTimeStr andToken:md5Str Field1:f1 Field2:f2 Field3:f3 Field4:f4 Field5:f5 Field6:f6 Field7:f7 Field8:f8 success:^(NSDictionary *resp) {
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
    }else if ([sender.titleLabel.text isEqualToString:@"修改"])
    {
        [HttpService ReportModifyByStudentID:CurrAdminID fromID:_SecondSubID andActivityID:batchID andProjectApplyID:_firstSubID andDocumentTitle:_DocumentTitle andSubmit:YES andTimeStamp:currTimeStr andToken:md5Str Field1:f1 Field2:f2 Field3:f3 Field4:f4 Field5:f5 Field6:f6 Field7:f7 Field8:f8 success:^(NSDictionary *resp) {
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
    }else{
        
    }
}
@end

@implementation myProposalModel

@end
