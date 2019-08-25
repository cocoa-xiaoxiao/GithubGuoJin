//
//  AddStationTwoViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/3/2.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "AddStationTwoViewController.h"
#import "AddStationThreeViewController.h"
#import "StationDetailViewController.h"
#import "MainViewController.h"
#import "DGActivityIndicatorView.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "RAlertView.h"

#import <IQKeyboardManager/IQPreviousNextView.h>
@interface AddStationTwoViewController ()<UITextFieldDelegate>

@property(nonatomic,strong) UIView *contentView;

@property(nonatomic,strong) UIView *titleView;
@property(nonatomic,retain) UILabel *titleLab;

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

@property(nonatomic,strong) UIView *baseView;
@property(nonatomic,strong) UILabel *baseLab;
@property(nonatomic,strong) UIView *baseField;

@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UILabel *bottomLab;

@property(nonatomic,strong) UIButton *nextBtn;

@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

@property(nonatomic,strong) NSString *uploadStationID;
@property(nonatomic,strong) NSString *uploadStationName;
@property(nonatomic,strong) NSString *uploadStationTotal;
@property(nonatomic,strong) NSString *uploadStationIntro;

@end

@implementation AddStationTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"添加岗位信息";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [self startLayout];
}

-(void) startLayout{
    _contentView = [[IQPreviousNextView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, self.view.frame.size.width, self.view.frame.size.height - (HEIGHT_STATUSBAR + HEIGHT_NAVBAR));
    _contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
    
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[UIColor grayColor]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [_contentView addSubview:_activityIndicatorView];
    
    
    _nextBtn = [[UIButton alloc]init];
    _nextBtn.frame = CGRectMake(0, _contentView.frame.size.height - HEIGHT_TABBAR, _contentView.frame.size.width, HEIGHT_TABBAR);
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBtn.backgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    [_nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_nextBtn];
    
    _titleView = [[UIView alloc]init];
    _titleView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height * 0.05);
    [_contentView addSubview:_titleView];
    
    _titleLab = [[UILabel alloc]init];
    _titleLab.frame = CGRectMake(_titleView.frame.size.width * 0.05, 0, _titleView.frame.size.width * 0.45, _titleView.frame.size.height);
    _titleLab.text = @"岗位信息";
    _titleLab.font = [UIFont systemFontOfSize:13.0];
    _titleLab.textColor = [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1];
    [_titleView addSubview:_titleLab];
    
    _stationView = [[UIView alloc]init];
    _stationView.frame = CGRectMake(0, _titleView.frame.origin.y + _titleView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height * 0.08);
    _stationView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_stationView];
    
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
    [_stationView addSubview:_stationField];
    
    UIView * line1 = [[UIView alloc]init];
    line1.frame = CGRectMake(_stationView.frame.size.width * 0.05, _stationView.frame.size.height - 1, _stationView.frame.size.width * 0.95, 1);
    line1.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_stationView addSubview:line1];
    
    
    _stationPeopleView = [[UIView alloc]init];
    _stationPeopleView.frame = CGRectMake(0, _stationView.frame.origin.y + _stationView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height * 0.08);
    _stationPeopleView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_stationPeopleView];
    
    _stationPeopleLab = [[UILabel alloc]init];
    _stationPeopleLab.frame = CGRectMake(_stationPeopleView.frame.size.width * 0.05, 0, _stationPeopleView.frame.size.width * 0.45, _stationPeopleView.frame.size.height);
    _stationPeopleLab.text = @"在岗员工数";
    _stationPeopleLab.textColor = [UIColor blackColor];
    _stationPeopleLab.font = [UIFont systemFontOfSize:18.0];
    [_stationPeopleView addSubview:_stationPeopleLab];
    
    
    _stationPeopleField = [[BaseTextFeild alloc]init];
    _stationPeopleField.frame = CGRectMake(_stationPeopleLab.frame.origin.x + _stationPeopleLab.frame.size.width, 0, _stationPeopleView.frame.size.width * 0.45, _stationPeopleView.frame.size.height);
    _stationPeopleField.placeholder = @"请输入";
    _stationPeopleField.textAlignment = UITextAlignmentRight;
    _stationPeopleField.font = [UIFont systemFontOfSize:18.0];
    [_stationPeopleView addSubview:_stationPeopleField];
    _stationPeopleField.delegate  = self;
    _stationPeopleField.keyboardType = UIKeyboardTypeNumberPad;

    
    UIView * line2 = [[UIView alloc]init];
    line2.frame = CGRectMake(_stationPeopleView.frame.size.width * 0.05, _stationPeopleView.frame.size.height - 1, _stationPeopleView.frame.size.width * 0.95, 1);
    line2.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_stationPeopleView addSubview:line2];
    
    
    _stationInstrView = [[UIView alloc]init];
    _stationInstrView.frame = CGRectMake(0, _stationPeopleView.frame.origin.y + _stationPeopleView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height * 0.08);
    _stationInstrView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_stationInstrView];
    
    _stationInstrLab = [[UILabel alloc]init];
    _stationInstrLab.frame = CGRectMake(_stationInstrView.frame.size.width * 0.05, 0, _stationInstrView.frame.size.width * 0.45, _stationInstrView.frame.size.height);
    _stationInstrLab.text = @"岗位简介";
    _stationInstrLab.textColor = [UIColor blackColor];
    _stationInstrLab.font = [UIFont systemFontOfSize:18.0];
    [_stationInstrView addSubview:_stationInstrLab];
    
    
    _stationInstrField = [[BaseTextFeild alloc]init];
    _stationInstrField.frame = CGRectMake(_stationInstrLab.frame.origin.x + _stationInstrLab.frame.size.width, 0, _stationInstrView.frame.size.width * 0.45, _stationInstrView.frame.size.height);
    _stationInstrField.placeholder = @"请输入";
    _stationInstrField.textAlignment = UITextAlignmentRight;
    _stationInstrField.font = [UIFont systemFontOfSize:18.0];
    [_stationInstrView addSubview:_stationInstrField];
    _stationInstrField.delegate  = self;
    
    UIView * line3 = [[UIView alloc]init];
    line3.frame = CGRectMake(_stationInstrView.frame.size.width * 0.05, _stationInstrView.frame.size.height - 1, _stationInstrView.frame.size.width * 0.95, 1);
    line3.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_stationInstrView addSubview:line3];
    
    
    _bottomView = [[UIView alloc]init];
    _bottomView.frame = CGRectMake(0, _stationInstrView.frame.size.height + _stationInstrView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height * 0.05);
    [_contentView addSubview:_bottomView];
    
    _bottomLab = [[UILabel alloc]init];
    _bottomLab.frame = CGRectMake(_bottomView.frame.size.width * 0.05, 0, _bottomView.frame.size.width * 0.45, _bottomView.frame.size.height);
    _bottomLab.text = @"第二步，共五步";
    _bottomLab.font = [UIFont systemFontOfSize:13.0];
    _bottomLab.textColor = [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1];
    [_bottomView addSubview:_bottomLab];
}


- (NSString *)br_jduagehadNilData{

    NSString *msg= @"";
    if (_uploadStationName == NULL || _uploadStationName == nil || _uploadStationName.length == 0) {
        msg = @"请输入岗位";
        return msg;
    }
    if (_stationPeopleField.text.length == 0) {
        msg = @"请输入岗员工数";
        return msg;
    }
    
  
    return msg;
}
-(void) nextAction:(UIButton *)sender{
    NSString *msg = [self br_jduagehadNilData];
    if(msg.length > 0){
        RAlertView *alert = [[RAlertView alloc]initWithStyle:SimpleAlert];
        alert.headerTitleLabel.text = @"提示";
        alert.contentTextLabel.text = msg;
        alert.isClickBackgroundCloseWindow = YES;
    }else{
        AddStationThreeViewController *three = [[AddStationThreeViewController alloc]init];
        three.uploadID = _uploadID;
        three.uploadQYName = _uploadQYName;
        three.uploadQYCode = _uploadQYCode;
        three.uploadQYTotal = _uploadQYTotal;
        three.uploadQYAddress = _uploadQYAddress;
        three.uploadQYFlag = _uploadQYFlag;

        three.uploadStationID = _uploadStationID;
        three.uploadStationName = _uploadStationName;
        three.uploadStationIntro = _stationInstrField.text; //_uploadStationIntro;
        three.uploadStationTotal = _stationPeopleField.text;//_uploadStationTotal;
        [self.navigationController pushViewController:three animated:YES];
    }
}



-(void) stationAction:(UITapGestureRecognizer *)sender{
    StationDetailViewController *station = [[StationDetailViewController alloc]init];
    station.uploadID = _uploadID;
    [self.navigationController pushViewController:station animated:YES];
}


-(void) viewDidAppear:(BOOL)animated{
    if([_getStationDic objectForKey:@"ID"]){
        if([[_getStationDic objectForKey:@"ID"] isEqualToString:@"0"]){
            _stationField.text = [_getStationDic objectForKey:@"PositionName"];
            _stationField.textColor = [UIColor blackColor];
            _uploadStationName = [_getStationDic objectForKey:@"PositionName"];

            _uploadStationID = @"0";
        }else{
            _stationField.text = [_getStationDic objectForKey:@"PositionName"];
            _stationField.textColor = [UIColor blackColor];
            
            _uploadStationID = [_getStationDic objectForKey:@"ID"];
            _uploadStationName = [_getStationDic objectForKey:@"PositionName"];
            
            [_activityIndicatorView startAnimating];
            NSString *url = [NSString stringWithFormat:@"%@/ApiEnterpriseInfo/GetPositionInfo?PositionID=%@",kCacheHttpRoot,[_getStationDic objectForKey:@"ID"]];
            [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
                [_activityIndicatorView stopAnimating];
                NSDictionary *jsonDic = result;
                if([[jsonDic objectForKey:@"ResultType"] intValue] == 0){
                    [self handleOtherData:[[jsonDic objectForKey:@"AppendData"] objectAtIndex:0]];
                }
            } failue:^(NSError *error) {
                [_activityIndicatorView stopAnimating];
                NSLog(@"请求失败--获取岗位信息");
            }];
            
            
        }
    }
}



-(void) handleOtherData:(NSDictionary *)dataDic{
    _stationPeopleField.text = [[dataDic objectForKey:@"StaffTotal"] stringValue];
    
    _uploadStationTotal = [[dataDic objectForKey:@"StaffTotal"] stringValue];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
