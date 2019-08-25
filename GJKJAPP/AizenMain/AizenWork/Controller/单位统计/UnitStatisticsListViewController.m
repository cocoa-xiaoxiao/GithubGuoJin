//
//  UnitStatisticsListViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/2/20.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "UnitStatisticsListViewController.h"
#import "AttendanceCustomTableHeadView.h"
#import "UnitTableViewCell.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "People.h"
#import "WorkBaseModel.h"
#import "UnitStatisticsDetailViewController.h"
#import "CZPickerView.h"
#import "AizenHttp.h"
@interface UnitStatisticsListViewController ()<UITableViewDelegate,UITableViewDataSource,CZPickerViewDelegate,CZPickerViewDataSource>
{
    NSString *_selebumen;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AttendanceCustomTableHeadView *tableSectionHeadView;
@property (nonatomic, strong) DGActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSMutableArray *kaoqinListArray;
@property(nonatomic,strong) UIView *contentView;
@property (nonatomic, strong) UIView *bumenView;
@property (nonatomic, strong) UILabel *bumenLb;
@property (nonatomic, strong) UILabel *bumenValue;
@property (nonatomic, strong) CZPickerView *bmPicker;
@property(nonatomic,strong) NSMutableArray *bumenArr;
@end

@implementation UnitStatisticsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"单位统计";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    _bumenArr = [[NSMutableArray alloc]init];
    [self startlayout];
    [self.contentView addSubview:self.tableView];
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
    self.kaoqinListArray = [[NSMutableArray alloc]init];
    [HttpService GetUnitStatisticsListDeptID:ID ActivityID:batchID AdminID:CurrAdminID success:^(id  _Nonnull responseObject) {
        NSArray *array = [responseObject objectForKey:@"AppendData"];
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dict = array[i];
            UnitModel *model = [[UnitModel alloc]init];
            model.renshu = [dict[@"ysxx"] intValue];
            model.name = dict[@"DepartmentName"];
            model.unit_zg = [dict[@"zgs"] intValue];
            model.unit_dg = [dict[@"dgs"] intValue];
            model.unit_jd = [dict[@"sxjds"]intValue];
            model.unit_sxl = [dict[@"zgsxl"] floatValue];
            model.unit_jdsxl = [dict[@"sxjdl"] floatValue];
            model.unit_dgl = model.unit_dg / (model.renshu * 1.0);
            [self.kaoqinListArray addObject:model];
        }
        [self.tableView reloadData];
        [_activityIndicatorView stopAnimating];
    } failure:^(NSError * _Nonnull error) {
        [_activityIndicatorView stopAnimating];
    }];
}
//-(void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    _tableView.frame = CGRectMake(0, _contentView.frame.size.height * 0.09, self.view.frame.size.width, self.view.frame.size.height);
//}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _contentView.frame.size.height * 0.09, self.view.frame.size.width, self.view.frame.size.height-_contentView.frame.size.height * 0.09-_navHeight()) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"UnitTableViewCell" bundle:nil] forCellReuseIdentifier:@"tableCellID"];
    }
    return _tableView;
}
-(NSMutableArray *)kaoqinListArray
{
    if (!_kaoqinListArray) {
        _kaoqinListArray = [[NSMutableArray alloc]init];
    }
    return _kaoqinListArray;
}
#pragma mark delegate;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.kaoqinListArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UITableViewHeaderFooterView *head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"head"];
//    if (!head) {
//        head = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"head"];
//        AttendanceCustomTableHeadView *customView = [[AttendanceCustomTableHeadView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
//        customView.hiddenView2 = YES;
//        [head addSubview:customView];
//    }
//    return head;
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnitModel *model = self.kaoqinListArray[indexPath.row];
    UnitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCellID"];
    cell.name1.text = model.name;
    cell.name2.text = [NSString stringWithFormat:@"%d人",model.renshu];
    cell.name3.attributedText = [NSAttributedString xo_changeFontWithFont:[UIFont systemFontOfSize:13] totalStr:[NSString stringWithFormat:@"在岗数：%d人",model.unit_zg] andChangeStingArray:@[@"在岗数："]andColor:[UIColor darkGrayColor]];
    cell.name4.attributedText = [NSAttributedString xo_changeFontWithFont:[UIFont systemFontOfSize:13] totalStr:[NSString stringWithFormat:@"待岗数：%d人",model.unit_dg] andChangeStingArray:@[@"待岗数："]andColor:[UIColor darkGrayColor]];
    cell.degress = model.unit_sxl*0.01;
    cell.shixilvLabel.text = [NSString stringWithFormat:@"%.2f%%\n实习率",model.unit_sxl];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnitModel *model = self.kaoqinListArray[indexPath.row];
    UnitStatisticsDetailViewController *vc = [[UnitStatisticsDetailViewController alloc]init];
    vc.detailModel = model;
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
