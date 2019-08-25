//
//  ModifyStationViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/4/28.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "ModifyStationViewController.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "DGActivityIndicatorView.h"
#import "People.h"
#import "PhoneInfo.h"
#import "MainViewController.h"
#import "HMCustomSwitch.h"
#import "ModifyCompanyDetailViewController.h"
#import "ModifyStationDetailViewController.h"
#import "ModifyTeacherDetailViewController.h"
#import "CZPickerView.h"
#import "PGDatePickManager.h"
#import "BRDetailStationModel.h"

@interface ModifyStationViewController ()<PGDatePickerDelegate,CZPickerViewDelegate,CZPickerViewDataSource,UITextViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@property(nonatomic,strong) UIButton *modifyBtn;

/*备用ID*/
@property(nonatomic,strong) NSString *companyID;
@property(nonatomic,strong) NSString *stationID;
@property(nonatomic,strong) NSString *teacherID;
@property(nonatomic,strong) NSString *applyID;

/*第一页内容*/
@property(nonatomic,strong) UIView *titleView;
@property(nonatomic,retain) UILabel *titleLab;

@property(nonatomic,strong) UIView *companyView;
@property(nonatomic,strong) UILabel *companyLab;
@property(nonatomic,strong) UILabel *companyField;

@property(nonatomic,strong) UIView *companyCodeView;
@property(nonatomic,strong) UILabel *companyCodeLab;
@property(nonatomic,strong) BaseTextFeild *companyCodeField;

@property(nonatomic,strong) UIView *peopleCountView;
@property(nonatomic,strong) UILabel *peopleCountLab;
@property(nonatomic,strong) BaseTextFeild *peopleCountField;

@property(nonatomic,strong) UIView *addressView;
@property(nonatomic,strong) UILabel *addressLab;
@property(nonatomic,strong) BaseTextFeild *addressField;

@property(nonatomic,strong) UIView *baseView;
@property(nonatomic,strong) UILabel *baseLab;
@property(nonatomic,strong) UIView *baseField;
@property(nonatomic,strong) UILabel *baseSwitch;


/*第二页内容*/
@property(nonatomic,strong) UIView *titleView1;
@property(nonatomic,retain) UILabel *titleLab1;

@property(nonatomic,strong) UIView *stationView;
@property(nonatomic,strong) UILabel *stationLab;
@property(nonatomic,strong) UILabel *stationField;

@property(nonatomic,strong) UIView *stationPeopleView;
@property(nonatomic,strong) UILabel *stationPeopleLab;
@property(nonatomic,strong) BaseTextFeild *stationPeopleField;

@property(nonatomic,strong) UIView *stationInstrView;
@property(nonatomic,strong) UILabel *stationInstrLab;
@property(nonatomic,strong) BaseTextFeild *stationInstrField;

@property(nonatomic,strong) UIView *stationTypsView;
@property(nonatomic,strong) UILabel *stationTypeLab;
@property(nonatomic,strong) BaseTextFeild *stationTypeField;


/*第三页内容*/
@property(nonatomic,strong) UIView *titleView2;
@property(nonatomic,strong) UILabel *titleLab2;

@property(nonatomic,strong) UIView *teacherView;
@property(nonatomic,strong) UILabel *teacherLab;
@property(nonatomic,strong) UILabel *teacherField;

@property(nonatomic,strong) UIView *mobileView;
@property(nonatomic,strong) UILabel *mobileLab;
@property(nonatomic,strong) BaseTextFeild *mobileField;

@property(nonatomic,strong) UIView *phoneView;
@property(nonatomic,strong) UILabel *phoneLab;
@property(nonatomic,strong) BaseTextFeild *phoneField;

@property(nonatomic,strong) UIView *emailView;
@property(nonatomic,strong) UILabel *emailLab;
@property(nonatomic,strong) BaseTextFeild *emailField;

@property(nonatomic,strong) UIView *offerView;
@property(nonatomic,strong) UILabel *offerLab;
@property(nonatomic,strong) BaseTextFeild *offerField;

@property(nonatomic,strong) UIView *dateView;
@property(nonatomic,strong) UILabel *dateLab;
@property(nonatomic,strong) BaseTextFeild *dateField;

@property(nonatomic,strong) UIView *liveView;
@property(nonatomic,strong) UILabel *liveLab;
@property(nonatomic,strong) BaseTextFeild *liveField;

@property(nonatomic,strong) UIView *eatView;
@property(nonatomic,strong) UILabel *eatLab;
@property(nonatomic,strong) BaseTextFeild *eatField;

@property(nonatomic,strong) UIView *instrView;
@property(nonatomic,strong) UILabel *instrLab;
@property(nonatomic,strong) UITextView *instrField;


/*第四页内容*/
@property(nonatomic,strong) UIView *titleView3;
@property(nonatomic,strong) UILabel *titleLab3;

@property(nonatomic,strong) UIView *salaryView;
@property(nonatomic,strong) UILabel *salaryLab;
@property(nonatomic,strong) BaseTextFeild *salaryField;

@property(nonatomic,strong) UIView *postDateView;
@property(nonatomic,strong) UILabel *postDateLab;
@property(nonatomic,strong) UILabel *postDateField;

@property(nonatomic,strong) UIView *stayView;
@property(nonatomic,strong) UILabel *stayLab;
@property(nonatomic,strong) BaseTextFeild *stayField;

@property(nonatomic,strong) UIView *foodView;
@property(nonatomic,strong) UILabel *foodLab;
@property(nonatomic,strong) BaseTextFeild *foodField;

@property(nonatomic,strong) UIView *agreementView;
@property(nonatomic,strong) UILabel *agreementLab;
@property(nonatomic,strong) BaseTextFeild *agreementField;

@property(nonatomic,strong) UIView *descrView;
@property(nonatomic,strong) UILabel *descrLab;
@property(nonatomic,strong) BaseTextFeild *descrField;


/*第五页内容*/
@property(nonatomic,strong) UIView *group1;
@property(nonatomic,strong) UIView *group2;
@property(nonatomic,strong) UIView *group3;
@property(nonatomic,strong) UIView *group4;
@property(nonatomic,strong) UIView *group5;
@property(nonatomic,strong) UIView *group6;

@property(nonatomic,strong) UILabel *group1Title;
@property(nonatomic,strong) UILabel *group2Title;
@property(nonatomic,strong) UILabel *group3Title;
@property(nonatomic,strong) UILabel *group4Title;
@property(nonatomic,strong) UILabel *group5Title;
@property(nonatomic,strong) UILabel *group6Title;


@property(nonatomic,strong) UIView *group1DetailView;
@property(nonatomic,strong) UITextView *group1Pro1;
@property(nonatomic,strong) HMCustomSwitch *group1Switch1;

@property(nonatomic,strong) UIView *group2DetailView;
@property(nonatomic,strong) UITextView *group2Pro1;
@property(nonatomic,strong) HMCustomSwitch *group2Switch1;


@property(nonatomic,strong) UIView *group3DetailView;
@property(nonatomic,strong) UITextView *group3Pro1;
@property(nonatomic,strong) HMCustomSwitch *group3Switch1;
@property(nonatomic,strong) UITextView *group3Pro2;
@property(nonatomic,strong) HMCustomSwitch *group3Switch2;
@property(nonatomic,strong) UITextView *group3Pro3;
@property(nonatomic,strong) HMCustomSwitch *group3Switch3;


@property(nonatomic,strong) UIView *group4DetailView;
@property(nonatomic,strong) UITextView *group4Pro1;
@property(nonatomic,strong) HMCustomSwitch *group4Switch1;
@property(nonatomic,strong) UITextView *group4Pro2;
@property(nonatomic,strong) HMCustomSwitch *group4Switch2;
@property(nonatomic,strong) UITextView *group4Pro3;
@property(nonatomic,strong) HMCustomSwitch *group4Switch3;
@property(nonatomic,strong) UITextView *group4Pro4;
@property(nonatomic,strong) HMCustomSwitch *group4Switch4;


@property(nonatomic,strong) UIView *group5DetailView;
@property(nonatomic,strong) UITextView *group5Pro1;
@property(nonatomic,strong) UILabel *group5Switch1;
@property(nonatomic,strong) UITextView *group5Pro2;
@property(nonatomic,strong) HMCustomSwitch *group5Switch2;
@property(nonatomic,strong) UITextView *group5Pro3;
@property(nonatomic,strong) HMCustomSwitch *group5Switch3;
@property(nonatomic,strong) UITextView *group5Pro4;
@property(nonatomic,strong) HMCustomSwitch *group5Switch4;
@property(nonatomic,strong) UITextView *group5Pro5;
@property(nonatomic,strong) HMCustomSwitch *group5Switch5;

@property(nonatomic,strong) UIView *group6DetailView;
@property(nonatomic,strong) UITextView *group6Pro1;
@property(nonatomic,strong) HMCustomSwitch *group6Switch1;
@property(nonatomic,strong) UITextView *group6Pro2;
@property(nonatomic,strong) HMCustomSwitch *group6Switch2;
@property(nonatomic,strong) UITextView *group6Pro3;
@property(nonatomic,strong) HMCustomSwitch *group6Switch3;
@property(nonatomic,strong) UITextView *group6Pro4;
@property(nonatomic,strong) HMCustomSwitch *group6Switch4;
@property(nonatomic,strong) UITextView *group6Pro5;
@property(nonatomic,strong) HMCustomSwitch *group6Switch5;
@property(nonatomic,strong) UITextView *group6Pro6;
@property(nonatomic,strong) HMCustomSwitch *group6Switch6;


/*其他*/
@property(nonatomic,strong) NSMutableArray *stayArr;
@property(nonatomic,strong) NSMutableArray *foodArr;
@property(nonatomic,strong) NSMutableArray *problemArr;

@property(nonatomic,strong) NSString *stayVal;
@property(nonatomic,strong) NSString *foodVal;
@property(nonatomic,strong) NSString *problemVal;


@end

@implementation ModifyStationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"修改岗位信息";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self startLayout];
}


-(void) startLayout{
    _stayArr = [[NSMutableArray alloc]initWithObjects:@"不提供",@"提供但自费",@"免费住宿",@"其他", nil];
    _foodArr = [[NSMutableArray alloc]initWithObjects:@"不提供",@"提供但自费",@"免费提供",@"其他", nil];
    _problemArr = [[NSMutableArray alloc]initWithObjects:@"学校",@"教师",@"自己联系",@"其他", nil];
    

    
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_NAVBAR + HEIGHT_STATUSBAR, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_STATUSBAR - HEIGHT_NAVBAR - HEIGHT_TABBAR);
    [self.view addSubview:_contentView];
    
    _modifyBtn = [[UIButton alloc]init];
    _modifyBtn.frame = CGRectMake(0, _contentView.frame.size.height + _contentView.frame.origin.y, self.view.frame.size.width, HEIGHT_TABBAR);
        [_modifyBtn setTitle:@"修改岗位" forState:UIControlStateNormal];
    _modifyBtn.backgroundColor = [UIColor colorWithRed:23/255.0 green:194/255.0 blue:149/255.0 alpha:1];
    [_modifyBtn addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_modifyBtn];
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((_contentView.frame.size.width - 100)/2, (_contentView.frame.size.height - 200)/2, 100, 100);
    [_contentView addSubview:_activityIndicatorView];
    _activityIndicatorView.layer.zPosition = 1000;
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, _contentView.frame.size.height * 4.3);
    [_contentView addSubview:_scrollView];
    
    
    [self handleHttp];
}


-(void) handleHttp{
    [_activityIndicatorView startAnimating];
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipApplyEnterpriseInfo/GetByID?ApplyID=%@",kCacheHttpRoot,_ID];
    NSLog(@"%@",url);
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
            [self detailLayout:[jsonDic objectForKey:@"AppendData"]];
        }
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败--获取申请详情");
    }];
}



-(void) detailLayout:(NSArray *)dataArr{
    NSLog(@"%@",dataArr);
    
    dataArr = [GJToolsHelp processDictionaryIsNSNull:dataArr];

    dataArr = [GJToolsHelp processDictionaryIsNSNull:dataArr];
    _applyID = [[[dataArr objectAtIndex:0] objectForKey:@"ID"] stringValue];
    _companyID = [[[dataArr objectAtIndex:0]objectForKey:@"EnterpriseID"] stringValue];
    _stationID = [[[dataArr objectAtIndex:0]objectForKey:@"PositionID"] stringValue];
    /*******************************第一页内容*******************************/
    _titleView = [[UIView alloc]init];
    _titleView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height * 0.05);
    [_scrollView addSubview:_titleView];
    
    _titleLab = [[UILabel alloc]init];
    _titleLab.frame = CGRectMake(_titleView.frame.size.width * 0.05, 0, _titleView.frame.size.width * 0.45, _titleView.frame.size.height);
    _titleLab.text = @"企业信息";
    _titleLab.font = [UIFont systemFontOfSize:13.0];
    _titleLab.textColor = [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1];
    [_titleView addSubview:_titleLab];
    
    _companyView = [[UIView alloc]init];
    _companyView.frame = CGRectMake(0, _titleView.frame.origin.y + _titleView.frame.size.height, _scrollView.frame.size.width, _scrollView.frame.size.height * 0.08);
    _companyView.backgroundColor = [UIColor whiteColor];
    _companyView.userInteractionEnabled = YES;
    [_scrollView addSubview:_companyView];
    
    _companyLab = [[UILabel alloc]init];
    _companyLab.frame = CGRectMake(_companyView.frame.size.width * 0.05, 0, _companyView.frame.size.width * 0.45, _companyView.frame.size.height);
    _companyLab.text = @"企业名称";
    _companyLab.textColor = [UIColor blackColor];
    _companyLab.font = [UIFont systemFontOfSize:18.0];
    [_companyView addSubview:_companyLab];
    
    
    _companyField = [[UILabel alloc]init];
    _companyField.frame = CGRectMake(_companyLab.frame.origin.x + _companyLab.frame.size.width, 0, _companyView.frame.size.width * 0.45, _companyView.frame.size.height);
    _companyField.text = @"请输入";
    _companyField.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:205/255.0 alpha:1];
    _companyField.textAlignment = UITextAlignmentRight;
    _companyField.font = [UIFont systemFontOfSize:18.0];
    _companyField.userInteractionEnabled = YES;
    UITapGestureRecognizer *companyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyAction:)];
    [_companyField addGestureRecognizer:companyTap];
    _companyField.text = [[dataArr objectAtIndex:0] objectForKey:@"EnterpriseName"];
    _companyField.textColor = [UIColor blackColor];
    [_companyView addSubview:_companyField];
    
    
    UIView * line1 = [[UIView alloc]init];
    line1.frame = CGRectMake(_companyView.frame.size.width * 0.05, _companyView.frame.size.height - 1, _companyView.frame.size.width * 0.95, 1);
    line1.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_companyView addSubview:line1];
    
    
    _companyCodeView = [[UIView alloc]init];
    _companyCodeView.frame = CGRectMake(0, _companyView.frame.origin.y + _companyView.frame.size.height, _scrollView.frame.size.width, _scrollView.frame.size.height * 0.08);
    _companyCodeView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_companyCodeView];
    
    _companyCodeLab = [[UILabel alloc]init];
    _companyCodeLab.frame = CGRectMake(_companyCodeView.frame.size.width * 0.05, 0, _companyCodeView.frame.size.width * 0.45, _companyCodeView.frame.size.height);
    _companyCodeLab.text = @"企业代码";
    _companyCodeLab.textColor = [UIColor blackColor];
    _companyCodeLab.font = [UIFont systemFontOfSize:18.0];
    [_companyCodeView addSubview:_companyCodeLab];
    
    
    _companyCodeField = [[BaseTextFeild alloc]init];
    _companyCodeField.frame = CGRectMake(_companyCodeLab.frame.origin.x + _companyCodeLab.frame.size.width, 0, _companyCodeView.frame.size.width * 0.45, _companyCodeView.frame.size.height);
    _companyCodeField.placeholder = @"请输入";
    _companyCodeField.textAlignment = UITextAlignmentRight;
    _companyCodeField.font = [UIFont systemFontOfSize:18.0];
    
    _companyCodeField.text = [[dataArr objectAtIndex:0] objectForKey:@"CreditCode"];
    [_companyCodeView addSubview:_companyCodeField];
    _companyCodeField.delegate = self;
    
    
    
    
    UIView * line2 = [[UIView alloc]init];
    line2.frame = CGRectMake(_companyCodeView.frame.size.width * 0.05, _companyCodeView.frame.size.height - 1, _companyCodeView.frame.size.width * 0.95, 1);
    line2.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_companyCodeView addSubview:line2];
    
    
    _addressView = [[UIView alloc]init];
    _addressView.frame = CGRectMake(0, _companyCodeView.frame.origin.y + _companyCodeView.frame.size.height, _scrollView.frame.size.width, _scrollView.frame.size.height * 0.08);
    _addressView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_addressView];
    
    _addressLab = [[UILabel alloc]init];
    _addressLab.frame = CGRectMake(_addressView.frame.size.width * 0.05, 0, _addressView.frame.size.width * 0.45, _addressView.frame.size.height);
    _addressLab.text = @"企业地址";
    _addressLab.textColor = [UIColor blackColor];
    _addressLab.font = [UIFont systemFontOfSize:18.0];
    [_addressView addSubview:_addressLab];
    
    
    _addressField = [[BaseTextFeild alloc]init];
    _addressField.frame = CGRectMake(_addressLab.frame.origin.x + _addressLab.frame.size.width, 0, _addressView.frame.size.width * 0.45, _addressView.frame.size.height);
    _addressField.placeholder = @"请输入";
    _addressField.textAlignment = UITextAlignmentRight;
    _addressField.font = [UIFont systemFontOfSize:18.0];
    _addressField.text = [[dataArr objectAtIndex:0] objectForKey:@"Address"];
    [_addressView addSubview:_addressField];
    _addressField.delegate = self;
    
    UIView * line3 = [[UIView alloc]init];
    line3.frame = CGRectMake(_addressView.frame.size.width * 0.05, _addressView.frame.size.height - 1, _addressView.frame.size.width * 0.95, 1);
    line3.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_addressView addSubview:line3];
    
    
    _peopleCountView = [[UIView alloc]init];
    _peopleCountView.frame = CGRectMake(0, _addressView.frame.origin.y + _addressView.frame.size.height, _scrollView.frame.size.width, _scrollView.frame.size.height * 0.08);
    _peopleCountView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_peopleCountView];
    
    _peopleCountLab = [[UILabel alloc]init];
    _peopleCountLab.frame = CGRectMake(_peopleCountView.frame.size.width * 0.05, 0, _peopleCountView.frame.size.width * 0.45, _peopleCountView.frame.size.height);
    _peopleCountLab.text = @"员工总数";
    _peopleCountLab.textColor = [UIColor blackColor];
    _peopleCountLab.font = [UIFont systemFontOfSize:18.0];
    [_peopleCountView addSubview:_peopleCountLab];
    
    
    _peopleCountField = [[BaseTextFeild alloc]init];
    _peopleCountField.frame = CGRectMake(_peopleCountLab.frame.origin.x + _peopleCountLab.frame.size.width, 0, _peopleCountView.frame.size.width * 0.45, _peopleCountView.frame.size.height);
    _peopleCountField.placeholder = @"请输入";
    _peopleCountField.textAlignment = UITextAlignmentRight;
    _peopleCountField.font = [UIFont systemFontOfSize:18.0];
    _peopleCountField.text = [[[dataArr objectAtIndex:0] objectForKey:@"StaffTotal"] stringValue];
    [_peopleCountView addSubview:_peopleCountField];
    _peopleCountField.delegate = self;
    
    UIView * line4 = [[UIView alloc]init];
    line4.frame = CGRectMake(_peopleCountView.frame.size.width * 0.05, _peopleCountView.frame.size.height - 1, _peopleCountView.frame.size.width * 0.95, 1);
    line4.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_peopleCountView addSubview:line4];
    
    
    _baseView = [[UIView alloc]init];
    _baseView.frame = CGRectMake(0, _peopleCountView.frame.origin.y + _peopleCountView.frame.size.height, _scrollView.frame.size.width, _scrollView.frame.size.height * 0.08);
    _baseView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_baseView];
    
    _baseLab = [[UILabel alloc]init];
    _baseLab.frame = CGRectMake(_baseView.frame.size.width * 0.05, 0, _baseView.frame.size.width * 0.45, _baseView.frame.size.height);
    _baseLab.text = @"是否实习基地";
    _baseLab.textColor = [UIColor blackColor];
    _baseLab.font = [UIFont systemFontOfSize:18.0];
    [_baseView addSubview:_baseLab];
    
    
    _baseField = [[UIView alloc]init];
    _baseField.frame = CGRectMake(_baseLab.frame.origin.x + _baseLab.frame.size.width, 0, _baseView.frame.size.width * 0.45, _baseView.frame.size.height);
    [_baseView addSubview:_baseField];
    
//    _baseSwitch = [[UISwitch alloc]init];
//    _baseSwitch.frame = CGRectMake(_baseField.frame.size.width * 0.7, _baseField.frame.size.height * 0.15, _baseField.frame.size.width * 0.3, _baseField.frame.size.height * 0.7);
//    if([[[dataArr objectAtIndex:0] objectForKey:@"IsPracticeBase"] boolValue]){
//        _baseSwitch.on = true;
//    }else{
//        _baseSwitch.on = false;
//    }
//    [_baseField addSubview:_baseSwitch];
    _baseSwitch = [[UILabel alloc]init];
    _baseSwitch.frame = CGRectMake(_baseField.frame.size.width * 0.7, _baseField.frame.size.height * 0.15, _baseField.frame.size.width * 0.3, _baseField.frame.size.height * 0.7);
    NSString *BaseStr = @"";
    UIColor *BaseColor = nil;
    if([[[dataArr objectAtIndex:0] objectForKey:@"IsPracticeBase"] boolValue]){
        BaseStr = @"是";
        BaseColor = [UIColor colorWithRed:23/255.0 green:194/255.0 blue:149/255.0 alpha:1];
    }else{
        BaseStr = @"否";
        BaseColor = [UIColor redColor];
    }
    _baseSwitch.text = BaseStr;
    _baseSwitch.textColor = BaseColor;
    _baseSwitch.textAlignment = UITextAlignmentRight;
    [_baseField addSubview:_baseSwitch];
    
    
    /*******************************第二页内容*******************************/
    
    _titleView1 = [[UIView alloc]init];
    _titleView1.frame = CGRectMake(0, _baseView.frame.size.height + _baseView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height * 0.05);
    [_scrollView addSubview:_titleView1];
    
    _titleLab1 = [[UILabel alloc]init];
    _titleLab1.frame = CGRectMake(_titleView1.frame.size.width * 0.05, 0, _titleView1.frame.size.width * 0.45, _titleView1.frame.size.height);
    _titleLab1.text = @"岗位信息";
    _titleLab1.font = [UIFont systemFontOfSize:13.0];
    _titleLab1.textColor = [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1];
    [_titleView1 addSubview:_titleLab1];
    
    _stationView = [[UIView alloc]init];
    _stationView.frame = CGRectMake(0, _titleView1.frame.origin.y + _titleView1.frame.size.height, _scrollView.frame.size.width, _scrollView.frame.size.height * 0.08);
    _stationView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_stationView];
    
    _stationLab = [[UILabel alloc]init];
    _stationLab.frame = CGRectMake(_stationView.frame.size.width * 0.05, 0, _stationView.frame.size.width * 0.45, _stationView.frame.size.height);
    _stationLab.text = @"岗位";
    _stationLab.textColor = [UIColor blackColor];
    _stationLab.font = [UIFont systemFontOfSize:18.0];
    [_stationView addSubview:_stationLab];
    
    
    _stationField = [[UILabel alloc]init];
    _stationField.frame = CGRectMake(_stationLab.frame.origin.x + _stationLab.frame.size.width, 0, _stationView.frame.size.width * 0.45, _stationView.frame.size.height);
    _stationField.text = @"请输入";
    _stationField.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:205/255.0 alpha:1];
    _stationField.textAlignment = UITextAlignmentRight;
    _stationField.font = [UIFont systemFontOfSize:18.0];
    UITapGestureRecognizer *stationTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stationAction:)];
    [_stationField addGestureRecognizer:stationTap];
    _stationField.userInteractionEnabled = YES;
    _stationField.text = [[dataArr objectAtIndex:0] objectForKey:@"PositionName"];
    _stationField.textColor = [UIColor blackColor];
    [_stationView addSubview:_stationField];
    
    UIView * line11 = [[UIView alloc]init];
    line11.frame = CGRectMake(_stationView.frame.size.width * 0.05, _stationView.frame.size.height - 1, _stationView.frame.size.width * 0.95, 1);
    line11.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_stationView addSubview:line11];
    
    
    _stationPeopleView = [[UIView alloc]init];
    _stationPeopleView.frame = CGRectMake(0, _stationView.frame.origin.y + _stationView.frame.size.height, _scrollView.frame.size.width, _scrollView.frame.size.height * 0.08);
    _stationPeopleView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_stationPeopleView];
    
    _stationPeopleLab = [[UILabel alloc]init];
    _stationPeopleLab.frame = CGRectMake(_stationPeopleView.frame.size.width * 0.05, 0, _stationPeopleView.frame.size.width * 0.45, _stationPeopleView.frame.size.height);
    _stationPeopleLab.text = @"在岗员工数";
    _stationPeopleLab.textColor = [UIColor blackColor];
    _stationPeopleLab.font = [UIFont systemFontOfSize:18.0];
    [_stationPeopleView addSubview:_stationPeopleLab];
    
    
    _stationPeopleField = [[BaseTextFeild alloc]init];
    _stationPeopleField.frame = CGRectMake(_stationPeopleLab.frame.origin.x + _stationPeopleLab.frame.size.width, 0, _stationPeopleView.frame.size.width * 0.45, _stationPeopleView.frame.size.height);
    _stationPeopleField.placeholder = @"请输入";
    _stationPeopleField.text = [[[dataArr objectAtIndex:0] objectForKey:@"PStaffTotal"] stringValue];
    _stationPeopleField.textAlignment = UITextAlignmentRight;
    _stationPeopleField.font = [UIFont systemFontOfSize:18.0];
    [_stationPeopleView addSubview:_stationPeopleField];
    _stationPeopleField.delegate = self;
    
    
    UIView * line21 = [[UIView alloc]init];
    line21.frame = CGRectMake(_stationPeopleView.frame.size.width * 0.05, _stationPeopleView.frame.size.height - 1, _stationPeopleView.frame.size.width * 0.95, 1);
    line21.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_stationPeopleView addSubview:line2];
    
    
    _stationInstrView = [[UIView alloc]init];
    _stationInstrView.frame = CGRectMake(0, _stationPeopleView.frame.origin.y + _stationPeopleView.frame.size.height, _scrollView.frame.size.width, _scrollView.frame.size.height * 0.08);
    _stationInstrView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_stationInstrView];
    
    _stationInstrLab = [[UILabel alloc]init];
    _stationInstrLab.frame = CGRectMake(_stationInstrView.frame.size.width * 0.05, 0, _stationInstrView.frame.size.width * 0.45, _stationInstrView.frame.size.height);
    _stationInstrLab.text = @"岗位简介";
    _stationInstrLab.textColor = [UIColor blackColor];
    _stationInstrLab.font = [UIFont systemFontOfSize:18.0];
    [_stationInstrView addSubview:_stationInstrLab];
    
    
    _stationInstrField = [[BaseTextFeild alloc]init];
    _stationInstrField.frame = CGRectMake(_stationInstrLab.frame.origin.x + _stationInstrLab.frame.size.width, 0, _stationInstrView.frame.size.width * 0.45, _stationInstrView.frame.size.height);
    _stationInstrField.placeholder = @"请输入";
    _stationInstrField.text = [[dataArr objectAtIndex:0] objectForKey:@"PDescription"] == [NSNull null]?@"无":[[dataArr objectAtIndex:0] objectForKey:@"PDescription"];
    _stationInstrField.textAlignment = UITextAlignmentRight;
    _stationInstrField.font = [UIFont systemFontOfSize:18.0];
    [_stationInstrView addSubview:_stationInstrField];
    _stationInstrField.delegate = self;
    
    
    /*******************************第三页内容*******************************/
    _titleView2 = [[UIView alloc]init];
    _titleView2.frame = CGRectMake(0, _stationInstrView.frame.size.height + _stationInstrView.frame.origin.y, _contentView.frame.size.width, _scrollView.frame.size.height * 0.05);
    [_scrollView addSubview:_titleView2];
    
    _titleLab2 = [[UILabel alloc]init];
    _titleLab2.frame = CGRectMake(_titleView2.frame.size.width * 0.05, 0, _titleView2.frame.size.width * 0.45, _titleView2.frame.size.height);
    _titleLab2.text = @"指导教师";
    _titleLab2.font = [UIFont systemFontOfSize:13.0];
    _titleLab2.textColor = [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1];
    [_titleView2 addSubview:_titleLab2];
    
    
    _teacherView = [[UIView alloc]init];
    _teacherView.frame = CGRectMake(0, _titleView2.frame.origin.y + _titleView2.frame.size.height, _contentView.frame.size.width, _scrollView.frame.size.height * 0.08);
    _teacherView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_teacherView];
    
    _teacherLab = [[UILabel alloc]init];
    _teacherLab.frame = CGRectMake(_teacherView.frame.size.width * 0.05, 0, _teacherView.frame.size.width * 0.45, _teacherView.frame.size.height);
    _teacherLab.text = @"企业指导师傅";
    _teacherLab.textColor = [UIColor blackColor];
    _teacherLab.font = [UIFont systemFontOfSize:18.0];
    [_teacherView addSubview:_teacherLab];
    
    
    _teacherField = [[UILabel alloc]init];
    _teacherField.frame = CGRectMake(_teacherLab.frame.origin.x + _teacherLab.frame.size.width, 0, _teacherView.frame.size.width * 0.45, _teacherView.frame.size.height);
    _teacherField.text = [[dataArr objectAtIndex:0] objectForKey:@"LinkManName"];
    _teacherField.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:205/255.0 alpha:1];
    _teacherField.textAlignment = UITextAlignmentRight;
    _teacherField.font = [UIFont systemFontOfSize:18.0];
    _teacherField.userInteractionEnabled = YES;
    _teacherField.textColor = [UIColor blackColor];
    UITapGestureRecognizer *teacherTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teacherAction:)];
    [_teacherField addGestureRecognizer:teacherTap];
    [_teacherView addSubview:_teacherField];
    
    UIView * line12 = [[UIView alloc]init];
    line12.frame = CGRectMake(_teacherView.frame.size.width * 0.05, _teacherView.frame.size.height - 1, _teacherView.frame.size.width * 0.95, 1);
    line12.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_teacherView addSubview:line12];
    
    
    
    _mobileView = [[UIView alloc]init];
    _mobileView.frame = CGRectMake(0, _teacherView.frame.origin.y + _teacherView.frame.size.height, _contentView.frame.size.width, _scrollView.frame.size.height * 0.08);
    _mobileView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_mobileView];
    
    _mobileLab = [[UILabel alloc]init];
    _mobileLab.frame = CGRectMake(_mobileView.frame.size.width * 0.05, 0, _mobileView.frame.size.width * 0.45, _mobileView.frame.size.height);
    _mobileLab.text = @"师傅手机";
    _mobileLab.textColor = [UIColor blackColor];
    _mobileLab.font = [UIFont systemFontOfSize:18.0];
    [_mobileView addSubview:_mobileLab];
    
    
    _mobileField = [[BaseTextFeild alloc]init];
    _mobileField.frame = CGRectMake(_mobileLab.frame.origin.x + _mobileLab.frame.size.width, 0, _mobileView.frame.size.width * 0.45, _mobileView.frame.size.height);
    _mobileField.placeholder = @"请输入";
    _mobileField.text = [[dataArr objectAtIndex:0] objectForKey:@"LinkManMobile"];
    _mobileField.textAlignment = UITextAlignmentRight;
    _mobileField.font = [UIFont systemFontOfSize:18.0];
    _mobileField.delegate = self;
    
    [_mobileView addSubview:_mobileField];
    
    UIView * line22 = [[UIView alloc]init];
    line22.frame = CGRectMake(_mobileView.frame.size.width * 0.05, _mobileView.frame.size.height - 1, _mobileView.frame.size.width * 0.95, 1);
    line22.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_mobileView addSubview:line22];
    
    
    _phoneView = [[UIView alloc]init];
    _phoneView.frame = CGRectMake(0, _mobileView.frame.origin.y + _mobileView.frame.size.height, _contentView.frame.size.width, _scrollView.frame.size.height * 0.08);
    _phoneView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_phoneView];
    
    _phoneLab = [[UILabel alloc]init];
    _phoneLab.frame = CGRectMake(_phoneView.frame.size.width * 0.05, 0, _phoneView.frame.size.width * 0.45, _phoneView.frame.size.height);
    _phoneLab.text = @"师傅固话";
    _phoneLab.textColor = [UIColor blackColor];
    _phoneLab.font = [UIFont systemFontOfSize:18.0];
    [_phoneView addSubview:_phoneLab];
    
    
    _phoneField = [[BaseTextFeild alloc]init];
    _phoneField.frame = CGRectMake(_phoneLab.frame.origin.x + _phoneLab.frame.size.width, 0, _phoneView.frame.size.width * 0.45, _phoneView.frame.size.height);
    _phoneField.placeholder = @"请输入";
    _phoneField.text = [[dataArr objectAtIndex:0] objectForKey:@"LinkManTel"] == [NSNull null]?@"无":[[dataArr objectAtIndex:0] objectForKey:@"LinkManTel"];
    _phoneField.textAlignment = UITextAlignmentRight;
    _phoneField.font = [UIFont systemFontOfSize:18.0];
    [_phoneView addSubview:_phoneField];
    _phoneField.delegate = self;
    _phoneField.keyboardType = UIKeyboardTypeNumberPad;
    
    UIView * line32 = [[UIView alloc]init];
    line32.frame = CGRectMake(_phoneView.frame.size.width * 0.05, _phoneView.frame.size.height - 1, _phoneView.frame.size.width * 0.95, 1);
    line32.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_phoneView addSubview:line32];
    
    
    _emailView = [[UIView alloc]init];
    _emailView.frame = CGRectMake(0, _phoneView.frame.origin.y + _phoneView.frame.size.height, _contentView.frame.size.width, _scrollView.frame.size.height * 0.08);
    _emailView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_emailView];
    
    _emailLab = [[UILabel alloc]init];
    _emailLab.frame = CGRectMake(_emailView.frame.size.width * 0.05, 0, _emailView.frame.size.width * 0.45, _emailView.frame.size.height);
    _emailLab.text = @"师傅邮箱";
    _emailLab.textColor = [UIColor blackColor];
    _emailLab.font = [UIFont systemFontOfSize:18.0];
    [_emailView addSubview:_emailLab];
    
    
    _emailField = [[BaseTextFeild alloc]init];
    _emailField.frame = CGRectMake(_emailLab.frame.origin.x + _emailLab.frame.size.width, 0, _emailView.frame.size.width * 0.45, _emailView.frame.size.height);
    _emailField.placeholder = @"请输入";
    _emailField.text = [[dataArr objectAtIndex:0] objectForKey:@"LinkManEmail"];
    _emailField.textAlignment = UITextAlignmentRight;
    _emailField.font = [UIFont systemFontOfSize:18.0];
    [_emailView addSubview:_emailField];
    _emailField.delegate = self;
    _emailField.keyboardType = UIKeyboardTypeEmailAddress;
    
    UIView * line42 = [[UIView alloc]init];
    line42.frame = CGRectMake(_emailView.frame.size.width * 0.05, _emailView.frame.size.height - 1, _emailView.frame.size.width * 0.95, 1);
    line42.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_emailView addSubview:line42];
    
    
    
    
    
    /*******************************第四页内容*******************************/
    _titleView3 = [[UIView alloc]init];
    _titleView3.frame = CGRectMake(0, _emailView.frame.size.height + _emailView.frame.origin.y, _contentView.frame.size.width, _scrollView.frame.size.height * 0.05);
    [_scrollView addSubview:_titleView3];
    
    _titleLab3 = [[UILabel alloc]init];
    _titleLab3.frame = CGRectMake(_titleView3.frame.size.width * 0.05, 0, _titleView3.frame.size.width * 0.45, _titleView3.frame.size.height);
    _titleLab3.text = @"入职资料";
    _titleLab3.font = [UIFont systemFontOfSize:13.0];
    _titleLab3.textColor = [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1];
    [_titleView3 addSubview:_titleLab3];
    
    
    _salaryView = [[UIView alloc]init];
    _salaryView.frame = CGRectMake(0, _titleView3.frame.origin.y + _titleView3.frame.size.height, _contentView.frame.size.width, _scrollView.frame.size.height * 0.08);
    _salaryView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_salaryView];
    
    _salaryLab = [[UILabel alloc]init];
    _salaryLab.frame = CGRectMake(_salaryView.frame.size.width * 0.05, 0, _salaryView.frame.size.width * 0.45, _salaryView.frame.size.height);
    _salaryLab.text = @"月薪收入";
    _salaryLab.textColor = [UIColor blackColor];
    _salaryLab.font = [UIFont systemFontOfSize:18.0];
    [_salaryView addSubview:_salaryLab];
    
    
    _salaryField = [[BaseTextFeild alloc]init];
    _salaryField.frame = CGRectMake(_salaryLab.frame.origin.x + _salaryLab.frame.size.width, 0, _salaryView.frame.size.width * 0.45, _salaryView.frame.size.height);
    _salaryField.placeholder = @"请输入";
    _salaryField.text = [[[dataArr objectAtIndex:0] objectForKey:@"MonthlySalary"] stringValue];
    _salaryField.textAlignment = UITextAlignmentRight;
    _salaryField.font = [UIFont systemFontOfSize:18.0];
    _salaryField.keyboardType = UIKeyboardTypeDecimalPad;
    [_salaryView addSubview:_salaryField];
    _salaryField.delegate  = self;
    
    UIView * line13 = [[UIView alloc]init];
    line13.frame = CGRectMake(_salaryView.frame.size.width * 0.05, _salaryView.frame.size.height - 1, _salaryView.frame.size.width * 0.95, 1);
    line13.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_salaryView addSubview:line13];
    
    
    
    _postDateView = [[UIView alloc]init];
    _postDateView.frame = CGRectMake(0, _salaryView.frame.origin.y + _salaryView.frame.size.height, _contentView.frame.size.width, _scrollView.frame.size.height * 0.08);
    _postDateView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_postDateView];
    
    _postDateLab = [[UILabel alloc]init];
    _postDateLab.frame = CGRectMake(_postDateView.frame.size.width * 0.05, 0, _postDateView.frame.size.width * 0.45, _postDateView.frame.size.height);
    _postDateLab.text = @"上岗日期";
    _postDateLab.textColor = [UIColor blackColor];
    _postDateLab.font = [UIFont systemFontOfSize:18.0];
    [_postDateView addSubview:_postDateLab];
    
    
    _postDateField = [[BaseTextFeild alloc]init];
    _postDateField.frame = CGRectMake(_postDateLab.frame.origin.x + _postDateLab.frame.size.width, 0, _postDateView.frame.size.width * 0.45, _postDateView.frame.size.height);
    _postDateField.text = @"请输入";
    _postDateField.textAlignment = UITextAlignmentRight;
    _postDateField.font = [UIFont systemFontOfSize:18.0];
    _postDateField.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:205/255.0 alpha:1];
    UITapGestureRecognizer *dateTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateAction:)];
    [_postDateField addGestureRecognizer:dateTap];
    NSString *DateStr = [PhoneInfo handleDateStr:[[dataArr objectAtIndex:0] objectForKey:@"ComeWorkDate"] handleFormat:@"yyyy-MM-dd"];
    _postDateField.text = DateStr;
    _postDateField.textColor = [UIColor blackColor];
    [_postDateView addSubview:_postDateField];
    
    UIView * line23 = [[UIView alloc]init];
    line23.frame = CGRectMake(_postDateView.frame.size.width * 0.05, _postDateView.frame.size.height - 1, _postDateView.frame.size.width * 0.95, 1);
    line23.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_postDateView addSubview:line23];
    
    
    _stayView = [[UIView alloc]init];
    _stayView.frame = CGRectMake(0, _postDateView.frame.origin.y + _postDateView.frame.size.height, _contentView.frame.size.width, _scrollView.frame.size.height * 0.08);
    _stayView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_stayView];
    
    _stayLab = [[UILabel alloc]init];
    _stayLab.frame = CGRectMake(_stayView.frame.size.width * 0.05, 0, _stayView.frame.size.width * 0.45, _stayView.frame.size.height);
    _stayLab.text = @"是否提供住宿";
    _stayLab.textColor = [UIColor blackColor];
    _stayLab.font = [UIFont systemFontOfSize:18.0];
    [_stayView addSubview:_stayLab];
    
    
    _stayField = [[BaseTextFeild alloc]init];
    _stayField.frame = CGRectMake(_stayLab.frame.origin.x + _stayLab.frame.size.width, 0, _stayView.frame.size.width * 0.45, _stayView.frame.size.height);
    _stayField.placeholder = @"请输入";
    _stayField.textAlignment = UITextAlignmentRight;
    _stayField.font = [UIFont systemFontOfSize:18.0];
    _stayField.keyboardType = UIKeyboardTypeDecimalPad;
    UITapGestureRecognizer *stayTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stayAction:)];
    [_stayField addGestureRecognizer:stayTap];
    [_stayView addSubview:_stayField];

    NSString *stayStr = @"";
    if([[[dataArr objectAtIndex:0] objectForKey:@"AccommodationType"] integerValue] == 0){
        stayStr = @"不提供";
        _stayVal = @"0";
    }else if([[[dataArr objectAtIndex:0] objectForKey:@"AccommodationType"] integerValue] == 1){
        stayStr = @"提供但自费";
        _stayVal = @"1";
    }else if([[[dataArr objectAtIndex:0] objectForKey:@"AccommodationType"] integerValue] == 2){
        stayStr = @"免费住宿";
        _stayVal = @"2";
    }else if([[[dataArr objectAtIndex:0] objectForKey:@"AccommodationType"] integerValue] == 3){
        stayStr = @"其他";
        _stayVal = @"3";
    }
    _stayField.text = stayStr;
    
    
    
    
    UIView * line33 = [[UIView alloc]init];
    line33.frame = CGRectMake(_stayView.frame.size.width * 0.05, _stayView.frame.size.height - 1, _stayView.frame.size.width * 0.95, 1);
    line33.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_salaryView addSubview:line33];
    
    
    _foodView = [[UIView alloc]init];
    _foodView.frame = CGRectMake(0, _stayView.frame.origin.y + _stayView.frame.size.height, _contentView.frame.size.width, _scrollView.frame.size.height * 0.08);
    _foodView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_foodView];
    
    _foodLab = [[UILabel alloc]init];
    _foodLab.frame = CGRectMake(_foodView.frame.size.width * 0.05, 0, _foodView.frame.size.width * 0.45, _foodView.frame.size.height);
    _foodLab.text = @"是否提供伙食";
    _foodLab.textColor = [UIColor blackColor];
    _foodLab.font = [UIFont systemFontOfSize:18.0];
    [_foodView addSubview:_foodLab];
    
    
    _foodField = [[BaseTextFeild alloc]init];
    _foodField.frame = CGRectMake(_foodLab.frame.origin.x + _foodLab.frame.size.width, 0, _foodView.frame.size.width * 0.45, _foodView.frame.size.height);
    _foodField.placeholder = @"请输入";
    _foodField.textAlignment = UITextAlignmentRight;
    _foodField.font = [UIFont systemFontOfSize:18.0];
    _foodField.keyboardType = UIKeyboardTypeDecimalPad;
    UITapGestureRecognizer *foodTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(foodAction:)];
    [_foodField addGestureRecognizer:foodTap];
    [_foodView addSubview:_foodField];
    
    NSString *foodStr = @"";
    if([[[dataArr objectAtIndex:0] objectForKey:@"FoodType"] integerValue] == 0){
        foodStr = @"不提供";
        _foodVal = @"0";
    }else if([[[dataArr objectAtIndex:0] objectForKey:@"FoodType"] integerValue] == 1){
        foodStr = @"提供但自费";
        _foodVal = @"1";
    }else if([[[dataArr objectAtIndex:0] objectForKey:@"FoodType"] integerValue] == 2){
        foodStr = @"免费提供";
        _foodVal = @"2";
    }else if([[[dataArr objectAtIndex:0] objectForKey:@"FoodType"] integerValue] == 3){
        foodStr = @"其他";
        _foodVal = @"3";
    }
    _foodField.text = foodStr;
    
    
    
    UIView * line43 = [[UIView alloc]init];
    line43.frame = CGRectMake(_foodView.frame.size.width * 0.05, _foodView.frame.size.height - 1, _foodView.frame.size.width * 0.95, 1);
    line43.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_foodView addSubview:line43];
    
    
    
    _agreementView = [[UIView alloc]init];
//    _agreementView.frame = CGRectMake(0, _foodView.frame.origin.y + _foodView.frame.size.height, _contentView.frame.size.width, _scrollView.frame.size.height * 0.08);
    _agreementView.frame = CGRectMake(0, _foodView.frame.origin.y + _foodView.frame.size.height, _contentView.frame.size.width, 0);
    _agreementView.hidden = YES;
    _agreementView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_agreementView];
    
    _agreementLab = [[UILabel alloc]init];
    _agreementLab.frame = CGRectMake(_agreementView.frame.size.width * 0.05, 0, _agreementView.frame.size.width * 0.45, _agreementView.frame.size.height);
    _agreementLab.text = @"实习协议";
    _agreementLab.textColor = [UIColor blackColor];
    _agreementLab.font = [UIFont systemFontOfSize:18.0];
    [_agreementView addSubview:_agreementLab];
    
    
    _agreementField = [[BaseTextFeild alloc]init];
    _agreementField.frame = CGRectMake(_agreementLab.frame.origin.x + _agreementLab.frame.size.width, 0, _agreementView.frame.size.width * 0.45, _agreementView.frame.size.height);
    _agreementField.placeholder = @"请输入";
    _agreementField.textAlignment = UITextAlignmentRight;
    _agreementField.font = [UIFont systemFontOfSize:18.0];
    _agreementField.keyboardType = UIKeyboardTypeDecimalPad;
    [_agreementView addSubview:_agreementField];
    _agreementField.delegate = self;
    
    UIView * line53 = [[UIView alloc]init];
    line53.frame = CGRectMake(_agreementView.frame.size.width * 0.05, _agreementView.frame.size.height - 1, _agreementView.frame.size.width * 0.95, 1);
    line53.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_agreementView addSubview:line53];
    
    
    _descrView = [[UIView alloc]init];
    _descrView.frame = CGRectMake(0, _agreementView.frame.origin.y + _agreementView.frame.size.height, _contentView.frame.size.width, _scrollView.frame.size.height * 0.08);
    _descrView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_descrView];
    
    _descrLab = [[UILabel alloc]init];
    _descrLab.frame = CGRectMake(_descrView.frame.size.width * 0.05, 0, _descrView.frame.size.width * 0.45, _descrView.frame.size.height);
    _descrLab.text = @"说明";
    _descrLab.textColor = [UIColor blackColor];
    _descrLab.font = [UIFont systemFontOfSize:18.0];
    [_descrView addSubview:_descrLab];
    
    
    _descrField = [[BaseTextFeild alloc]init];
    _descrField.frame = CGRectMake(_descrLab.frame.origin.x + _descrLab.frame.size.width, 0, _descrView.frame.size.width * 0.45, _descrView.frame.size.height);
    _descrField.placeholder = @"请输入";
    _descrField.textAlignment = UITextAlignmentRight;
    _descrField.font = [UIFont systemFontOfSize:18.0];
    _descrField.keyboardType = UIKeyboardTypeDecimalPad;
    _descrField.text = [[dataArr objectAtIndex:0] objectForKey:@"Description"] == [NSNull null]?@"无":[[dataArr objectAtIndex:0] objectForKey:@"Description"];
    [_descrView addSubview:_descrField];
    _descrField.delegate = self;
    
    UIView * line63 = [[UIView alloc]init];
    line63.frame = CGRectMake(_descrView.frame.size.width * 0.05, _descrView.frame.size.height - 1, _descrView.frame.size.width * 0.95, 1);
    line63.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_descrView addSubview:line63];
    
    
    
    /*******************************第五页内容*******************************/
    
    _group1 = [[UIView alloc]init];
    _group1.frame = CGRectMake(_scrollView.frame.size.width * 0.03, _scrollView.frame.size.height * 0.02 + _descrView.frame.size.height + _descrView.frame.origin.y, _scrollView.frame.size.width * 0.94, _scrollView.frame.size.height * 0.05 + _scrollView.frame.size.height * 0.1);
    _group1.layer.cornerRadius = 5;
    _group1.layer.masksToBounds = YES;
    _group1.layer.borderColor = [UIColor grayColor].CGColor;
    _group1.layer.borderWidth = 1;
    _group1.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_group1];
    
    
    _group1Title = [[UILabel alloc]init];
    _group1Title.frame = CGRectMake(0, 0, _group1.frame.size.width, _scrollView.frame.size.height * 0.05);
    _group1Title.backgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    _group1Title.text = @" (一)实习过程一不许";
    _group1Title.textColor = [UIColor whiteColor];
    [_group1 addSubview:_group1Title];
    
    _group1DetailView = [[UIView alloc]init];
    _group1DetailView.frame = CGRectMake(0, _group1Title.frame.origin.y + _group1Title.frame.size.height, _group1.frame.size.width, _scrollView.frame.size.height * 0.1);
    _group1DetailView.backgroundColor = [UIColor whiteColor];
    [_group1 addSubview:_group1DetailView];
    
    _group1Pro1 = [[UITextView alloc]init];
    _group1Pro1.frame = CGRectMake(_group1DetailView.frame.size.width * 0.02, _group1DetailView.frame.size.height * 0.05, _group1DetailView.frame.size.width * 0.68, _group1DetailView.frame.size.height * 0.9);
    _group1Pro1.text = @"1.是否签署实习三方协议？";
    _group1Pro1.textColor = [UIColor blackColor];
    _group1Pro1.font = [UIFont systemFontOfSize:16.0];
    [_group1DetailView addSubview:_group1Pro1];
    
    BRDetailStationModel *detailStation_model = [[BRDetailStationModel alloc] initWithDictionary:[dataArr firstObject] error:nil];
    _group1Switch1 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group1Pro1.frame.origin.x + _group1Pro1.frame.size.width, _group1Pro1.frame.origin.y, _group1DetailView.frame.size.width * 0.25, _group1DetailView.frame.size.height * 0.6)];
    _group1Switch1.on = YES;
    [_group1DetailView addSubview:_group1Switch1];
    
    
    
    /*----------------------------------------------------------------------------------*/
    
    _group2 = [[UIView alloc]init];
    _group2.frame = CGRectMake(_scrollView.frame.size.width * 0.03, _scrollView.frame.size.height * 0.02 + _group1.frame.size.height + _group1.frame.origin.y, _scrollView.frame.size.width * 0.94, _scrollView.frame.size.height * 0.05 + _scrollView.frame.size.height * 0.1);
    _group2.layer.cornerRadius = 5;
    _group2.layer.masksToBounds = YES;
    _group2.layer.borderColor = [UIColor grayColor].CGColor;
    _group2.layer.borderWidth = 1;
    _group2.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_group2];
    
    
    _group2Title = [[UILabel alloc]init];
    _group2Title.frame = CGRectMake(0, 0, _group2.frame.size.width, _scrollView.frame.size.height * 0.05);
    _group2Title.backgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    _group2Title.text = @" (二)专业对口两相关";
    _group2Title.textColor = [UIColor whiteColor];
    [_group2 addSubview:_group2Title];
    
    _group2DetailView = [[UIView alloc]init];
    _group2DetailView.frame = CGRectMake(0, _group2Title.frame.origin.y + _group2Title.frame.size.height, _group2.frame.size.width, _scrollView.frame.size.height * 0.1);
    _group2DetailView.backgroundColor = [UIColor whiteColor];
    [_group2 addSubview:_group2DetailView];
    
    /*RelevantType*/
    _group2Pro1 = [[UITextView alloc]init];
    _group2Pro1.frame = CGRectMake(_group2DetailView.frame.size.width * 0.02, _group2DetailView.frame.size.height * 0.05, _group2DetailView.frame.size.width * 0.68, _group2DetailView.frame.size.height * 0.9);
    _group2Pro1.text = @"1.实习岗位与所学专业相关性？";
    _group2Pro1.textColor = [UIColor blackColor];
    _group2Pro1.font = [UIFont systemFontOfSize:16.0];
    [_group2DetailView addSubview:_group2Pro1];
    
    _group2Switch1 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group2Pro1.frame.origin.x + _group2Pro1.frame.size.width, _group2DetailView.frame.size.height * 0.2, _group2DetailView.frame.size.width * 0.25, _group2DetailView.frame.size.height * 0.6)];
//    if([[dataArr objectAtIndex:0] objectForKey:@"RelevantType"]){
//        _group2Switch1.on = YES;
//    }else{
//        _group2Switch1.on = NO;
//    }
    
    _group2Switch1.on = detailStation_model.RelevantType;
    [_group2DetailView addSubview:_group2Switch1];
    
    
    
    //    /*----------------------------------------------------------------------------------*/
    
    
    _group3 = [[UIView alloc]init];
    _group3.frame = CGRectMake(_scrollView.frame.size.width * 0.03, _scrollView.frame.size.height * 0.02 + _group2.frame.size.height + _group2.frame.origin.y, _scrollView.frame.size.width * 0.94, _scrollView.frame.size.height * 0.05 + _scrollView.frame.size.height * 0.15 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1);
    _group3.layer.cornerRadius = 5;
    _group3.layer.masksToBounds = YES;
    _group3.layer.borderColor = [UIColor grayColor].CGColor;
    _group3.layer.borderWidth = 1;
    _group3.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_group3];
    
    _group3Title = [[UILabel alloc]init];
    _group3Title.frame = CGRectMake(0, 0, _group3.frame.size.width, _scrollView.frame.size.height * 0.05);
    _group3Title.backgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    _group3Title.text = @" (三)工作岗位三不准";
    _group3Title.textColor = [UIColor whiteColor];
    [_group3 addSubview:_group3Title];
    
    _group3DetailView = [[UIView alloc]init];
    _group3DetailView.frame = CGRectMake(0, _group3Title.frame.origin.y + _group3Title.frame.size.height, _group3.frame.size.width, _scrollView.frame.size.height * 0.15 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1);
    _group3DetailView.backgroundColor = [UIColor whiteColor];
    [_group3 addSubview:_group3DetailView];
    
    
    /*IsWorkplace*/
    _group3Pro1 = [[UITextView alloc]init];
    _group3Pro1.frame = CGRectMake(_group3DetailView.frame.size.width * 0.02, _group3DetailView.frame.size.height * 0.05, _group3DetailView.frame.size.width * 0.68, _scrollView.frame.size.height * 0.15);
    _group3Pro1.text = @"1.从事高空、井下、放射性、有毒、易燃易爆，以及其他具有较高安全风险的实习？";
    _group3Pro1.textColor = [UIColor blackColor];
    _group3Pro1.font = [UIFont systemFontOfSize:16.0];
    [_group3DetailView addSubview:_group3Pro1];
    
    _group3Switch1 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group3Pro1.frame.origin.x + _group3Pro1.frame.size.width, _scrollView.frame.size.height * 0.15 * 0.3, _group3DetailView.frame.size.width * 0.25, _scrollView.frame.size.height * 0.15 * 0.6)];
//    if([[dataArr objectAtIndex:0] objectForKey:@"IsWorkplace"]){
//        _group3Switch1.on = YES;
//    }else{
//        _group3Switch1.on = NO;
//    }
    _group3Switch1.on = detailStation_model.IsWorkplace;
    [_group3DetailView addSubview:_group3Switch1];
    
    
    UIView *group3line1 = [[UIView alloc]init];
    group3line1.frame = CGRectMake(_group3DetailView.frame.size.width * 0.05, _scrollView.frame.size.height * 0.15 - 1, _group3DetailView.frame.size.width * 0.95, 1);
    group3line1.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group3DetailView addSubview:group3line1];
    
    
    /*IsRest*/
    _group3Pro2 = [[UITextView alloc]init];
    _group3Pro2.frame = CGRectMake(_group3DetailView.frame.size.width * 0.02, _group3DetailView.frame.size.height * 0.05 + _scrollView.frame.size.height * 0.15, _group3DetailView.frame.size.width * 0.68, _scrollView.frame.size.height * 0.1);
    _group3Pro2.text = @"2.存在安排学生在法定节假日实习的情况？";
    _group3Pro2.textColor = [UIColor blackColor];
    _group3Pro2.font = [UIFont systemFontOfSize:16.0];
    [_group3DetailView addSubview:_group3Pro2];
    
    _group3Switch2 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group3Pro2.frame.origin.x + _group3Pro2.frame.size.width, _scrollView.frame.size.height * 0.15 + _scrollView.frame.size.height * 0.1 * 0.2, _group3DetailView.frame.size.width * 0.25, _scrollView.frame.size.height * 0.1 * 0.6)];
//    if([[dataArr objectAtIndex:0] objectForKey:@"IsRest"]){
//        _group3Switch2.on = YES;
//    }else{
//        _group3Switch2.on = NO;
//    }
    
    _group3Switch2.on = detailStation_model.IsRest;
    [_group3DetailView addSubview:_group3Switch2];
    
    
    UIView *group3line2 = [[UIView alloc]init];
    group3line2.frame = CGRectMake(_group3DetailView.frame.size.width * 0.05, _scrollView.frame.size.height * 0.15 + _scrollView.frame.size.height * 0.1 - 1, _group3DetailView.frame.size.width * 0.95, 1);
    group3line2.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group3DetailView addSubview:group3line2];
    
    
    /*IsOvertime*/
    _group3Pro3 = [[UITextView alloc]init];
    _group3Pro3.frame = CGRectMake(_group3DetailView.frame.size.width * 0.02, _group3DetailView.frame.size.height * 0.05 + _scrollView.frame.size.height * 0.15 + _scrollView.frame.size.height * 0.1, _group3DetailView.frame.size.width * 0.68, _scrollView.frame.size.height * 0.1);
    _group3Pro3.text = @"3.存在安排学生加班和上夜班的情况？";
    _group3Pro3.textColor = [UIColor blackColor];
    _group3Pro3.font = [UIFont systemFontOfSize:16.0];
    [_group3DetailView addSubview:_group3Pro3];
    
    _group3Switch3 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group3Pro3.frame.origin.x + _group3Pro3.frame.size.width, _scrollView.frame.size.height * 0.15 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 * 0.2, _group3DetailView.frame.size.width * 0.25, _scrollView.frame.size.height * 0.1 * 0.6)];
//    if([[dataArr objectAtIndex:0] objectForKey:@"IsOvertime"]){
//        _group3Switch3.on = YES;
//    }else{
//        _group3Switch3.on = NO;
//    }
    _group3Switch3.on = detailStation_model.IsOvertime;
    [_group3DetailView addSubview:_group3Switch3];
    
    
    //    /*----------------------------------------------------------------------------------*/
    //
    
    _group4 = [[UIView alloc]init];
    _group4.frame = CGRectMake(_scrollView.frame.size.width * 0.03, _scrollView.frame.size.height * 0.02 + _group3.frame.size.height + _group3.frame.origin.y, _scrollView.frame.size.width * 0.94, _scrollView.frame.size.height * 0.05 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1);
    _group4.layer.cornerRadius = 5;
    _group4.layer.masksToBounds = YES;
    _group4.layer.borderColor = [UIColor grayColor].CGColor;
    _group4.layer.borderWidth = 1;
    _group4.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_group4];
    
    
    _group4Title = [[UILabel alloc]init];
    _group4Title.frame = CGRectMake(0, 0, _group4.frame.size.width, _scrollView.frame.size.height * 0.05);
    _group4Title.backgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    _group4Title.text = @" (四)实习准备四达标";
    _group4Title.textColor = [UIColor whiteColor];
    [_group4 addSubview:_group4Title];
    
    
    _group4DetailView = [[UIView alloc]init];
    _group4DetailView.frame = CGRectMake(0, _group4Title.frame.origin.y + _group4Title.frame.size.height, _group4.frame.size.width, _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1);
    _group4DetailView.backgroundColor = [UIColor whiteColor];
    [_group4 addSubview:_group4DetailView];
    
    /*IsPlan*/
    _group4Pro1 = [[UITextView alloc]init];
    _group4Pro1.frame = CGRectMake(_group4DetailView.frame.size.width * 0.02, _scrollView.frame.size.height * 0.1  * 0.05, _group4DetailView.frame.size.width * 0.68, _scrollView.frame.size.height * 0.1 * 0.9);
    _group4Pro1.text = @"1.学校根据专业人才培养方案，制定了实习计划？";
    _group4Pro1.textColor = [UIColor blackColor];
    _group4Pro1.font = [UIFont systemFontOfSize:16.0];
    [_group4DetailView addSubview:_group4Pro1];
    
    _group4Switch1 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group4Pro1.frame.origin.x + _group4Pro1.frame.size.width, _scrollView.frame.size.height * 0.1 * 0.2, _group4DetailView.frame.size.width * 0.25, _scrollView.frame.size.height * 0.1 * 0.6)];
//    if([[dataArr objectAtIndex:0] objectForKey:@"IsPlan"]){
//        _group4Switch1.on = YES;
//    }else{
//        _group4Switch1.on = NO;
//    }
    _group4Switch1.on = detailStation_model.IsPlan;
    [_group4DetailView addSubview:_group4Switch1];
    
    
    UIView *group4line1 = [[UIView alloc]init];
    group4line1.frame = CGRectMake(_group4DetailView.frame.size.width * 0.05, _scrollView.frame.size.height * 0.1 - 1, _group4DetailView.frame.size.width * 0.95, 1);
    group4line1.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group4DetailView addSubview:group4line1];
    
    /*IsEducation*/
    _group4Pro2 = [[UITextView alloc]init];
    _group4Pro2.frame = CGRectMake(_group4DetailView.frame.size.width * 0.02, _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1  * 0.05, _group4DetailView.frame.size.width * 0.68, _scrollView.frame.size.height * 0.1 * 0.9);
    _group4Pro2.text = @"2.学校组织了实习教育或实习培训活动？";
    _group4Pro2.textColor = [UIColor blackColor];
    _group4Pro2.font = [UIFont systemFontOfSize:16.0];
    [_group4DetailView addSubview:_group4Pro2];
    
    _group4Switch2 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group4Pro2.frame.origin.x + _group4Pro2.frame.size.width, _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 * 0.2, _group4DetailView.frame.size.width * 0.25, _scrollView.frame.size.height * 0.1 * 0.6)];
//    if([[dataArr objectAtIndex:0] objectForKey:@"IsEducation"]){
//        _group4Switch2.on = YES;
//    }else{
//        _group4Switch2.on = NO;
//    }
    _group4Switch2.on = detailStation_model.IsEducation;
    [_group4DetailView addSubview:_group4Switch2];
    
    
    UIView *group4line2 = [[UIView alloc]init];
    group4line2.frame = CGRectMake(_group4DetailView.frame.size.width * 0.05, _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 - 1, _group4DetailView.frame.size.width * 0.95, 1);
    group4line2.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group4DetailView addSubview:group4line2];
    
    /*IsGuarantee*/
    _group4Pro3 = [[UITextView alloc]init];
    _group4Pro3.frame = CGRectMake(_group4DetailView.frame.size.width * 0.02,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1  * 0.05, _group4DetailView.frame.size.width * 0.68, _scrollView.frame.size.height * 0.1 * 0.9);
    _group4Pro3.text = @"3.学校制定了实习工作具体管理办法和安全管理规定？";
    _group4Pro3.textColor = [UIColor blackColor];
    _group4Pro3.font = [UIFont systemFontOfSize:16.0];
    [_group4DetailView addSubview:_group4Pro3];
    
    _group4Switch3 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group4Pro3.frame.origin.x + _group4Pro3.frame.size.width,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 * 0.2, _group4DetailView.frame.size.width * 0.25, _scrollView.frame.size.height * 0.1 * 0.6)];
    
//    if([[dataArr objectAtIndex:0] objectForKey:@"IsGuarantee"]){
//        _group4Switch3.on = YES;
//    }else{
//        _group4Switch3.on = NO;
//    }
    _group4Switch3.on = detailStation_model.IsGuarantee;
    [_group4DetailView addSubview:_group4Switch3];
    
    
    UIView *group4line3 = [[UIView alloc]init];
    group4line3.frame = CGRectMake(_group4DetailView.frame.size.width * 0.05,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 - 1, _group4DetailView.frame.size.width * 0.95, 1);
    group4line3.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group4DetailView addSubview:group4line3];
    
    /*IsWarning*/
    _group4Pro4 = [[UITextView alloc]init];
    _group4Pro4.frame = CGRectMake(_group4DetailView.frame.size.width * 0.02,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1  * 0.05, _group4DetailView.frame.size.width * 0.68, _scrollView.frame.size.height * 0.1 * 0.9);
    _group4Pro4.text = @"4.学校制定了实习学生安全及突发事件应急预案等制定？";
    _group4Pro4.textColor = [UIColor blackColor];
    _group4Pro4.font = [UIFont systemFontOfSize:16.0];
    [_group4DetailView addSubview:_group4Pro4];
    
    _group4Switch4 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group4Pro3.frame.origin.x + _group4Pro3.frame.size.width,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 * 0.2, _group4DetailView.frame.size.width * 0.25, _scrollView.frame.size.height * 0.1 * 0.6)];
//    if([[dataArr objectAtIndex:0] objectForKey:@"IsWarning"]){
//        _group4Switch4.on = YES;
//    }else{
//        _group4Switch4.on = NO;
//    }
    _group4Switch4.on = detailStation_model.IsWarning;
    [_group4DetailView addSubview:_group4Switch4];
    
    
    
    //    /*----------------------------------------------------------------------------------*/
    _group5 = [[UIView alloc]init];
    _group5.frame = CGRectMake(_scrollView.frame.size.width * 0.03, _scrollView.frame.size.height * 0.02 + _group4.frame.size.height + _group4.frame.origin.y, _scrollView.frame.size.width * 0.94, _scrollView.frame.size.height * 0.05 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1);
    _group5.layer.cornerRadius = 5;
    _group5.layer.masksToBounds = YES;
    _group5.layer.borderColor = [UIColor grayColor].CGColor;
    _group5.layer.borderWidth = 1;
    _group5.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_group5];
    
    
    _group5Title = [[UILabel alloc]init];
    _group5Title.frame = CGRectMake(0, 0, _group5.frame.size.width, _scrollView.frame.size.height * 0.05);
    _group5Title.backgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    _group5Title.text = @" (五)实习组织五不要";
    _group5Title.textColor = [UIColor whiteColor];
    [_group5 addSubview:_group5Title];
    
    
    _group5DetailView = [[UIView alloc]init];
    _group5DetailView.frame = CGRectMake(0, _group5Title.frame.origin.y + _group5Title.frame.size.height, _group5.frame.size.width, _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1);
    _group5DetailView.backgroundColor = [UIColor whiteColor];
    [_group5 addSubview:_group5DetailView];
    
    
    _group5Pro1 = [[UITextView alloc]init];
    _group5Pro1.frame = CGRectMake(_group5DetailView.frame.size.width * 0.02, _scrollView.frame.size.height * 0.1  * 0.05, _group5DetailView.frame.size.width * 0.68, _scrollView.frame.size.height * 0.1 * 0.9);
    _group5Pro1.text = @"1.学校安排、教师推荐、自己联系、其他？";
    _group5Pro1.textColor = [UIColor blackColor];
    _group5Pro1.font = [UIFont systemFontOfSize:16.0];
    [_group5DetailView addSubview:_group5Pro1];
    
    _group5Switch1 = [[UILabel alloc] initWithFrame:CGRectMake(_group5Pro1.frame.origin.x + _group5Pro1.frame.size.width, _scrollView.frame.size.height * 0.1 * 0.2, _group5DetailView.frame.size.width * 0.25, _scrollView.frame.size.height * 0.1 * 0.6)];
    NSString *EnterpriseSourceStr = @"";
    if([[[dataArr objectAtIndex:0] objectForKey:@"EnterpriseSource"] integerValue] == 0){
        EnterpriseSourceStr = @"学校";
        _problemVal = @"0";
    }else if([[[dataArr objectAtIndex:0] objectForKey:@"EnterpriseSource"] integerValue] == 1){
        EnterpriseSourceStr = @"教师";
        _problemVal = @"1";
    }else if([[[dataArr objectAtIndex:0] objectForKey:@"EnterpriseSource"] integerValue] == 2){
        EnterpriseSourceStr = @"自己联系";
        _problemVal = @"2";
    }else if([[[dataArr objectAtIndex:0] objectForKey:@"EnterpriseSource"] integerValue] == 3){
        _problemVal = @"3";
        EnterpriseSourceStr = @"其他";
    }
    _group5Switch1.text = EnterpriseSourceStr;
    _group5Switch1.textAlignment = UITextAlignmentRight;
    UITapGestureRecognizer *group5Switch1Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(group5Switch1Action:)];
    [_group5Switch1 addGestureRecognizer:group5Switch1Tap];
    _group5Switch1.userInteractionEnabled = YES;
    [_group5DetailView addSubview:_group5Switch1];
    
    
    UIView *group5line1 = [[UIView alloc]init];
    group5line1.frame = CGRectMake(_group5DetailView.frame.size.width * 0.05, _scrollView.frame.size.height * 0.1 - 1, _group5DetailView.frame.size.width * 0.95, 1);
    group5line1.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group5DetailView addSubview:group5line1];
    
    /*IsENumber*/
    _group5Pro2 = [[UITextView alloc]init];
    _group5Pro2.frame = CGRectMake(_group5DetailView.frame.size.width * 0.02, _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1  * 0.05, _group5DetailView.frame.size.width * 0.68, _scrollView.frame.size.height * 0.1 * 0.9);
    _group5Pro2.text = @"2.实习生人数超过实习单位在岗职工总数的10%？";
    _group5Pro2.textColor = [UIColor blackColor];
    _group5Pro2.font = [UIFont systemFontOfSize:16.0];
    [_group5DetailView addSubview:_group5Pro2];
    
    _group5Switch2 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group5Pro2.frame.origin.x + _group5Pro2.frame.size.width, _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 * 0.2, _group5DetailView.frame.size.width * 0.25, _scrollView.frame.size.height * 0.1 * 0.6)];
    
//    if([[dataArr objectAtIndex:0] objectForKey:@"IsENumber"]){
//        _group5Switch2.on = YES;
//    }else{
//        _group5Switch2.on = NO;
//    }
    _group5Switch2.on = detailStation_model.IsENumber;
    [_group5DetailView addSubview:_group5Switch2];
    
    
    UIView *group5line2 = [[UIView alloc]init];
    group5line2.frame = CGRectMake(_group4DetailView.frame.size.width * 0.05, _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 - 1, _group4DetailView.frame.size.width * 0.95, 1);
    group5line2.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group5DetailView addSubview:group5line2];
    
    /*IsPNumber*/
    _group5Pro3 = [[UITextView alloc]init];
    _group5Pro3.frame = CGRectMake(_group5DetailView.frame.size.width * 0.02,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1  * 0.05, _group5DetailView.frame.size.width * 0.68, _scrollView.frame.size.height * 0.1 * 0.9);
    _group5Pro3.text = @"3.具体岗位的实习生人数高于该岗位职工总人数的20%？";
    _group5Pro3.textColor = [UIColor blackColor];
    _group5Pro3.font = [UIFont systemFontOfSize:16.0];
    [_group5DetailView addSubview:_group5Pro3];
    
    _group5Switch3 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group5Pro3.frame.origin.x + _group5Pro3.frame.size.width,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 * 0.2, _group5DetailView.frame.size.width * 0.25, _scrollView.frame.size.height * 0.1 * 0.6)];
    
//    if([[dataArr objectAtIndex:0] objectForKey:@"IsPNumber"]){
//        _group5Switch3.on = YES;
//    }else{
//        _group5Switch3.on = NO;
//    }
    
    _group5Switch3.on = detailStation_model.IsPNumber;
    [_group5DetailView addSubview:_group5Switch3];
    
    
    UIView *group5line3 = [[UIView alloc]init];
    group5line3.frame = CGRectMake(_group5DetailView.frame.size.width * 0.05,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 - 1, _group5DetailView.frame.size.width * 0.95, 1);
    group5line3.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group5DetailView addSubview:group5line3];
    
    /*IsExIntervention*/
    _group5Pro4 = [[UITextView alloc]init];
    _group5Pro4.frame = CGRectMake(_group5DetailView.frame.size.width * 0.02,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1  * 0.05, _group5DetailView.frame.size.width * 0.68, _scrollView.frame.size.height * 0.1 * 0.9);
    _group5Pro4.text = @"4.存在学校以外的单位干预实习安排的情况？";
    _group5Pro4.textColor = [UIColor blackColor];
    _group5Pro4.font = [UIFont systemFontOfSize:16.0];
    [_group5DetailView addSubview:_group5Pro4];
    
    _group5Switch4 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group5Pro3.frame.origin.x + _group5Pro3.frame.size.width,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 * 0.2, _group5DetailView.frame.size.width * 0.25, _scrollView.frame.size.height * 0.1 * 0.6)];
    
//    if([[dataArr objectAtIndex:0] objectForKey:@"IsExIntervention"]){
//        _group5Switch4.on = YES;
//    }else{
//        _group5Switch4.on = NO;
//    }

    _group5Switch4.on = detailStation_model.IsExIntervention;
    
    [_group5DetailView addSubview:_group5Switch4];
    
    UIView *group5line4 = [[UIView alloc]init];
    group5line4.frame = CGRectMake(_group5DetailView.frame.size.width * 0.05,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 - 1, _group5DetailView.frame.size.width * 0.95, 1);
    group5line4.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group5DetailView addSubview:group5line4];
    
    /*IsExForce*/
    _group5Pro5 = [[UITextView alloc]init];
    _group5Pro5.frame = CGRectMake(_group5DetailView.frame.size.width * 0.02,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1  * 0.05, _group5DetailView.frame.size.width * 0.68, _scrollView.frame.size.height * 0.1 * 0.9);
    _group5Pro5.text = @"5.存在强制职业学校安排学生到指定单位实习的情况？";
    _group5Pro5.textColor = [UIColor blackColor];
    _group5Pro5.font = [UIFont systemFontOfSize:16.0];
    [_group5DetailView addSubview:_group5Pro5];
    
    _group5Switch5 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group5Pro5.frame.origin.x + _group5Pro5.frame.size.width,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 * 0.2, _group5DetailView.frame.size.width * 0.25, _scrollView.frame.size.height * 0.1 * 0.6)];
    
//    if([[dataArr objectAtIndex:0] objectForKey:@"IsExForce"]){
//        _group5Switch5.on = YES;
//    }else{
//        _group5Switch5.on = NO;
//    }
    _group5Switch5.on = detailStation_model.IsExForce;
    
    [_group5DetailView addSubview:_group5Switch5];
    
    
    
    //    /*----------------------------------------------------------------------------------*/
    _group6 = [[UIView alloc]init];
    _group6.frame = CGRectMake(_scrollView.frame.size.width * 0.03, _scrollView.frame.size.height * 0.02 + _group5.frame.size.height + _group5.frame.origin.y, _scrollView.frame.size.width * 0.94, _scrollView.frame.size.height * 0.05 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1);
    _group6.layer.cornerRadius = 5;
    _group6.layer.masksToBounds = YES;
    _group6.layer.borderColor = [UIColor grayColor].CGColor;
    _group6.layer.borderWidth = 1;
    _group6.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_group6];
    
    
    _group6Title = [[UILabel alloc]init];
    _group6Title.frame = CGRectMake(0, 0, _group6.frame.size.width, _scrollView.frame.size.height * 0.05);
    _group6Title.backgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    _group6Title.text = @" (六)学生权利六不得";
    _group6Title.textColor = [UIColor whiteColor];
    [_group6 addSubview:_group6Title];
    
    
    _group6DetailView = [[UIView alloc]init];
    _group6DetailView.frame = CGRectMake(0, _group6Title.frame.origin.y + _group6Title.frame.size.height, _group6.frame.size.width, _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1);
    _group6DetailView.backgroundColor = [UIColor whiteColor];
    [_group6 addSubview:_group6DetailView];
    
    
    /*IsGradeOne*/
    _group6Pro1 = [[UITextView alloc]init];
    _group6Pro1.frame = CGRectMake(_group6DetailView.frame.size.width * 0.02, _scrollView.frame.size.height * 0.1  * 0.05, _group6DetailView.frame.size.width * 0.68, _scrollView.frame.size.height * 0.1 * 0.9);
    _group6Pro1.text = @"1.一年级在校学生参加顶岗实习？";
    _group6Pro1.textColor = [UIColor blackColor];
    _group6Pro1.font = [UIFont systemFontOfSize:16.0];
    [_group6DetailView addSubview:_group6Pro1];
    
    _group6Switch1 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group6Pro1.frame.origin.x + _group6Pro1.frame.size.width, _scrollView.frame.size.height * 0.1 * 0.2, _group6DetailView.frame.size.width * 0.25, _scrollView.frame.size.height * 0.1 * 0.6)];
    
//    if([[dataArr objectAtIndex:0] objectForKey:@"IsGradeOne"]){
//        _group6Switch1.on = YES;
//    }else{
//        _group6Switch1.on = NO;
//    }
    _group6Switch1.on = detailStation_model.IsGradeOne;
    
    [_group6DetailView addSubview:_group6Switch1];
    
    
    UIView *group6line1 = [[UIView alloc]init];
    group6line1.frame = CGRectMake(_group6DetailView.frame.size.width * 0.05, _scrollView.frame.size.height * 0.1 - 1, _group6DetailView.frame.size.width * 0.95, 1);
    group6line1.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group6DetailView addSubview:group6line1];
    
    /*IsAdult*/
    _group6Pro2 = [[UITextView alloc]init];
    _group6Pro2.frame = CGRectMake(_group6DetailView.frame.size.width * 0.02, _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1  * 0.05, _group6DetailView.frame.size.width * 0.68, _scrollView.frame.size.height * 0.1 * 0.9);
    _group6Pro2.text = @"2.未满16周岁的学生参加跟岗实习、顶岗实习？";
    _group6Pro2.textColor = [UIColor blackColor];
    _group6Pro2.font = [UIFont systemFontOfSize:16.0];
    [_group6DetailView addSubview:_group6Pro2];
    
    _group6Switch2 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group6Pro2.frame.origin.x + _group6Pro2.frame.size.width, _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 * 0.2, _group6DetailView.frame.size.width * 0.25, _scrollView.frame.size.height * 0.1 * 0.6)];
    
//    if([[dataArr objectAtIndex:0] objectForKey:@"IsAdult"]){
//        _group6Switch2.on = YES;
//    }else{
//        _group6Switch2.on = NO;
//    }
    
    _group6Switch2.on = detailStation_model.IsAdult;
    [_group6DetailView addSubview:_group6Switch2];
    
    
    UIView *group6line2 = [[UIView alloc]init];
    group6line2.frame = CGRectMake(_group6DetailView.frame.size.width * 0.05, _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 - 1, _group6DetailView.frame.size.width * 0.95, 1);
    group6line2.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group6DetailView addSubview:group6line2];
    
    /*IsTaboo*/
    _group6Pro3 = [[UITextView alloc]init];
    _group6Pro3.frame = CGRectMake(_group6DetailView.frame.size.width * 0.02,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1  * 0.05, _group6DetailView.frame.size.width * 0.68, _scrollView.frame.size.height * 0.1 * 0.9);
    _group6Pro3.text = @"3.未成年学生从事《未成年工特殊保护规定》中禁忌从事的劳动？";
    _group6Pro3.textColor = [UIColor blackColor];
    _group6Pro3.font = [UIFont systemFontOfSize:16.0];
    [_group6DetailView addSubview:_group6Pro3];
    
    _group6Switch3 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group6Pro3.frame.origin.x + _group6Pro3.frame.size.width,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 * 0.2, _group6DetailView.frame.size.width * 0.25, _scrollView.frame.size.height * 0.1 * 0.6)];
//    if([[dataArr objectAtIndex:0] objectForKey:@"IsTaboo"]){
//        _group6Switch3.on = YES;
//    }else{
//        _group6Switch3.on = NO;
//    }
    _group6Switch3.on = detailStation_model.IsTaboo;
    
    [_group6DetailView addSubview:_group6Switch3];
    
    
    UIView *group6line3 = [[UIView alloc]init];
    group6line3.frame = CGRectMake(_group6DetailView.frame.size.width * 0.05,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 - 1, _group6DetailView.frame.size.width * 0.95, 1);
    group6line3.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group6DetailView addSubview:group6line3];
    
    /*IsWomenTaboo*/
    _group6Pro4 = [[UITextView alloc]init];
    _group6Pro4.frame = CGRectMake(_group6DetailView.frame.size.width * 0.02,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1  * 0.05, _group6DetailView.frame.size.width * 0.68, _scrollView.frame.size.height * 0.1 * 0.9);
    _group6Pro4.text = @"4.女学生从事《女职工劳动保护特别规定》中禁忌从事的劳动？";
    _group6Pro4.textColor = [UIColor blackColor];
    _group6Pro4.font = [UIFont systemFontOfSize:16.0];
    [_group6DetailView addSubview:_group6Pro4];
    
    _group6Switch4 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group6Pro3.frame.origin.x + _group6Pro3.frame.size.width,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 * 0.2, _group6DetailView.frame.size.width * 0.25, _scrollView.frame.size.height * 0.1 * 0.6)];
    
//    if([[dataArr objectAtIndex:0] objectForKey:@"IsWomenTaboo"]){
//        _group6Switch4.on = YES;
//    }else{
//        _group6Switch4.on = NO;
//    }
    
    _group6Switch4.on = detailStation_model.IsWomenTaboo;
    [_group6DetailView addSubview:_group6Switch4];
    
    UIView *group6line4 = [[UIView alloc]init];
    group6line4.frame = CGRectMake(_group6DetailView.frame.size.width * 0.05,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 - 1, _group6DetailView.frame.size.width * 0.95, 1);
    group6line4.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group6DetailView addSubview:group6line4];
    
    /*IsBar*/
    _group6Pro5 = [[UITextView alloc]init];
    _group6Pro5.frame = CGRectMake(_group6DetailView.frame.size.width * 0.02,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1  * 0.05, _group6DetailView.frame.size.width * 0.68, _scrollView.frame.size.height * 0.1 * 0.9);
    _group6Pro5.text = @"5.到酒吧、夜总会、歌厅、洗浴中心等营业性娱乐场所实习？";
    _group6Pro5.textColor = [UIColor blackColor];
    _group6Pro5.font = [UIFont systemFontOfSize:16.0];
    [_group6DetailView addSubview:_group6Pro5];
    
    _group6Switch5 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group6Pro5.frame.origin.x + _group6Pro5.frame.size.width,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 * 0.2, _group6DetailView.frame.size.width * 0.25, _scrollView.frame.size.height * 0.1 * 0.6)];
    
//    if([[dataArr objectAtIndex:0] objectForKey:@"IsBar"]){
//        _group6Switch5.on = YES;
//    }else{
//        _group6Switch5.on = NO;
//    }
    _group6Switch5.on = detailStation_model.IsBar;
    [_group6DetailView addSubview:_group6Switch5];
    
    UIView *group6line5 = [[UIView alloc]init];
    group6line5.frame = CGRectMake(_group6DetailView.frame.size.width * 0.05,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 - 1, _group6DetailView.frame.size.width * 0.95, 1);
    group6line5.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group6DetailView addSubview:group6line5];
    
    
    /*IsIntermediary*/
    _group6Pro6 = [[UITextView alloc]init];
    _group6Pro6.frame = CGRectMake(_group6DetailView.frame.size.width * 0.02,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1  * 0.05, _group6DetailView.frame.size.width * 0.68, _scrollView.frame.size.height * 0.1 * 0.9);
    _group6Pro6.text = @"6.通过中介机构或有偿代理组织、安排和管理学生实习工作？";
    _group6Pro6.textColor = [UIColor blackColor];
    _group6Pro6.font = [UIFont systemFontOfSize:16.0];
    [_group6DetailView addSubview:_group6Pro6];
    
    _group6Switch6 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group6Pro6.frame.origin.x + _group6Pro6.frame.size.width,_scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 + _scrollView.frame.size.height * 0.1 * 0.2, _group6DetailView.frame.size.width * 0.25, _scrollView.frame.size.height * 0.1 * 0.6)];
    
//    if([[dataArr objectAtIndex:0] objectForKey:@"IsIntermediary"]){
//        _group6Switch6.on = YES;
//    }else{
//        _group6Switch6.on = NO;
//    }
    _group6Switch6.on = detailStation_model.IsIntermediary;
    [_group6DetailView addSubview:_group6Switch6];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) companyAction:(UITapGestureRecognizer *)sender{
    ModifyCompanyDetailViewController *modifyCompany = [[ModifyCompanyDetailViewController alloc]init];
    [self.navigationController pushViewController:modifyCompany animated:YES];
}



-(void) stationAction:(UITapGestureRecognizer *)sender{
    ModifyStationDetailViewController *modifyStation = [[ModifyStationDetailViewController alloc]init];
    modifyStation.uploadID = _companyID;
    [self.navigationController pushViewController:modifyStation animated:YES];
}



-(void) teacherAction:(UITapGestureRecognizer *)sender{
    ModifyTeacherDetailViewController *modifyTeacher = [[ModifyTeacherDetailViewController alloc]init];
    modifyTeacher.uploadStationID = _stationID;
    [self.navigationController pushViewController:modifyTeacher animated:YES];
}


-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"%@",_getReturnDic);
    if([[_getReturnDic objectForKey:@"Type"] isEqualToString:@"company"]){
        [self handleReturnCompany:[_getReturnDic objectForKey:@"ID"]];
    }else if([[_getReturnDic objectForKey:@"Type"] isEqualToString:@"station"]){
        [self handleReturnStation:[_getReturnDic objectForKey:@"ID"]];
    }else if([[_getReturnDic objectForKey:@"Type"] isEqualToString:@"teacher"]){
        [self handleReturnTeacher:_getReturnDic];
    }
}



-(void) handleReturnCompany:(NSString *)getID{
    [_activityIndicatorView startAnimating];
    NSString *url = [NSString stringWithFormat:@"%@/ApiEnterpriseInfo/GetEnterpriseInfo?EnterpriseID=%@",kCacheHttpRoot,getID];
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
            _companyField.text = [[[jsonDic objectForKey:@"AppendData"] objectAtIndex:0] objectForKey:@"EnterpriseName"];
            _companyCodeField.text = [[[jsonDic objectForKey:@"AppendData"] objectAtIndex:0] objectForKey:@"CreditCode"];
            _peopleCountField.text = [[[[jsonDic objectForKey:@"AppendData"] objectAtIndex:0] objectForKey:@"StaffTotal"] stringValue];
            _addressField.text = [[[jsonDic objectForKey:@"AppendData"] objectAtIndex:0] objectForKey:@"Address"];
            _companyID = [[[[jsonDic objectForKey:@"AppendData"] objectAtIndex:0] objectForKey:@"ID"] stringValue];
        }
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败--查询企业信息");
    }];
}


-(void) handleReturnStation:(NSString *)getID{
    [_activityIndicatorView startAnimating];
    NSString *url = [NSString stringWithFormat:@"%@/ApiEnterpriseInfo/GetPositionInfo?PositionID=%@",kCacheHttpRoot,getID];
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        NSLog(@"%@",jsonDic);
        if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
            NSArray *dataArr = [jsonDic objectForKey:@"AppendData"];
            _stationID = [[[dataArr objectAtIndex:0] objectForKey:@"ID"] stringValue];
            _stationField.text = [[dataArr objectAtIndex:0] objectForKey:@"PositionName"];
            _stationPeopleField.text = [[[dataArr objectAtIndex:0] objectForKey:@"StaffTotal"] stringValue];
        }
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败--查询岗位信息");
    }];
}


-(void) handleReturnTeacher:(NSMutableDictionary *)getDic{
    _teacherField.text = [getDic objectForKey:@"ManName"];
    _mobileField.text = [getDic objectForKey:@"ManMobile"];
    _phoneField.text = [getDic objectForKey:@"ManTel"] == [NSNull null]?@"":[getDic objectForKey:@"ManTel"];
    _emailField.text = [getDic objectForKey:@"ManEmail"];
    
}



-(void) stayAction:(UITapGestureRecognizer *)sender{
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"请选额"
                                                   cancelButtonTitle:@"取消"
                                                  confirmButtonTitle:@"提交"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    picker.headerBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    picker.confirmButtonBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    picker.accessibilityValue = @"stay";
    [picker show];
}


-(void) foodAction:(UITapGestureRecognizer *)sender{
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"请选额"
                                                   cancelButtonTitle:@"取消"
                                                  confirmButtonTitle:@"提交"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    picker.headerBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    picker.confirmButtonBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    picker.accessibilityValue = @"food";
    [picker show];
}


-(void) group5Switch1Action:(UITapGestureRecognizer *)sender{
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"请选额"
                                                   cancelButtonTitle:@"取消"
                                                  confirmButtonTitle:@"提交"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    picker.headerBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    picker.confirmButtonBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    picker.accessibilityValue = @"problem";
    [picker show];
}


-(void) dateAction:(UITapGestureRecognizer *)sender{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGDatePickerType3;//PGPickerViewType3;
    datePicker.datePickerMode = PGDatePickerModeDate;
    [self presentViewController:datePickManager animated:false completion:nil];
}



-(void) modifyAction:(UIButton *)sender{
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipApplyEnterpriseInfo/Modify",kCacheHttpRoot];
    
    NSString *currTime = [PhoneInfo getNowTimeTimestamp3];
    NSString *token = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@GJApply%@",_applyID,currTime]];
    
    
    // _baseSwitch.on == YES ? @"true" :@"false",@"IsPracticeBase",
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:_applyID,@"ID",CurrAdminID,@"Creater",batchID,@"ActivityID",_companyID,@"EnterpriseID",_stationID,@"PositionID",_companyField.text,@"EnterpriseName",_companyCodeField.text,@"CreditCode", _addressField.text,@"Address", _peopleCountField.text,@"StaffTotal",_stationField.text,@"PositionName",_stationPeopleField.text,@"PStaffTotal",_stationInstrField.text,@"PDescription",_teacherField.text,@"LinkManName",_mobileField.text,@"LinkManMobile",_phoneField.text,@"LinkManTel",_emailField.text,@"LinkManEmail",_salaryField.text,@"MonthlySalary",_postDateField.text,@"ComeWorkDate",_stayVal == nil?@"0":_stayVal,@"AccommodationType",_foodVal == nil?@"0":_foodVal,@"FoodType",_descrField.text,@"Description", _teacherID == nil?@"0":_teacherID,@"LinkManID",@"",@"AgreementUrl",@(_group2Switch1.on),@"RelevantType",_group3Switch1.on == YES?@"true":@"false",@"IsWorkplace",_group3Switch2.on == YES?@"true":@"false",@"IsRest",_group3Switch3.on == YES?@"true":@"false",@"IsOvertime",_group4Switch1.on == YES?@"true":@"false",@"IsPlan",_group4Switch2.on == YES?@"true":@"false",@"IsEducation",_group4Switch3.on == YES?@"true":@"false",@"IsGuarantee",_group4Switch4.on == YES?@"true":@"false",@"IsWarning",_problemVal == nil?@"0":_problemVal,@"EnterpriseSource",_group5Switch2.on == YES?@"true":@"false",@"IsENumber",_group5Switch3.on == YES?@"true":@"false",@"IsPNumber",_group5Switch4.on == YES?@"true":@"false",@"IsExIntervention",_group5Switch5.on == YES?@"true":@"false",@"IsExForce",_group6Switch1.on == YES?@"true":@"false",@"IsGradeOne",_group6Switch2.on == YES?@"true":@"false",@"IsAdult",_group6Switch3.on == YES?@"true":@"false",@"IsTaboo",_group6Switch4.on == YES?@"true":@"false",@"IsWomenTaboo",_group6Switch5.on == YES?@"true":@"false",@"IsBar",_group6Switch6.on == YES?@"true":@"false",@"IsIntermediary",currTime,@"TimeStamp",token,@"Token",nil];
    
    [_activityIndicatorView startAnimating];
    [AizenHttp asynRequest:url httpMethod:@"POST" params:params success:^(id result) {
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[jsonDic objectForKey:@"Message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        NSLog(@"%@",jsonDic);
        [_activityIndicatorView stopAnimating];
    } failue:^(NSError *error) {
        NSLog(@"请求失败--修改岗位");
        [_activityIndicatorView stopAnimating];
    }];
    
    
    
}







#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSString *dateStr = [NSString stringWithFormat:@"%d-%d-%d",dateComponents.year,dateComponents.month,dateComponents.day,dateComponents.hour,dateComponents.minute,dateComponents.second];
    _postDateField.text = dateStr;
    _postDateField.textColor = [UIColor blackColor];
}


#pragma mark - CZPickerViewDataSource
/* number of items for picker */
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    if([pickerView.accessibilityValue isEqualToString:@"stay"]){
        return [_stayArr count];
    }else if([pickerView.accessibilityValue isEqualToString:@"food"]){
        return [_foodArr count];
    }else{
        return [_problemArr count];
    }
    
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
    if([pickerView.accessibilityValue isEqualToString:@"stay"]){
        return [_stayArr objectAtIndex:row];
    }else if([pickerView.accessibilityValue isEqualToString:@"food"]){
        return [_foodArr objectAtIndex:row];
    }else{
        return [_problemArr objectAtIndex:row];
    }
    
}




#pragma mark - CZPickerViewDelegate
/** delegate method for picking one item */
- (void)czpickerView:(CZPickerView *)pickerView
didConfirmWithItemAtRow:(NSInteger)row{
    if([pickerView.accessibilityValue isEqualToString:@"stay"]){
        NSString *stayStr = [_stayArr objectAtIndex:row];
        
        _stayField.text = stayStr;
        _stayField.textColor = [UIColor blackColor];
        
        if([stayStr isEqualToString:@"不提供"]){
            _stayVal = @"0";
        }else if([stayStr isEqualToString:@"提供但自费"]){
            _stayVal = @"1";
        }else if([stayStr isEqualToString:@"免费住宿"]){
            _stayVal = @"2";
        }else{
            _stayVal = @"3";
        }
    }else if([pickerView.accessibilityValue isEqualToString:@"food"]){
        NSString *foodStr = [_foodArr objectAtIndex:row];
        
        _foodField.text = foodStr;
        _foodField.textColor = [UIColor blackColor];

        if([foodStr isEqualToString:@"不提供"]){
            _foodVal = @"0";
        }else if([foodStr isEqualToString:@"提供但自费"]){
            _foodVal = @"1";
        }else if([foodStr isEqualToString:@"免费提供"]){
            _foodVal = @"2";
        }else{
            _foodVal = @"3";
        }
    }else if([pickerView.accessibilityValue isEqualToString:@"problem"]){
        NSString *problemStr = [_problemArr objectAtIndex:row];
        
        _group5Switch1.text = problemStr;
        _group5Switch1.textColor = [UIColor blackColor];
        
        if([problemStr isEqualToString:@"学校"]){
            _problemVal = @"0";
        }else if([problemStr isEqualToString:@"教师"]){
            _problemVal = @"1";
        }else if([problemStr isEqualToString:@"自己联系"]){
            _problemVal = @"2";
        }else{
            _problemVal = @"3";
        }
    }
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
    [_scrollView endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    return YES;
}

@end
