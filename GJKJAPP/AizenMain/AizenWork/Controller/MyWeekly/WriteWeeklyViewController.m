//
//  WriteWeeklyViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/4/11.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "WriteWeeklyViewController.h"
#import "AizenHttp.h"
#import "AizenMD5.h"
#import "AizenStorage.h"
#import "DGActivityIndicatorView.h"
#import "People.h"
#import "RAlertView.h"
#import "PGDatePickManager.h"
#import "CZPickerView.h"
#import "PhoneInfo.h"
#import "MainViewController.h"

#define intervalHeight 10

#define textHeight 160

#import <IQKeyboardManager/IQPreviousNextView.h>

@interface WriteWeeklyViewController ()<PGDatePickerDelegate,CZPickerViewDelegate,CZPickerViewDataSource,UITextViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong) UIView *contentView;

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIButton *submitBtn;

@property(nonatomic,strong) UIView *dateView;
@property(nonatomic,strong) UILabel *dateLab;
@property(nonatomic,strong) UILabel *dateVal;

@property(nonatomic,strong) UIView *titleView;
@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) UITextField *titleTextField;

@property(nonatomic,strong) UIView *workContentView;
@property(nonatomic,strong) UITextView *workContentVal;

@property(nonatomic,strong) UIView *problemView;
@property(nonatomic,strong) UITextView *problemVal;

@property(nonatomic,strong) UIView *solveView;
@property(nonatomic,strong) UITextView *solveVal;

@property(nonatomic,strong) UIView *lightView;
@property(nonatomic,strong) UITextView *lightVal;

@property(nonatomic,strong) UIView *insufficientView;
@property(nonatomic,strong) UITextView *insufficientVal;

@property (nonatomic, strong) UILabel *startLab;
@property (nonatomic, strong) UILabel *stopLab;

@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation WriteWeeklyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //创建
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"工作周记";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    _startLab = [[UILabel alloc]init];
    _stopLab = [[UILabel alloc]init];
    [self startLayout];
}

-(void)httpHelp
{
    NSString *activity = [AizenStorage readUserDataWithKey:@"batchID"];
    NSString *url2 = [NSString stringWithFormat:@"%@/ApiActivityWeekly/GetWeeklyConfig?ActivityID=%@",kCacheHttpRoot,activity];
    
    [_activityIndicatorView startAnimating];
    [AizenHttp asynRequest:url2 httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = [result objectForKey:@"AppendData"];
        self.dataDic = jsonDic;
        [self detailLayout];
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        [BaseViewController br_showAlterMsg:@"请求失败，请重试"];
    }];
}

-(void) startLayout{
    _contentView = [[IQPreviousNextView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_NAVBAR - HEIGHT_STATUSBAR);
    _contentView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
    
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height - HEIGHT_TABBAR);
//    _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, _contentView.frame.size.height * 2);
    [_contentView addSubview:_scrollView];
    
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[UIColor darkGrayColor]];
    _activityIndicatorView.frame = CGRectMake((_contentView.frame.size.width - 100)/2, (_contentView.frame.size.height - 200)/2, 100, 100);
    [_contentView addSubview:_activityIndicatorView];
    
    
    _submitBtn = [[UIButton alloc]init];
    _submitBtn.frame = CGRectMake(0, _scrollView.frame.size.height + _scrollView.frame.origin.y, _contentView.frame.size.width, HEIGHT_TABBAR);
    _submitBtn.backgroundColor = [UIColor colorWithRed:80/255.0 green:119/255.0 blue:170/255.0 alpha:1];
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    _submitBtn.font = [UIFont systemFontOfSize:18.0];
    [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_submitBtn];
    
    [self httpHelp];
}


-(void) submitAction:(UIButton *)sender{
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    
    NSString *dateStr = _dateVal.text;
    NSString *titleStr = _titleTextField.text;

    
    NSString *workStr = _workContentVal.text;
    NSString *problemStr = _problemVal.text;
    NSString *solveStr = _solveVal.text;
    NSString *lightStr = _lightVal.text;
    NSString *insufficientStr = _insufficientVal.text;
    
    NSString *currTime = [PhoneInfo getNowTimeTimestamp3];
    
    NSString *token = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@GJWeekly%@",CurrAdminID,currTime]];
    
    
    if([dateStr isEqualToString:@"请选择日期"]){
        RAlertView *alert = [[RAlertView alloc] initWithStyle:ConfirmAlert];
        alert.headerTitleLabel.text = @"提示";
        alert.contentTextLabel.attributedText = [TextHelper attributedStringForString:@"请选择时间！" lineSpacing:5];
        [alert.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [alert.confirmButton setBackgroundColor:[UIColor colorWithRed:20/255.0 green:184/255.0 blue:247/255.0 alpha:1]];
        alert.confirm = ^(){
            NSLog(@"Click on the Ok");
        };
    }else{
        [_activityIndicatorView startAnimating];
        NSString *url = [NSString stringWithFormat:@"%@/ApiActivityWeekly/Submit",kCacheHttpRoot];

        NSDictionary *paramsDic = [[NSDictionary alloc]initWithObjectsAndKeys:CurrAdminID,@"Creater",batchID,@"ActivityID",titleStr,@"WeeklyTitle",_startLab.text,@"BeginDate",_stopLab.text,@"EndDate",workStr,@"WeeklyContent",problemStr,@"Problem",solveStr,@"Resolvent",lightStr,@"Advantage",insufficientStr,@"Insufficient",currTime,@"TimeStamp",token,@"Token", nil];

        NSLog(@"%@",paramsDic);

        [AizenHttp asynRequest:url httpMethod:@"POST" params:paramsDic success:^(id result) {
            [_activityIndicatorView stopAnimating];
            NSDictionary *jsonDic = result;
            if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[jsonDic objectForKey:@"Message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alert.tag = kSuccessCodeTag;
                [alert show];
                
            }
        } failue:^(NSError *error) {
            [_activityIndicatorView stopAnimating];
            NSLog(@"请求失败--提交周记");
        }];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kSuccessCodeTag) {
        if (self.updateBlock) {
            self.updateBlock(nil);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void) detailLayout{
    NSString *key1 = [NSString checkNull:[self.dataDic objectForKey:@"Field1"]];
    NSString *key2 = [NSString checkNull:[self.dataDic objectForKey:@"Field2"]];
    NSString *key3 = [NSString checkNull:[self.dataDic objectForKey:@"Field3"]];
    NSString *key4 = [NSString checkNull:[self.dataDic objectForKey:@"Field4"]];
    NSString *key5 = [NSString checkNull:[self.dataDic objectForKey:@"Field5"]];
    
    _dateView = [[UIView alloc]init];
    _dateView.frame = CGRectMake(0, intervalHeight, _contentView.frame.size.width, _contentView.frame.size.height * 0.06);
    _dateView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_dateView];
    
    _dateLab = [[UILabel alloc]init];
    _dateLab.frame = CGRectMake(_dateView.frame.size.width * 0.05, _dateView.frame.size.height * 0.1, _dateView.frame.size.width * 0.3, _dateView.frame.size.height * 0.8);
    _dateLab.text = @"选择日期:";
    _dateLab.font = [UIFont systemFontOfSize:18.0];
    [_dateView addSubview:_dateLab];
    
    _dateVal = [[UILabel alloc]init];
    _dateVal.frame = CGRectMake(_dateLab.frame.size.width + _dateLab.frame.origin.x, _dateView.frame.size.height * 0.1, _dateView.frame.size.width * 0.6, _dateView.frame.size.height * 0.8);
    _dateVal.text = @"请选择日期";
    _dateVal.textColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    _dateVal.textAlignment = UITextAlignmentRight;
    _dateVal.font = [UIFont systemFontOfSize:18.0];
    UITapGestureRecognizer *dateTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateAction:)];
    [_dateVal addGestureRecognizer:dateTap];
    _dateVal.userInteractionEnabled = YES;
    [_dateView addSubview:_dateVal];
    
    CALayer *layerTop = [CALayer layer];
    layerTop.frame = CGRectMake(0, 0, _dateView.frame.size.width, 1);
    layerTop.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1].CGColor;
    [_dateView.layer addSublayer:layerTop];
    
    
    CALayer *layerBottom = [CALayer layer];
    layerBottom.frame = CGRectMake(0, _dateView.frame.size.height - 1,_dateView.frame.size.width, 1);
    layerBottom.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1].CGColor;
    [_dateView.layer addSublayer:layerBottom];
    
    
    _titleView = [[UIView alloc]init];
    _titleView.frame = CGRectMake(0, _dateView.frame.size.height + _dateView.frame.origin.y + intervalHeight, _dateView.frame.size.width, _contentView.frame.size.height * 0.06);
    _titleView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_titleView];
    
    CALayer *layerBottom1 = [CALayer layer];
    layerBottom1.frame = CGRectMake(_titleView.frame.size.width * 0.05, _titleView.frame.size.height - 1,_titleView.frame.size.width * 0.95, 1);
    layerBottom1.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1].CGColor;
    [_titleView.layer addSublayer:layerBottom1];
    
    
    _titleLab = [[UILabel alloc]init];
    _titleLab.frame = CGRectMake(_dateView.frame.size.width * 0.05, _dateView.frame.size.height * 0.1, _dateView.frame.size.width * 0.2, _dateView.frame.size.height * 0.8);
    _titleLab.text = @"周记标题:";
    _titleLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    _titleLab.font = [UIFont systemFontOfSize:14.0];
    [_titleView addSubview:_titleLab];
    
    
    _titleTextField = [[UITextField alloc]init];
    _titleTextField.frame = CGRectMake(_titleLab.frame.size.width + _titleLab.frame.origin.x, _titleView.frame.size.height * 0.1, _titleView.frame.size.width * 0.7, _titleView.frame.size.height * 0.8);
    _titleTextField.placeholder = @"请输入标题";
    _titleTextField.textAlignment = UITextAlignmentRight;
    _titleTextField.font = [UIFont systemFontOfSize:14.0];
    [_titleView addSubview:_titleTextField];
    
    
    _workContentView = [[UIView alloc]init];
    _workContentView.frame = CGRectMake(0, _titleView.frame.size.height + _titleView.frame.origin.y, _contentView.frame.size.width, textHeight);
    _workContentView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_workContentView];
    
    CALayer *layerBottom2 = [CALayer layer];
    layerBottom2.frame = CGRectMake(0, _workContentView.frame.size.height - 1,_workContentView.frame.size.width, 1);
    layerBottom2.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1].CGColor;
    [_workContentView.layer addSublayer:layerBottom2];
    
    _workContentVal = [[UITextView alloc]init];
    _workContentVal.frame = CGRectMake(_workContentView.frame.size.width * 0.05, _workContentView.frame.size.height * 0.05, _workContentView.frame.size.width * 0.9, _workContentView.frame.size.height * 0.9);
    _workContentVal.delegate = self;
    _workContentVal.accessibilityLabel = @"workContent";
    _workContentVal.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    _workContentVal.font = [UIFont systemFontOfSize:18.0];
    _workContentVal.text = key1;
    [_workContentView addSubview:_workContentVal];
    
    
    _problemView = [[UIView alloc]init];
    _problemView.frame = CGRectMake(0, _workContentView.frame.size.height + _workContentView.frame.origin.y, _contentView.frame.size.width, textHeight);
    _problemView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_problemView];
    
    CALayer *layerBottom3 = [CALayer layer];
    layerBottom3.frame = CGRectMake(0, _problemView.frame.size.height - 1,_problemView.frame.size.width, 1);
    layerBottom3.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1].CGColor;
    [_problemView.layer addSublayer:layerBottom3];
    
    _problemVal = [[UITextView alloc]init];
    _problemVal.frame = CGRectMake(_problemView.frame.size.width * 0.05, _problemView.frame.size.height * 0.05, _problemView.frame.size.width * 0.9, _problemView.frame.size.height * 0.9);
    _problemVal.delegate = self;
    _problemVal.accessibilityLabel = @"problem";
    _problemVal.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    _problemVal.font = [UIFont systemFontOfSize:18.0];
    _problemVal.text = key2;
    [_problemView addSubview:_problemVal];
    
    
    
    _solveView = [[UIView alloc]init];
    _solveView.frame = CGRectMake(0, _problemView.frame.size.height + _problemView.frame.origin.y, _contentView.frame.size.width, textHeight);
    _solveView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_solveView];
    
    CALayer *layerBottom4 = [CALayer layer];
    layerBottom4.frame = CGRectMake(0, _solveView.frame.size.height - 1,_solveView.frame.size.width, 1);
    layerBottom4.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1].CGColor;
    [_solveView.layer addSublayer:layerBottom4];
    
    _solveVal = [[UITextView alloc]init];
    _solveVal.frame = CGRectMake(_solveView.frame.size.width * 0.05, _solveView.frame.size.height * 0.05, _solveView.frame.size.width * 0.9, _solveView.frame.size.height * 0.9);
    _solveVal.delegate = self;
    _solveVal.accessibilityLabel = @"solve";
    _solveVal.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    _solveVal.font = [UIFont systemFontOfSize:18.0];
    _solveVal.text = key3;
    [_solveView addSubview:_solveVal];
    
    
    
    _lightView = [[UIView alloc]init];
    _lightView.frame = CGRectMake(0, _solveView.frame.size.height + _solveView.frame.origin.y, _contentView.frame.size.width, textHeight);
    _lightView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_lightView];
    
    CALayer *layerBottom5 = [CALayer layer];
    layerBottom5.frame = CGRectMake(0, _lightView.frame.size.height - 1,_lightView.frame.size.width, 1);
    layerBottom5.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1].CGColor;
    [_lightView.layer addSublayer:layerBottom5];
    
    _lightVal = [[UITextView alloc]init];
    _lightVal.frame = CGRectMake(_lightView.frame.size.width * 0.05, _lightView.frame.size.height * 0.05, _lightView.frame.size.width * 0.9, _lightView.frame.size.height * 0.9);
    _lightVal.delegate = self;
    _lightVal.accessibilityLabel = @"light";
    _lightVal.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    _lightVal.font = [UIFont systemFontOfSize:18.0];
    _lightVal.text = key4;
    [_lightView addSubview:_lightVal];
    
    
    _insufficientView = [[UIView alloc]init];
    _insufficientView.frame = CGRectMake(0, _lightView.frame.size.height + _lightView.frame.origin.y, _contentView.frame.size.width, textHeight);
    _insufficientView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_insufficientView];
    
    CALayer *layerBottom6 = [CALayer layer];
    layerBottom6.frame = CGRectMake(0, _insufficientView.frame.size.height - 1,_insufficientView.frame.size.width, 1);
    layerBottom6.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1].CGColor;
    [_insufficientView.layer addSublayer:layerBottom6];
    
    _insufficientVal = [[UITextView alloc]init];
    _insufficientVal.frame = CGRectMake(_insufficientView.frame.size.width * 0.05, _insufficientView.frame.size.height * 0.05, _insufficientView.frame.size.width * 0.9, _insufficientView.frame.size.height * 0.9);
    _insufficientVal.delegate = self;
    _insufficientVal.accessibilityLabel = @"insufficient";
    _insufficientVal.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    _insufficientVal.font = [UIFont systemFontOfSize:18.0];
    _insufficientVal.text = key5;
    [_insufficientView addSubview:_insufficientVal];
    
    
    CGFloat scrollHeight = _dateView.frame.size.height + intervalHeight + intervalHeight + _titleView.frame.size.height + _workContentView.frame.size.height + _problemView.frame.size.height + _solveVal.frame.size.height + _lightView.frame.size.height + _insufficientView.frame.size.height;
    scrollHeight = _insufficientView.frame.origin.y + _insufficientView.frame.size.height;

    _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, scrollHeight);
    
    
    
}




-(void) dateAction:(UITapGestureRecognizer *)sender{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGDatePickerType3;
    datePicker.datePickerMode = PGDatePickerModeDate;
    [self presentViewController:datePickManager animated:YES completion:nil];
}


-(void) handleWeeklyTitle:(NSString *)dateStr weekday:(NSInteger)weekday_num{
    NSDateFormatter *inputFormatter=[[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *formatterDate=[inputFormatter dateFromString:dateStr];
    NSDateFormatter *outputFormatter=[[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:@"EEEE-MMMM-d"];
    NSString *outputDateStr=[outputFormatter stringFromDate:formatterDate];
    NSArray *weekArray=[outputDateStr componentsSeparatedByString:@"-"];
    
  
    //// 1 是周日，2是周一 3.以此类推
    NSInteger weekInt = weekday_num;//[weekNumber integerValue];
  

    NSInteger Timestamp = [PhoneInfo timeSwitchTimestamp:dateStr andFormatter:@"YYYY-MM-dd"];
    NSLog(@"%d",Timestamp);
    if(weekInt == 2){
        [self setWeeklyTitle:Timestamp leftDay:0 rightDay:6];
    }else if(weekInt == 3){
        [self setWeeklyTitle:Timestamp leftDay:1 rightDay:5];
    }else if(weekInt == 4){
        [self setWeeklyTitle:Timestamp leftDay:2 rightDay:4];
    }else if(weekInt == 5){
        [self setWeeklyTitle:Timestamp leftDay:3 rightDay:3];
    }else if(weekInt == 6){
        [self setWeeklyTitle:Timestamp leftDay:4 rightDay:2];
    }else if(weekInt == 7){
        [self setWeeklyTitle:Timestamp leftDay:5 rightDay:1];
    }else if(weekInt == 1){
        [self setWeeklyTitle:Timestamp leftDay:6 rightDay:0];
    }
    
//    NSString *whichWeek = [weekArray objectAtIndex:0];
//    if([whichWeek isEqualToString:@"Monday"]){
//        [self setWeeklyTitle:Timestamp leftDay:0 rightDay:6];
//    }else if([whichWeek isEqualToString:@"Tuesday"]){
//        [self setWeeklyTitle:Timestamp leftDay:1 rightDay:5];
//    }else if([whichWeek isEqualToString:@"Wednesday"]){
//        [self setWeeklyTitle:Timestamp leftDay:2 rightDay:4];
//    }else if([whichWeek isEqualToString:@"Thursday"]){
//        [self setWeeklyTitle:Timestamp leftDay:3 rightDay:3];
//    }else if([whichWeek isEqualToString:@"Friday"]){
//        [self setWeeklyTitle:Timestamp leftDay:4 rightDay:2];
//    }else if([whichWeek isEqualToString:@"Saturday"]){
//        [self setWeeklyTitle:Timestamp leftDay:5 rightDay:1];
//    }else if([whichWeek isEqualToString:@"Sunday"]){
//        [self setWeeklyTitle:Timestamp leftDay:6 rightDay:0];
//    }
}


-(void) setWeeklyTitle:(NSInteger) currTimestamp leftDay:(int) leftDayVal rightDay:(int) rightDayVal {
    NSString *account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *peopleArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",account]];
    People *peopleData = [peopleArr objectAtIndex:0];
    
    NSString *leftDate = [NSString stringWithFormat:@"%@",[PhoneInfo timestampSwitchTime:(currTimestamp - leftDayVal * 60 * 60 * 24) andFormatter:@"YYYY-MM-dd"]];
    NSString *rightDate = [NSString stringWithFormat:@"%@",[PhoneInfo timestampSwitchTime:(currTimestamp + rightDayVal * 60 * 60 * 24) andFormatter:@"YYYY-MM-dd"]];
    
    _startLab.text = leftDate;
    _stopLab.text = rightDate;

    
    NSString *weeklyTitleStr = [NSString stringWithFormat:@"%@%@到%@周记",peopleData.USERNAME,leftDate,rightDate];
    _titleTextField.text = weeklyTitleStr;
    
}


#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSString *key1 = [NSString checkNull:[self.dataDic objectForKey:@"Field1"]];
    NSString *key2 = [NSString checkNull:[self.dataDic objectForKey:@"Field2"]];
    NSString *key3 = [NSString checkNull:[self.dataDic objectForKey:@"Field3"]];
    NSString *key4 = [NSString checkNull:[self.dataDic objectForKey:@"Field4"]];
    NSString *key5 = [NSString checkNull:[self.dataDic objectForKey:@"Field5"]];
    if([textView.accessibilityLabel isEqualToString:@"workContent"]){
        if(textView.text.length < 1){
            textView.text = key1;
            textView.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        }
    }else if([textView.accessibilityLabel isEqualToString:@"problem"]){
        if(textView.text.length < 1){
            textView.text = key2;
            textView.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        }
    }else if([textView.accessibilityLabel isEqualToString:@"solve"]){
        if(textView.text.length < 1){
            textView.text = key3;
            textView.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        }
    }else if([textView.accessibilityLabel isEqualToString:@"light"]){
        if(textView.text.length < 1){
            textView.text = key4;
            textView.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        }
    }else if([textView.accessibilityLabel isEqualToString:@"insufficient"]){
        if(textView.text.length < 1){
            textView.text = key5;
            textView.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        }
    }
    
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSString *key1 = [NSString checkNull:[self.dataDic objectForKey:@"Field1"]];
    NSString *key2 = [NSString checkNull:[self.dataDic objectForKey:@"Field2"]];
    NSString *key3 = [NSString checkNull:[self.dataDic objectForKey:@"Field3"]];
    NSString *key4 = [NSString checkNull:[self.dataDic objectForKey:@"Field4"]];
    NSString *key5 = [NSString checkNull:[self.dataDic objectForKey:@"Field5"]];
    
    if([textView.accessibilityLabel isEqualToString:@"workContent"]){
        if([textView.text isEqualToString:key1]){
            textView.text=@"";
            textView.textColor=[UIColor blackColor];
        }
    }else if([textView.accessibilityLabel isEqualToString:@"problem"]){
        if([textView.text isEqualToString:key2]){
            textView.text=@"";
            textView.textColor=[UIColor blackColor];
        }
    }else if([textView.accessibilityLabel isEqualToString:@"solve"]){
        if([textView.text isEqualToString:key3]){
            textView.text=@"";
            textView.textColor=[UIColor blackColor];
        }
    }else if([textView.accessibilityLabel isEqualToString:@"light"]){
        if([textView.text isEqualToString:key4]){
            textView.text=@"";
            textView.textColor=[UIColor blackColor];
        }
    }else if([textView.accessibilityLabel isEqualToString:@"insufficient"]){
        if([textView.text isEqualToString:key5]){
            textView.text=@"";
            textView.textColor=[UIColor blackColor];
        }
    }
}


#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    
    NSString *dateStr = [NSString stringWithFormat:@"%d-%d-%d",dateComponents.year,dateComponents.month,dateComponents.day];
    _dateVal.textColor = [UIColor blackColor];
    _dateVal.text = dateStr;

    [self handleWeeklyTitle:dateStr weekday:dateComponents.weekday];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
