//
//  DetailTaskViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/4/13.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "DetailTaskViewController.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "PhoneInfo.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AizenStorage.h"
#import "People.h"
#import "PhoneInfo.h"
#import "AizenMD5.h"
#import "AFNetworking.h"
#import "HTTPOpration.h"
#import "BRMoifyUserInfoViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BRTaskDetailModel.h"
@interface DetailTaskViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate>{
    
    UIImagePickerController *_imagePickerController;
    
}

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIButton *submitBtn;

@property(nonatomic,strong) UIButton *passBtn;
@property(nonatomic,strong) UIButton *unpassBtn;


@property(nonatomic,strong) UIView *detailView;

@property(nonatomic,strong) UIView *titleView;
@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) UILabel *titleVal;

@property(nonatomic,strong) UIView *contextView;
@property(nonatomic,strong) UILabel *contextLab;
@property(nonatomic,strong) UILabel *contextVal;

@property(nonatomic,strong) UIView *fuzeView;
@property(nonatomic,strong) UILabel *fuzeLab;
@property(nonatomic,strong) UILabel *fuzeVal;

@property(nonatomic,strong) UIView *shenpiView;
@property(nonatomic,strong) UILabel *shenpiLab;
@property(nonatomic,strong) UILabel *shenpiVal;

@property(nonatomic,strong) UIView *dateView;
@property(nonatomic,strong) UILabel *dateLab;
@property(nonatomic,strong) UILabel *dateVal;


@property(nonatomic,strong) UIView *fujianView;
@property(nonatomic,strong) UILabel *fujianLab;
@property(nonatomic,strong) UILabel *fujianVal;

@property(nonatomic,strong) UIView *pinglunView;
@property(nonatomic,strong) UILabel *pinglunLab;


@property(nonatomic,strong) UIView *MongoView;
@property(nonatomic,strong) UIView *PopupView;
@property(nonatomic,strong) UILabel *PopTitleView;
@property(nonatomic,strong) UIButton *PopconfirmBtn;
@property(nonatomic,strong) UIButton *PopcancelBtn;

@property(nonatomic,strong) UIView *PopcontentView;

@property(nonatomic,strong) UILabel *commentLabel;
@property(nonatomic,strong) UITextView *commentView;

@property(nonatomic,strong) UILabel *enclosureLab;
@property(nonatomic,strong) UIButton *enclosureBtn;

@property(nonatomic,strong) UIImageView *closeView;


@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@property(nonatomic,strong) UIImageView *uploadImg;

@property (nonatomic, strong) UIImage *chooseImg;


@end

@implementation DetailTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"任务详情";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    [self startLayout];
}

-(void) startLayout{
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    
    
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_NAVBAR - HEIGHT_STATUSBAR - HEIGHT_TABBAR);
    _contentView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    _activityIndicatorView.layer.zPosition = 1000;
    
    [_contentView addSubview:_activityIndicatorView];
    
    
    if([_flagRole isEqualToString:@"student"]){
        _submitBtn = [[UIButton alloc]init];
        _submitBtn.frame = CGRectMake(0, _contentView.frame.size.height + _contentView.frame.origin.y, _contentView.frame.size.width, HEIGHT_TABBAR);
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        _submitBtn.backgroundColor = [UIColor colorWithRed:23/255.0 green:194/255.0 blue:149/255.0 alpha:1];
        [self.view addSubview:_submitBtn];
        
        UITapGestureRecognizer *submitTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(submitAction:)];
        [_submitBtn addGestureRecognizer:submitTap];
        
        [self PopupLayout];
        
    }else if([_flagRole isEqualToString:@"teacher"]){
        _passBtn = [[UIButton alloc]init];
        _passBtn.frame = CGRectMake(0, _contentView.frame.size.height + _contentView.frame.origin.y, _contentView.frame.size.width / 2, HEIGHT_TABBAR);
        [_passBtn setTitle:@"通过" forState:UIControlStateNormal];
        _passBtn.backgroundColor = [UIColor colorWithRed:23/255.0 green:194/255.0 blue:149/255.0 alpha:1];
        [self.view addSubview:_passBtn];
        
        
        _unpassBtn = [[UIButton alloc]init];
        _unpassBtn.frame = CGRectMake(_contentView.frame.size.width / 2, _contentView.frame.size.height + _contentView.frame.origin.y, _contentView.frame.size.width / 2, HEIGHT_TABBAR);
        [_unpassBtn setTitle:@"指导" forState:UIControlStateNormal];
        _unpassBtn.backgroundColor = [UIColor colorWithRed:23/255.0 green:194/255.0 blue:149/255.0 alpha:1];
        [self.view addSubview:_unpassBtn];
    }
    
    _scrollView  = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, _contentView.frame.size.height * 3);
    [_contentView addSubview:_scrollView];
    
    
    [self httpTask];
    
    
}


-(void) PopupLayout{
    _MongoView = [[UIView alloc]init];
    _MongoView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _MongoView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self.view insertSubview:_MongoView atIndex:0];
    
    
    _PopupView = [[UIView alloc]init];
    _PopupView.frame = CGRectMake(_MongoView.frame.size.width * 0.1, _MongoView.frame.size.height * 0.3, _MongoView.frame.size.width * 0.8, _MongoView.frame.size.height * 0.4);
    _PopupView.layer.cornerRadius = 10;
    _PopupView.layer.masksToBounds = YES;
    _PopupView.backgroundColor = [UIColor whiteColor];
    [_MongoView addSubview:_PopupView];
    
    
    _PopTitleView = [[UILabel alloc]init];
    _PopTitleView.frame = CGRectMake(0, 0, _PopupView.frame.size.width, _PopupView.frame.size.height * 0.14);
    _PopTitleView.text = @"提交信息";
    _PopTitleView.textAlignment = UITextAlignmentCenter;
    _PopTitleView.textColor = [UIColor whiteColor];
    _PopTitleView.font = [UIFont systemFontOfSize:20.0];
    _PopTitleView.backgroundColor = [UIColor colorWithRed:23/255.0 green:194/255.0 blue:149/255.0 alpha:1];
    [_PopupView addSubview:_PopTitleView];
    
    _closeView = [[UIImageView alloc]init];
    _closeView.frame = CGRectMake(_PopTitleView.frame.size.width - _PopTitleView.frame.size.height, _PopTitleView.frame.size.height * 0.25, _PopTitleView.frame.size.height * 0.5, _PopTitleView.frame.size.height * 0.5);
    
    _closeView.image = [UIImage imageNamed:@"CloseButtonNormal"];
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAction:)];
    [_closeView addGestureRecognizer:closeTap];
    _closeView.userInteractionEnabled = YES;
    [_PopupView addSubview:_closeView];
    
    
    _PopcontentView = [[UIView alloc]init];
    _PopcontentView.frame = CGRectMake(0, _PopTitleView.frame.size.height + _PopTitleView.frame.origin.y, _PopupView.frame.size.width, _PopupView.frame.size.height - (_PopTitleView.frame.size.height + _PopupView.frame.size.height * 0.15));
    [_PopupView addSubview:_PopcontentView];
    
    
    CGFloat oneHeight = (_PopcontentView.frame.size.height - (_PopcontentView.frame.size.width * 0.05 * 3)) / 5;
    
    _commentLabel = [[UILabel alloc]init];
    _commentLabel.frame = CGRectMake(_PopcontentView.frame.size.width * 0.05, _PopcontentView.frame.size.width * 0.05, _PopcontentView.frame.size.width * 0.18, oneHeight);
    _commentLabel.textAlignment = UITextAlignmentLeft;
    _commentLabel.text = @"备注：";
    _commentLabel.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    _commentLabel.font = [UIFont systemFontOfSize:16.0];
    [_PopcontentView addSubview:_commentLabel];
    
    
    _commentView = [[UITextView alloc]init];
    _commentView.frame = CGRectMake(_commentLabel.frame.size.width + _commentLabel.frame.origin.x, _commentLabel.frame.origin.y, _PopcontentView.frame.size.width * 0.7, oneHeight * 2);
    _commentView.layer.cornerRadius = 5;
    _commentView.layer.masksToBounds = YES;
    _commentView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
    _commentView.layer.borderWidth = 1;
    _commentView.font = [UIFont systemFontOfSize:16.0];
    [_PopcontentView addSubview:_commentView];
    
    
    _enclosureLab = [[UILabel alloc]init];
    _enclosureLab.frame = CGRectMake(_PopcontentView.frame.size.width * 0.05, _commentView.frame.size.height + _commentView.frame.origin.y + oneHeight, _PopcontentView.frame.size.width * 0.18, oneHeight);
    _enclosureLab.text = @"附件：";
    _enclosureLab.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    _enclosureLab.font = [UIFont systemFontOfSize:16.0];
    [_PopcontentView addSubview:_enclosureLab];
    
    
    _enclosureBtn = [[UIButton alloc]init];
    _enclosureBtn.frame = CGRectMake(_commentView.frame.origin.x, _enclosureLab.frame.origin.y, _PopupView.frame.size.width * 0.2, oneHeight);
    [_enclosureBtn setTitle:@"上传" forState:UIControlStateNormal];
    [_enclosureBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _enclosureBtn.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    _enclosureBtn.layer.cornerRadius = 5;
    _enclosureBtn.layer.masksToBounds = YES;
    _enclosureBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _enclosureBtn.layer.borderWidth = 1;
    [_enclosureBtn addTarget:self action:@selector(enclosureAction:) forControlEvents:UIControlEventTouchUpInside];
    [_PopcontentView addSubview:_enclosureBtn];
    
    
    
    
    if([_flagRole isEqualToString:@"student"]){
        _PopconfirmBtn = [[UIButton alloc]init];
        _PopconfirmBtn.frame = CGRectMake(0, _PopupView.frame.size.height * 0.85, _PopupView.frame.size.width, _PopupView.frame.size.height * 0.15);
        [_PopconfirmBtn setTitle:@"提交" forState:UIControlStateNormal];
        _PopconfirmBtn.backgroundColor = [UIColor colorWithRed:23/255.0 green:194/255.0 blue:149/255.0 alpha:1];
        [_PopconfirmBtn addTarget:self action:@selector(PopSubmitAction:) forControlEvents:UIControlEventTouchUpInside];
        [_PopupView addSubview:_PopconfirmBtn];
        
        
    }else if([_flagRole isEqualToString:@"teacher"]){
        _PopconfirmBtn = [[UIButton alloc]init];
        _PopconfirmBtn.frame = CGRectMake(0, _PopupView.frame.size.height * 0.85, _PopupView.frame.size.width / 2, _PopupView.frame.size.height * 0.15);
        [_PopconfirmBtn setTitle:@"通过" forState:UIControlStateNormal];
        _PopconfirmBtn.backgroundColor = [UIColor colorWithRed:23/255.0 green:194/255.0 blue:149/255.0 alpha:1];
        [_PopconfirmBtn addTarget:self action:@selector(PopConfirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [_PopupView addSubview:_PopconfirmBtn];
        
        _PopcancelBtn = [[UIButton alloc]init];
        _PopcancelBtn.frame = CGRectMake(_PopupView.frame.size.width / 2, _PopupView.frame.size.height * 0.85, _PopupView.frame.size.width / 2, _PopupView.frame.size.height * 0.15);
        [_PopcancelBtn setTitle:@"不通过" forState:UIControlStateNormal];
        _PopcancelBtn.backgroundColor = [UIColor colorWithRed:23/255.0 green:194/255.0 blue:149/255.0 alpha:1];
        [_PopcancelBtn addTarget:self action:@selector(PopCancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [_PopupView addSubview:_PopcancelBtn];
    }
}



-(void) httpTask{
    NSString *url = [NSString stringWithFormat:@"%@/ApiActivityTaskInfo/GetByID?TaskID=%@",kCacheHttpRoot,_taskID];
    [_activityIndicatorView startAnimating];
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
            [self detailLayout:[jsonDic objectForKey:@"AppendData"]];
        }
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败--获取任务详情");
    }];
}



-(void) detailLayout:(NSArray *)sender{
    
    sender = [GJToolsHelp processDictionaryIsNSNull:sender];

    _detailView = [[UIView alloc]init];
    _detailView.frame = CGRectMake(_contentView.frame.size.width * 0.05, _contentView.frame.size.width * 0.05, _contentView.frame.size.width * 0.9, _contentView.frame.size.height * 0.5);
    _detailView.layer.cornerRadius = 5;
    _detailView.layer.masksToBounds = YES;
    [_scrollView addSubview:_detailView];
    
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = CGRectMake(0, 0, _detailView.frame.size.width, _detailView.frame.size.height);
    borderLayer.position = CGPointMake(CGRectGetMidX(_detailView.bounds),CGRectGetMidY(_detailView.bounds));
    borderLayer.path = [UIBezierPath bezierPathWithRect:borderLayer.bounds].CGPath;
    borderLayer.lineWidth = 2. / [[UIScreen mainScreen] scale];
    borderLayer.lineDashPattern = @[@5, @5];
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor grayColor].CGColor;
    [_detailView.layer addSublayer:borderLayer];
    
    
    _titleView = [[UIView alloc]init];
    _titleView.frame = CGRectMake(_detailView.frame.size.width * 0.05, _detailView.frame.size.width * 0.05, _detailView.frame.size.width * 0.9, _detailView.frame.size.height * 0.1);
    [_detailView addSubview:_titleView];
    
    
    _titleLab = [[UILabel alloc]init];
    _titleLab.frame = CGRectMake(0, 0, _titleView.frame.size.width * 0.15, _titleView.frame.size.height);
    _titleLab.text = @"主题:";
    _titleLab.font = [UIFont systemFontOfSize:15.0];
    [_titleView addSubview:_titleLab];
    
    _titleVal = [[UILabel alloc]init];
    _titleVal.frame = CGRectMake(_titleLab.frame.size.width, 0, _titleView.frame.size.width * 0.85, _titleView.frame.size.height);
    _titleVal.text = [[sender objectAtIndex:0] objectForKey:@"TaskTitle"];
    _titleVal.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    _titleVal.font = [UIFont systemFontOfSize:15.0];
    [_titleView addSubview:_titleVal];
    
    
    _contextView = [[UIView alloc]init];
    _contextView.frame = CGRectMake(_detailView.frame.size.width * 0.05, _titleView.frame.size.height + _titleView.frame.origin.y, _detailView.frame.size.width * 0.9, _detailView.frame.size.height * 0.1);
    [_detailView addSubview:_contextView];
    
    
    _contextLab = [[UILabel alloc]init];
    _contextLab.frame = CGRectMake(0, 0,_contextView.frame.size.width * 0.15, _contextView.frame.size.height);
    _contextLab.text = @"描述:";
    _contextLab.font = [UIFont systemFontOfSize:15.0];
    [_contextView addSubview:_contextLab];
    
    _contextVal = [[UILabel alloc]init];
    _contextVal.frame = CGRectMake(_contextLab.frame.size.width, 0, _contextView.frame.size.width * 0.85, _contextView.frame.size.height);
    _contextVal.text = [[sender objectAtIndex:0] objectForKey:@"ContentReq"];
    _contextVal.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    _contextVal.font = [UIFont systemFontOfSize:15.0];
    [_contextView addSubview:_contextVal];
    
    
    
    
    _fuzeView = [[UIView alloc]init];
    _fuzeView.frame = CGRectMake(_detailView.frame.size.width * 0.05, _contextView.frame.size.height + _contextView.frame.origin.y, _detailView.frame.size.width * 0.9, _detailView.frame.size.height * 0.1);
    [_detailView addSubview:_fuzeView];
    
    
    _fuzeLab = [[UILabel alloc]init];
    _fuzeLab.frame = CGRectMake(0, 0,_fuzeView.frame.size.width * 0.2, _fuzeView.frame.size.height);
    _fuzeLab.text = @"负责人:";
    _fuzeLab.font = [UIFont systemFontOfSize:15.0];
    [_fuzeView addSubview:_fuzeLab];
    
    _fuzeVal = [[UILabel alloc]init];
    _fuzeVal.frame = CGRectMake(_fuzeLab.frame.size.width, 0, _fuzeView.frame.size.width * 0.8, _fuzeView.frame.size.height);
    _fuzeVal.text = [[sender objectAtIndex:0] objectForKey:@"StudentName"];
    _fuzeVal.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    _fuzeVal.font = [UIFont systemFontOfSize:15.0];
    [_fuzeView addSubview:_fuzeVal];
    
    
    _shenpiView = [[UIView alloc]init];
    _shenpiView.frame = CGRectMake(_detailView.frame.size.width * 0.05, _fuzeView.frame.size.height + _fuzeView.frame.origin.y, _detailView.frame.size.width * 0.9, _detailView.frame.size.height * 0.1);
    [_detailView addSubview:_shenpiView];
    
    
    _shenpiLab = [[UILabel alloc]init];
    _shenpiLab.frame = CGRectMake(0, 0,_shenpiView.frame.size.width * 0.2, _shenpiView.frame.size.height);
    _shenpiLab.text = @"审核人:";
    _shenpiLab.font = [UIFont systemFontOfSize:15.0];
    [_shenpiView addSubview:_shenpiLab];
    
    _shenpiVal = [[UILabel alloc]init];
    _shenpiVal.frame = CGRectMake(_shenpiLab.frame.size.width, 0, _shenpiView.frame.size.width * 0.8, _shenpiView.frame.size.height);
    //CheckName
    NSString *CheckName = [[sender objectAtIndex:0] objectForKey:@"CheckName"];
    if ([CheckName isKindOfClass:[NSNull class]]) {
        CheckName = @"暂无";
    }
    _shenpiVal.text = CheckName;//@"谭老师";
    _shenpiVal.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    _shenpiVal.font = [UIFont systemFontOfSize:15.0];
    [_shenpiView addSubview:_shenpiVal];
    
    
    _dateView = [[UIView alloc]init];
    _dateView.frame = CGRectMake(_detailView.frame.size.width * 0.05, _shenpiView.frame.size.height + _shenpiView.frame.origin.y, _detailView.frame.size.width * 0.9, _detailView.frame.size.height * 0.1);
    [_detailView addSubview:_dateView];
    
    
    _dateLab = [[UILabel alloc]init];
    _dateLab.frame = CGRectMake(0, 0,_dateView.frame.size.width * 0.25, _dateView.frame.size.height);
    _dateLab.text = @"截止时间:";
    _dateLab.font = [UIFont systemFontOfSize:15.0];
    [_dateView addSubview:_dateLab];
    
    
    NSRange rang = {0,10};
    NSString *DateTime = [[[[[sender objectAtIndex:0] objectForKey:@"EndDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
    NSString *DateStr = [PhoneInfo timestampSwitchTime:[DateTime integerValue] andFormatter:@"yyyy-MM-dd"];
    
    _dateVal = [[UILabel alloc]init];
    _dateVal.frame = CGRectMake(_dateLab.frame.size.width, 0, _dateView.frame.size.width * 0.7, _dateView.frame.size.height);
    _dateVal.text = DateStr;
    _dateVal.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    _dateVal.font = [UIFont systemFontOfSize:15.0];
    [_dateView addSubview:_dateVal];
    
    
    
    _fujianView = [[UIView alloc]init];
    _fujianView.frame = CGRectMake(_detailView.frame.size.width * 0.05, _dateView.frame.size.height + _dateView.frame.origin.y, _detailView.frame.size.width * 0.9, _detailView.frame.size.height * 0.1);
    [_detailView addSubview:_fujianView];
    
    
    _fujianLab = [[UILabel alloc]init];
    _fujianLab.frame = CGRectMake(0, 0,_fujianView.frame.size.width * 0.15, _fujianView.frame.size.height);
    _fujianLab.text = @"附件:";
    _fujianLab.font = [UIFont systemFontOfSize:15.0];
    [_fujianView addSubview:_fujianLab];
    
    _fujianVal = [[UILabel alloc]init];
    _fujianVal.frame = CGRectMake(_fujianLab.frame.size.width, 0, _fujianView.frame.size.width * 0.85, _fujianView.frame.size.height);
    _fujianVal.text = @"暂无文件";
    _fujianVal.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    _fujianVal.font = [UIFont systemFontOfSize:15.0];
    [_fujianView addSubview:_fujianVal];
    
    //[self pinglunLayout];
    [self getGetRecordListByDetailIDCommenent];
}

- (void)getGetRecordListByDetailIDCommenent{
//    NSString *url = @"ApiActivityTaskInfo/GetRecordListByDetailID";
    NSString *url = [NSString stringWithFormat:@"%@/ApiActivityTaskInfo/GetRecordListByDetailID?ActivityTaskDetailID=%@",kCacheHttpRoot,_taskID];

    [_activityIndicatorView startAnimating];
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        NSData *das = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONReadingAllowFragments error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:das encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonStr);
        if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
          //  [self detailLayout:[jsonDic objectForKey:@"AppendData"]];
            //
            NSDictionary *AppendData = jsonDic[@"AppendData"];
            if ([AppendData isKindOfClass:[NSDictionary class]]) {
                [self pinglunLayout:AppendData[@"rows"]];

            }
            else{
                [self pinglunLayout:nil];

            }
        }
        else{
            [self pinglunLayout:nil];

        }
        NSLog(@"%@",jsonDic);
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败--获取任务详情");
    }];
    
}
//MARK:评论
-(void) pinglunLayout:(NSArray *)dataArray{
    _pinglunView = [[UIView alloc]init];
    _pinglunView.frame = CGRectMake(0, _detailView.frame.size.height + _detailView.frame.origin.y + _contentView.frame.size.height * 0.05, _scrollView.frame.size.width, _contentView.frame.size.height * 0.05);
    _pinglunView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_pinglunView];
    
    CALayer *pinglunLayer = [CALayer layer];
    pinglunLayer.frame = CGRectMake(_pinglunView.frame.size.width * 0.05, _pinglunView.frame.size.height - 1, _pinglunView.frame.size.width * 0.9, 1);
    pinglunLayer.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    [_pinglunView.layer addSublayer:pinglunLayer];
    
    _pinglunLab = [[UILabel alloc]init];
    _pinglunLab.frame = CGRectMake(0, 0, _pinglunView.frame.size.width, _pinglunView.frame.size.height);
    _pinglunLab.text = @"指导区";
    _pinglunLab.textAlignment = UITextAlignmentCenter;
    _pinglunLab.font = [UIFont systemFontOfSize:18.0];
    _pinglunLab.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [_pinglunView addSubview:_pinglunLab];
    
    
    
    for(int i = 0;i<dataArray.count;i++){
        
        BRTaskDetailModel *model_info = [[BRTaskDetailModel alloc] initWithDictionary:dataArray[i] error:nil];
        
        UIView *detailView = [[UIView alloc]init];
        detailView.frame = CGRectMake(0, _pinglunView.frame.size.height + _pinglunView.frame.origin.y + _contentView.frame.size.height * 0.2 * i, _pinglunView.frame.size.width, _contentView.frame.size.height * 0.2);
        detailView.backgroundColor = [UIColor whiteColor];
        CALayer *bottomLayer = [CALayer layer];
        bottomLayer.frame = CGRectMake(detailView.frame.size.width * 0.05, detailView.frame.size.height - 1, detailView.frame.size.width * 0.9, 1);
        bottomLayer.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
        [detailView.layer addSublayer:bottomLayer];
        [_scrollView addSubview:detailView];
        
        
        
        UIImageView *logoImg = [[UIImageView alloc]init];
        logoImg.frame = CGRectMake(detailView.frame.size.width * 0.05, detailView.frame.size.width * 0.05, detailView.frame.size.width * 0.1, detailView.frame.size.width * 0.1);
        logoImg.layer.cornerRadius = 5;
        logoImg.layer.masksToBounds = YES;
        logoImg.image = [UIImage imageNamed:@"gj_msglogo1"];
//        [logoImg sd_setImageWithURL:[NSURL URLWithString:model_info.] placeholderImage:<#(nullable UIImage *)#>];
        [detailView addSubview:logoImg];
        
        
        UILabel *nameLab = [[UILabel alloc]init];
        nameLab.frame = CGRectMake(logoImg.frame.origin.x + logoImg.frame.size.width + detailView.frame.size.width * 0.02, logoImg.frame.origin.y, detailView.frame.size.width * 0.5, detailView.frame.size.height * 0.15);
        nameLab.text = model_info.CheckName;
        nameLab.font = [UIFont systemFontOfSize:16.0];
        [detailView addSubview:nameLab];
        
        
        UITextView *contentLab = [[UITextView alloc]init];
        contentLab.frame = CGRectMake(nameLab.frame.origin.x, nameLab.frame.size.height + nameLab.frame.origin.y, detailView.frame.size.width - (detailView.frame.size.width * 0.05 * 2 + logoImg.frame.size.width + detailView.frame.size.width * 0.02), detailView.frame.size.height * 0.4);
        contentLab.text = model_info.SubmitContent;//@"很好，98分";
        contentLab.font = [UIFont systemFontOfSize:16.0];
        [detailView addSubview:contentLab];
        contentLab.userInteractionEnabled = NO;
        UILabel *dateLab = [[UILabel alloc]init];
        dateLab.frame = CGRectMake(contentLab.frame.origin.x, contentLab.frame.size.height + contentLab.frame.origin.y, detailView.frame.size.width - (detailView.frame.size.width * 0.05 * 2 + logoImg.frame.size.width + detailView.frame.size.width * 0.02), detailView.frame.size.height * 0.15);
        dateLab.text = model_info.CreateDate;//@"2018-04-12 17:58:12";
        dateLab.font = [UIFont systemFontOfSize:13.0];
        [detailView addSubview:dateLab];
    }
    
    
}




-(void) submitAction:(UITapGestureRecognizer *)sender{
    [UIView beginAnimations:@"showPop" context:@"start"];
    [UIView setAnimationDuration:0.1];
    [self.view insertSubview:_MongoView atIndex:2];
    UIColor *showColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _MongoView.backgroundColor = showColor;
    [UIView commitAnimations];
    
    [self shakeAnimationForView:_PopupView];
}


-(void)shakeAnimationForView:(UIView *) view {
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint x = CGPointMake(position.x + 2, position.y);
    CGPoint y = CGPointMake(position.x - 2, position.y);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:.06];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
}


-(void) closeAction:(UITapGestureRecognizer *)sender{
    _commentView.text = @"";
    [BaseViewController br_endKeyboard];

    [UIView beginAnimations:@"hidePop" context:@"stop"];
    [UIView setAnimationDuration:0.1];
    UIColor *hideColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0];
    _MongoView.backgroundColor = hideColor;
    [self.view insertSubview:_MongoView atIndex:0];
    [UIView commitAnimations];
}


-(void) PopSubmitAction:(UITapGestureRecognizer *)sender{
    [_activityIndicatorView startAnimating];
    [BaseViewController br_endKeyboard];
    
    [DetailTaskViewController br_uploadImage:self.chooseImg block:^(BOOL success, NSString *msg) {
        if (success) {
            NSString *commentVal = _commentView.text;
            NSString *url = [NSString stringWithFormat:@"%@/ApiActivityTaskInfo/Submit",kCacheHttpRoot];
            NSLog(@"%@",url);
            NSString *currTime = [PhoneInfo getNowTimeTimestamp3];
            NSString *tokenStr = [NSString stringWithFormat:@"%@GJTask%@",_taskID,currTime];
            NSString *getToken = [AizenMD5 MD5ForUpper16Bate:tokenStr];
            NSLog(@"%@",tokenStr);
            NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:_taskID,@"ID",commentVal,@"SubmitContent",msg,@"submitAttachment",getToken,@"Token",currTime,@"TimeStamp", nil];
            
            NSLog(@"%@",params);
            
            [AizenHttp asynRequest:url httpMethod:@"POST" params:params success:^(id result) {
                [_activityIndicatorView stopAnimating];
                NSDictionary *jsonDic = result;
                if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[jsonDic objectForKey:@"Message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alertView.tag = kSuccessCodeTag;
                    [alertView show];
                    
                }
                NSLog(@"%@",[jsonDic objectForKey:@"Message"]);
            } failue:^(NSError *error) {
                [_activityIndicatorView stopAnimating];
                NSLog(@"请求失败--提交任务");
            }];
        }
    }];
    
   
    
    
    
    [UIView beginAnimations:@"hidePop" context:@"stop"];
    [UIView setAnimationDuration:0.1];
    UIColor *hideColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0];
    _MongoView.backgroundColor = hideColor;
    [self.view insertSubview:_MongoView atIndex:0];
    [UIView commitAnimations];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kSuccessCodeTag) {
        if (self.updateBlock) {
            self.updateBlock(nil);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void) enclosureAction:(UIButton *)sender{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择普通文件或相册文件" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", nil];
    [sheet showInView:self.view];
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        /*相册*/
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }
}

#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    NSData *fileData = nil;
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        UIImage *editImg = info[UIImagePickerControllerEditedImage];
        self.chooseImg = editImg;
        //压缩图片
        fileData = UIImageJPEGRepresentation(self.uploadImg.image, 1.0);
//        NSLog(@"%@",fileData);
        //保存图片至相册
//        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        //上传图片
//        [self uploadImageWithData:fileData];
        
    }else{
        //如果是视频
//        NSURL *url = info[UIImagePickerControllerMediaURL];
//        //播放视频
//        _moviePlayer.contentURL = url;
//        [_moviePlayer play];
//        //保存视频至相册（异步线程）
//        NSString *urlStr = [url path];
//
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
//
//                UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
//            }
//        });
//        NSData *videoData = [NSData dataWithContentsOfURL:url];
//        //视频上传
//        [self uploadVideoWithData:videoData];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void) uploadFile:(NSData *)file{
    
}

+ (void)br_uploadImage:(UIImage *)img block:(void(^)(BOOL success,NSString *msg))block {
    if (!img) {
        if (block) {
            block(YES,@"");
        }
        return;
    }
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *CurrTimeStamp = [PhoneInfo getNowTimeTimestamp3];
    NSString *CurrToken = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@%@UpFile%@",CurrAdminID,CurrTimeStamp,@"Task"]];
    
    
    NSString *url = [NSString stringWithFormat:@"ApiActivityTaskInfo/UploadFile?AdminID=%@&ModuleName=%@&TimeStamp=%@&Token=%@",CurrAdminID,@"Task",CurrTimeStamp,CurrToken];
    NSString *urlencode = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [[HTTPOpration sharedHTTPOpration] NetRequestPOSTFileWithRequestURL:urlencode WithParameter:nil WithFiles:@{@"file":UIImageJPEGRepresentation(img, 0.5)} WithReturnValeuBlock:^(HTTPData *data) {
        
        if (data.code == 0) {
            /*
             {"ResultType":0,"Message":"上传成功！","LogMessage":null,"AppendData":"/Upload/Internship/2018/09/13003042387171.png"}
             
             */
            if ([data.returnData isKindOfClass:[NSDictionary class]]) {
                NSDictionary *temp = data.returnData;
                NSString *AppendData = temp[@"AppendData"];
                if (block) {
                    block(YES,AppendData);
                }
            }
            else{
                [BRMoifyUserInfoViewController br_showAlterMsg:@"数据异常"];
                
            }
        }
        else{
            [BRMoifyUserInfoViewController br_showAlterMsg:data.msg];
        }
        
    } WithFailureBlock:^(id error) {
        [BRMoifyUserInfoViewController br_showAlterMsg:@"提交失败请重试!"];
    }];
    //    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    //    [params setObject:CurrAdminID forKey:@"AdminID"];
    //    [params setObject:@"Internship" forKey:@"ModuleName"];
    //    [params setObject:CurrTimeStamp forKey:@"TimeStamp "];
    //    [params setObject:CurrToken forKey:@"Token"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
