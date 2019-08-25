//
//  TeacherDetailTaskViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/16.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "TeacherDetailTaskViewController.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "PhoneInfo.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "People.h"
#import "BRTaskDetailModel.h"
#import "LDPublicWebViewController.h"
@interface TeacherDetailTaskViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    
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

@property(nonatomic,strong) UILabel *teacherScoreLabel;
@property(nonatomic,strong) UITextField *teacherScoreLabelField;

@property(nonatomic,strong) UILabel *overdueScoreLabel;
@property(nonatomic,strong) UITextField *overdueScoreField;

@property(nonatomic,strong) UILabel *FinalScoreLabel;
@property(nonatomic,strong) UITextField *FinalScoreField;

@property(nonatomic,strong) UILabel *enclosureLab;
@property(nonatomic,strong) UIButton *enclosureBtn;



@property(nonatomic,strong) UIView *un_MongoView;
@property(nonatomic,strong) UIView *un_PopupView;
@property(nonatomic,strong) UILabel *un_PopTitleView;
@property(nonatomic,strong) UIButton *un_PopconfirmBtn;
@property(nonatomic,strong) UIButton *un_PopcancelBtn;

@property(nonatomic,strong) UIView *un_PopcontentView;

@property(nonatomic,strong) UILabel *un_commentLabel;
@property(nonatomic,strong) UITextView *un_commentView;

@property(nonatomic,strong) UILabel *un_enclosureLab;
@property(nonatomic,strong) UIButton *un_enclosureBtn;


@property(nonatomic,strong) UIImageView *closeView;


@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

@property(nonatomic,strong) NSMutableDictionary *taskDetail;

@property (nonatomic, copy) NSString *uploadFileStr;

@end

@implementation TeacherDetailTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"任务详情";
    self.view.backgroundColor = [UIColor whiteColor];
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
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[[MainViewController colorWithHexString:@"#0092ff"] copy]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
//    [_contentView addSubview:_activityIndicatorView];
//    [_contentView insertSubview:_activityIndicatorView atIndex:999];
    [self.view addSubview:_activityIndicatorView];
    _activityIndicatorView.layer.zPosition = 1000;
    _activityIndicatorView.startingNotUserInterface = YES;
    
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
        _passBtn.frame = CGRectMake(0, _contentView.frame.size.height + _contentView.frame.origin.y, _contentView.frame.size.width, HEIGHT_TABBAR);
        [_passBtn setTitle:@"通过" forState:UIControlStateNormal];
        _passBtn.backgroundColor = [UIColor colorWithRed:23/255.0 green:194/255.0 blue:149/255.0 alpha:1];
        [_passBtn addTarget:self action:@selector(passAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_passBtn];
        if (self.isNotApplay) {
            _passBtn.userInteractionEnabled = NO;
         
        }
        else{
            
            _passBtn.frame = CGRectMake(_contentView.frame.size.width/2.0, _contentView.frame.size.height + _contentView.frame.origin.y, _contentView.frame.size.width/2.0, HEIGHT_TABBAR);
            [_passBtn setTitle:@"通过" forState:UIControlStateNormal];
            
            _un_PopconfirmBtn = [[UIButton alloc]init];
            _un_PopconfirmBtn.frame = CGRectMake(0,  _contentView.frame.size.height + _contentView.frame.origin.y, _contentView.frame.size.width/2.0, HEIGHT_TABBAR);
            [_un_PopconfirmBtn setTitle:@"不通过" forState:UIControlStateNormal];
            _un_PopconfirmBtn.backgroundColor = [UIColor redColor];//[UIColor colorWithRed:23/255.0 green:194/255.0 blue:149/255.0 alpha:1];
            [_un_PopconfirmBtn addTarget:self action:@selector(unpassAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_un_PopconfirmBtn];

        }
    
        
        
//        _unpassBtn = [[UIButton alloc]init];
//        _unpassBtn.frame = CGRectMake(_contentView.frame.size.width / 2, _contentView.frame.size.height + _contentView.frame.origin.y, _contentView.frame.size.width / 2, HEIGHT_TABBAR);
//        [_unpassBtn setTitle:@"指导" forState:UIControlStateNormal];
//        _unpassBtn.backgroundColor = [UIColor colorWithRed:23/255.0 green:194/255.0 blue:149/255.0 alpha:1];
//        [_unpassBtn addTarget:self action:@selector(unpassAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_unpassBtn];
    
        [self unpass_PopupLayout];
        [self PopupLayout];
    }
    
    _scrollView  = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, _contentView.frame.size.height+1);
    [_contentView addSubview:_scrollView];
    
    
    [self httpTask];
    
    
}



-(void) unpass_PopupLayout{
    _un_MongoView = [[UIView alloc]init];
    _un_MongoView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _un_MongoView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self.view addSubview:_un_MongoView];
    _un_MongoView.hidden = YES;
    
    
    _un_PopupView = [[UIView alloc]init];
    _un_PopupView.frame = CGRectMake(_un_MongoView.frame.size.width * 0.1, _un_MongoView.frame.size.height * 0.3, _un_MongoView.frame.size.width * 0.8, _un_MongoView.frame.size.height * 0.4);
    _un_PopupView.layer.cornerRadius = 10;
    _un_PopupView.layer.masksToBounds = YES;
    _un_PopupView.backgroundColor = [UIColor whiteColor];
    [_un_MongoView addSubview:_un_PopupView];
    
    
    _un_PopTitleView = [[UILabel alloc]init];
    _un_PopTitleView.frame = CGRectMake(0, 0, _un_PopupView.frame.size.width, _un_PopupView.frame.size.height * 0.14);
    _un_PopTitleView.text = @"指导信息";
    _un_PopTitleView.textAlignment = UITextAlignmentCenter;
    _un_PopTitleView.textColor = [UIColor whiteColor];
    _un_PopTitleView.font = [UIFont systemFontOfSize:20.0];
    _un_PopTitleView.backgroundColor = [UIColor colorWithRed:23/255.0 green:194/255.0 blue:149/255.0 alpha:1];
    [_un_PopupView addSubview:_un_PopTitleView];
    
    _closeView = [[UIImageView alloc]init];
    _closeView.frame = CGRectMake(_un_PopTitleView.frame.size.width - _un_PopTitleView.frame.size.height, _un_PopTitleView.frame.size.height * 0.25, _un_PopTitleView.frame.size.height * 0.5, _un_PopTitleView.frame.size.height * 0.5);
    _closeView.image = [UIImage imageNamed:@"CloseButtonNormal"];
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAction:)];
    [_closeView addGestureRecognizer:closeTap];
    _closeView.userInteractionEnabled = YES;
    [_un_PopupView addSubview:_closeView];
    
    
    _un_PopcontentView = [[UIView alloc]init];
    _un_PopcontentView.frame = CGRectMake(0, _un_PopTitleView.frame.size.height + _un_PopTitleView.frame.origin.y, _un_PopupView.frame.size.width, _un_PopupView.frame.size.height - (_un_PopTitleView.frame.size.height + _un_PopupView.frame.size.height * 0.15));
    [_un_PopupView addSubview:_un_PopcontentView];
    
    
    CGFloat oneHeight = (_un_PopcontentView.frame.size.height - (_un_PopcontentView.frame.size.width * 0.05 * 3)) / 5;
    
    _un_commentLabel = [[UILabel alloc]init];
    _un_commentLabel.frame = CGRectMake(_un_PopcontentView.frame.size.width * 0.05, _un_PopcontentView.frame.size.width * 0.05, _un_PopcontentView.frame.size.width * 0.18, oneHeight);
    _un_commentLabel.textAlignment = UITextAlignmentLeft;
    _un_commentLabel.text = @"备注：";
    _un_commentLabel.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    _un_commentLabel.font = [UIFont systemFontOfSize:16.0];
    [_un_PopcontentView addSubview:_un_commentLabel];
    
    
    _un_commentView = [[UITextView alloc]init];
    _un_commentView.frame = CGRectMake(_un_commentLabel.frame.size.width + _un_commentLabel.frame.origin.x, _un_commentLabel.frame.origin.y, _un_PopcontentView.frame.size.width * 0.7, oneHeight * 2);
    _un_commentView.layer.cornerRadius = 5;
    _un_commentView.layer.masksToBounds = YES;
    _un_commentView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
    _un_commentView.layer.borderWidth = 1;
    _un_commentView.font = [UIFont systemFontOfSize:16.0];
    [_un_PopcontentView addSubview:_un_commentView];
    
    
    _un_enclosureLab = [[UILabel alloc]init];
    _un_enclosureLab.frame = CGRectMake(_un_PopcontentView.frame.size.width * 0.05, _un_commentView.frame.size.height + _un_commentView.frame.origin.y + oneHeight, _un_PopcontentView.frame.size.width * 0.18, oneHeight);
    _un_enclosureLab.text = @"附件：";
    _un_enclosureLab.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    _un_enclosureLab.font = [UIFont systemFontOfSize:16.0];
    [_un_PopcontentView addSubview:_un_enclosureLab];
    
    
    _un_enclosureBtn = [[UIButton alloc]init];
    _un_enclosureBtn.frame = CGRectMake(_un_commentView.frame.origin.x, _un_enclosureLab.frame.origin.y, _un_PopupView.frame.size.width * 0.2, oneHeight);
    [_un_enclosureBtn setTitle:@"上传" forState:UIControlStateNormal];
    [_un_enclosureBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _un_enclosureBtn.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    _un_enclosureBtn.layer.cornerRadius = 5;
    _un_enclosureBtn.layer.masksToBounds = YES;
    _un_enclosureBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _un_enclosureBtn.layer.borderWidth = 1;
    [_un_enclosureBtn addTarget:self action:@selector(enclosureAction:) forControlEvents:UIControlEventTouchUpInside];
    [_un_PopcontentView addSubview:_un_enclosureBtn];
    
    
    
    
    if([_flagRole isEqualToString:@"teacher"]){
        _un_PopconfirmBtn = [[UIButton alloc]init];
        _un_PopconfirmBtn.frame = CGRectMake(0, _un_PopupView.frame.size.height * 0.85, _un_PopupView.frame.size.width, _un_PopupView.frame.size.height * 0.15);
        [_un_PopconfirmBtn setTitle:@"提交" forState:UIControlStateNormal];
        _un_PopconfirmBtn.backgroundColor = [UIColor colorWithRed:23/255.0 green:194/255.0 blue:149/255.0 alpha:1];
        [_un_PopconfirmBtn addTarget:self action:@selector(PopSubmit_unpass_Action:) forControlEvents:UIControlEventTouchUpInside];
        [_un_PopupView addSubview:_un_PopconfirmBtn];

    }
}





-(void) PopupLayout{
    _MongoView = [[UIView alloc]init];
    _MongoView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _MongoView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _MongoView.hidden = YES;
    [self.view addSubview:_MongoView];
    _PopupView = [[UIView alloc]init];
    _PopupView.frame = CGRectMake(_MongoView.frame.size.width * 0.1, _MongoView.frame.size.height * 0.25, _MongoView.frame.size.width * 0.8, _MongoView.frame.size.height * 0.5);
    _PopupView.layer.cornerRadius = 10;
    _PopupView.layer.masksToBounds = YES;
    _PopupView.backgroundColor = [UIColor whiteColor];
    [_MongoView addSubview:_PopupView];
    
    
    _PopTitleView = [[UILabel alloc]init];
    _PopTitleView.frame = CGRectMake(0, 0, _PopupView.frame.size.width, _PopupView.frame.size.height * 0.12);
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
    _commentView.frame = CGRectMake(_commentLabel.frame.size.width + _commentLabel.frame.origin.x, _commentLabel.frame.origin.y, _PopcontentView.frame.size.width * 0.7, oneHeight * 1.2);
    _commentView.layer.cornerRadius = 5;
    _commentView.layer.masksToBounds = YES;
    _commentView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
    _commentView.layer.borderWidth = 1;
    _commentView.font = [UIFont systemFontOfSize:16.0];
    [_PopcontentView addSubview:_commentView];
    
    _teacherScoreLabel = [[UILabel alloc]init];
    _teacherScoreLabel.frame = CGRectMake(_PopcontentView.frame.size.width * 0.05, _commentView.frame.size.height + _commentView.frame.origin.y + _PopcontentView.frame.size.width * 0.02, _PopcontentView.frame.size.width * 0.18, oneHeight);
    _teacherScoreLabel.text = @"评分：";
    _teacherScoreLabel.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    _teacherScoreLabel.font = [UIFont systemFontOfSize:16.0];
    [_PopcontentView addSubview:_teacherScoreLabel];
    
    
    
    _teacherScoreLabelField = [[UITextField alloc]init];
    _teacherScoreLabelField.frame = CGRectMake(_commentView.frame.origin.x, _teacherScoreLabel.frame.origin.y + oneHeight * 0.1, _commentView.frame.size.width, oneHeight * 0.8);
    _teacherScoreLabelField.layer.cornerRadius = 5;
    _teacherScoreLabelField.layer.masksToBounds = YES;
    _teacherScoreLabelField.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
    _teacherScoreLabelField.layer.borderWidth = 1;
    _teacherScoreLabelField.font = [UIFont systemFontOfSize:16.0];
    _teacherScoreLabelField.keyboardType = UIKeyboardTypeNumberPad;
    [_teacherScoreLabelField addTarget:self action:@selector(scoreAction:) forControlEvents:(UIControlEventEditingChanged)];
    [_PopcontentView addSubview:_teacherScoreLabelField];
    
    
    _overdueScoreLabel = [[UILabel alloc]init];
    _overdueScoreLabel.frame = CGRectMake(_PopcontentView.frame.size.width * 0.05, _teacherScoreLabel.frame.size.height + _teacherScoreLabel.frame.origin.y + _PopcontentView.frame.size.width * 0.02, _PopcontentView.frame.size.width * 0.18, oneHeight);
    _overdueScoreLabel.text = @"罚分：";
    _overdueScoreLabel.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    _overdueScoreLabel.font = [UIFont systemFontOfSize:16.0];
    [_PopcontentView addSubview:_overdueScoreLabel];
    
    
    _overdueScoreField = [[UITextField alloc]init];
    _overdueScoreField.frame = CGRectMake(_teacherScoreLabelField.frame.origin.x, _overdueScoreLabel.frame.origin.y + oneHeight * 0.1, _teacherScoreLabelField.frame.size.width, oneHeight * 0.8);
    _overdueScoreField.layer.cornerRadius = 5;
    _overdueScoreField.layer.masksToBounds = YES;
    _overdueScoreField.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
    _overdueScoreField.layer.borderWidth = 1;
    _overdueScoreField.font = [UIFont systemFontOfSize:16.0];
    [_overdueScoreField setEnabled:NO];
    _overdueScoreField.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_PopcontentView addSubview:_overdueScoreField];
    
    
    
    _FinalScoreLabel = [[UILabel alloc]init];
    _FinalScoreLabel.frame = CGRectMake(_PopcontentView.frame.size.width * 0.05, _overdueScoreLabel.frame.size.height + _overdueScoreLabel.frame.origin.y + _PopcontentView.frame.size.width * 0.02, _PopcontentView.frame.size.width * 0.18, oneHeight);
    _FinalScoreLabel.text = @"得分：";
    _FinalScoreLabel.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    _FinalScoreLabel.font = [UIFont systemFontOfSize:16.0];
    [_PopcontentView addSubview:_FinalScoreLabel];
    
    
    _FinalScoreField = [[UITextField alloc]init];
    _FinalScoreField.frame = CGRectMake(_overdueScoreField.frame.origin.x, _FinalScoreLabel.frame.origin.y + oneHeight * 0.1, _overdueScoreField.frame.size.width, oneHeight * 0.8);
    _FinalScoreField.layer.cornerRadius = 5;
    _FinalScoreField.layer.masksToBounds = YES;
    _FinalScoreField.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
    _FinalScoreField.layer.borderWidth = 1;
    _FinalScoreField.font = [UIFont systemFontOfSize:16.0];
    [_FinalScoreField setEnabled:NO];
    _FinalScoreField.text = @"0.00";
    _FinalScoreField.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_PopcontentView addSubview:_FinalScoreField];
    
    
    
    
    _enclosureLab = [[UILabel alloc]init];
    _enclosureLab.frame = CGRectMake(_PopcontentView.frame.size.width * 0.05, _FinalScoreLabel.frame.size.height + _FinalScoreLabel.frame.origin.y + _PopcontentView.frame.size.width * 0.02, _PopcontentView.frame.size.width * 0.18, oneHeight);
    _enclosureLab.text = @"附件：";
    _enclosureLab.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    _enclosureLab.font = [UIFont systemFontOfSize:16.0];
    [_PopcontentView addSubview:_enclosureLab];


    _enclosureBtn = [[UIButton alloc]init];
    _enclosureBtn.frame = CGRectMake(_FinalScoreField.frame.origin.x, _enclosureLab.frame.origin.y, _PopupView.frame.size.width * 0.2, oneHeight);
    [_enclosureBtn setTitle:@"上传" forState:UIControlStateNormal];
    [_enclosureBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _enclosureBtn.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    _enclosureBtn.layer.cornerRadius = 5;
    _enclosureBtn.layer.masksToBounds = YES;
    _enclosureBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _enclosureBtn.layer.borderWidth = 1;
    [_enclosureBtn addTarget:self action:@selector(enclosureAction:) forControlEvents:UIControlEventTouchUpInside];
    [_PopcontentView addSubview:_enclosureBtn];
    
    
    
    
    if([_flagRole isEqualToString:@"teacher"]){
        _PopconfirmBtn = [[UIButton alloc]init];
        _PopconfirmBtn.frame = CGRectMake(0, _PopupView.frame.size.height * 0.88, _PopupView.frame.size.width, _PopupView.frame.size.height * 0.12);
        [_PopconfirmBtn setTitle:@"提交" forState:UIControlStateNormal];
        _PopconfirmBtn.backgroundColor = [UIColor colorWithRed:23/255.0 green:194/255.0 blue:149/255.0 alpha:1];
        [_PopconfirmBtn addTarget:self action:@selector(PopSubmit_pass_Action:) forControlEvents:UIControlEventTouchUpInside];
        [_PopupView addSubview:_PopconfirmBtn];
        
        
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



//-(void) countScore:(NSDictionary *)sender{
//    NSString *endStr = [sender objectForKey:@"EndDate"];
//
//    NSRange rang = {0,10};
//    NSString *DateTime = [[[endStr stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
//
//    NSString *currTime = [PhoneInfo getNowTimeTimestamp3];
//
//    int timeCount =  ([DateTime integerValue] + (24 * 60 * 60) - 1) - [currTime integerValue] / 1000;
//
//
//    NSString *overScore = @"0";
//
//    _overdueScoreField.text = overScore;
//}


-(void) detailLayout:(NSArray *)sender{
    
    sender = [GJToolsHelp processDictionaryIsNSNull:sender];

    self.taskDetail = [[sender objectAtIndex:0] mutableCopy];
    
    //State 1 通过 0 未通过
    if (self.isNotApplay) {
        NSInteger State = [self.taskDetail[@"State"] integerValue];
        if (State == 1) {
            [_passBtn setTitle:@"已通过" forState:UIControlStateNormal];
        }
        else{
            [_passBtn setTitle:@"未通过" forState:UIControlStateNormal];
            _passBtn.backgroundColor = [UIColor redColor];
        }
    }
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
    _shenpiVal.text = @"谭老师";
    _shenpiVal.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    _shenpiVal.font = [UIFont systemFontOfSize:15.0];
    [_shenpiView addSubview:_shenpiVal];
    NSString *CheckName = [[sender objectAtIndex:0] objectForKey:@"CheckName"];
    if ([CheckName isKindOfClass:[NSNull class]]) {
        CheckName = @"暂无";
    }
    _shenpiVal.text = CheckName;
    
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
    
    NSString *SubmitAttachment = self.taskDetail[@"SubmitAttachment"];
    if ([SubmitAttachment isKindOfClass:[NSNull class]]) {
        SubmitAttachment = @"";
    }
    if (SubmitAttachment.length > 0) {
        _fujianVal.text = @"查看附件";
   //     asdasd
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(br_lookFills:)];
        [_fujianVal addGestureRecognizer:tap];
        tap.accessibilityLabel = SubmitAttachment;
        _fujianVal.userInteractionEnabled = YES;
    }
    
  //  [self pinglunLayout];
}

- (void)br_lookFills:(UITapGestureRecognizer *)tap{
    
    LDPublicWebViewController *web = [[LDPublicWebViewController alloc] init];
    web.webUrl = tap.accessibilityLabel.fullImg;
    web.title = @"查看附件";
    [self.navigationController pushViewController:web animated:YES];
  //  asdad
}


-(void) pinglunLayout{
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
    
    
    
    for(int i = 0;i<2;i++){
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
        [detailView addSubview:logoImg];
        
        
        UILabel *nameLab = [[UILabel alloc]init];
        nameLab.frame = CGRectMake(logoImg.frame.origin.x + logoImg.frame.size.width + detailView.frame.size.width * 0.02, logoImg.frame.origin.y, detailView.frame.size.width * 0.5, detailView.frame.size.height * 0.15);
        nameLab.text = @"谭老师";
        nameLab.font = [UIFont systemFontOfSize:16.0];
        [detailView addSubview:nameLab];
        
        
        UITextView *contentLab = [[UITextView alloc]init];
        contentLab.frame = CGRectMake(nameLab.frame.origin.x, nameLab.frame.size.height + nameLab.frame.origin.y, detailView.frame.size.width - (detailView.frame.size.width * 0.05 * 2 + logoImg.frame.size.width + detailView.frame.size.width * 0.02), detailView.frame.size.height * 0.4);
        contentLab.text = @"很好，98分";
        contentLab.font = [UIFont systemFontOfSize:16.0];
        [detailView addSubview:contentLab];
        
        UILabel *dateLab = [[UILabel alloc]init];
        dateLab.frame = CGRectMake(contentLab.frame.origin.x, contentLab.frame.size.height + contentLab.frame.origin.y, detailView.frame.size.width - (detailView.frame.size.width * 0.05 * 2 + logoImg.frame.size.width + detailView.frame.size.width * 0.02), detailView.frame.size.height * 0.15);
        dateLab.text = @"2018-04-12 17:58:12";
        dateLab.font = [UIFont systemFontOfSize:13.0];
        [detailView addSubview:dateLab];
    }
    
    
}




-(void) submitAction:(UITapGestureRecognizer *)sender{
    [UIView beginAnimations:@"showPop" context:@"start"];
    [UIView setAnimationDuration:0.1];
    _MongoView.hidden = NO;
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
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];

    _commentView.text = @"";
    [UIView beginAnimations:@"hidePop" context:@"stop"];
    [UIView setAnimationDuration:0.1];
    UIColor *hideColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0];
    _MongoView.backgroundColor = hideColor;
    _MongoView.hidden = YES;
    [UIView commitAnimations];
    
    
    _un_commentView.text = @"";
    [UIView beginAnimations:@"hidePop1" context:@"stop1"];
    [UIView setAnimationDuration:0.1];
    UIColor *hideColor1 = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0];
    _un_MongoView.backgroundColor = hideColor1;
    _un_MongoView.hidden = YES;
    [UIView commitAnimations];
}


-(void) PopSubmit_unpass_Action:(UITapGestureRecognizer *)sender{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [_activityIndicatorView startAnimating];
    NSString *commentVal = _un_commentView.text;
    NSString *url = [NSString stringWithFormat:@"%@/ApiActivityTaskInfo/Check",kCacheHttpRoot];
    NSLog(@"%@",url);

    NSString *currTime = [PhoneInfo getNowTimeTimestamp3];
    NSString *tokenStr = [NSString stringWithFormat:@"%@GJTask%@",_taskID,currTime];
    NSString *getToken = [AizenMD5 MD5ForUpper16Bate:tokenStr];

    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    if (self.uploadFileStr.length <= 0) {
        self.uploadFileStr = @"";
    }
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:_taskID,@"ID",CurrAdminID,@"Updater",commentVal,@"CheckContent",@"2",@"State",getToken,@"Token",currTime,@"TimeStamp",self.uploadFileStr,@"CheckAttachment", nil];

    NSLog(@"%@",params);

    [AizenHttp asynRequest:url httpMethod:@"POST" params:params success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[jsonDic objectForKey:@"Message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
        NSString *Message = jsonDic[@"Message"];
        if ([Message isKindOfClass:[NSNull class]]) {
            Message = @"提交失败";
        }
        if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){//成功
            
            _un_MongoView.hidden = YES;
            [UIView beginAnimations:@"hidePop" context:@"stop"];
            [UIView setAnimationDuration:0.1];
            UIColor *hideColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
            _un_MongoView.backgroundColor = hideColor;
            [UIView commitAnimations];
            
            if (self.updateBlock) {
                self.updateBlock(nil);
            }
            [BaseViewController br_showAlterMsg:Message sureBlock:^(id info) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        else{
            [BaseViewController br_showAlterMsg:Message];
        }
        
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败--提交任务");
    }];

    
  
}


-(void) PopSubmit_pass_Action:(UITapGestureRecognizer *)sender{
    
    
    NSString *teacherScore = _teacherScoreLabelField.text;
    NSString *overScore = _overdueScoreField.text;
    NSString *finalScore = _FinalScoreField.text;
    if([teacherScore isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入分数" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [[UIApplication sharedApplication].keyWindow endEditing:YES];

        NSString *commentVal = _un_commentView.text;
        NSString *url = [NSString stringWithFormat:@"%@/ApiActivityTaskInfo/Check",kCacheHttpRoot];
        
        NSString *currTime = [PhoneInfo getNowTimeTimestamp3];
        NSString *tokenStr = [NSString stringWithFormat:@"%@GJTask%@",_taskID,currTime];
        NSString *getToken = [AizenMD5 MD5ForUpper16Bate:tokenStr];
        
        NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
        NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
        People *getObj = existArr[0];
        NSString *CurrAdminID = [getObj.USERID stringValue];
        NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
        
        if (self.uploadFileStr.length <= 0) {
            self.uploadFileStr = @"";
        }
        NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:_taskID,@"ID",CurrAdminID,@"Updater",commentVal,@"CheckContent",@"1",@"State",teacherScore,@"TeacherScore",overScore,@"OverdueScore",finalScore,@"FinalScore",getToken,@"Token",currTime,@"TimeStamp",self.uploadFileStr,@"CheckAttachment", nil];
        [_activityIndicatorView startAnimating];
        [AizenHttp asynRequest:url httpMethod:@"POST" params:params success:^(id result) {
            [_activityIndicatorView stopAnimating];
            NSDictionary *jsonDic = result;
            NSString *Message = jsonDic[@"Message"];
            if ([Message isKindOfClass:[NSNull class]]) {
                Message = @"提交失败";
            }
            if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){//成功
                
                [UIView beginAnimations:@"hidePop" context:@"stop"];
                [UIView setAnimationDuration:0.1];
                UIColor *hideColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0];
                _MongoView.backgroundColor = hideColor;
                _MongoView.hidden = YES;
                [UIView commitAnimations];
                
                if (self.updateBlock) {
                    self.updateBlock(nil);
                }
                [BaseViewController br_showAlterMsg:Message sureBlock:^(id info) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
            else{
                [BaseViewController br_showAlterMsg:Message];
            }

//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[jsonDic objectForKey:@"Message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
        } failue:^(NSError *error) {
            [_activityIndicatorView stopAnimating];
            NSLog(@"请求失败--提交审核");
            [BaseViewController br_showAlterMsg:@"提交失败，请重试"];

        }];
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
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
           UIImage *image = info[UIImagePickerControllerEditedImage];
        WS(ws);
        [self br_uploadImage:image block:^(BOOL success, NSString *msg) {
            ws.uploadFileStr = [msg copy];
        }];
        //压缩图片
        //        NSData *fileData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
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




-(void) passAction:(UIButton *)sender{
    [UIView beginAnimations:@"showPop" context:@"start"];
    [UIView setAnimationDuration:0.1];
    _MongoView.hidden = NO;
    UIColor *showColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _MongoView.backgroundColor = showColor;
    [UIView commitAnimations];
    [self shakeAnimationForView:_PopupView];
}



-(void) unpassAction:(UIButton *)sender{
    [UIView beginAnimations:@"showPop" context:@"start"];
    [UIView setAnimationDuration:0.1];
    _un_MongoView.hidden = NO;
    UIColor *showColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _un_MongoView.backgroundColor = showColor;
    [UIView commitAnimations];
    
    [self shakeAnimationForView:_un_PopupView];
}



#pragma mark 监听评分
-(void) scoreAction:(UITextField *)sender{
    NSLog(@"%@",self.taskDetail);
    NSString *endDate = [self.taskDetail objectForKey:@"EndDate"];
    
    NSRange rang = {0,10};
    NSString *DateTime = [[[endDate stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
    
    NSString *currTime = [PhoneInfo getNowTimeTimestamp3];
    
    float overPoint = [[self.taskDetail objectForKey:@"OverduePoints"] floatValue];
    float maxPoint = [[self.taskDetail objectForKey:@"MaxPoints"] floatValue];
    
    int timeCount =  ([DateTime integerValue] + (24 * 60 * 60) - 1) - [currTime integerValue] / 1000;
    
    float teacherScore = [sender.text floatValue];
    
    if(timeCount > 0){
        _overdueScoreField.text = @"0.00";
        
        float resultScore = teacherScore - [_overdueScoreField.text floatValue];
        
        _FinalScoreField.text = [NSString stringWithFormat:@"%0.2f",resultScore];
    }else{
        
        int dayCount = abs(timeCount / (24 * 60 * 60) - 1);
        
        if(dayCount * overPoint > maxPoint){
            float resultScore = teacherScore - (teacherScore * maxPoint * 0.01);
            _overdueScoreField.text = [NSString stringWithFormat:@"%0.2f",(teacherScore * maxPoint * 0.01)];
            _FinalScoreField.text = [NSString stringWithFormat:@"%0.2f",resultScore];
        }else{
            float resultScore = teacherScore - (teacherScore * dayCount * overPoint * 0.01);
            _overdueScoreField.text = [NSString stringWithFormat:@"%0.2f",(teacherScore * dayCount * overPoint * 0.01)];
            _FinalScoreField.text = [NSString stringWithFormat:@"%0.2f",resultScore];
        }
    }
}


- (void)br_uploadImage:(UIImage *)img block:(void(^)(BOOL success,NSString *msg))block {
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
    
    
    NSString *url = [NSString stringWithFormat:@"ApiInternshipApplyEnterpriseInfo/UploadFile?AdminID=%@&ModuleName=%@&TimeStamp=%@&Token=%@",CurrAdminID,@"Task",CurrTimeStamp,CurrToken];
    NSString *urlencode = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [_activityIndicatorView startAnimating];
    
    [[HTTPOpration sharedHTTPOpration] NetRequestPOSTFileWithRequestURL:urlencode WithParameter:nil WithFiles:@{@"file":UIImageJPEGRepresentation(img, 0.5)} WithReturnValeuBlock:^(HTTPData *data) {
        [_activityIndicatorView stopAnimating];

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
                [BaseViewController br_showAlterMsg:@"数据异常"];
                
            }
        }
        else{
            [BaseViewController br_showAlterMsg:data.msg];
        }
        
    } WithFailureBlock:^(id error) {
        [_activityIndicatorView stopAnimating];

        [BaseViewController br_showAlterMsg:@"提交失败请重试!"];
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
