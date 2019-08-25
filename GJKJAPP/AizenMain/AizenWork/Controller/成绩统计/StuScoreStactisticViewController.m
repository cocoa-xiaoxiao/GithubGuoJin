//
//  StuScoreStactisticViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/2/15.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "StuScoreStactisticViewController.h"
#import "GradesTableViewCell.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "PhoneInfo.h"
#import "People.h"
#import "WorkBaseModel.h"
#import "ScoreDetailViewController.h"
#import "CZPickerView.h"
#import "AizenHttp.h"
@interface StuScoreStactisticViewController ()<UITableViewDelegate,UITableViewDataSource,CZPickerViewDelegate,CZPickerViewDataSource>
{
    NSString *_selebumen;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) NSMutableArray *ScoreResultArray;
@property (nonatomic, strong) UIView *actionView;
@property(nonatomic,strong) UIView *contentView;
@property (nonatomic, strong) UIView *bumenView;
@property (nonatomic, strong) UILabel *bumenLb;
@property (nonatomic, strong) UILabel *bumenValue;
@property (nonatomic, strong) CZPickerView *bmPicker;
@property(nonatomic,strong) NSMutableArray *bumenArr;
@end

@implementation StuScoreStactisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"论文成绩";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self startlayout];
    [self.view addSubview:self.tableView];
}
-(void)bumenPicker
{
    _bmPicker = [[CZPickerView alloc] initWithHeaderTitle:@"选择部门"
                                        cancelButtonTitle:@"取消"
                                       confirmButtonTitle:@"提交"];
    _bmPicker.delegate = self;
    _bmPicker.dataSource = self;
    _bmPicker.needFooterView = YES;
    _bmPicker.headerBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    _bmPicker.confirmButtonBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    __weak typeof(self) weakself =self;
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiSystem/GetSubjectTree?AdminID=%@",kCacheHttpRoot,CurrAdminID];
    
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        NSArray *dictArray = [result objectForKey:@"AppendData"];
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in dictArray) {
            NSArray *childArray = [dict objectForKey:@"children"];
            for (NSDictionary *child in childArray) {
                [array addObject:@{@"BmName":[child objectForKey:@"text"],@"BmID":[child objectForKey:@"id"]}];
            }
        }
        weakself.bumenArr = [array mutableCopy];
        [weakself httpFieldWithDeptID:nil];
    } failue:^(NSError *error) {
        
        NSLog(@"请求失败");
    }];
}
-(void)startlayout
{
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, 0, self.view.frame.size.width,HEIGHT_SCREEN - _navHeight());
    _contentView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
    _bumenView = [[UIView alloc]init];
    _bumenView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height * 0.08);
    _bumenView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_bumenView];
    
    _bumenLb = [[UILabel alloc]init];
    _bumenLb.frame = CGRectMake(_bumenView.frame.size.width * 0.06, _bumenView.frame.size.height * 0.1, _bumenView.frame.size.width * 0.3, _bumenView.frame.size.height * 0.8);
    _bumenLb.font = [UIFont systemFontOfSize:15.0];
    _bumenLb.text = @"院系";
    [_bumenView addSubview:_bumenLb];
    
    _bumenValue = [[UILabel alloc]init];
    _bumenValue.frame = CGRectMake(_bumenLb.frame.size.width + _bumenLb.frame.origin.x, _bumenLb.frame.origin.y, _bumenView.frame.size.width * 0.58, _bumenView.frame.size.height * 0.8);
    _bumenValue.textAlignment = NSTextAlignmentRight;
    _bumenValue.text = @"请选择";
    _bumenValue.font = [UIFont systemFontOfSize:15.0];
    _bumenValue.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    _bumenValue.userInteractionEnabled = YES;
    UITapGestureRecognizer *bumenTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bumenAction:)];
    [_bumenValue addGestureRecognizer:bumenTap];
    [_bumenView addSubview:_bumenValue];
    
    
    UIView *bumenLine = [[UIView alloc]init];
    bumenLine.frame = CGRectMake(_bumenView.frame.size.width * 0.03, _bumenView.xo_height * 0.1, _bumenView.frame.size.width * 0.94, _bumenView.xo_height*0.8);
    bumenLine.layer.borderWidth = 2.0f;
    bumenLine.layer.cornerRadius = 5;
    bumenLine.userInteractionEnabled = NO;
    bumenLine.layer.borderColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor;
    [_bumenView addSubview:bumenLine];
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [self.view addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    [self bumenPicker];
}

-(void)bumenAction:(UITapGestureRecognizer *)sender
{
    [_bmPicker show];
}
-(void)httpFieldWithDeptID:(NSString *)ID
{
    if (!ID) {
        ID =  [self.bumenArr.firstObject objectForKey:@"BmID"];
        self.bumenValue.text = [self.bumenArr.firstObject objectForKey:@"BmName"];
    }
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    [HttpService GetResultsStatisticsListWithDepartmentID:ID andactivityID:batchID success:^(id  _Nonnull responseObject) {
        NSArray * array = [[responseObject objectForKey:@"AppendData"] objectForKey:@"rows"];
        [self detailLayout:array];
        [self headerEndFreshPull];
        [_activityIndicatorView stopAnimating];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [self headerEndFreshPull];
        [_activityIndicatorView stopAnimating];
    }];
}
-(void) detailLayout:(NSArray *)dataArr{
    if (self.ScoreResultArray) {
        [self.ScoreResultArray removeAllObjects];
    }
    for (int i = 0 ; i < dataArr.count; i++) {
        NSDictionary *dict = dataArr[i];
        resultScoreModel *model = [[resultScoreModel alloc]init];
        model.name = [dict objectForKey:@"DepartmentName"];
        model.yxl = [[dict objectForKey:@"yxl"] floatValue];
        model.lhl = [[dict objectForKey:@"lhl"] floatValue];
        model.zdl = [[dict objectForKey:@"zdl"] floatValue];
        model.hgl = [[dict objectForKey:@"hgl"] floatValue];
        model.bhgl = [[dict objectForKey:@"bhgl"] floatValue];
        model.sxrs = [[dict objectForKey:@"sxrs"] intValue];
        model.sccj = [[dict objectForKey:@"sccj"] intValue];
        model.wcc = model.sxrs - model.sccj;
        model.ccscl =  model.sccj / (model.sxrs*1.0);
        [self.ScoreResultArray addObject:model];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc]init];
        _headView.layer.cornerRadius = 10;
        _headView.layer.borderWidth = 1;
        _headView.layer.borderColor = RGB_HEX(0xC0C0C0, 1).CGColor;
        _headView.backgroundColor = [UIColor whiteColor];
        
        UILabel *title  = [[UILabel alloc]init];
        title.text = @"部门";
        title.font = [UIFont systemFontOfSize:15];
        [_headView addSubview:title];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(chooseClasses) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"jiantouarrow486"] forState:UIControlStateNormal];
        [_headView addSubview:button];
        
        UILabel *bumen = [[UILabel alloc]init];
        bumen.tag = 1000;
        bumen.font = [UIFont systemFontOfSize:15];
        [_headView addSubview:bumen];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            make.centerY.equalTo(_headView);
        }];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-10);
            make.centerY.equalTo(_headView);
        }];
        [bumen mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(button.mas_left).offset(-5);
            make.centerY.equalTo(_headView);
        }];
    }
    return _headView;
}
-(UIView *)actionView
{
    if (!_actionView) {
        _actionView = [[UIView alloc]init];
        _actionView.hidden = YES;
        _actionView.frame = CGRectMake(self.view.frame.size.width - 110, 50, 100, 0);
    }
    return _actionView;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _contentView.frame.size.height * 0.09, self.view.frame.size.width, self.view.frame.size.height - _contentView.frame.size.height * 0.09-_navHeight()) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        WS(ws);
        [self addFreshPull:self.tableView withBlock:^(id info) {
            [ws httpFieldWithDeptID:nil];
        }];
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

-(NSMutableArray *)ScoreResultArray
{
    if (!_ScoreResultArray) {
        _ScoreResultArray = [[NSMutableArray alloc]init];
    }
    return _ScoreResultArray;
}

-(void)chooseClasses
{
    _actionView.hidden = !_actionView.hidden;
}
-(void)tap:(UIButton *)sender
{
    _actionView.hidden = YES;
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    [_activityIndicatorView startAnimating];
    SubjectTreeModel *model = self.listArray[sender.tag - 100];
    for (UIView *vs in _headView.subviews) {
        if ([vs isKindOfClass:[UILabel class]]) {
            UILabel *lab = (UILabel *)vs;
            if (lab.tag == 1000) {
                lab.text = model.name;
            }
        }
    }
    [HttpService GetResultsStatisticsListWithDepartmentID:model.departmentID andactivityID:batchID success:^(id  _Nonnull responseObject) {
        NSArray * array = [[responseObject objectForKey:@"AppendData"] objectForKey:@"rows"];
        [self detailLayout:array];
        [_activityIndicatorView stopAnimating];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [_activityIndicatorView stopAnimating];
    }];
}
#pragma mark tableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.ScoreResultArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    resultScoreModel *model = self.ScoreResultArray[indexPath.section];
    GradesTableViewCell *cell = [[GradesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.percentage1 = model.yxl*0.01;
    cell.percentage2 = model.lhl*0.01;
    cell.percentage3 = model.zdl*0.01;
    cell.percentage4 = model.hgl*0.01;
    cell.titleN = model.name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    resultScoreModel *model = self.ScoreResultArray[indexPath.section];
    ScoreDetailViewController *vc = [[ScoreDetailViewController alloc]init];
    vc.scoreDetail = model;
    [self.navigationController pushViewController:vc animated:NO];
}
#pragma mark - CZPickerViewDataSource
/* number of items for picker */
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    return [_bumenArr count];
}

/* picker item title for each row */
- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row{
    return [[_bumenArr objectAtIndex:row]objectForKey:@"BmName"];
}

#pragma mark - CZPickerViewDelegate
/** delegate method for picking one item */
- (void)czpickerView:(CZPickerView *)pickerView
didConfirmWithItemAtRow:(NSInteger)row{
    NSString *name = [[_bumenArr objectAtIndex:row] objectForKey:@"BmName"];
    _bumenValue.text = name;
    _bumenValue.textColor = [UIColor blueColor];
    _selebumen = [[_bumenArr objectAtIndex:row]objectForKey:@"BmID"];
    [self httpFieldWithDeptID:_selebumen];
}

/** delegate method for picking multiple items,
 implement this method if allowMultipleSelection is YES,
 rows is an array of NSNumbers
 */
- (void)czpickerView:(CZPickerView *)pickerView
didConfirmWithItemsAtRows:(NSArray *)rows{
}
/** delegate method for canceling */
- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView{
    
}
@end
