//
//  SubsidyListViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/3/27.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "SubsidyListViewController.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "PGDatePickManager.h"
#import "CZPickerView.h"
#import "People.h"
#import "AizenHttp.h"
#import "PhoneInfo.h"
#import "SubsidyDetailViewController.h"
@interface SubsidyListViewController ()<PGDatePickerDelegate,CZPickerViewDelegate,CZPickerViewDataSource>
{
    NSString *_selebumen;
    NSString *_seletime;
}
@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIScrollView *dataScrollView;
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong) UIView *bumenView;
@property (nonatomic, strong) UILabel *bumenLb;
@property (nonatomic, strong) UILabel *bumenValue;
@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UILabel *timeValue;


@property(nonatomic,strong) NSMutableArray *bumenArr;
@property (nonatomic, strong) CZPickerView *bmPicker;
@property (nonatomic, strong) UIView *tableContentView;
@end

@implementation SubsidyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"补贴清单";
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    _bumenArr = [[NSMutableArray alloc]init];
    [self startLayout];
}

-(void)startLayout
{
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, _navHeight(), self.view.frame.size.width,HEIGHT_SCREEN - _navHeight());
    _contentView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
    _bumenView = [[UIView alloc]init];
    _bumenView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height * 0.08);
    [_contentView addSubview:_bumenView];
    
    _bumenLb = [[UILabel alloc]init];
    _bumenLb.frame = CGRectMake(_bumenView.frame.size.width * 0.06, _bumenView.frame.size.height * 0.1, _bumenView.frame.size.width * 0.3, _bumenView.frame.size.height * 0.8);
    _bumenLb.font = [UIFont systemFontOfSize:15.0];
    _bumenLb.text = @"部门";
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
    
    _dataScrollView = [[UIScrollView alloc]init];
    _dataScrollView.frame = CGRectMake(0, _timeView.xo_bottomY + 10, _contentView.frame.size.width, _contentView.frame.size.height - _timeView.xo_bottomY - 10);
    _dataScrollView.delegate = self;
    _dataScrollView.contentSize = CGSizeMake(_contentView.frame.size.width, _contentView.frame.size.height * 2);
    [_contentView addSubview:_dataScrollView];
    
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [_dataScrollView addSubview:_activityIndicatorView];
    [self bumenPicker];
    [self detailLayout];
}

-(void) detailLayout{
    
    _tableContentView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, _bumenView.frame.size.width,0)];
    [_dataScrollView addSubview:_tableContentView];
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
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiSystem/GetCollegaTree?AdminID=%@",kCacheHttpRoot,CurrAdminID];
    
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        NSArray *dictArray = [result objectForKey:@"AppendData"];
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in dictArray) {
            [array addObject:@{@"BmName":[dict objectForKey:@"text"],@"BmID":[dict objectForKey:@"id"]}];
            
//            if ([[dict objectForKey:@"children"] isKindOfClass:[NSArray class]]) {
//                for (NSDictionary *childDict in [dict objectForKey:@"children"]) {
//                    
//                }
//            }
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
        time = [PhoneInfo getCurrentTimes:@"YYYY-MM"];
        self.timeValue.text = time;
    }
        [_activityIndicatorView startAnimating];
        NSString *activity = [AizenStorage readUserDataWithKey:@"batchID"];
        NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipInspectionTeamInfo/GetTeacherRecordReportList?DeptID=%@&ActivityID=%@&Month=%@",kCacheHttpRoot,ID,activity,time];
    
        [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
            [_activityIndicatorView stopAnimating];
            NSDictionary *jsonDic = result;
            if([[jsonDic objectForKey:@"ResultType"] intValue] == 0){
                NSArray *dataArr = [jsonDic objectForKey:@"AppendData"];
                [self handlePianQuList:dataArr];
            }
        } failue:^(NSError *error) {
            [_activityIndicatorView stopAnimating];
            NSLog(@"请求失败");
        }];
}
-(void)handlePianQuList:(NSArray *)dataArr{
    
    for (UIView * vs in _tableContentView.subviews) {
        [vs removeFromSuperview];
    }
    CGFloat height = _contentView.frame.size.height * 0.16;
    CGFloat oneView = _bumenView.frame.size.height;
    CGFloat twoView = height - oneView;
    int num = 0;
    for(int i = 0;i<[dataArr count];i++){
        NSDictionary *dict = dataArr[i];
        UIView *FieldView = [[UIView alloc]init];
        FieldView.frame = CGRectMake(0, height * num, _tableContentView.frame.size.width,height);
        [_tableContentView addSubview:FieldView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(select:)];
        tap.accessibilityElements = @[dict];
        [FieldView addGestureRecognizer:tap];
        
        UILabel *FieldLab = [[UILabel alloc]init];
        FieldLab.frame = CGRectMake(FieldView.frame.size.width * 0.03, oneView * 0.1, FieldView.frame.size.width * 0.47, oneView * 0.8);
        FieldLab.text = [NSString stringWithFormat:@"%@：",[dict objectForKey:@"TeacherName"] ];
        FieldLab.font = [UIFont systemFontOfSize:15.0];
        [FieldView addSubview:FieldLab];
        
        UIView *Line0 = [[UIView alloc]init];
        Line0.frame = CGRectMake(FieldView.frame.size.width * 0.03, oneView, FieldView.frame.size.width * 0.93, 1);
        Line0.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [FieldView addSubview:Line0];
        //巡查次数
        UILabel *cishu = [[UILabel alloc]init];
        cishu.frame = CGRectMake(FieldView.frame.size.width * 0.04, oneView+twoView*0.1, FieldView.xo_width*0.22, twoView*0.8);
        cishu.textAlignment = NSTextAlignmentCenter;
        NSString *a = [NSString checkNull:[dict objectForKey:@"RecordCount"]];
        cishu.attributedText = [NSAttributedString xo_changeFontWithFont:[UIFont systemFontOfSize:13] totalStr:[NSString stringWithFormat:@"巡查次数：%@",a] andChangeStingArray:@[a]andColor:[UIColor colorWithRed:247/255.0 green:181/255.0 blue:94/255.0 alpha:1]];
        cishu.font = [UIFont systemFontOfSize:12.0];
        [FieldView addSubview:cishu];
        //企业
        UILabel *qiye = [[UILabel alloc]init];
        qiye.frame = CGRectMake(FieldView.frame.size.width * 0.05 + cishu.xo_width, cishu.xo_y, cishu.xo_width, cishu.xo_height);
        qiye.textAlignment = NSTextAlignmentCenter;
        NSString *b = [NSString checkNull:[dict objectForKey:@"EnterpriseCount"]];
        qiye.attributedText = [NSAttributedString xo_changeFontWithFont:[UIFont systemFontOfSize:13] totalStr:[NSString stringWithFormat:@"企业：%@",b] andChangeStingArray:@[b]andColor:[UIColor colorWithRed:247/255.0 green:181/255.0 blue:94/255.0 alpha:1]];
        qiye.font = [UIFont systemFontOfSize:12.0];
        [FieldView addSubview:qiye];
        //报告
        UILabel *baogao = [[UILabel alloc]init];
        baogao.frame = CGRectMake(FieldView.frame.size.width * 0.06+2*cishu.xo_width, cishu.xo_y, cishu.xo_width, cishu.xo_height);
        baogao.textAlignment = NSTextAlignmentCenter;
        NSString *c = [NSString checkNull:[dict objectForKey:@"StudentCount"]];
        baogao.attributedText = [NSAttributedString xo_changeFontWithFont:[UIFont systemFontOfSize:13] totalStr:[NSString stringWithFormat:@"报告：%@",c] andChangeStingArray:@[c]andColor:[UIColor colorWithRed:247/255.0 green:181/255.0 blue:94/255.0 alpha:1]];
        baogao.font = [UIFont systemFontOfSize:12.0];
        [FieldView addSubview:baogao];
        
        //补贴
        UILabel *butie = [[UILabel alloc]init];
        butie.frame = CGRectMake(FieldView.frame.size.width * 0.07+3*cishu.xo_width, cishu.xo_y, cishu.xo_width, cishu.xo_height);
        butie.textAlignment = NSTextAlignmentCenter;
        NSString *d = [NSString checkNull:[dict objectForKey:@"TotalPrice"]];
        butie.attributedText = [NSAttributedString xo_changeFontWithFont:[UIFont systemFontOfSize:13] totalStr:[NSString stringWithFormat:@"补贴额：%@",d] andChangeStingArray:@[d]andColor:[UIColor colorWithRed:247/255.0 green:181/255.0 blue:94/255.0 alpha:1]];
        butie.font = [UIFont systemFontOfSize:12.0];
        [FieldView addSubview:butie];
        
        UIView *Line = [[UIView alloc]init];
        Line.frame = CGRectMake(FieldView.frame.size.width * 0.01, FieldView.frame.size.height*0.03, FieldView.frame.size.width * 0.98, FieldView.xo_height*0.94);
        Line.userInteractionEnabled = NO;
        Line.layer.borderWidth = 2.0;
        Line.layer.borderColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor;
        [FieldView addSubview:Line];
        /*写布局------------------------------------end*/
        
        num++;
    }
    _tableContentView.xo_height = height * num;
    CGFloat scrollHeight = _bumenView.frame.size.height + _timeValue.frame.size.height  + _tableContentView.xo_height;
    _dataScrollView.contentSize = CGSizeMake(_contentView.frame.size.width, scrollHeight + 100);
}

-(void) dateAction:(UITapGestureRecognizer *)sender{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGDatePickerType3;//PGPickerViewType3;
    datePicker.datePickerMode = PGDatePickerModeYearAndMonth;
    datePicker.accessibilityHint = @"date";
    [self presentViewController:datePickManager animated:false completion:nil];
}


-(void)bumenAction:(UITapGestureRecognizer *)sender
{
    [_bmPicker show];
}

-(void)select:(UITapGestureRecognizer *)tap
{
    NSDictionary *dict  =  tap.accessibilityElements.firstObject;
    NSString *time = _seletime?_seletime:[PhoneInfo getCurrentTimes:@"YYYY-MM"];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Worker" bundle:[NSBundle mainBundle]];
    SubsidyDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SubsidyDetailSbID"];
    vc.sourceDict = dict;
    vc.timeDate = time;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    
    if([datePicker.accessibilityHint isEqualToString:@"date"]){
        NSString *dateStr = [NSString stringWithFormat:@"%d-%d",dateComponents.year,dateComponents.month];
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
