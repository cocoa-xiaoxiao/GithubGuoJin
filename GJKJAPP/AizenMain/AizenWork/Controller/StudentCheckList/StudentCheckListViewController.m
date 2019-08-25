//
//  StudentCheckListViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/3/28.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "StudentCheckListViewController.h"
#import "RDVTabBarController.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "DGActivityIndicatorView.h"
#import "CZPickerView.h"
#import "PhoneInfo.h"
#import "People.h"
#import "MainViewController.h"
#import "PGDatePickManager.h"
#import "RAlertView.h"
#import "StudentCheckListDetailViewController.h"


@interface StudentCheckListViewController ()<PGDatePickerDelegate,CZPickerViewDelegate,CZPickerViewDataSource,UITextViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *studentView;
@property(nonatomic,strong) UILabel *studentLab;
@property(nonatomic,strong) UILabel *studentValue;

@property(nonatomic,strong) UIView *startDateView;
@property(nonatomic,strong) UILabel *startDateLab;
@property(nonatomic,strong) UILabel *startDateValue;

@property(nonatomic,strong) UIView *endDateView;
@property(nonatomic,strong) UILabel *endDateLab;
@property(nonatomic,strong) UILabel *endDateValue;

@property(nonatomic,strong) UILabel *tipLab;

@property(nonatomic,strong) UIButton *searchBtn;

@property(nonatomic,strong) UIView *detailView;

@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

@property(nonatomic,strong) NSMutableArray *peopleArr;
@property(nonatomic,strong) CZPickerView *picker;
@property(nonatomic,strong) NSString *studentID;

@property(nonatomic,strong) UIView *detailTipView;
@property(nonatomic,strong) UIView *decorateView;
@property(nonatomic,strong) UILabel *detailTipLab;


@end

@implementation StudentCheckListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self rdv_tabBarController]setTabBarHidden:YES animated:YES];

    _peopleArr = [[NSMutableArray alloc]init];
    
    self.view.userInteractionEnabled = YES;
    self.navigationItem.title = @"学生签到列表";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction:)];
    [backBtnItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = backBtnItem ;
    
    [self startLayout];
}

-(void)backAction:(UIBarButtonItem *)sender{
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) startLayout{
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    _scrollView.userInteractionEnabled = YES;
    [self.view addSubview:_scrollView];
    
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [_scrollView addSubview:_activityIndicatorView];
    
    _topView = [[UIView alloc]init];
    _topView.frame = CGRectMake(0, 10, _scrollView.frame.size.width, _scrollView.frame.size.height * 0.35);
    _topView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_topView];
    
    _studentView = [[UIView alloc]init];
    _studentView.frame = CGRectMake(0, 0, _topView.frame.size.width, _topView.frame.size.height * 0.2);
    _studentView.userInteractionEnabled = YES;
    [_topView addSubview:_studentView];
    
    UIView *line1 = [[UIView alloc]init];
    line1.frame = CGRectMake(_studentView.frame.size.width * 0.05, _studentView.frame.size.height - 1, _studentView.frame.size.width * 0.95, 1);
    line1.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_studentView addSubview:line1];
    
    _studentLab = [[UILabel alloc]init];
    _studentLab.frame = CGRectMake(_studentView.frame.size.width * 0.05, 0, _studentView.frame.size.width * 0.25, _studentView.frame.size.height);
    _studentLab.textColor = [UIColor blackColor];
    _studentLab.text = @"学生姓名";
    _studentLab.font = [UIFont systemFontOfSize:18.0];
    [_studentView addSubview:_studentLab];
    
    
    _studentValue = [[UILabel alloc]init];
    _studentValue.frame = CGRectMake(_studentLab.frame.size.width + _studentLab.frame.origin.x, 0, _studentView.frame.size.width * 0.6, _studentView.frame.size.height);
    _studentValue.text = @"请选择〉";
    _studentValue.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    _studentValue.userInteractionEnabled = YES;
    _studentValue.textAlignment = UITextAlignmentRight;
    _studentValue.font = [UIFont systemFontOfSize:18.0];
    [_studentView addSubview:_studentValue];
    
    
    
    
    _startDateView = [[UIView alloc]init];
    _startDateView.frame = CGRectMake(0, _studentView.frame.size.height + _studentView.frame.origin.y, _topView.frame.size.width, _topView.frame.size.height * 0.2);
    [_topView addSubview:_startDateView];
    
    UIView *line2 = [[UIView alloc]init];
    line2.frame = CGRectMake(_startDateView.frame.size.width * 0.05, _startDateView.frame.size.height - 1, _startDateView.frame.size.width * 0.95, 1);
    line2.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_startDateView addSubview:line2];
    
    
    _startDateLab = [[UILabel alloc]init];
    _startDateLab.frame = CGRectMake(_startDateView.frame.size.width * 0.05, 0, _startDateView.frame.size.width * 0.25, _startDateView.frame.size.height);
    _startDateLab.textColor = [UIColor blackColor];
    _startDateLab.text = @"开始时间";
    _startDateLab.font = [UIFont systemFontOfSize:18.0];
    [_startDateView addSubview:_startDateLab];
    
    
    _startDateValue = [[UILabel alloc]init];
    _startDateValue.frame = CGRectMake(_startDateLab.frame.size.width + _startDateLab.frame.origin.x, 0, _startDateView.frame.size.width * 0.6, _startDateView.frame.size.height);
    _startDateValue.text = @"请选择〉";
    _startDateValue.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    _startDateValue.userInteractionEnabled = YES;
    _startDateValue.textAlignment = UITextAlignmentRight;
    _startDateValue.font = [UIFont systemFontOfSize:18.0];
    [_startDateView addSubview:_startDateValue];
    
    
    _endDateView = [[UIView alloc]init];
    _endDateView.frame = CGRectMake(0, _startDateView.frame.size.height + _startDateView.frame.origin.y, _topView.frame.size.width, _topView.frame.size.height * 0.2);
    [_topView addSubview:_endDateView];
    
    UIView *line3 = [[UIView alloc]init];
    line3.frame = CGRectMake(_endDateView.frame.size.width * 0.05, _endDateView.frame.size.height - 1, _endDateView.frame.size.width * 0.95, 1);
    line3.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_endDateView addSubview:line3];
    
    _endDateLab = [[UILabel alloc]init];
    _endDateLab.frame = CGRectMake(_endDateView.frame.size.width * 0.05, 0, _endDateView.frame.size.width * 0.25, _endDateView.frame.size.height);
    _endDateLab.textColor = [UIColor blackColor];
    _endDateLab.text = @"结束时间";
    _endDateLab.font = [UIFont systemFontOfSize:18.0];
    [_endDateView addSubview:_endDateLab];
    
    
    _endDateValue = [[UILabel alloc]init];
    _endDateValue.frame = CGRectMake(_endDateLab.frame.size.width + _endDateLab.frame.origin.x, 0, _endDateView.frame.size.width * 0.6, _endDateView.frame.size.height);
    _endDateValue.text = @"请选择〉";
    _endDateValue.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    _endDateValue.userInteractionEnabled = YES;
    _endDateValue.textAlignment = UITextAlignmentRight;
    _endDateValue.font = [UIFont systemFontOfSize:18.0];
    [_endDateView addSubview:_endDateValue];
    
    
    _tipLab = [[UILabel alloc]init];
    _tipLab.frame = CGRectMake(_topView.frame.size.width * 0.05, _endDateView.frame.size.height + _endDateView.frame.origin.y, _topView.frame.size.width * 0.9, _topView.frame.size.height * 0.1);
    _tipLab.text = @"请填写所有条件进行搜索";
    _tipLab.font = [UIFont systemFontOfSize:12.0];
    _tipLab.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    [_topView addSubview:_tipLab];
    
    _searchBtn = [[UIButton alloc]init];
    _searchBtn.frame = CGRectMake(0, _tipLab.frame.size.height + _tipLab.frame.origin.y + _topView.frame.size.height * 0.1, _topView.frame.size.width, _topView.frame.size.height * 0.2);
    [_searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    _searchBtn.backgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    [_topView addSubview:_searchBtn];
    
    
    
    UITapGestureRecognizer *studentTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(studentAction:)];
    [_studentValue addGestureRecognizer:studentTap];
    
    UITapGestureRecognizer *startDateTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateAction:)];
    startDateTap.accessibilityHint = @"start";
    [_startDateValue addGestureRecognizer:startDateTap];
    
    UITapGestureRecognizer *endDateTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateAction:)];
    endDateTap.accessibilityHint = @"end";
    [_endDateValue addGestureRecognizer:endDateTap];
    
    [self initData];
}



-(void) initData{
    _picker = [[CZPickerView alloc] initWithHeaderTitle:@"选择学生"
                                      cancelButtonTitle:@"取消"
                                     confirmButtonTitle:@"提交"];
    _picker.delegate = self;
    _picker.dataSource = self;
    _picker.needFooterView = YES;
    _picker.headerBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    _picker.confirmButtonBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    
    [_activityIndicatorView startAnimating];
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiActivity/GetMyStudent?AdminID=%@&ActivityID=%@",kCacheHttpRoot,CurrAdminID,batchID];
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] intValue] == 0){
            NSArray *dataArr = [jsonDic objectForKey:@"AppendData"];
            [self handleList:dataArr];
        }
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败");
    }];
}


-(void) handleList:(NSArray *)dataArr{
    [_peopleArr removeAllObjects];
    for(int i = 0;i<[dataArr count];i++){
        NSMutableDictionary *getDic = [[NSMutableDictionary alloc]init];
        [getDic setObject:[[dataArr objectAtIndex:i] objectForKey:@"UserName"] forKey:@"UserName"];
        [getDic setObject:[[[dataArr objectAtIndex:i] objectForKey:@"StudentID"] stringValue] forKey:@"ID"];
        [_peopleArr addObject:getDic];
    }
}



-(void) searchAction:(UIButton *)sender{
    if([_studentValue.text isEqualToString:@"请选择〉"] || [_startDateValue.text isEqualToString:@"请选择〉"] || [_endDateValue.text isEqualToString:@"请选择〉"]){
        RAlertView *alert = [[RAlertView alloc] initWithStyle:ConfirmAlert];
        alert.headerTitleLabel.text = @"提示";
        alert.contentTextLabel.attributedText = [TextHelper attributedStringForString:@"请完整填写信息。" lineSpacing:5];
        [alert.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [alert.confirmButton setBackgroundColor:[UIColor colorWithRed:20/255.0 green:184/255.0 blue:247/255.0 alpha:1]];
        alert.confirm = ^(){
            NSLog(@"Click on the Ok");
        };
    }else{
        [_activityIndicatorView startAnimating];
        NSString *url = [NSString stringWithFormat:@"%@/ApiCheckWork/GetCheckListByStudentID?StudentID=%@&BeginDate=%@&EndDate=%@",kCacheHttpRoot,_studentID,_startDateValue.text,_endDateValue.text];
        NSLog(@"%@",url);
        [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
            [_activityIndicatorView stopAnimating];
            NSDictionary *jsonDic = result;
            if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
                NSArray *dataArr = [jsonDic objectForKey:@"AppendData"];
                [self detailLayout:dataArr];
            }else{
                RAlertView *alert = [[RAlertView alloc] initWithStyle:SimpleAlert width:0.8];
                alert.isClickBackgroundCloseWindow = YES;
                alert.contentTextLabel.text = [jsonDic objectForKey:@"Message"];
            }
        } failue:^(NSError *error) {
            [_activityIndicatorView stopAnimating];
            NSLog(@"请求失败--签到列表");
        }];
    }
}


-(void) detailLayout:(NSArray *)dataArr{
    
    dataArr = [GJToolsHelp processDictionaryIsNSNull:dataArr];

    CGFloat width = _scrollView.frame.size.width;
    CGFloat height = _scrollView.frame.size.height * 0.3;
    
    _detailView = [[UIView alloc]init];
    _detailView.frame = CGRectMake(0, _topView.frame.size.height + _topView.frame.origin.y + 10, _scrollView.frame.size.width, [dataArr count] * height + _scrollView.frame.size.height * 0.04);
    _detailView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_detailView];
    
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width,20 + _topView.frame.size.height + _detailView.frame.size.height);
    
    
    _detailTipView = [[UIView alloc]init];
    _detailTipView.frame = CGRectMake(0, 0, _detailView.frame.size.width, _scrollView.frame.size.height * 0.04);
    [_detailView addSubview:_detailTipView];
    
    _decorateView = [[UIView alloc]init];
    _decorateView.frame = CGRectMake(_detailTipView.frame.size.width * 0.05, _detailTipView.frame.size.height * 0.1, 7, _detailTipView.frame.size.height * 0.8);
    _decorateView.backgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    [_detailTipView addSubview:_decorateView];
    
    
    _detailTipLab = [[UILabel alloc]init];
    _detailTipLab.frame = CGRectMake(_decorateView.frame.size.width + _decorateView.frame.origin.x + _detailTipView.frame.size.width * 0.02, _detailTipView.frame.size.height * 0.1, _detailTipView.frame.size.width * 0.5, _detailTipView.frame.size.height * 0.8);
    _detailTipLab.text = @"签到列表详情";
    _detailTipLab.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    _detailTipLab.font = [UIFont systemFontOfSize:15.0];
    [_detailTipView addSubview:_detailTipLab];
    
    
    for(int i = 0;i<[dataArr count];i++){
        StudentCheckListDetailViewController *showView = [[StudentCheckListDetailViewController alloc]init_Value:i width:&width height:&height dataDic:dataArr[i] getName:_studentValue.text];
        showView.view.frame = CGRectMake(0, _detailTipView.frame.size.height + (i * height),width,height);
        [_detailView addSubview:showView.view];
    }
    
    
    
    
    
    
}



-(void) studentAction:(UITapGestureRecognizer *)sender{
    [_picker show];
}


-(void) dateAction:(UITapGestureRecognizer *)sender{
    if([sender.accessibilityHint isEqualToString:@"start"]){
        PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
        PGDatePicker *datePicker = datePickManager.datePicker;
        datePicker.delegate = self;
        datePicker.datePickerType = PGDatePickerType3;//PGPickerViewType3;
        datePicker.datePickerMode = PGDatePickerModeDate;
        datePicker.accessibilityHint = @"start";
        [self presentViewController:datePickManager animated:false completion:nil];
    }else if([sender.accessibilityHint isEqualToString:@"end"]){
        PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
        PGDatePicker *datePicker = datePickManager.datePicker;
        datePicker.delegate = self;
        datePicker.datePickerType = PGDatePickerType3;//PGPickerViewType3;
        datePicker.datePickerMode = PGDatePickerModeDate;
        datePicker.accessibilityHint = @"end";
        [self presentViewController:datePickManager animated:false completion:nil];
    }
}


#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    
    if([datePicker.accessibilityHint isEqualToString:@"start"]){
        NSString *dateStr = [NSString stringWithFormat:@"%d-%d-%d",dateComponents.year,dateComponents.month,dateComponents.day];
        _startDateValue.text = dateStr;
        _startDateValue.textColor = [UIColor blackColor];
        
        if(![_startDateValue.text isEqualToString:@"请选择〉"] && ![_endDateValue.text isEqualToString:@"请选择〉"]){
            /*比较*/
            if(![self compareTime:_startDateValue.text end:_endDateValue.text]){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"结束时间不能小于开始时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                _startDateValue.text = @"请选择〉";
                _startDateValue.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
            }
        }
    }else if([datePicker.accessibilityHint isEqualToString:@"end"]){
        NSString *dateStr = [NSString stringWithFormat:@"%d-%d-%d",dateComponents.year,dateComponents.month,dateComponents.day];
        _endDateValue.text = dateStr;
        _endDateValue.textColor = [UIColor blackColor];
        
        if(![_startDateValue.text isEqualToString:@"请选择〉"] && ![_endDateValue.text isEqualToString:@"请选择〉"]){
            /*比较*/
            if(![self compareTime:_startDateValue.text end:_endDateValue.text]){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"结束时间不能小于开始时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                _endDateValue.text = @"请选择〉";
                _endDateValue.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
            }
        }
    }
}


-(BOOL) compareTime:(NSString *)startStr end:(NSString *)endStr{
    BOOL *flag = NO;
    NSInteger StartInt = [PhoneInfo timeSwitchTimestamp:startStr andFormatter:@"yyyy-MM-dd"];
    NSInteger EndInt = [PhoneInfo timeSwitchTimestamp:endStr andFormatter:@"yyyy-MM-dd"];
    if(StartInt < EndInt){
        flag = YES;
    }
    return flag;
}



#pragma mark - CZPickerViewDataSource
/* number of items for picker */
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    return [_peopleArr count];
}

/* picker item title for each row */
- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row{
    return [[_peopleArr objectAtIndex:row]objectForKey:@"UserName"];
}



#pragma mark - CZPickerViewDelegate
/** delegate method for picking one item */
- (void)czpickerView:(CZPickerView *)pickerView
didConfirmWithItemAtRow:(NSInteger)row{
    NSString *name = [[_peopleArr objectAtIndex:row] objectForKey:@"UserName"];
    _studentValue.text = name;
    _studentValue.textColor = [UIColor blackColor];
    _studentID = [[_peopleArr objectAtIndex:row] objectForKey:@"ID"];
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


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
