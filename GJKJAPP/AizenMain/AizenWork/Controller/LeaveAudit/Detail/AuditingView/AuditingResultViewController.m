//
//  AuditingResultViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/2/25.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "AuditingResultViewController.h"
#import "RDVTabBarController.h"
#import "AizenStorage.h"
#import "AizenHttp.h"
#import "AizenMD5.h"
#import "PhoneInfo.h"
#import "People.h"
#import "AizenMD5.h"
#import "RAlertView.h"
#import "DGActivityIndicatorView.h"


@interface AuditingResultViewController ()

@property(nonatomic,strong) UIView *contentView;

@property(nonatomic,strong) UIView *topView;

@property(nonatomic,strong) UIView *nameView;
@property(nonatomic,strong) UIImageView *headImgView;
@property(nonatomic,strong) UILabel *nameLab;
@property(nonatomic,strong) UILabel *statusLab;
@property(nonatomic,strong) UIView *nameViewLine;

@property(nonatomic,strong) UIView *detailView;
@property(nonatomic,strong) UIView *numView;
@property(nonatomic,strong) UIView *deparmentView;
@property(nonatomic,strong) UIView *typeView;
@property(nonatomic,strong) UIView *startView;
@property(nonatomic,strong) UIView *endView;
@property(nonatomic,strong) UIView *totalView;
@property(nonatomic,strong) UIView *reasonView;
@property(nonatomic,strong) UIView *historyView;


@property(nonatomic,strong) UILabel *numLab;
@property(nonatomic,strong) UILabel *numVal;
@property(nonatomic,strong) UILabel *deparmentLab;
@property(nonatomic,strong) UILabel *deparmentVal;
@property(nonatomic,strong) UILabel *typeLab;
@property(nonatomic,strong) UILabel *typeVal;
@property(nonatomic,strong) UILabel *startLab;
@property(nonatomic,strong) UILabel *startVal;
@property(nonatomic,strong) UILabel *endLab;
@property(nonatomic,strong) UILabel *endVal;
@property(nonatomic,strong) UILabel *totalLab;
@property(nonatomic,strong) UILabel *totalVal;
@property(nonatomic,strong) UILabel *reasonLab;
@property(nonatomic,strong) UITextView *reasonVal;
@property(nonatomic,strong) UILabel *historyLab;
@property(nonatomic,strong) UIView *historyLineView;

@property(nonatomic,strong) UIView *btnView;
@property(nonatomic,strong) UIButton *agreeBtn;
@property(nonatomic,strong) UIButton *refuseBtn;
@property(nonatomic,strong) UIButton *tranferBtn;

@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

@end

@implementation AuditingResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *titleName = [NSString stringWithFormat:@"%@的请假",[_dataDic objectForKey:@"name"]];
    self.navigationItem.title = titleName;
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    [self startLayout];
}

-(void) startLayout{
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[UIColor whiteColor]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 100)/2, 100, 100);
    [self.view addSubview:_activityIndicatorView];
    
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, self.view.frame.size.width, self.view.frame.size.height - (HEIGHT_NAVBAR + HEIGHT_STATUSBAR))];
    _contentView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height * 0.6)];
    _topView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_topView];
    
    
    _nameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _topView.frame.size.width, _topView.frame.size.height * 0.2)];
    [_topView addSubview:_nameView];
    
    
    _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(_nameView.frame.size.width * 0.05, _nameView.frame.size.height * 0.15, _nameView.frame.size.height * 0.7, _nameView.frame.size.height * 0.7)];
    _headImgView.layer.cornerRadius = _nameView.frame.size.height * 0.7 / 2;
    _headImgView.layer.masksToBounds = YES;
    _headImgView.image = [UIImage imageNamed:@"gj_auditinghead"];
    [_nameView addSubview:_headImgView];
    
    _nameViewLine = [[UIView alloc]initWithFrame:CGRectMake(_nameView.frame.size.width * 0.05, _nameView.frame.size.height - 1, _nameView.frame.size.width * 0.95, 1)];
    _nameViewLine.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    [_nameView addSubview:_nameViewLine];
    
    _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(_headImgView.frame.size.width + _headImgView.frame.origin.x + 10, _headImgView.frame.origin.y, _nameView.frame.size.width * 0.3, _headImgView.frame.size.height * 0.5)];
    _nameLab.text = [_dataDic objectForKey:@"name"];
    _nameLab.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];
    [_nameView addSubview:_nameLab];
    
    _statusLab = [[UILabel alloc]initWithFrame:CGRectMake(_nameLab.frame.origin.x, _nameLab.frame.origin.y + _nameLab.frame.size.height, _nameView.frame.size.width * 0.3, _headImgView.frame.size.height * 0.5)];
    _statusLab.text = @"等待审批";
    _statusLab.font = [UIFont systemFontOfSize:13.0];
    _statusLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    [_nameView addSubview:_statusLab];
    
    _detailView = [[UIView alloc]initWithFrame:CGRectMake(0, _nameView.frame.size.height + _nameView.frame.origin.y, _contentView.frame.size.width, _topView.frame.size.height * 0.8)];
    [_contentView addSubview:_detailView];
    
    _numView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _detailView.frame.size.width, _detailView.frame.size.height * 0.1)];
    [_detailView addSubview:_numView];
    
    _numLab = [[UILabel alloc]initWithFrame:CGRectMake(_numView.frame.size.width * 0.05, 0, _numView.frame.size.width * 0.25, _numView.frame.size.height)];
    _numLab.text = @"审批编号";
    _numLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    [_numView addSubview:_numLab];
    
    _numVal = [[UILabel alloc]initWithFrame:CGRectMake(_numLab.frame.size.width + _numLab.frame.origin.x, 0, _numView.frame.size.width * 0.65, _numView.frame.size.height)];
    _numVal.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];
    _numVal.text = [_dataDic objectForKey:@"id"];
    [_numView addSubview:_numVal];
    
    
    _deparmentView = [[UIView alloc]initWithFrame:CGRectMake(0, _numView.frame.size.height + _numView.frame.origin.y, _detailView.frame.size.width, _detailView.frame.size.height * 0)];
    [_detailView addSubview:_deparmentView];
    _deparmentView.hidden = YES;
    
    _deparmentLab = [[UILabel alloc]initWithFrame:CGRectMake(_deparmentView.frame.size.width * 0.05, 0, _deparmentView.frame.size.width * 0.25, _deparmentView.frame.size.height)];
    _deparmentLab.text = @"所在部门";
    _deparmentLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    [_deparmentView addSubview:_deparmentLab];
    
    _deparmentVal = [[UILabel alloc]initWithFrame:CGRectMake(_deparmentLab.frame.size.width + _deparmentLab.frame.origin.x, 0, _deparmentView.frame.size.width * 0.65, _deparmentView.frame.size.height)];
    _deparmentVal.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];
    _deparmentVal.text = @"信息技术科";
    [_deparmentView addSubview:_deparmentVal];
    
    _typeView = [[UIView alloc]initWithFrame:CGRectMake(0, _deparmentView.frame.origin.y + _deparmentView.frame.size.height, _detailView.frame.size.width, _detailView.frame.size.height * 0.1)];
    [_detailView addSubview:_typeView];
    
    _typeLab = [[UILabel alloc]initWithFrame:CGRectMake(_typeView.frame.size.width * 0.05, 0, _typeView.frame.size.width * 0.25, _typeView.frame.size.height)];
    _typeLab.text = @"请假类型";
    _typeLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    [_typeView addSubview:_typeLab];
    
    _typeVal = [[UILabel alloc]initWithFrame:CGRectMake(_typeLab.frame.size.width + _typeLab.frame.origin.x, 0, _typeView.frame.size.width * 0.65, _typeView.frame.size.height)];
    _typeVal.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];
    _typeVal.text = [_dataDic objectForKey:@"leavetype"] != [NSNull null]?[_dataDic objectForKey:@"leavetype"]:@"未知类型";
    [_typeView addSubview:_typeVal];
    
    
    _startView = [[UIView alloc]initWithFrame:CGRectMake(0, _typeView.frame.origin.y + _typeView.frame.size.height, _detailView.frame.size.width, _detailView.frame.size.height * 0.1)];
    [_detailView addSubview:_startView];
    
    
    _startLab = [[UILabel alloc]initWithFrame:CGRectMake(_startView.frame.size.width * 0.05, 0, _startView.frame.size.width * 0.25, _startView.frame.size.height)];
    _startLab.text = @"开始时间";
    _startLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    [_startView addSubview:_startLab];
    
    _startVal = [[UILabel alloc]initWithFrame:CGRectMake(_startLab.frame.size.width + _startLab.frame.origin.x, 0, _startView.frame.size.width * 0.65, _startView.frame.size.height)];
    _startVal.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];
    _startVal.text = [_dataDic objectForKey:@"startdate"];
    [_startView addSubview:_startVal];
    
    _endView = [[UIView alloc]initWithFrame:CGRectMake(0, _startView.frame.origin.y + _startView.frame.size.height, _detailView.frame.size.width, _detailView.frame.size.height * 0.1)];
    [_detailView addSubview:_endView];
    
    _endLab = [[UILabel alloc]initWithFrame:CGRectMake(_endView.frame.size.width * 0.05, 0, _endView.frame.size.width * 0.25, _endView.frame.size.height)];
    _endLab.text = @"结束时间";
    _endLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    [_endView addSubview:_endLab];
    
    _endVal = [[UILabel alloc]initWithFrame:CGRectMake(_endLab.frame.size.width + _endLab.frame.origin.x, 0, _endView.frame.size.width * 0.65, _endView.frame.size.height)];
    _endVal.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];
    _endVal.text = [_dataDic objectForKey:@"enddate"];
    [_endView addSubview:_endVal];
    
    
    _totalView = [[UIView alloc]initWithFrame:CGRectMake(0, _endView.frame.origin.y + _endView.frame.size.height, _detailView.frame.size.width, _detailView.frame.size.height * 0.1)];
    [_detailView addSubview:_totalView];
    
    _totalLab = [[UILabel alloc]initWithFrame:CGRectMake(_totalView.frame.size.width * 0.05, 0, _totalView.frame.size.width * 0.25, _totalView.frame.size.height)];
    _totalLab.text = @"时长(分钟)";
    _totalLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    [_totalView addSubview:_totalLab];
    
    _totalVal = [[UILabel alloc]initWithFrame:CGRectMake(_totalLab.frame.size.width + _totalLab.frame.origin.x, 0, _totalView.frame.size.width * 0.65, _totalView.frame.size.height)];
    _totalVal.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];
    _totalVal.text = [_dataDic objectForKey:@"howlong"];
    [_totalView addSubview:_totalVal];
    
    
    
    _reasonView = [[UIView alloc]initWithFrame:CGRectMake(0, _totalView.frame.origin.y + _totalView.frame.size.height, _detailView.frame.size.width, _detailView.frame.size.height * 0.1 * 3)];
    [_detailView addSubview:_reasonView];
    
    _reasonLab = [[UILabel alloc]initWithFrame:CGRectMake(_reasonView.frame.size.width * 0.05, 0, _reasonView.frame.size.width * 0.25, _reasonView.frame.size.height / 3)];
    _reasonLab.text = @"请假事由";
    _reasonLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    [_reasonView addSubview:_reasonLab];
    
    _reasonVal = [[UITextView alloc]initWithFrame:CGRectMake(_reasonLab.frame.size.width + _reasonLab.frame.origin.x, 0, _reasonView.frame.size.width * 0.65, _reasonView.frame.size.height / 4 * 2)];
    _reasonVal.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];
    _reasonVal.text = [_dataDic objectForKey:@"leavecontent"];
    _reasonVal.font = [UIFont systemFontOfSize:16.0];
    [_reasonView addSubview:_reasonVal];
    
    _historyView = [[UIView alloc]initWithFrame:CGRectMake(0, _reasonView.frame.origin.y + _reasonView.frame.size.height, _detailView.frame.size.width, _detailView.frame.size.height * 0.0)];
    [_detailView addSubview:_historyView];
    _historyView.hidden = YES;
    _historyLineView = [[UIView alloc]initWithFrame:CGRectMake(_historyView.frame.size.width * 0.05, 0, _historyView.frame.size.width * 0.95, 1)];
    _historyLineView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    [_historyView addSubview:_historyLineView];
    
    _historyLab = [[UILabel alloc]initWithFrame:CGRectMake(_historyView.frame.size.width * 0.05, 0, _historyView.frame.size.width * 0.5, _historyView.frame.size.height)];
    _historyLab.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];
    _historyLab.text = @"查看TA的历史记录";
    _historyLab.font = [UIFont systemFontOfSize:15.0];
    [_historyView addSubview:_historyLab];
    
    
    _btnView = [[UIView alloc]initWithFrame:CGRectMake(0, _contentView.frame.size.height - _contentView.frame.size.height * 0.07, _contentView.frame.size.width, _contentView.frame.size.height * 0.07)];
    _btnView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_btnView];
    
    _agreeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _btnView.frame.size.width / 2, _btnView.frame.size.height)];
    [_agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    [_agreeBtn setTitleColor:[UIColor colorWithRed:64/255.0 green:175/255.0 blue:252/255.0 alpha:1] forState:UIControlStateNormal];
    [_agreeBtn addTarget:self action:@selector(agreeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnView addSubview:_agreeBtn];
    
    
    _refuseBtn = [[UIButton alloc]initWithFrame:CGRectMake(_agreeBtn.frame.size.width + _agreeBtn.frame.origin.x, 0, _btnView.frame.size.width / 2, _btnView.frame.size.height)];
    [_refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    [_refuseBtn setTitleColor:[UIColor colorWithRed:64/255.0 green:175/255.0 blue:252/255.0 alpha:1] forState:UIControlStateNormal];
    [_refuseBtn addTarget:self action:@selector(refuseAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnView addSubview:_refuseBtn];
    
    
    _tranferBtn = [[UIButton alloc]initWithFrame:CGRectMake(_refuseBtn.frame.size.width + _refuseBtn.frame.origin.x, 0, _btnView.frame.size.width / 3, _btnView.frame.size.height)];
    [_tranferBtn setTitle:@"转批" forState:UIControlStateNormal];
    [_tranferBtn setTitleColor:[UIColor colorWithRed:64/255.0 green:175/255.0 blue:252/255.0 alpha:1] forState:UIControlStateNormal];
    [_btnView addSubview:_tranferBtn];
    _tranferBtn.hidden = YES;
    
    UIView *leftLineView = [[UIView alloc]initWithFrame:CGRectMake(_agreeBtn.frame.size.width + _agreeBtn.frame.origin.x, _btnView.frame.size.height * 0.3, 1, _btnView.frame.size.height * 0.4)];
    leftLineView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    [_btnView addSubview:leftLineView];
    
    
    UIView *rightLineView = [[UIView alloc]initWithFrame:CGRectMake(_refuseBtn.frame.size.width + _refuseBtn.frame.origin.x, _btnView.frame.size.height * 0.3, 1.5, _btnView.frame.size.height * 0.4)];
    rightLineView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    [_btnView addSubview:rightLineView];
    
    UIView *btnLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _btnView.frame.size.width, 1)];
    btnLineView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    [_btnView addSubview:btnLineView];
}



-(void) agreeAction:(UIButton *)sender{
    [_activityIndicatorView startAnimating];
    NSString *currTime = [PhoneInfo getNowTimeTimestamp3];
   // currTime = @"1537033103000";
    NSLog(@"%@",currTime);
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    
    
    NSString *token = [NSString stringWithFormat:@"%@%@GJCheck%@",[_dataDic objectForKey:@"id"],currTime,CurrAdminID];
    NSString *md5token = [AizenMD5 MD5ForUpper16Bate:token];
    //MD5ForUpper16Bate
    NSString *url = [NSString stringWithFormat:@"%@/ApiCheckWork/ConfirmLeaveApply?AdminID=%@&ID=%@&Remark=%@&State=1&TimeStamp=%@&Token=%@",kCacheHttpRoot,CurrAdminID,[_dataDic objectForKey:@"id"],@"同意",currTime,md5token];
    NSString *utf = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [AizenHttp asynRequest:utf httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
            RAlertView *alert = [[RAlertView alloc] initWithStyle:ConfirmAlert];
            alert.headerTitleLabel.text = @"提示";
            alert.contentTextLabel.attributedText = [TextHelper attributedStringForString:[jsonDic objectForKey:@"Message"] lineSpacing:5];
            [alert.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
            [alert.confirmButton setBackgroundColor:[UIColor colorWithRed:20/255.0 green:184/255.0 blue:247/255.0 alpha:1]];
            alert.confirm = ^(){
                NSLog(@"Click on the Ok");
                if (self.updateBlock) {
                    self.updateBlock(nil);
                }
                [self.navigationController popViewControllerAnimated:YES];
            };
        }else{
            RAlertView *alert = [[RAlertView alloc] initWithStyle:ConfirmAlert];
            alert.headerTitleLabel.text = @"提示";
            alert.contentTextLabel.attributedText = [TextHelper attributedStringForString:[jsonDic objectForKey:@"Message"] lineSpacing:5];
            [alert.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
            [alert.confirmButton setBackgroundColor:[UIColor colorWithRed:20/255.0 green:184/255.0 blue:247/255.0 alpha:1]];
            alert.confirm = ^(){
                NSLog(@"Click on the Ok");
            };
        }
    } failue:^(NSError *error) {
        NSLog(@"请求失败---请假审核(同意)");
        [_activityIndicatorView stopAnimating];
    }];
    
}


-(void) refuseAction:(UIButton *)sender{
    [_activityIndicatorView startAnimating];
    NSString *currTime = [PhoneInfo getNowTimeTimestamp3];
    NSLog(@"%@",currTime);
    NSString *token = [NSString stringWithFormat:@"%@%@GJCheck%@",[_dataDic objectForKey:@"id"],currTime,[_dataDic objectForKey:@"adminid"]];
    NSString *md5token = [AizenMD5 MD5ForUpper16Bate:token];
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiCheckWork/ConfirmLeaveApply?AdminID=%@&ID=%@&Remark=%@&State=1&TimeStamp=%@&Token=%@",kCacheHttpRoot,[_dataDic objectForKey:@"adminid"],[_dataDic objectForKey:@"id"],@"拒绝",currTime,md5token];
    NSString *utf = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [AizenHttp asynRequest:utf httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
            RAlertView *alert = [[RAlertView alloc] initWithStyle:ConfirmAlert];
            alert.headerTitleLabel.text = @"提示";
            alert.contentTextLabel.attributedText = [TextHelper attributedStringForString:[jsonDic objectForKey:@"Message"] lineSpacing:5];
            [alert.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
            [alert.confirmButton setBackgroundColor:[UIColor colorWithRed:20/255.0 green:184/255.0 blue:247/255.0 alpha:1]];
            alert.confirm = ^(){
                NSLog(@"Click on the Ok");
                if (self.updateBlock) {
                    self.updateBlock(nil);
                }
                [self.navigationController popViewControllerAnimated:YES];
            };
        }else{
            RAlertView *alert = [[RAlertView alloc] initWithStyle:ConfirmAlert];
            alert.headerTitleLabel.text = @"提示";
            alert.contentTextLabel.attributedText = [TextHelper attributedStringForString:[jsonDic objectForKey:@"Message"] lineSpacing:5];
            [alert.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
            [alert.confirmButton setBackgroundColor:[UIColor colorWithRed:20/255.0 green:184/255.0 blue:247/255.0 alpha:1]];
            alert.confirm = ^(){
                NSLog(@"Click on the Ok");
            };
        }
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败---请假审核(拒绝)");
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
