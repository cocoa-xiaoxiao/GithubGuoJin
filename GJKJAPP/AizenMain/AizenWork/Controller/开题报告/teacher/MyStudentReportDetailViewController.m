//
//  MyStudentReportDetailViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/1/4.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "MyStudentReportDetailViewController.h"
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
#import "IBCreatHelper.h"
#import "GJShenheViewController.h"
#import "LDPublicWebViewController.h"
@interface MyStudentReportDetailViewController ()
{
    BOOL _isteam;
    int _checkState;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourceArray; //数据源
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIButton *submitButton;
@end

@implementation MyStudentReportDetailViewController

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
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
        [HttpService GetProjectDocumentsConfigByActivityID:batchID success:^(id  _Nonnull responseObject) {
            NSDictionary *SecondDict = responseObject[@"AppendData"];
            [HttpService GetProjectDocumentsByID:self.reportID success:^(id  _Nonnull responseObject) {
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
}
-(void)startLayout
{
    _tableView = [[BaseTablewView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerNib:[UINib nibWithNibName:@"MyTaskBookCustom1TableViewCell" bundle:nil] forCellReuseIdentifier:@"MyTaskBookCustom1CellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"MyTaskBookCustom2TableViewCell" bundle:nil] forCellReuseIdentifier:@"MyTaskBookCustom2CellID"];
    [self.view addSubview:_tableView];
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    [_submitButton setTitle:@"查看Word文件" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitButton.backgroundColor = [UIColor colorWithRed:75/255.0 green:145/255.0 blue:255/255.0 alpha:1.0];
    [_submitButton addTarget:self action:@selector(shenhe:) forControlEvents:UIControlEventTouchUpInside];
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
    myStudentProposalModel *model = self.dataSourceArray[indexPath.row];
    if (model.cellType == 1) {
        return 50.0f;
    }
    return 150.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    myStudentProposalModel *model = self.dataSourceArray[indexPath.row];
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
    return cell2;
}
#pragma mark 返回组头的高度 : 第一组的头部一定要通过代理设置

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}


-(void)combineWithFirstDict:(NSDictionary *)firstDic andSectionDict:(NSDictionary *)SecondDict
{
    _isteam = [[firstDic objectForKey:@"IsTeam"] boolValue];
    _checkState = [[firstDic objectForKey:@"CheckState"] intValue];
    if (_checkState == 0) {
        [_submitButton setTitle:@"审核" forState:UIControlStateNormal];
    }else if (_checkState == 2)
    {
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _submitButton.hidden = YES;
    }else{
        _submitButton.accessibilityLabel = [firstDic objectForKey:@"TempUrl"];
    }
    if (_isteam == YES) {
        myStudentProposalModel *model1 = [[myStudentProposalModel alloc]init];
        model1.title = [firstDic objectForKey:@"ProjectName"];
        model1.cellType = 1;
        myStudentProposalModel *model2 = [[myStudentProposalModel alloc]init];
        model2.title = [firstDic objectForKey:@"ProjectSubName"];
        model2.cellType = 1;
        [self.dataSourceArray addObject:model1];
        [self.dataSourceArray addObject:model2];
    }else{
        myStudentProposalModel *model1 = [[myStudentProposalModel alloc]init];
        model1.title = [firstDic objectForKey:@"ProjectName"];
        model1.cellType = 1;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field1"] isKindOfClass:[NSNull class]]) {
        myStudentProposalModel *model1 = [[myStudentProposalModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field1"];
        model1.detail = [SecondDict objectForKey:@"Field1"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field2"] isKindOfClass:[NSNull class]]) {
        myStudentProposalModel *model1 = [[myStudentProposalModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field2"];
        model1.detail = [SecondDict objectForKey:@"Field2"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field3"] isKindOfClass:[NSNull class]]) {
        myStudentProposalModel *model1 = [[myStudentProposalModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field3"];
        model1.detail = [SecondDict objectForKey:@"Field3"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field4"] isKindOfClass:[NSNull class]]) {
        myStudentProposalModel *model1 = [[myStudentProposalModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field4"];
        model1.detail = [SecondDict objectForKey:@"Field4"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field5"] isKindOfClass:[NSNull class]]) {
        myStudentProposalModel *model1 = [[myStudentProposalModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field5"];
        model1.detail = [SecondDict objectForKey:@"Field5"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field6"] isKindOfClass:[NSNull class]]) {
        myStudentProposalModel *model1 = [[myStudentProposalModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field6"];
        model1.detail = [SecondDict objectForKey:@"Field6"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field7"] isKindOfClass:[NSNull class]]) {
        myStudentProposalModel *model1 = [[myStudentProposalModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field7"];
        model1.detail = [SecondDict objectForKey:@"Field7"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    if (![[SecondDict objectForKey:@"Field8"] isKindOfClass:[NSNull class]]) {
        myStudentProposalModel *model1 = [[myStudentProposalModel alloc]init];
        model1.title = [firstDic objectForKey:@"Field8"];
        model1.detail = [SecondDict objectForKey:@"Field8"];
        model1.cellType = 2;
        [self.dataSourceArray addObject:model1];
    }
    
}
-(void)shenhe:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"审核"]) {
        GJShenheViewController *vc = getControllerFromStoryBoard(@"Worker", @"myshenheSbID");
        vc.pid = self.reportID;
        vc.shenheType = shenheType_kaitibaogao;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSString *url = [sender.accessibilityLabel fullImg];
        LDPublicWebViewController *web = [[LDPublicWebViewController alloc] init];
        web.webUrl = url;
        web.title = @"查看附件";
        [self.navigationController pushViewController:web animated:YES];
    }
}
@end

@implementation myStudentProposalModel

@end
