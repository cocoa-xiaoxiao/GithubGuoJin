//
//  AttendanceStatisticsListViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/2/20.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "AttendanceStatisticsListViewController.h"
#import "AttendanceCustomTableHeadView.h"
#import "AttendanceTableViewCell.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "People.h"
#import "WorkBaseModel.h"
#import "CZPickerView.h"
#import "AizenHttp.h"
#import "PhoneInfo.h"
#import "PGDatePickManager.h"
@interface AttendanceStatisticsListViewController ()<UITableViewDelegate,UITableViewDataSource,CZPickerViewDelegate,CZPickerViewDataSource,PGDatePickerDelegate>
{
    NSString *_selebumen;
    NSString *_seletime;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AttendanceCustomTableHeadView *tableSectionHeadView;
@property (nonatomic, strong) DGActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSMutableArray *kaoqinListArray;
@property(nonatomic,strong) UIView *contentView;
@property (nonatomic, strong) UIView *bumenView;
@property (nonatomic, strong) UILabel *bumenLb;
@property (nonatomic, strong) UILabel *bumenValue;
@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UILabel *timeValue;
@property (nonatomic, strong) UIView *timeView2;
@property (nonatomic, strong) UILabel *timeLb2;
@property (nonatomic, strong) UILabel *timeValue2;
@property (nonatomic, strong) CZPickerView *bmPicker;
@property(nonatomic,strong) NSMutableArray *bumenArr;
@end

@implementation AttendanceStatisticsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"考勤统计";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
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
        [weakself httpFieldWithDeptID:nil andTimeDate:nil];
    } failue:^(NSError *error) {
        
        NSLog(@"请求失败");
    }];
}
-(void)httpFieldWithDeptID:(NSString *)ID andTimeDate:(NSString *)time
{
    if (!ID) {
        ID =  [self.bumenArr.firstObject objectForKey:@"BmID"];
        self.bumenValue.text = [self.bumenArr.firstObject objectForKey:@"BmName"];
    }
    if (!time) {
        time = [PhoneInfo getCurrentTimes:@"YYYY-MM-dd"];
        self.timeValue.text = time;
    }
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    self.kaoqinListArray = [[NSMutableArray alloc]init];
    [HttpService GetAttendanceStatisticsListWithDeptID:ID ActivityID:batchID AdminID:CurrAdminID StartDate:time EndDate:time success:^(id  _Nonnull responseObject) {
        NSArray *array = [responseObject objectForKey:@"AppendData"];
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dict = array[i];
            kaoqinTableModel *model = [[kaoqinTableModel alloc]init];
            model.qiandao =  [NSString checkNull:dict[@"qdwcs"]];
            model.qiantui = [NSString checkNull:dict[@"zts"]];
            model.sureqiandao = [NSString checkNull:dict[@"qdcs"]];
            model.sureqiantui = [NSString checkNull:dict[@"qtcs"]];
            model.name = [NSString checkNull:dict[@"DepartmentName"]];
            [self.kaoqinListArray addObject:model];
        }
        [self.tableView reloadData];
        [_activityIndicatorView stopAnimating];
    } failure:^(NSError * _Nonnull error) {
        [_activityIndicatorView stopAnimating];
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
    
    _timeView = [[UIView alloc]init];
    _timeView.backgroundColor = [UIColor whiteColor];
    _timeView.frame = CGRectMake(0, _bumenView.frame.size.height + _bumenView.frame.origin.y, _bumenView.frame.size.width, _bumenView.frame.size.height);
    [_contentView addSubview:_timeView];
    
    
    _timeLb = [[UILabel alloc]init];
    _timeLb.frame = CGRectMake(_timeView.frame.size.width * 0.06, _timeView.frame.size.height * 0.1, _timeView.frame.size.width * 0.3, _timeView.frame.size.height * 0.8);
    _timeLb.text = @"时间";
    _timeLb.font = [UIFont systemFontOfSize:15.0];
    [_timeView addSubview:_timeLb];
    
    _timeValue = [[UILabel alloc]init];
    _timeValue.frame = CGRectMake(_timeLb.xo_width + _timeLb.xo_x, _timeLb.frame.origin.y, _timeView.frame.size.width * 0.58, _timeView.frame.size.height * 0.8);
    _timeValue.textAlignment = NSTextAlignmentRight;
    _timeValue.text = @"请选择";
    _timeValue.font = [UIFont systemFontOfSize:15.0];
    _timeValue.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    _timeValue.userInteractionEnabled = YES;
    UITapGestureRecognizer *timeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateAction:)];
    [_timeValue addGestureRecognizer:timeTap];
    [_timeView addSubview:_timeValue];
    
    UIView *timeLine = [[UIView alloc]init];
    timeLine.frame = CGRectMake(_timeView.frame.size.width * 0.03, _timeView.xo_height * 0.1, _timeView.frame.size.width * 0.94, _timeView.xo_height*0.8);
    timeLine.layer.borderWidth = 2.0f;
    timeLine.layer.cornerRadius = 5;
    timeLine.userInteractionEnabled = NO;
    timeLine.layer.borderColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor;
    [_timeView addSubview:timeLine];
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [self.view addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    [self bumenPicker];
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.timeView.xo_bottomY + 10, self.view.frame.size.width, self.view.frame.size.height - self.timeView.xo_bottomY - 10-_navHeight()) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:@"AttendanceTableViewCell" bundle:nil] forCellReuseIdentifier:@"tableCellID"];
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
    return 90;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UITableViewHeaderFooterView *head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"head"];
//    if (!head) {
//        head = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"head"];
//        AttendanceCustomTableHeadView *customView = [[AttendanceCustomTableHeadView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 135)];
//        [head addSubview:customView];
//    }
//    return head;
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    kaoqinTableModel *model = self.kaoqinListArray[indexPath.row];
    AttendanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCellID"];
    cell.name.text = model.name;
    cell.name4.attributedText = [NSAttributedString xo_changeFontWithFont:[UIFont systemFontOfSize:13] totalStr:[NSString stringWithFormat:@"确认签退数：%@人",model.sureqiantui] andChangeStingArray:@[@"确认签退数："]andColor:[UIColor darkGrayColor]];
    cell.name3.attributedText = [NSAttributedString xo_changeFontWithFont:[UIFont systemFontOfSize:13] totalStr:[NSString stringWithFormat:@"确认签到数：%@人",model.sureqiandao] andChangeStingArray:@[@"确认签到数："]andColor:[UIColor darkGrayColor]];
    cell.name2.attributedText = [NSAttributedString xo_changeFontWithFont:[UIFont systemFontOfSize:13] totalStr:[NSString stringWithFormat:@"签退数：%@人",model.qiantui] andChangeStingArray:@[@"签退数："]andColor:[UIColor darkGrayColor]];
    cell.name1.attributedText = [NSAttributedString xo_changeFontWithFont:[UIFont systemFontOfSize:13] totalStr:[NSString stringWithFormat:@"签到数：%@人",model.qiandao] andChangeStingArray:@[@"签到数："]andColor:[UIColor darkGrayColor]];
    return cell;
}
-(void) dateAction:(UITapGestureRecognizer *)sender{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGDatePickerType3;//PGPickerViewType3;
    datePicker.datePickerMode = PGDatePickerModeDate;
    datePicker.accessibilityHint = @"date";
    [self presentViewController:datePickManager animated:false completion:nil];
}


-(void)bumenAction:(UITapGestureRecognizer *)sender
{
    [_bmPicker show];
}
#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    
    if([datePicker.accessibilityHint isEqualToString:@"date"]){
        NSString *dateStr = [NSString stringWithFormat:@"%d-%d-%d",dateComponents.year,dateComponents.month,dateComponents.day];
        _timeValue.text = dateStr;
        _timeValue.textColor = [UIColor blackColor];
        _seletime = dateStr;
        [self httpFieldWithDeptID:_selebumen andTimeDate:_seletime];
    }
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
    [self httpFieldWithDeptID:_selebumen andTimeDate:_seletime];
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
