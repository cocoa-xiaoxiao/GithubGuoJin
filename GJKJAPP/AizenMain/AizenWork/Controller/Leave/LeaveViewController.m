//
//  LeaveViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/2/12.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "LeaveViewController.h"
#import "RDVTabBarController.h"
#import "PGDatePickManager.h"
#import "AizenHttp.h"
#import "AizenMD5.h"
#import "AizenStorage.h"
#import "CZPickerView.h"
#import "People.h"
#import "PhoneInfo.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "MyLeaveRecordViewController.h"

@interface LeaveViewController ()<PGDatePickerDelegate,CZPickerViewDelegate,CZPickerViewDataSource,UITextViewDelegate>

@property(nonatomic,strong) UIView *contentView;

@property(nonatomic,strong) UIView *leaveTypeView;
@property(nonatomic,strong) UIView *leaveTypeLine;
@property(nonatomic,strong) UILabel *leaveTypeLab;


@property(nonatomic,strong) UIView *leaveStartView;
@property(nonatomic,strong) UIView *leaveStartLine;
@property(nonatomic,strong) UILabel *leaveStartLab;

@property(nonatomic,strong) UIView *leaveEndView;
@property(nonatomic,strong) UIView *leaveEndLine;
@property(nonatomic,strong) UILabel *leaveEndLab;

@property(nonatomic,strong) UIView *leaveTotalView;
@property(nonatomic,strong) UIView *leaveTotalLine;
@property(nonatomic,strong) UILabel *leaveTotalLab;
@property(nonatomic,strong) UILabel *leaveTotalVal;

@property(nonatomic,strong) UIView *leaveReasonView;
@property(nonatomic,strong) UILabel *leaveReasonLab;
@property(nonatomic,strong) UITextView *leaveReasonText;

@property(nonatomic,strong) UIView *leavePhotoView;
@property(nonatomic,strong) UILabel *leavePhotoLab;
@property(nonatomic,strong) UIView *leavePhotoDetailView;

@property(nonatomic,strong) UIView *auditingView;
@property(nonatomic,strong) UILabel *auditingLab;
@property(nonatomic,strong) UIView *auditingDetailView;

@property(nonatomic,strong) UIButton *submitBtn;

@property(nonatomic,strong) UIImageView *photoFirst;
@property(nonatomic,strong) UIImageView *photoSecond;
@property(nonatomic,strong) UIImageView *photoThird;
@property(nonatomic,strong) UIImageView *photoFourth;

@property(nonatomic,strong) UILabel *leaveResultTypeLab;
@property(nonatomic,strong) UILabel *leaveResultStartLab;
@property(nonatomic,strong) UILabel *leaveResultEndLab;
@property(nonatomic,strong) UILabel *leaveResultAuditingLab;
@property(nonatomic,strong) NSMutableArray *typeArr;
@property(nonatomic,strong) NSString *typeVal;

@property(nonatomic,strong) DGActivityIndicatorView *animationView;

@end

@implementation LeaveViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _typeArr = [AizenStorage readUserDataWithKey:@"LeaveType"];
    
    self.navigationItem.title = @"请假";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"查看记录" style:UIBarButtonItemStylePlain target:self action:@selector(moreInfo:)];
    [rightBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_STATUSBAR - HEIGHT_NAVBAR);
    _contentView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
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

    _leaveTypeView = [[UIView alloc]init];
    _leaveTypeView.frame = CGRectMake(0, _contentView.frame.size.height * 0.07 * 0.3, _contentView.frame.size.width, _contentView.frame.size.height * 0.07);
    _leaveTypeView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_leaveTypeView];
    
    _leaveTypeLine = [[UIView alloc]init];
    _leaveTypeLine.frame = CGRectMake(_leaveTypeView.frame.size.width * 0.1, _leaveTypeView.frame.size.height - 1, _contentView.frame.size.width * 0.9, 1);
    _leaveTypeLine.backgroundColor = [UIColor clearColor];
    [_leaveTypeView addSubview:_leaveTypeLine];
    
    _leaveTypeLab = [[UILabel alloc]init];
    _leaveTypeLab.frame = CGRectMake(_leaveTypeView.frame.size.width * 0.05, _leaveTypeView.frame.size.height * 0.1, _leaveTypeView.frame.size.width * 0.35, _leaveTypeView.frame.size.height * 0.8);
    _leaveTypeLab.text = @"请假类型:";
    _leaveTypeLab.font = [UIFont fontWithName:@"Arial" size:17.0];
    _leaveTypeLab.textColor = [UIColor blackColor];
    [_leaveTypeView addSubview:_leaveTypeLab];
    
    _leaveResultTypeLab = [[UILabel alloc]init];
    _leaveResultTypeLab.frame = CGRectMake(_leaveTypeLab.frame.size.width + _leaveTypeLab.frame.origin.x, _leaveTypeView.frame.size.height * 0.1, _leaveTypeView.frame.size.width * 0.55, _leaveTypeView.frame.size.height * 0.8);
    _leaveResultTypeLab.text = @"请选择 〉";
    _leaveResultTypeLab.textColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    _leaveResultTypeLab.textAlignment = UITextAlignmentRight;
    [_leaveTypeView addSubview:_leaveResultTypeLab];
    
    
    _leaveStartView = [[UIView alloc]init];
    _leaveStartView.frame = CGRectMake(0, _leaveTypeView.frame.size.height * 1.3 + _leaveTypeView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height * 0.07);
    _leaveStartView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_leaveStartView];
    
    _leaveStartLine = [[UIView alloc]init];
    _leaveStartLine.frame = CGRectMake(_leaveStartView.frame.size.width * 0.1, _leaveStartView.frame.size.height - 1, _leaveStartView.frame.size.width * 0.9, 1);
    _leaveStartLine.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [_leaveStartView addSubview:_leaveStartLine];
    
    _leaveStartLab = [[UILabel alloc]init];
    _leaveStartLab.frame = CGRectMake(_leaveStartView.frame.size.width * 0.05, _leaveStartView.frame.size.height * 0.1, _leaveStartView.frame.size.width * 0.35, _leaveStartView.frame.size.height * 0.8);
    _leaveStartLab.text = @"开始时间:";
    _leaveStartLab.textColor = [UIColor blackColor];
    _leaveStartLab.font = [UIFont fontWithName:@"Arial" size:17.0];
    [_leaveStartView addSubview:_leaveStartLab];
    
    _leaveResultStartLab = [[UILabel alloc]init];
    _leaveResultStartLab.frame = CGRectMake(_leaveStartLab.frame.size.width + _leaveStartLab.frame.origin.x, _leaveStartView.frame.size.height * 0.1, _leaveStartView.frame.size.width * 0.55, _leaveStartView.frame.size.height * 0.8);
    _leaveResultStartLab.text = @"请选择 〉";
    _leaveResultStartLab.textColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    _leaveResultStartLab.textAlignment = UITextAlignmentRight;
    [_leaveStartView addSubview:_leaveResultStartLab];

    
    
    _leaveEndView = [[UIView alloc]init];
    _leaveEndView.frame = CGRectMake(0, _leaveStartView.frame.size.height + _leaveStartView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height * 0.07);
    _leaveEndView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_leaveEndView];
    
    
    _leaveEndLine = [[UIView alloc]init];
    _leaveEndLine.frame = CGRectMake(_leaveEndView.frame.size.width * 0.1, _leaveEndView.frame.size.height - 1, _leaveEndView.frame.size.width * 0.9, 1);
    _leaveEndLine.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [_leaveEndView addSubview:_leaveEndLine];
    
    _leaveEndLab = [[UILabel alloc]init];
    _leaveEndLab.frame = CGRectMake(_leaveEndView.frame.size.width * 0.05, _leaveEndView.frame.size.height * 0.1, _leaveEndView.frame.size.width * 0.35, _leaveEndView.frame.size.height * 0.8);
    _leaveEndLab.text = @"结束时间:";
    _leaveEndLab.textColor = [UIColor blackColor];
    _leaveEndLab.font = [UIFont fontWithName:@"Arial" size:17.0];
    [_leaveEndView addSubview:_leaveEndLab];
    
    _leaveResultEndLab = [[UILabel alloc]init];
    _leaveResultEndLab.frame = CGRectMake(_leaveEndLab.frame.size.width + _leaveEndLab.frame.origin.x, _leaveEndView.frame.size.height * 0.1, _leaveEndView.frame.size.width * 0.55, _leaveEndView.frame.size.height * 0.8);
    _leaveResultEndLab.text = @"请选择 〉";
    _leaveResultEndLab.textColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    _leaveResultEndLab.textAlignment = UITextAlignmentRight;
    [_leaveEndView addSubview:_leaveResultEndLab];
    
    
    _leaveTotalView = [[UIView alloc]init];
    _leaveTotalView.frame = CGRectMake(0, _leaveEndView.frame.size.height + _leaveEndView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height * 0.07);
    _leaveTotalView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_leaveTotalView];
    
    _leaveTotalLine = [[UIView alloc]init];
    _leaveTotalLine.frame = CGRectMake(_leaveTotalView.frame.size.width * 0.1, _leaveTotalView.frame.size.height - 1, _leaveTotalView.frame.size.width * 0.9, 1);
    _leaveTotalLine.backgroundColor = [UIColor clearColor];
    [_leaveTotalView addSubview:_leaveTotalLine];
    
    _leaveTotalLab = [[UILabel alloc]init];
    _leaveTotalLab.frame = CGRectMake(_leaveTotalView.frame.size.width * 0.05, _leaveTotalView.frame.size.height * 0.1, _leaveTotalView.frame.size.width * 0.35, _leaveTotalView.frame.size.height * 0.8);
    _leaveTotalLab.text = @"请假时长:";
    _leaveTotalLab.textColor = [UIColor blackColor];
    _leaveTotalLab.font = [UIFont fontWithName:@"Arial" size:17.0];
    [_leaveTotalView addSubview:_leaveTotalLab];
    
    
    _leaveTotalVal = [[UILabel alloc]init];
    _leaveTotalVal.frame = CGRectMake(_leaveTotalLab.frame.size.width + _leaveTotalLab.frame.origin.x, _leaveTotalView.frame.size.height * 0.1, _leaveTotalView.frame.size.width * 0.55, _leaveTotalView.frame.size.height * 0.8);
    _leaveTotalVal.text = @"请选择时间 〉";
    _leaveTotalVal.textColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    _leaveTotalVal.textAlignment = UITextAlignmentRight;
    [_leaveTotalView addSubview:_leaveTotalVal];
    
    _leaveReasonView = [[UIView alloc]init];
    _leaveReasonView.frame = CGRectMake(0, _leaveTotalView.frame.size.height * 1.3 + _leaveTotalView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height * 0.07 * 3);
    _leaveReasonView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_leaveReasonView];
    
    _leaveReasonLab = [[UILabel alloc]init];
    _leaveReasonLab.frame = CGRectMake(_leaveReasonView.frame.size.width * 0.05, _leaveReasonView.frame.size.height / 3 * 0.1, _leaveReasonView.frame.size.width * 0.35, _leaveReasonView.frame.size.height / 3 * 0.8);
    _leaveReasonLab.text = @"请假事由:";
    _leaveReasonLab.textColor = [UIColor blackColor];
    [_leaveReasonView addSubview:_leaveReasonLab];
    
    _leaveReasonText = [[UITextView alloc]init];
    _leaveReasonText.frame = CGRectMake(_leaveReasonView.frame.size.width * 0.05, _leaveReasonLab.frame.origin.y + _leaveReasonLab.frame.size.height, _leaveReasonView.frame.size.width * 0.9, _leaveReasonView.frame.size.height / 3 * 2);
    _leaveReasonText.text = @"请填写请假理由（必填）";
    _leaveReasonText.textColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    _leaveReasonText.delegate = self;
    _leaveReasonText.font = [UIFont systemFontOfSize:15.0];
    _leaveReasonText.backgroundColor = [UIColor clearColor];
    _leaveReasonText.layer.cornerRadius = 5;
    _leaveReasonText.layer.masksToBounds = YES;
    
//    CAShapeLayer *border = [CAShapeLayer layer];
//    //  线条颜色
//    border.strokeColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
//    border.fillColor = nil;
//    border.path = [UIBezierPath bezierPathWithRect:_leaveReasonText.bounds].CGPath;
//    border.frame = _leaveReasonText.bounds;
//    // 不要设太大 不然看不出效果
//    border.lineWidth = 2;
//    border.lineCap = @"square";
//    //  第一个是 线条长度   第二个是间距    nil时为实线
//    border.lineDashPattern = @[@10, @7];
//    [_leaveReasonText.layer addSublayer:border];
    [_leaveReasonView addSubview:_leaveReasonText];
    
    _leavePhotoView = [[UIView alloc]init];
//    _leavePhotoView.frame = CGRectMake(0, _leaveReasonView.frame.size.height * 1.1 + _leaveReasonView.frame.origin.y, _leaveReasonView.frame.size.width, _contentView.frame.size.height * 0.07 * 2.5);
    _leavePhotoView.frame = CGRectMake(0, _leaveReasonView.frame.size.height * 1.1 + _leaveReasonView.frame.origin.y, _leaveReasonView.frame.size.width, 0);
    _leavePhotoView.hidden = YES;
    _leavePhotoView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_leavePhotoView];
    
    _leavePhotoLab = [[UILabel alloc]init];
    _leavePhotoLab.frame = CGRectMake(_leavePhotoView.frame.size.width * 0.05, _leavePhotoView.frame.size.height / 3 * 0.1, _leavePhotoView.frame.size.width * 0.35, _leavePhotoView.frame.size.height / 3 * 0.8);
    _leavePhotoLab.text = @"拍照上传";
    _leavePhotoLab.textColor = [UIColor blackColor];
    _leavePhotoLab.font = [UIFont fontWithName:@"Arial" size:17.0];
    [_leavePhotoView addSubview:_leavePhotoLab];
    
    _leavePhotoDetailView = [[UIView alloc]init];
    _leavePhotoDetailView.frame = CGRectMake(_leavePhotoView.frame.size.width * 0.05, _leavePhotoLab.frame.size.height * 1.2 + _leavePhotoLab.frame.origin.y, _leavePhotoView.frame.size.width * 0.9, _contentView.frame.size.height * 0.07 * 1.6 - _contentView.frame.size.height * 0.07 * 0.1);
    [_leavePhotoView addSubview:_leavePhotoDetailView];
    _leavePhotoDetailView.hidden = YES;
    _leavePhotoDetailView.frame = CGRectMake(_leavePhotoView.frame.size.width * 0.05, _leavePhotoLab.frame.size.height * 1.2 + _leavePhotoLab.frame.origin.y, _leavePhotoView.frame.size.width * 0.9, 0);

    
    _photoFirst = [[UIImageView alloc]init];
    _photoFirst.frame = CGRectMake(0, 0, _leavePhotoDetailView.frame.size.height, _leavePhotoDetailView.frame.size.height);
    _photoFirst.image = [UIImage imageNamed:@"gj_signaddimg"];
    [_leavePhotoDetailView addSubview:_photoFirst];
    
    _photoSecond = [[UIImageView alloc]init];
    _photoSecond.frame = CGRectMake(_photoFirst.frame.size.width + _photoFirst.frame.origin.x + ((_leavePhotoDetailView.frame.size.width - _leavePhotoDetailView.frame.size.height * 4) / 3), 0, _leavePhotoDetailView.frame.size.height, _leavePhotoDetailView.frame.size.height);
    _photoSecond.image = [UIImage imageNamed:@"gj_signaddimg"];
    [_leavePhotoDetailView addSubview:_photoSecond];
    
    
    _photoThird = [[UIImageView alloc]init];
    _photoThird.frame = CGRectMake(_photoSecond.frame.size.width + _photoSecond.frame.origin.x + ((_leavePhotoDetailView.frame.size.width - _leavePhotoDetailView.frame.size.height * 4) / 3), 0, _leavePhotoDetailView.frame.size.height, _leavePhotoDetailView.frame.size.height);
    _photoThird.image = [UIImage imageNamed:@"gj_signaddimg"];
    [_leavePhotoDetailView addSubview:_photoThird];
    
    
    _photoFourth = [[UIImageView alloc]init];
    _photoFourth.frame = CGRectMake(_photoThird.frame.size.width + _photoThird.frame.origin.x + ((_leavePhotoDetailView.frame.size.width - _leavePhotoDetailView.frame.size.height * 4) / 3), 0, _leavePhotoDetailView.frame.size.height, _leavePhotoDetailView.frame.size.height);
    _photoFourth.image = [UIImage imageNamed:@"gj_signaddimg"];
    [_leavePhotoDetailView addSubview:_photoFourth];
    
    
    
    
    _auditingView = [[UIView alloc]init];
    _auditingView.frame = CGRectMake(0, _leavePhotoView.frame.size.height * 1.1 + _leavePhotoView.frame.origin.y, _leavePhotoView.frame.size.width, _contentView.frame.size.height * 0.07);
    _auditingView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_auditingView];
    
    
    _auditingLab = [[UILabel alloc]init];
    _auditingLab.frame = CGRectMake(_auditingView.frame.size.width * 0.05, _auditingView.frame.size.height * 0.1, _auditingView.frame.size.width * 0.35, _auditingView.frame.size.height * 0.8);
    _auditingLab.text = @"审批人:";
    _auditingLab.font = [UIFont fontWithName:@"Arial" size:17.0];
    _auditingLab.textColor = [UIColor blackColor];
    [_auditingView addSubview:_auditingLab];
    
    _leaveResultAuditingLab = [[UILabel alloc]init];
    _leaveResultAuditingLab.frame = CGRectMake(_auditingLab.frame.size.width + _auditingLab.frame.origin.x, _auditingView.frame.size.height * 0.1, _auditingView.frame.size.width * 0.55, _auditingView.frame.size.height * 0.8);
    _leaveResultAuditingLab.text = @"----";
    _leaveResultAuditingLab.textColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    _leaveResultAuditingLab.textAlignment = UITextAlignmentRight;
    [_auditingView addSubview:_leaveResultAuditingLab];
    
    
    _submitBtn = [[UIButton alloc]init];
    _submitBtn.frame = CGRectMake(0, _contentView.frame.size.height - _contentView.frame.size.height * 0.1, _contentView.frame.size.width, _contentView.frame.size.height * 0.1);
    [_submitBtn setTitle:@"提交审批" forState:UIControlStateNormal];
    _submitBtn.backgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_submitBtn];
    
    
    
    _leaveTypeView.userInteractionEnabled = YES;
    _leaveStartView.userInteractionEnabled = YES;
    _leaveEndView.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *chooseStart = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTimeAction:)];
    chooseStart.accessibilityHint = @"start";
    [_leaveStartView addGestureRecognizer:chooseStart];
    
    UITapGestureRecognizer *chooseEnd = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTimeAction:)];
    chooseEnd.accessibilityHint = @"end";
    [_leaveEndView addGestureRecognizer:chooseEnd];
    
    UITapGestureRecognizer *chooseType = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTypeAction:)];
    [_leaveTypeView addGestureRecognizer:chooseType];
    
    [self HttpAuditingMan];
}



-(void) HttpAuditingMan{
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiActivity/GetMyTeacher?AdminID=%@&ActivityID=%@",kCacheHttpRoot,CurrAdminID,batchID];
    NSLog(@"%@",url);
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"Message"] isEqualToString:@"获取成功"]){
            NSArray *dataArr = [jsonDic objectForKey:@"AppendData"];
            _leaveResultAuditingLab.text = [dataArr[0] objectForKey:@"InUserName"];
            _leaveResultAuditingLab.textColor = [UIColor blackColor];
        }
    } failue:^(NSError *error) {
        NSLog(@"网络请求失败1");
    }];
}


-(void) chooseTypeAction:(UITapGestureRecognizer *)sender{
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"请假类型"
                                                   cancelButtonTitle:@"取消"
                                                  confirmButtonTitle:@"提交"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    picker.headerBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    picker.confirmButtonBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    [picker show];
}


-(void) chooseTimeAction:(UITapGestureRecognizer *)sender{
    if([sender.accessibilityHint isEqualToString:@"start"]){
        PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
        PGDatePicker *datePicker = datePickManager.datePicker;
        datePicker.delegate = self;
        datePicker.datePickerType = PGDatePickerType3;//PGPickerViewType3;
        datePicker.datePickerMode = PGDatePickerModeDateHourMinuteSecond;
        datePicker.accessibilityHint = @"start";
        [self presentViewController:datePickManager animated:false completion:nil];
    }else if([sender.accessibilityHint isEqualToString:@"end"]){
        PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
        PGDatePicker *datePicker = datePickManager.datePicker;
        datePicker.delegate = self;
        datePicker.datePickerType = PGDatePickerType3;//PGPickerViewType3;
        datePicker.datePickerMode = PGDatePickerModeDateHourMinuteSecond;
        datePicker.accessibilityHint = @"end";
        [self presentViewController:datePickManager animated:false completion:nil];
    }
}


#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    
    if([datePicker.accessibilityHint isEqualToString:@"start"]){
        NSString *dateStr = [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d",dateComponents.year,dateComponents.month,dateComponents.day,dateComponents.hour,dateComponents.minute,dateComponents.second];
        _leaveResultStartLab.text = dateStr;
        _leaveResultStartLab.textColor = [UIColor blackColor];
        
        if(![_leaveResultStartLab.text isEqualToString:@"请选择 〉"] && ![_leaveResultEndLab.text isEqualToString:@"请选择 〉"]){
            /*比较*/
            if(![self compareTime:_leaveResultStartLab.text end:_leaveResultEndLab.text]){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"结束时间不能小于开始时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                _leaveResultStartLab.text = @"请选择 〉";
                _leaveResultStartLab.textColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
            }
        }
    }else if([datePicker.accessibilityHint isEqualToString:@"end"]){
        NSString *dateStr = [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d",dateComponents.year,dateComponents.month,dateComponents.day,dateComponents.hour,dateComponents.minute,dateComponents.second];
        _leaveResultEndLab.text = dateStr;
        _leaveResultEndLab.textColor = [UIColor blackColor];
        
        if(![_leaveResultStartLab.text isEqualToString:@"请选择 〉"] && ![_leaveResultEndLab.text isEqualToString:@"请选择 〉"]){
            /*比较*/
            if(![self compareTime:_leaveResultStartLab.text end:_leaveResultEndLab.text]){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"结束时间不能小于开始时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                _leaveResultEndLab.text = @"请选择 〉";
                _leaveResultEndLab.textColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
            }
        }
    }
}


-(BOOL) compareTime:(NSString *)startStr end:(NSString *)endStr{
    BOOL *flag = NO;
    NSInteger StartInt = [PhoneInfo timeSwitchTimestamp:startStr andFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSInteger EndInt = [PhoneInfo timeSwitchTimestamp:endStr andFormatter:@"yyyy-MM-dd HH:mm:ss"];
    if(StartInt < EndInt){
        flag = YES;
        float val = (EndInt - StartInt) / 60;
        _leaveTotalVal.textColor = [UIColor blackColor];
        _leaveTotalVal.text =  [NSString stringWithFormat:@"%0.1f 分钟",val];
    }
    return flag;
}


-(void) moreInfo:(UIBarButtonItem *)sender{
    MyLeaveRecordViewController *myleaverecord = [[MyLeaveRecordViewController alloc]init];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:self.navigationItem.title style:UIBarButtonItemStylePlain target:nil action:nil];
    [backBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationController pushViewController:myleaverecord animated:YES];
}




#pragma mark - CZPickerViewDataSource
/* number of items for picker */
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    return [_typeArr count];
}

/*
 Implement at least one of the following method,
 czpickerView:(CZPickerView *)pickerView
 attributedTitleForRow:(NSInteger)row has higer priority
 */

/* attributed picker item title for each row */
//- (NSAttributedString *)czpickerView:(CZPickerView *)pickerView
//               attributedTitleForRow:(NSInteger)row{
//    NSAttributedString *att = [[NSAttributedString alloc]
//                               initWithString:@"哈哈"
//                               attributes:@{
//                                            NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:18.0]
//                                            }];
//    return att;
//}

/* picker item title for each row */
- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row{
    return [[_typeArr objectAtIndex:row]objectForKey:@"DictionaryName"];
}



#pragma mark - CZPickerViewDelegate
/** delegate method for picking one item */
- (void)czpickerView:(CZPickerView *)pickerView
didConfirmWithItemAtRow:(NSInteger)row{
    NSString *typeStr = [[_typeArr objectAtIndex:row]objectForKey:@"DictionaryName"];
    _typeVal = [[_typeArr objectAtIndex:row]objectForKey:@"ID"];
    
    _leaveResultTypeLab.text = typeStr;
    _leaveResultTypeLab.textColor = [UIColor blackColor];
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



-(void) submitAction:(UIButton *)sender{
    if([_leaveResultTypeLab.text isEqualToString:@"请选择 〉"] || [_leaveResultStartLab.text isEqualToString:@"请选择 〉"] || [_leaveResultEndLab.text isEqualToString:@"请选择 〉"] || [_leaveReasonText.text isEqualToString:@"请填写请假理由（必填）"]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写相关信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        _animationView = [[DGActivityIndicatorView alloc]initWithType:DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
        _animationView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 100)/2, 100, 100);
        [self.view addSubview:_animationView];
        [_animationView startAnimating];
        
        NSString *currAccount = [AizenStorage readUserDataWithKey:@"Account"];
        NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",currAccount]];
        People *getObj = existArr[0];
        NSString *currAdminID = [getObj.USERID stringValue];
        
        NSDateFormatter *StartdateFormatter = [[NSDateFormatter alloc] init];
        [StartdateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *Startdate = [StartdateFormatter dateFromString:_leaveResultStartLab.text];
        
        NSDateFormatter *StartdateFormatter1 = [[NSDateFormatter alloc] init];
        [StartdateFormatter1 setDateFormat:@"yyyy-MM-dd"];
        NSString *currStartDate = [StartdateFormatter1 stringFromDate:Startdate];
        
        NSDateFormatter *StartdateFormatter2 = [[NSDateFormatter alloc] init];
        [StartdateFormatter2 setDateFormat:@"yyyyMMdd"];
        NSString *currBeginDate = [StartdateFormatter2 stringFromDate:Startdate];
        
        NSDateFormatter *EnddateFormatter = [[NSDateFormatter alloc] init];
        [EnddateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *Enddate = [EnddateFormatter dateFromString:_leaveResultEndLab.text];
        
        NSDateFormatter *EnddateFormatter1 = [[NSDateFormatter alloc] init];
        [EnddateFormatter1 setDateFormat:@"yyyy-MM-dd"];
        NSString *currEndDate = [EnddateFormatter1 stringFromDate:Enddate];
        
        NSDateFormatter *EnddateFormatter2 = [[NSDateFormatter alloc] init];
        [EnddateFormatter2 setDateFormat:@"yyyyMMdd"];
        NSString *currJieshuDate = [EnddateFormatter2 stringFromDate:Enddate];
        
        NSString *currTypeID = _typeVal;
        NSString *currContent = _leaveReasonText.text;
        NSString *currTimeStamp = [PhoneInfo getNowTimeTimestamp3];
        
        NSString *currToken = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@%@%@GJCheck%@",currAdminID,currBeginDate,currTimeStamp,currJieshuDate]];
        
        //&TimeStamp=1517672080000&Token=A46E62BC99D60C47
        NSString *url = [NSString stringWithFormat:@"%@/ApiCheckWork/ApplyLeave?Creater=%@&BeginDate=%@&EndDate=%@&LeaveTypeID=%@&LeaveContent=%@&TimeStamp=%@&Token=%@",kCacheHttpRoot,currAdminID,currStartDate,currEndDate,currTypeID,currContent,currTimeStamp,currToken];
        
         NSString *urlencode = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [AizenHttp asynRequest:urlencode httpMethod:@"GET" params:nil success:^(id result) {
            NSDictionary *jsonDic = result;
            NSLog(@"%@",jsonDic);
            
            [_animationView stopAnimating];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[jsonDic objectForKey:@"Message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            [self.navigationController popViewControllerAnimated:true];
            
        } failue:^(NSError *error) {
            [_animationView stopAnimating];

            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
}


#pragma mark - UITextViewDelegate
-(void) textViewDidEndEditing:(UITextView *)textView:(UITextView *)textView{
    NSLog(@"%d",textView.text.length);
    if(textView.text.length < 1){
        textView.text = @"请填写请假理由（必填）";
        textView.textColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }
}


-(void) textViewDidBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@"请填写请假理由（必填）"]){
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
