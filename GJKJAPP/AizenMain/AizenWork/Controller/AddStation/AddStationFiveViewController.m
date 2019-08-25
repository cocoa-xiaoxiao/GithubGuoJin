//
//  AddStationFourViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/3/2.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "AddStationFiveViewController.h"
#import "HMCustomSwitch.h"
#import "AizenMD5.h"
#import "AizenStorage.h"
#import "AizenHttp.h"
#import "PhoneInfo.h"
#import "People.h"
#import "DGActivityIndicatorView.h"
#import "RAlertView.h"
#import "PGDatePickManager.h"
#import "CZPickerView.h"

#define MAINHEIGHT [UIScreen mainScreen].bounds.size.height - HEIGHT_STATUSBAR - HEIGHT_NAVBAR

@interface AddStationFiveViewController ()<PGDatePickerDelegate,CZPickerViewDelegate,CZPickerViewDataSource,UITextViewDelegate>

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) UIButton *submitBtn;

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

@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

@property(nonatomic,strong) NSArray *problemArr;
@property(nonatomic,strong) NSString *problemVal;

@end

@implementation AddStationFiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"企业资质";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    NSLog(@"%f",MAINHEIGHT);
    
    [self startLayout];
}

-(void) startLayout{
    _problemArr = [[NSArray alloc]initWithObjects:@"学校",@"教师",@"自己联系",@"其他", nil];
    
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, 0 ,self.view.frame.size.width, self.view.frame.size.height - (HEIGHT_TABBAR));
    _contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, _contentView.frame.size.height * 3);
    [_contentView addSubview:_scrollView];
    
//    UIColor *clor = [kAppMainColor copy];
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[UIColor grayColor]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [_contentView addSubview:_activityIndicatorView];
    _activityIndicatorView.layer.zPosition = 1000;
    
    _submitBtn = [[UIButton alloc]init];
    _submitBtn.frame = CGRectMake(0, _contentView.frame.origin.y + _contentView.frame.size.height, _contentView.frame.size.width, HEIGHT_TABBAR);
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    _submitBtn.backgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitBtn];
    
    [self detailLayout];
}


-(void) detailLayout{
    CGFloat height = MAINHEIGHT;
    
    _group1 = [[UIView alloc]init];
    _group1.frame = CGRectMake(_scrollView.frame.size.width * 0.03, _scrollView.frame.size.height * 0.02, _scrollView.frame.size.width * 0.94, height * 0.05 + height * 0.1);
    _group1.layer.cornerRadius = 5;
    _group1.layer.masksToBounds = YES;
    _group1.layer.borderColor = [UIColor grayColor].CGColor;
    _group1.layer.borderWidth = 1;
    _group1.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_group1];
    
    
    _group1Title = [[UILabel alloc]init];
    _group1Title.frame = CGRectMake(0, 0, _group1.frame.size.width, height * 0.05);
    _group1Title.backgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    _group1Title.text = @" (一)实习过程一不许";
    _group1Title.textColor = [UIColor whiteColor];
    [_group1 addSubview:_group1Title];
    
    _group1DetailView = [[UIView alloc]init];
    _group1DetailView.frame = CGRectMake(0, _group1Title.frame.origin.y + _group1Title.frame.size.height, _group1.frame.size.width, height * 0.1);
    _group1DetailView.backgroundColor = [UIColor whiteColor];
    [_group1 addSubview:_group1DetailView];
    
    _group1Pro1 = [[UITextView alloc]init];
    _group1Pro1.frame = CGRectMake(_group1DetailView.frame.size.width * 0.02, _group1DetailView.frame.size.height * 0.05, _group1DetailView.frame.size.width * 0.68, _group1DetailView.frame.size.height * 0.9);
    _group1Pro1.text = @"1.是否签署实习三方协议？";
    _group1Pro1.textColor = [UIColor blackColor];
    _group1Pro1.font = [UIFont systemFontOfSize:16.0];
    [_group1DetailView addSubview:_group1Pro1];
    
    _group1Switch1 = [HMCustomSwitch switchWithLeftText:@"是" andRight:@"否"];
    _group1Switch1 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group1Pro1.frame.origin.x + _group1Pro1.frame.size.width, _group1DetailView.frame.size.height * 0.2, _group1DetailView.frame.size.width * 0.25, _group1DetailView.frame.size.height * 0.6)];
    _group1Switch1.on = YES;
    [_group1DetailView addSubview:_group1Switch1];
    
    
    /*----------------------------------------------------------------------------------*/
    
    _group2 = [[UIView alloc]init];
    _group2.frame = CGRectMake(_scrollView.frame.size.width * 0.03, _scrollView.frame.size.height * 0.02 + _group1.frame.size.height + _group1.frame.origin.y, _scrollView.frame.size.width * 0.94, height * 0.05 + height * 0.1);
    _group2.layer.cornerRadius = 5;
    _group2.layer.masksToBounds = YES;
    _group2.layer.borderColor = [UIColor grayColor].CGColor;
    _group2.layer.borderWidth = 1;
    _group2.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_group2];
    
    
    _group2Title = [[UILabel alloc]init];
    _group2Title.frame = CGRectMake(0, 0, _group2.frame.size.width, height * 0.05);
    _group2Title.backgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    _group2Title.text = @" (二)专业对口两相关";
    _group2Title.textColor = [UIColor whiteColor];
    [_group2 addSubview:_group2Title];
    
    _group2DetailView = [[UIView alloc]init];
    _group2DetailView.frame = CGRectMake(0, _group2Title.frame.origin.y + _group2Title.frame.size.height, _group2.frame.size.width, height * 0.1);
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
    _group2Switch1.on = YES;
    [_group2DetailView addSubview:_group2Switch1];
    
    
    
   /*----------------------------------------------------------------------------------*/
    
    
    _group3 = [[UIView alloc]init];
    _group3.frame = CGRectMake(_scrollView.frame.size.width * 0.03, _scrollView.frame.size.height * 0.02 + _group2.frame.size.height + _group2.frame.origin.y, _scrollView.frame.size.width * 0.94, height * 0.05 + height * 0.15 + height * 0.1 + height * 0.1);
    _group3.layer.cornerRadius = 5;
    _group3.layer.masksToBounds = YES;
    _group3.layer.borderColor = [UIColor grayColor].CGColor;
    _group3.layer.borderWidth = 1;
    _group3.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_group3];
    
    _group3Title = [[UILabel alloc]init];
    _group3Title.frame = CGRectMake(0, 0, _group3.frame.size.width, height * 0.05);
    _group3Title.backgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    _group3Title.text = @" (三)工作岗位三不准";
    _group3Title.textColor = [UIColor whiteColor];
    [_group3 addSubview:_group3Title];
    
    _group3DetailView = [[UIView alloc]init];
    _group3DetailView.frame = CGRectMake(0, _group3Title.frame.origin.y + _group3Title.frame.size.height, _group3.frame.size.width, height * 0.15 + height * 0.1 + height * 0.1);
    _group3DetailView.backgroundColor = [UIColor whiteColor];
    [_group3 addSubview:_group3DetailView];
    
    
    /*IsWorkplace*/
    _group3Pro1 = [[UITextView alloc]init];
    _group3Pro1.frame = CGRectMake(_group3DetailView.frame.size.width * 0.02, _group3DetailView.frame.size.height * 0.05, _group3DetailView.frame.size.width * 0.68, height * 0.15);
    _group3Pro1.text = @"1.从事高空、井下、放射性、有毒、易燃易爆，以及其他具有较高安全风险的实习？";
    _group3Pro1.textColor = [UIColor blackColor];
    _group3Pro1.font = [UIFont systemFontOfSize:16.0];
    [_group3DetailView addSubview:_group3Pro1];
    
    _group3Switch1 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group3Pro1.frame.origin.x + _group3Pro1.frame.size.width, height * 0.15 * 0.3, _group3DetailView.frame.size.width * 0.25, height * 0.15 * 0.6)];
    _group3Switch1.on = NO;
    [_group3DetailView addSubview:_group3Switch1];
    
    
    UIView *group3line1 = [[UIView alloc]init];
    group3line1.frame = CGRectMake(_group3DetailView.frame.size.width * 0.05, height * 0.15 - 1, _group3DetailView.frame.size.width * 0.95, 1);
    group3line1.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group3DetailView addSubview:group3line1];
    
    
    /*IsRest*/
    _group3Pro2 = [[UITextView alloc]init];
    _group3Pro2.frame = CGRectMake(_group3DetailView.frame.size.width * 0.02, _group3DetailView.frame.size.height * 0.05 + height * 0.15, _group3DetailView.frame.size.width * 0.68, height * 0.1);
    _group3Pro2.text = @"2.存在安排学生在法定节假日实习的情况？";
    _group3Pro2.textColor = [UIColor blackColor];
    _group3Pro2.font = [UIFont systemFontOfSize:16.0];
    [_group3DetailView addSubview:_group3Pro2];
    
    _group3Switch2 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group3Pro2.frame.origin.x + _group3Pro2.frame.size.width, height * 0.15 + height * 0.1 * 0.2, _group3DetailView.frame.size.width * 0.25, height * 0.1 * 0.6)];
    _group3Switch2.on = NO;
    [_group3DetailView addSubview:_group3Switch2];
    
    
    UIView *group3line2 = [[UIView alloc]init];
    group3line2.frame = CGRectMake(_group3DetailView.frame.size.width * 0.05, height * 0.15 + height * 0.1 - 1, _group3DetailView.frame.size.width * 0.95, 1);
    group3line2.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group3DetailView addSubview:group3line2];
    
    
    /*IsOvertime*/
    _group3Pro3 = [[UITextView alloc]init];
    _group3Pro3.frame = CGRectMake(_group3DetailView.frame.size.width * 0.02, _group3DetailView.frame.size.height * 0.05 + height * 0.15 + height * 0.1, _group3DetailView.frame.size.width * 0.68, height * 0.1);
    _group3Pro3.text = @"3.存在安排学生加班和上夜班的情况？";
    _group3Pro3.textColor = [UIColor blackColor];
    _group3Pro3.font = [UIFont systemFontOfSize:16.0];
    [_group3DetailView addSubview:_group3Pro3];
    
    _group3Switch3 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group3Pro3.frame.origin.x + _group3Pro3.frame.size.width, height * 0.15 + height * 0.1 + height * 0.1 * 0.2, _group3DetailView.frame.size.width * 0.25, height * 0.1 * 0.6)];
    _group3Switch3.on = NO;
    [_group3DetailView addSubview:_group3Switch3];

    
    /*----------------------------------------------------------------------------------*/
    
    
    _group4 = [[UIView alloc]init];
    _group4.frame = CGRectMake(_scrollView.frame.size.width * 0.03, _scrollView.frame.size.height * 0.02 + _group3.frame.size.height + _group3.frame.origin.y, _scrollView.frame.size.width * 0.94, height * 0.05 + height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1);
    _group4.layer.cornerRadius = 5;
    _group4.layer.masksToBounds = YES;
    _group4.layer.borderColor = [UIColor grayColor].CGColor;
    _group4.layer.borderWidth = 1;
    _group4.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_group4];
    
    
    _group4Title = [[UILabel alloc]init];
    _group4Title.frame = CGRectMake(0, 0, _group4.frame.size.width, height * 0.05);
    _group4Title.backgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    _group4Title.text = @" (四)实习准备四达标";
    _group4Title.textColor = [UIColor whiteColor];
    [_group4 addSubview:_group4Title];
    
    
    _group4DetailView = [[UIView alloc]init];
    _group4DetailView.frame = CGRectMake(0, _group4Title.frame.origin.y + _group4Title.frame.size.height, _group4.frame.size.width, height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1);
    _group4DetailView.backgroundColor = [UIColor whiteColor];
    [_group4 addSubview:_group4DetailView];
    
    /*IsPlan*/
    _group4Pro1 = [[UITextView alloc]init];
    _group4Pro1.frame = CGRectMake(_group4DetailView.frame.size.width * 0.02, height * 0.1  * 0.05, _group4DetailView.frame.size.width * 0.68, height * 0.1 * 0.9);
    _group4Pro1.text = @"1.学校根据专业人才培养方案，制定了实习计划？";
    _group4Pro1.textColor = [UIColor blackColor];
    _group4Pro1.font = [UIFont systemFontOfSize:16.0];
    [_group4DetailView addSubview:_group4Pro1];
    
    _group4Switch1 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group4Pro1.frame.origin.x + _group4Pro1.frame.size.width, height * 0.1 * 0.2, _group4DetailView.frame.size.width * 0.25, height * 0.1 * 0.6)];
    _group4Switch1.on = YES;
    [_group4DetailView addSubview:_group4Switch1];
    
    
    UIView *group4line1 = [[UIView alloc]init];
    group4line1.frame = CGRectMake(_group4DetailView.frame.size.width * 0.05, height * 0.1 - 1, _group4DetailView.frame.size.width * 0.95, 1);
    group4line1.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group4DetailView addSubview:group4line1];
    
    /*IsEducation*/
    _group4Pro2 = [[UITextView alloc]init];
    _group4Pro2.frame = CGRectMake(_group4DetailView.frame.size.width * 0.02, height * 0.1 + height * 0.1  * 0.05, _group4DetailView.frame.size.width * 0.68, height * 0.1 * 0.9);
    _group4Pro2.text = @"2.学校组织了实习教育或实习培训活动？";
    _group4Pro2.textColor = [UIColor blackColor];
    _group4Pro2.font = [UIFont systemFontOfSize:16.0];
    [_group4DetailView addSubview:_group4Pro2];
    
    _group4Switch2 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group4Pro2.frame.origin.x + _group4Pro2.frame.size.width, height * 0.1 + height * 0.1 * 0.2, _group4DetailView.frame.size.width * 0.25, height * 0.1 * 0.6)];
    _group4Switch2.on = YES;
    [_group4DetailView addSubview:_group4Switch2];
    
    
    UIView *group4line2 = [[UIView alloc]init];
    group4line2.frame = CGRectMake(_group4DetailView.frame.size.width * 0.05, height * 0.1 + height * 0.1 - 1, _group4DetailView.frame.size.width * 0.95, 1);
    group4line2.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group4DetailView addSubview:group4line2];
    
    /*IsGuarantee*/
    _group4Pro3 = [[UITextView alloc]init];
    _group4Pro3.frame = CGRectMake(_group4DetailView.frame.size.width * 0.02,height * 0.1 + height * 0.1 + height * 0.1  * 0.05, _group4DetailView.frame.size.width * 0.68, height * 0.1 * 0.9);
    _group4Pro3.text = @"3.学校制定了实习工作具体管理办法和安全管理规定？";
    _group4Pro3.textColor = [UIColor blackColor];
    _group4Pro3.font = [UIFont systemFontOfSize:16.0];
    [_group4DetailView addSubview:_group4Pro3];
    
    _group4Switch3 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group4Pro3.frame.origin.x + _group4Pro3.frame.size.width,height * 0.1 + height * 0.1 + height * 0.1 * 0.2, _group4DetailView.frame.size.width * 0.25, height * 0.1 * 0.6)];
    _group4Switch3.on = YES;
    [_group4DetailView addSubview:_group4Switch3];
    
    
    UIView *group4line3 = [[UIView alloc]init];
    group4line3.frame = CGRectMake(_group4DetailView.frame.size.width * 0.05,height * 0.1 + height * 0.1 + height * 0.1 - 1, _group4DetailView.frame.size.width * 0.95, 1);
    group4line3.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group4DetailView addSubview:group4line3];
    
    /*IsWarning*/
    _group4Pro4 = [[UITextView alloc]init];
    _group4Pro4.frame = CGRectMake(_group4DetailView.frame.size.width * 0.02,height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1  * 0.05, _group4DetailView.frame.size.width * 0.68, height * 0.1 * 0.9);
    _group4Pro4.text = @"4.学校制定了实习学生安全及突发事件应急预案等制定？";
    _group4Pro4.textColor = [UIColor blackColor];
    _group4Pro4.font = [UIFont systemFontOfSize:16.0];
    [_group4DetailView addSubview:_group4Pro4];
    
    _group4Switch4 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group4Pro3.frame.origin.x + _group4Pro3.frame.size.width,height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 * 0.2, _group4DetailView.frame.size.width * 0.25, height * 0.1 * 0.6)];
    _group4Switch4.on = YES;
    [_group4DetailView addSubview:_group4Switch4];
    
    
    
    /*----------------------------------------------------------------------------------*/
    _group5 = [[UIView alloc]init];
    _group5.frame = CGRectMake(_scrollView.frame.size.width * 0.03, _scrollView.frame.size.height * 0.02 + _group4.frame.size.height + _group4.frame.origin.y, _scrollView.frame.size.width * 0.94, height * 0.05 + height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1);
    _group5.layer.cornerRadius = 5;
    _group5.layer.masksToBounds = YES;
    _group5.layer.borderColor = [UIColor grayColor].CGColor;
    _group5.layer.borderWidth = 1;
    _group5.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_group5];
    
    
    _group5Title = [[UILabel alloc]init];
    _group5Title.frame = CGRectMake(0, 0, _group5.frame.size.width, height * 0.05);
    _group5Title.backgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    _group5Title.text = @" (五)实习组织五不要";
    _group5Title.textColor = [UIColor whiteColor];
    [_group5 addSubview:_group5Title];
    
    
    _group5DetailView = [[UIView alloc]init];
    _group5DetailView.frame = CGRectMake(0, _group5Title.frame.origin.y + _group5Title.frame.size.height, _group5.frame.size.width, height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1);
    _group5DetailView.backgroundColor = [UIColor whiteColor];
    [_group5 addSubview:_group5DetailView];
    
    /*EnterpriseSource*/
    _group5Pro1 = [[UITextView alloc]init];
    _group5Pro1.frame = CGRectMake(_group5DetailView.frame.size.width * 0.02, height * 0.1  * 0.05, _group5DetailView.frame.size.width * 0.68, height * 0.1 * 0.9);
    _group5Pro1.text = @"1.学校安排、教师推荐、自己联系、其他？";
    _group5Pro1.textColor = [UIColor blackColor];
    _group5Pro1.font = [UIFont systemFontOfSize:16.0];
    [_group5DetailView addSubview:_group5Pro1];
    
    _group5Switch1 = [[UILabel alloc] initWithFrame:CGRectMake(_group5Pro1.frame.origin.x + _group5Pro1.frame.size.width, height * 0.1 * 0.2, _group5DetailView.frame.size.width * 0.25, height * 0.1 * 0.6)];
    _group5Switch1.text = @"请选择";
    _group5Switch1.textAlignment = UITextAlignmentRight;
    _group5Switch1.textColor = [UIColor lightGrayColor];
    _group5Switch1.userInteractionEnabled = YES;
    UITapGestureRecognizer *group5Switch1Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(problemAction:)];
    [_group5Switch1 addGestureRecognizer:group5Switch1Tap];
    [_group5DetailView addSubview:_group5Switch1];
    
    
    UIView *group5line1 = [[UIView alloc]init];
    group5line1.frame = CGRectMake(_group5DetailView.frame.size.width * 0.05, height * 0.1 - 1, _group5DetailView.frame.size.width * 0.95, 1);
    group5line1.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group5DetailView addSubview:group5line1];
    
    /*IsENumber*/
    _group5Pro2 = [[UITextView alloc]init];
    _group5Pro2.frame = CGRectMake(_group5DetailView.frame.size.width * 0.02, height * 0.1 + height * 0.1  * 0.05, _group5DetailView.frame.size.width * 0.68, height * 0.1 * 0.9);
    _group5Pro2.text = @"2.实习生人数超过实习单位在岗职工总数的10%？";
    _group5Pro2.textColor = [UIColor blackColor];
    _group5Pro2.font = [UIFont systemFontOfSize:16.0];
    [_group5DetailView addSubview:_group5Pro2];
    
    _group5Switch2 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group5Pro2.frame.origin.x + _group5Pro2.frame.size.width, height * 0.1 + height * 0.1 * 0.2, _group5DetailView.frame.size.width * 0.25, height * 0.1 * 0.6)];
    _group5Switch2.on = NO;
    [_group5DetailView addSubview:_group5Switch2];
    
    
    UIView *group5line2 = [[UIView alloc]init];
    group5line2.frame = CGRectMake(_group4DetailView.frame.size.width * 0.05, height * 0.1 + height * 0.1 - 1, _group4DetailView.frame.size.width * 0.95, 1);
    group5line2.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group5DetailView addSubview:group5line2];
    
    /*IsPNumber*/
    _group5Pro3 = [[UITextView alloc]init];
    _group5Pro3.frame = CGRectMake(_group5DetailView.frame.size.width * 0.02,height * 0.1 + height * 0.1 + height * 0.1  * 0.05, _group5DetailView.frame.size.width * 0.68, height * 0.1 * 0.9);
    _group5Pro3.text = @"3.具体岗位的实习生人数高于该岗位职工总人数的20%？";
    _group5Pro3.textColor = [UIColor blackColor];
    _group5Pro3.font = [UIFont systemFontOfSize:16.0];
    [_group5DetailView addSubview:_group5Pro3];
    
    _group5Switch3 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group5Pro3.frame.origin.x + _group5Pro3.frame.size.width,height * 0.1 + height * 0.1 + height * 0.1 * 0.2, _group5DetailView.frame.size.width * 0.25, height * 0.1 * 0.6)];
    _group5Switch3.on = NO;
    [_group5DetailView addSubview:_group5Switch3];
    
    
    UIView *group5line3 = [[UIView alloc]init];
    group5line3.frame = CGRectMake(_group5DetailView.frame.size.width * 0.05,height * 0.1 + height * 0.1 + height * 0.1 - 1, _group5DetailView.frame.size.width * 0.95, 1);
    group5line3.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group5DetailView addSubview:group5line3];
    
    /*IsExIntervention*/
    _group5Pro4 = [[UITextView alloc]init];
    _group5Pro4.frame = CGRectMake(_group5DetailView.frame.size.width * 0.02,height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1  * 0.05, _group5DetailView.frame.size.width * 0.68, height * 0.1 * 0.9);
    _group5Pro4.text = @"4.存在学校以外的单位干预实习安排的情况？";
    _group5Pro4.textColor = [UIColor blackColor];
    _group5Pro4.font = [UIFont systemFontOfSize:16.0];
    [_group5DetailView addSubview:_group5Pro4];
    
    _group5Switch4 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group5Pro3.frame.origin.x + _group5Pro3.frame.size.width,height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 * 0.2, _group5DetailView.frame.size.width * 0.25, height * 0.1 * 0.6)];
    _group5Switch4.on = NO;
    [_group5DetailView addSubview:_group5Switch4];
    
    UIView *group5line4 = [[UIView alloc]init];
    group5line4.frame = CGRectMake(_group5DetailView.frame.size.width * 0.05,height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 - 1, _group5DetailView.frame.size.width * 0.95, 1);
    group5line4.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group5DetailView addSubview:group5line4];
    
    /*IsExForce*/
    _group5Pro5 = [[UITextView alloc]init];
    _group5Pro5.frame = CGRectMake(_group5DetailView.frame.size.width * 0.02,height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1  * 0.05, _group5DetailView.frame.size.width * 0.68, height * 0.1 * 0.9);
    _group5Pro5.text = @"5.存在强制职业学校安排学生到指定单位实习的情况？";
    _group5Pro5.textColor = [UIColor blackColor];
    _group5Pro5.font = [UIFont systemFontOfSize:16.0];
    [_group5DetailView addSubview:_group5Pro5];
    
    _group5Switch5 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group5Pro5.frame.origin.x + _group5Pro5.frame.size.width,height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 * 0.2, _group5DetailView.frame.size.width * 0.25, height * 0.1 * 0.6)];
    _group5Switch5.on = NO;
    [_group5DetailView addSubview:_group5Switch5];
    
    
    
    /*----------------------------------------------------------------------------------*/
    _group6 = [[UIView alloc]init];
    _group6.frame = CGRectMake(_scrollView.frame.size.width * 0.03, _scrollView.frame.size.height * 0.02 + _group5.frame.size.height + _group5.frame.origin.y, _scrollView.frame.size.width * 0.94, height * 0.05 + height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1);
    _group6.layer.cornerRadius = 5;
    _group6.layer.masksToBounds = YES;
    _group6.layer.borderColor = [UIColor grayColor].CGColor;
    _group6.layer.borderWidth = 1;
    _group6.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_group6];
    
    
    _group6Title = [[UILabel alloc]init];
    _group6Title.frame = CGRectMake(0, 0, _group6.frame.size.width, height * 0.05);
    _group6Title.backgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    _group6Title.text = @" (六)学生权利六不得";
    _group6Title.textColor = [UIColor whiteColor];
    [_group6 addSubview:_group6Title];
    
    
    _group6DetailView = [[UIView alloc]init];
    _group6DetailView.frame = CGRectMake(0, _group6Title.frame.origin.y + _group6Title.frame.size.height, _group6.frame.size.width, height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1);
    _group6DetailView.backgroundColor = [UIColor whiteColor];
    [_group6 addSubview:_group6DetailView];
    
    /*IsGradeOne*/
    _group6Pro1 = [[UITextView alloc]init];
    _group6Pro1.frame = CGRectMake(_group6DetailView.frame.size.width * 0.02, height * 0.1  * 0.05, _group6DetailView.frame.size.width * 0.68, height * 0.1 * 0.9);
    _group6Pro1.text = @"1.一年级在校学生参加顶岗实习？";
    _group6Pro1.textColor = [UIColor blackColor];
    _group6Pro1.font = [UIFont systemFontOfSize:16.0];
    [_group6DetailView addSubview:_group6Pro1];
    
    _group6Switch1 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group6Pro1.frame.origin.x + _group6Pro1.frame.size.width, height * 0.1 * 0.2, _group6DetailView.frame.size.width * 0.25, height * 0.1 * 0.6)];
    _group6Switch1.on = NO;
    [_group6DetailView addSubview:_group6Switch1];
    
    
    UIView *group6line1 = [[UIView alloc]init];
    group6line1.frame = CGRectMake(_group6DetailView.frame.size.width * 0.05, height * 0.1 - 1, _group6DetailView.frame.size.width * 0.95, 1);
    group6line1.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group6DetailView addSubview:group6line1];
    
    /*IsAdult*/
    _group6Pro2 = [[UITextView alloc]init];
    _group6Pro2.frame = CGRectMake(_group6DetailView.frame.size.width * 0.02, height * 0.1 + height * 0.1  * 0.05, _group6DetailView.frame.size.width * 0.68, height * 0.1 * 0.9);
    _group6Pro2.text = @"2.未满16周岁的学生参加跟岗实习、顶岗实习？";
    _group6Pro2.textColor = [UIColor blackColor];
    _group6Pro2.font = [UIFont systemFontOfSize:16.0];
    [_group6DetailView addSubview:_group6Pro2];
    
    _group6Switch2 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group6Pro2.frame.origin.x + _group6Pro2.frame.size.width, height * 0.1 + height * 0.1 * 0.2, _group6DetailView.frame.size.width * 0.25, height * 0.1 * 0.6)];
    _group6Switch2.on = NO;
    [_group6DetailView addSubview:_group6Switch2];
    
    
    UIView *group6line2 = [[UIView alloc]init];
    group6line2.frame = CGRectMake(_group6DetailView.frame.size.width * 0.05, height * 0.1 + height * 0.1 - 1, _group6DetailView.frame.size.width * 0.95, 1);
    group6line2.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group6DetailView addSubview:group6line2];
    
    /*IsTaboo*/
    _group6Pro3 = [[UITextView alloc]init];
    _group6Pro3.frame = CGRectMake(_group6DetailView.frame.size.width * 0.02,height * 0.1 + height * 0.1 + height * 0.1  * 0.05, _group6DetailView.frame.size.width * 0.68, height * 0.1 * 0.9);
    _group6Pro3.text = @"3.未成年学生从事《未成年工特殊保护规定》中禁忌从事的劳动？";
    _group6Pro3.textColor = [UIColor blackColor];
    _group6Pro3.font = [UIFont systemFontOfSize:16.0];
    [_group6DetailView addSubview:_group6Pro3];
    
    _group6Switch3 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group6Pro3.frame.origin.x + _group6Pro3.frame.size.width,height * 0.1 + height * 0.1 + height * 0.1 * 0.2, _group6DetailView.frame.size.width * 0.25, height * 0.1 * 0.6)];
    _group6Switch3.on = NO;
    [_group6DetailView addSubview:_group6Switch3];
    
    
    UIView *group6line3 = [[UIView alloc]init];
    group6line3.frame = CGRectMake(_group6DetailView.frame.size.width * 0.05,height * 0.1 + height * 0.1 + height * 0.1 - 1, _group6DetailView.frame.size.width * 0.95, 1);
    group6line3.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group6DetailView addSubview:group6line3];
    
    /*IsWomenTaboo*/
    _group6Pro4 = [[UITextView alloc]init];
    _group6Pro4.frame = CGRectMake(_group6DetailView.frame.size.width * 0.02,height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1  * 0.05, _group6DetailView.frame.size.width * 0.68, height * 0.1 * 0.9);
    _group6Pro4.text = @"4.女学生从事《女职工劳动保护特别规定》中禁忌从事的劳动？";
    _group6Pro4.textColor = [UIColor blackColor];
    _group6Pro4.font = [UIFont systemFontOfSize:16.0];
    [_group6DetailView addSubview:_group6Pro4];
    
    _group6Switch4 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group6Pro3.frame.origin.x + _group6Pro3.frame.size.width,height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 * 0.2, _group6DetailView.frame.size.width * 0.25, height * 0.1 * 0.6)];
    _group6Switch4.on = NO;
    [_group6DetailView addSubview:_group6Switch4];
    
    UIView *group6line4 = [[UIView alloc]init];
    group6line4.frame = CGRectMake(_group6DetailView.frame.size.width * 0.05,height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 - 1, _group6DetailView.frame.size.width * 0.95, 1);
    group6line4.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group6DetailView addSubview:group6line4];
    
    /*IsBar*/
    _group6Pro5 = [[UITextView alloc]init];
    _group6Pro5.frame = CGRectMake(_group6DetailView.frame.size.width * 0.02,height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1  * 0.05, _group6DetailView.frame.size.width * 0.68, height * 0.1 * 0.9);
    _group6Pro5.text = @"5.到酒吧、夜总会、歌厅、洗浴中心等营业性娱乐场所实习？";
    _group6Pro5.textColor = [UIColor blackColor];
    _group6Pro5.font = [UIFont systemFontOfSize:16.0];
    [_group6DetailView addSubview:_group6Pro5];
    
    _group6Switch5 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group6Pro5.frame.origin.x + _group6Pro5.frame.size.width,height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 * 0.2, _group6DetailView.frame.size.width * 0.25, height * 0.1 * 0.6)];
    _group6Switch5.on = NO;
    [_group6DetailView addSubview:_group6Switch5];
    
    UIView *group6line5 = [[UIView alloc]init];
    group6line5.frame = CGRectMake(_group6DetailView.frame.size.width * 0.05,height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 - 1, _group6DetailView.frame.size.width * 0.95, 1);
    group6line5.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_group6DetailView addSubview:group6line5];
    
    /*IsIntermediary*/
    _group6Pro6 = [[UITextView alloc]init];
    _group6Pro6.frame = CGRectMake(_group6DetailView.frame.size.width * 0.02,height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1  * 0.05, _group6DetailView.frame.size.width * 0.68, height * 0.1 * 0.9);
    _group6Pro6.text = @"6.通过中介机构或有偿代理组织、安排和管理学生实习工作？";
    _group6Pro6.textColor = [UIColor blackColor];
    _group6Pro6.font = [UIFont systemFontOfSize:16.0];
    [_group6DetailView addSubview:_group6Pro6];
    
    _group6Switch6 = [[HMCustomSwitch alloc] initWithFrame:CGRectMake(_group6Pro6.frame.origin.x + _group6Pro6.frame.size.width,height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 + height * 0.1 * 0.2, _group6DetailView.frame.size.width * 0.25, height * 0.1 * 0.6)];
    _group6Switch6.on = NO;
    [_group6DetailView addSubview:_group6Switch6];
    
    
    CGFloat scrollHeight = _group1.frame.size.height + _group2.frame.size.height + _group3.frame.size.height + _group4.frame.size.height + _group5.frame.size.height + _group6.frame.size.height + _scrollView.frame.size.height * 0.03 * 6;
    _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, scrollHeight);
    
    [_group1Pro1 setEditable:NO];
    [_group2Pro1 setEditable:NO];
    [_group3Pro1 setEditable:NO];
    [_group3Pro2 setEditable:NO];
    [_group3Pro3 setEditable:NO];
    [_group4Pro1 setEditable:NO];
    [_group4Pro2 setEditable:NO];
    [_group4Pro3 setEditable:NO];
    [_group4Pro4 setEditable:NO];
    [_group5Pro1 setEditable:NO];
    [_group5Pro2 setEditable:NO];
    [_group5Pro3 setEditable:NO];
    [_group5Pro4 setEditable:NO];
    [_group5Pro5 setEditable:NO];
    [_group6Pro1 setEditable:NO];
    [_group6Pro2 setEditable:NO];
    [_group6Pro3 setEditable:NO];
    [_group6Pro4 setEditable:NO];
    [_group6Pro5 setEditable:NO];
    [_group6Pro6 setEditable:NO];
    
}


-(void) submitAction:(UIButton *)sender{
    
    
    [_activityIndicatorView startAnimating];
    
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    
    NSString *isQYFlag = @"";
    if(_uploadQYFlag){
        isQYFlag = @"true";
    }else{
        isQYFlag = @"false";
    }
    
    
    NSString *CurrTime = [PhoneInfo getNowTimeTimestamp3];
    
    NSString *setToken = [NSString stringWithFormat:@"%@GJApply%@",CurrAdminID,CurrTime];
    NSString *Token = [AizenMD5 MD5ForUpper16Bate:setToken];
    
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipApplyEnterpriseInfo/Apply",kCacheHttpRoot];
//    asdadasd
//    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:CurrAdminID,@"Creater",batchID,@"ActivityID",_uploadID,@"EnterpriseID",_uploadStationID,@"PositionID",_uploadQYName,@"EnterpriseName",_uploadQYCode,@"CreditCode",_uploadQYAddress,@"Address",_uploadQYTotal,@"StaffTotal",_uploadQYFlag == YES?@"true":@"false",@"IsPracticeBase",_uploadStationName,@"PositionName",_uploadStationTotal,@"PStaffTotal",_uploadStationIntro == nil?@"":_uploadStationIntro,@"PDescription",_uploadJSName,@"LinkManName",_uploadJSPhone == nil?@"":_uploadJSPhone,@"LinkManMobile",_uploadJSTel == nil?@"":_uploadJSTel,@"LinkManTel",_uploadJSEmail == nil?@"":_uploadJSEmail,@"LinkManEmail",_uploadSaraly == nil?@"":_uploadSaraly,@"MonthlySalary",_uploadDate == nil?@"":_uploadDate,@"ComeWorkDate",_uploadStay == nil?@"":_uploadStay,@"AccommodationType",_uploadFood == nil?@"":_uploadFood,@"FoodType",_uploadDescr == nil?@"":_uploadDescr,@"Description",_uploadJSID == nil?@"":_uploadJSID,@"LinkManID",_uploadAgreement == nil?@"":_uploadAgreement,@"AgreementUrl",_group2Switch1.on == YES?@"true":@"false",@"RelevantType",_group3Switch1.on == YES?@"true":@"false",@"IsWorkplace",_group3Switch2.on == YES?@"true":@"false",@"IsRest",_group3Switch3.on == YES?@"true":@"false",@"IsOvertime",_group4Switch1.on == YES?@"true":@"false",@"IsPlan",_group4Switch2.on == YES?@"true":@"false",@"IsEducation",_group4Switch3.on == YES?@"true":@"false",@"IsGuarantee",_group4Switch4.on == YES?@"true":@"false",@"IsWarning",_problemVal == nil?@"":_problemVal,@"EnterpriseSource",_group5Switch2.on == YES?@"true":@"false",@"IsENumber",_group5Switch3.on == YES?@"true":@"false",@"IsPNumber",_group5Switch4.on == YES?@"true":@"false",@"IsExIntervention",_group5Switch5.on == YES?@"true":@"false",@"IsExForce",_group6Switch1.on == YES?@"true":@"false",@"IsGradeOne",_group6Switch2.on == YES?@"true":@"false",@"IsAdult",_group6Switch3.on == YES?@"true":@"false",@"IsTaboo",_group6Switch4.on == YES?@"true":@"false",@"IsWomenTaboo",_group6Switch5.on == YES?@"true":@"false",@"IsBar",_group6Switch6.on == YES?@"true":@"false",@"IsIntermediary",CurrTime,@"TimeStamp",Token,@"Token", nil];
    
    NSMutableDictionary *params1 = [NSMutableDictionary dictionaryWithCapacity:0];
    [params1 setObject:isQYFlag forKey:@"IsPracticeBase"];
    [params1 setObject:CurrAdminID forKey:@"Creater"];
    [params1 setObject:batchID forKey:@"ActivityID"];
    
    [params1 setObject:Token forKey:@"Token"];

    [params1 setObject:CurrTime forKey:@"TimeStamp"];
    [params1 setObject:@"A" forKey:@"ApplyType"];//A-新增申请、U-转岗、D-辞职
    //"中介代理限制：通过中介机构或有偿代理组织、安排和管理学生实习工作"
    [params1 setObject:@(_group6Switch6.on) forKey:@"IsIntermediary"];

    //me = "娱乐场所限制：到酒吧、夜总会、歌厅、洗浴中心等营业性娱乐场所实习")
    [params1 setObject:@(_group6Switch5.on) forKey:@"IsBar"];

    //= "女职工保障：女学生从事《女职工劳动保护特别规定》中禁忌从事的劳动"
    [params1 setObject:@(_group6Switch4.on) forKey:@"IsWomenTaboo"];

    //= "未成年工保障：未成年学生从事《未成年工特殊保护规定》中禁忌从事的劳动
    [params1 setObject:@(_group6Switch3.on) forKey:@"IsTaboo"];

    //"学生年龄保障：未满16周岁的学生参加跟岗实习、顶岗实习")
    [params1 setObject:@(_group6Switch2.on) forKey:@"IsAdult"];

    //"在校年级保障：一年级在校学生参加顶岗实习")
    [params1 setObject:@(_group6Switch1.on) forKey:@"IsGradeOne"];
    
    //"外部强制情况：存在强制职业学校安排学生到指定单位实习的情况
    [params1 setObject:@(_group5Switch5.on) forKey:@"IsExForce"];

    //"外部干预情况：存在学校以外的单位干预实习安排的情况")
    [params1 setObject:@(_group5Switch4.on) forKey:@"IsExIntervention"];

    //= "岗位员工数：具体岗位的实习生人数高于该岗位职工总人数的20%"
    [params1 setObject:@(_group5Switch3.on) forKey:@"IsPNumber"];

    //"单位员工数：实习生人数超过实习单位在岗职工总数的10%")
    [params1 setObject:@(_group5Switch2.on) forKey:@"IsENumber"];

    if (_problemVal == nil) {
        _problemVal = @"";
    }
    //"实习岗位来源"
    [params1 setObject:_problemVal forKey:@"EnterpriseSource"];
    
    //"预警机制")
    [params1 setObject:@(_group4Switch4.on) forKey:@"IsWarning"];

    //"制度保障")
    [params1 setObject:@(_group4Switch3.on) forKey:@"IsGuarantee"];

    //"实习教育"
    [params1 setObject:@(_group4Switch2.on) forKey:@"IsEducation"];

    //"实习计划"
    [params1 setObject:@(_group4Switch1.on) forKey:@"IsPlan"];
    //"加班夜班：存在安排学生加班和上夜班的情况")
    [params1 setObject:@(_group3Switch3.on) forKey:@"IsOvertime"];
    //"休息休假：存在安排学生在法定节假日实习的情况"
    [params1 setObject:@(_group3Switch2.on) forKey:@"IsRest"];
    //e = "工作场所：从事高空、井下、放射性、有毒、易燃易爆，以及其他具有较高安全风险的实习"
    [params1 setObject:@(_group3Switch1.on) forKey:@"IsWorkplace"];
    //"专业相关程度
    [params1 setObject:@(_group2Switch1.on) forKey:@"RelevantType"];
    
    if (_uploadAgreement == nil) {//"实习协议"
        _uploadAgreement = @"";
    }
    [params1 setObject:_uploadAgreement forKey:@"AgreementUrl"];

    if (_uploadJSID == nil) {//"企业指导老师ID（可为空）")
        _uploadJSID = @"";
    }
    [params1 setObject:_uploadJSID forKey:@"LinkManID"];

    
    if (_uploadDescr == nil) {//"说明"
        _uploadDescr = @"";
    }
    [params1 setObject:_uploadDescr forKey:@"Description"];

    if (_uploadFood == nil) {//"伙食条件"
        _uploadFood = @"";
    }
    [params1 setObject:_uploadFood forKey:@"FoodType"];

    if (_uploadStay == nil) {//"住宿条件"
        _uploadStay = @"";
    }
    [params1 setObject:_uploadStay forKey:@"AccommodationType"];

    if (_uploadDate == nil) {//"上岗日期
        _uploadDate = @"";
    }
    [params1 setObject:_uploadDate forKey:@"ComeWorkDate"];

    if (_uploadSaraly == nil) {//月收入
        _uploadSaraly = @"";
    }
    [params1 setObject:_uploadSaraly forKey:@"MonthlySalary"];

    
    if (_uploadID == nil) { //"所属企业ID（可为空）
        _uploadID = @"";
    }
    [params1 setObject:_uploadID forKey:@"EnterpriseID"];

    if (_uploadStationID == nil) {//所属岗位ID（可为空
        _uploadStationID = @"";
    }
    [params1 setObject:_uploadStationID forKey:@"PositionID"];

    if (_uploadQYName == nil) {
        //"企业名称
        _uploadQYName = @"";
    }
    [params1 setObject:_uploadQYName forKey:@"EnterpriseName"];

    if (_uploadQYCode == nil) {//企业代码"
        _uploadQYCode = @"";
    }
    [params1 setObject:_uploadQYCode forKey:@"CreditCode"];

    
    if (_uploadQYAddress == nil) {//企业地址
        _uploadQYAddress = @"";
    }
    [params1 setObject:_uploadQYAddress forKey:@"Address"];

    if (_uploadQYTotal == nil) {//StaffTotal
        _uploadQYTotal = @"";
    }
    [params1 setObject:_uploadQYTotal forKey:@"StaffTotal"];

//    if (_uploadQYCode) {//企业代码"
//        [params1 setObject:_uploadQYCode forKey:@"CreditCode"];
//    }
    //是否实习基地"
    [params1 setObject:@(_uploadQYFlag) forKey:@"IsPracticeBase"];
    
    
    if (_uploadStationName == nil) {//岗位名称"
        _uploadStationName = @"";
    }
    [params1 setObject:_uploadStationName forKey:@"PositionName"];

    if (_uploadStationTotal == nil) {//"在岗员工数"
        _uploadStationTotal = @"";
    }
    
    [params1 setObject:_uploadStationTotal forKey:@"PStaffTotal"];

    if (_uploadStationIntro == nil) {//"岗位说明")
        _uploadStationIntro = @"";
    }
    [params1 setObject:_uploadStationIntro forKey:@"PDescription"];

    if (_uploadJSName == nil) {//"企业指导老师"
        _uploadJSName = @"";
    }
    [params1 setObject:_uploadJSName forKey:@"LinkManName"];

    if (_uploadJSPhone == nil) {//"老师手机"
        _uploadJSPhone = @"";
    }
    [params1 setObject:_uploadJSPhone forKey:@"LinkManMobile"];

    if (_uploadJSTel == nil) {//"老师电话"
        _uploadJSTel = @"";
    }
    [params1 setObject:_uploadJSTel forKey:@"LinkManTel"];

    if (_uploadJSEmail == nil) {//"企业邮箱"
        _uploadJSEmail = @"";
    }
    [params1 setObject:_uploadJSEmail forKey:@"LinkManEmail"];

    
    
    
    
//    NSString* encodeUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [AizenHttp asynRequest:url httpMethod:@"POST" params:params1 success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] intValue] == 0){
            RAlertView *alert = [[RAlertView alloc]initWithStyle:ConfirmAlert];
            alert.headerTitleLabel.text = @"提示";
            alert.contentTextLabel.text = [jsonDic objectForKey:@"Message"];
//            alert.isClickBackgroundCloseWindow = YES;
            alert.confirm = ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            };
            
        }else{
            RAlertView *alert = [[RAlertView alloc]initWithStyle:SimpleAlert];
            alert.headerTitleLabel.text = @"提示";
            alert.contentTextLabel.text = [jsonDic objectForKey:@"Message"];
            alert.isClickBackgroundCloseWindow = YES;
        }
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败--提交岗位申请");
    }];
    
    
}


-(void) problemAction:(UITapGestureRecognizer *)sender{
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"请选额"
                                                   cancelButtonTitle:@"取消"
                                                  confirmButtonTitle:@"提交"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    picker.headerBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    picker.confirmButtonBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    [picker show];
}


#pragma mark - CZPickerViewDataSource
/* number of items for picker */
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    return [_problemArr count];
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
    return [_problemArr objectAtIndex:row];
}




#pragma mark - CZPickerViewDelegate
/** delegate method for picking one item */
- (void)czpickerView:(CZPickerView *)pickerView
didConfirmWithItemAtRow:(NSInteger)row{
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
