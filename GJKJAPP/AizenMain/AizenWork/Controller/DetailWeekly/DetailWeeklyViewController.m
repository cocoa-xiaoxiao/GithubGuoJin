//
//  DetailWeeklyViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/4/13.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "DetailWeeklyViewController.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "People.h"
#import "PhoneInfo.h"
#import "DGActivityIndicatorView.h"
#import "RAlertView.h"
#import "RDVTabBarController.h"
#import "MainViewController.h"

#import <IQKeyboardManager/IQPreviousNextView.h>
#import "LDPublicWebViewController.h"
#import "BROpenWordManager.h"
@interface DetailWeeklyViewController ()<UIAlertViewDelegate>

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIButton *submitBtn;

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIImageView *imgView;
@property(nonatomic,strong) UILabel *nameLab;
@property(nonatomic,strong) UILabel *dateLab;

@property(nonatomic,strong) UILabel *titleLab;

@property(nonatomic,strong) UIView *workContentView;
@property(nonatomic,strong) UILabel *workLab;
@property(nonatomic,strong) UITextView *workContentVal;

@property(nonatomic,strong) UIView *problemView;
@property(nonatomic,strong) UILabel *problemLab;
@property(nonatomic,strong) UITextView *problemVal;

@property(nonatomic,strong) UIView *solveView;
@property(nonatomic,strong) UILabel *solveLab;
@property(nonatomic,strong) UITextView *solveVal;

@property(nonatomic,strong) UIView *lightView;
@property(nonatomic,strong) UILabel *lightLab;
@property(nonatomic,strong) UITextView *lightVal;

@property(nonatomic,strong) UIView *insufficientView;
@property(nonatomic,strong) UILabel *insufficientLab;
@property(nonatomic,strong) UITextView *insufficientVal;

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

@property(nonatomic,strong) UILabel *scoreLabel;
@property(nonatomic,strong) UITextField *scoreField;

@property(nonatomic,strong) UIImageView *closeView;


@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

@end

@implementation DetailWeeklyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"周记详情";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    [self startLayout];
}


-(void) startLayout{
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_NAVBAR - HEIGHT_STATUSBAR - HEIGHT_TABBAR);
    _contentView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((_contentView.frame.size.width - 100)/2, (_contentView.frame.size.height - 200)/2, 100, 100);
    [_contentView addSubview:_activityIndicatorView];
    _activityIndicatorView.layer.zPosition = 1000;
    
    if([_flagRole isEqualToString:@"student"]){
    
    }else if([_flagRole isEqualToString:@"teacher"]){
        _submitBtn = [[UIButton alloc]init];
        _submitBtn.frame = CGRectMake(0, _contentView.frame.size.height + _contentView.frame.origin.y, _contentView.frame.size.width, HEIGHT_TABBAR);
        [_submitBtn setTitle:@"审核" forState:UIControlStateNormal];
        _submitBtn.backgroundColor = [UIColor colorWithRed:23/255.0 green:194/255.0 blue:149/255.0 alpha:1];
        [_submitBtn addTarget:self action:@selector(passAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_submitBtn];
        _submitBtn.hidden = YES;
        [self PopupLayout];
        
    }
    
    _scrollView  = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, _contentView.frame.size.height * 3);
    [_contentView addSubview:_scrollView];
    
    
    
    [self handleHttp];
}

/*MARK:点击背景取消 */
- (void)br_selectedPopViewBgDismiss:(UITapGestureRecognizer *)tap{
    
}
//-(void)loadView {
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    [scrollView setBackgroundColor:[UIColor grayColor]];
//    self.view = scrollView;
//}
-(void) PopupLayout{
    
    _MongoView = [[UIScrollView alloc]init];
    
    _MongoView.frame = CGRectMake(0, _contentView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - _contentView.frame.origin.y);
    _MongoView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];//[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self.view insertSubview:_MongoView atIndex:0];
//    [self.view addSubview:_MongoView];
     ((UIScrollView*)_MongoView).contentSize = CGSizeMake(_MongoView.bounds.size.width, _MongoView.bounds.size.height);
//    ((UIScrollView*)_MongoView).scrollEnabled = NO;
    _PopupView = [[UIView alloc]init];
    _PopupView.frame = CGRectMake(_MongoView.frame.size.width * 0.1, _MongoView.frame.size.height * 0.3, _MongoView.frame.size.width * 0.8, _MongoView.frame.size.height * 0.4);
    _PopupView.layer.cornerRadius = 10;
    _PopupView.layer.masksToBounds = YES;
    _PopupView.backgroundColor = [UIColor whiteColor];
    [_MongoView addSubview:_PopupView];
   
    //[self.view insertSubview:_MongoView atIndex:0];


    _PopTitleView = [[UILabel alloc]init];
    _PopTitleView.frame = CGRectMake(0, 0, _PopupView.frame.size.width, _PopupView.frame.size.height * 0.14);
    _PopTitleView.text = @"审核评分";
    _PopTitleView.textAlignment = UITextAlignmentCenter;
    _PopTitleView.textColor = [UIColor whiteColor];
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
    _commentLabel.text = @"评论：";
    _commentLabel.adjustsFontSizeToFitWidth = YES;
//    _commentLabel.numberOfLines = 0;
//    [_commentLabel sizeToFit];
    _commentLabel.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    _commentLabel.font = [UIFont systemFontOfSize:16.0];
    [_PopcontentView addSubview:_commentLabel];
    
    
    _commentView = [[UITextView alloc]init];
    _commentView.frame = CGRectMake(_commentLabel.frame.size.width + _commentLabel.frame.origin.x, _commentLabel.frame.origin.y, _PopcontentView.frame.size.width * 0.7, oneHeight * 4);
    _commentView.layer.cornerRadius = 5;
    _commentView.layer.masksToBounds = YES;
    _commentView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
    _commentView.layer.borderWidth = 1;
    _commentView.font = [UIFont systemFontOfSize:16.0];
    [_PopcontentView addSubview:_commentView];
    
    
    _scoreLabel = [[UILabel alloc]init];
    _scoreLabel.frame = CGRectMake(_commentLabel.frame.origin.x, _PopcontentView.frame.size.width * 0.05 + _commentView.frame.size.height + _commentView.frame.origin.y, _commentLabel.frame.size.width, oneHeight);
    _scoreLabel.text = @"评分：";
    _scoreLabel.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    _scoreLabel.font = [UIFont systemFontOfSize:16.0];
    _scoreLabel.textAlignment = UITextAlignmentLeft;
    [_PopcontentView addSubview:_scoreLabel];
    _scoreLabel.adjustsFontSizeToFitWidth = YES;

    
    
    _scoreField = [[UITextField alloc]init];
    _scoreField.frame = CGRectMake(_scoreLabel.frame.size.width + _scoreLabel.frame.origin.x, _scoreLabel.frame.origin.y,_PopcontentView.frame.size.width * 0.7, oneHeight);
    _scoreField.layer.cornerRadius = 5;
    _scoreField.layer.masksToBounds = YES;
    _scoreField.layer.borderWidth = 1;
    _scoreField.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
    _scoreField.keyboardType = UIKeyboardTypeNumberPad;
    [_PopcontentView addSubview:_scoreField];
    
    
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



-(void) passAction:(UIButton *)sender{
    [UIView beginAnimations:@"showPop" context:@"start"];
    [UIView setAnimationDuration:0.1];
    [self.view insertSubview:_MongoView atIndex:2];
    UIColor *showColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _MongoView.backgroundColor = showColor;
    [UIView commitAnimations];
    
    [self shakeAnimationForView:_PopupView];
}










-(void) handleHttp{
    [_activityIndicatorView startAnimating];
    
    NSString *weeklyID = _ID;
    NSString *url = [NSString stringWithFormat:@"%@/ApiActivityWeekly/GetByID?WeeklyID=%@",kCacheHttpRoot,weeklyID];
    NSLog(@"%@",url);
    
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
            [self detailLayout:[jsonDic objectForKey:@"AppendData"]];
        }
        else{
            [BaseViewController br_showAlterMsg:@"数据错误，请重试"];
        }
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败--周记详情");
        [BaseViewController br_showAlterMsg:@"请求失败，请重试"];

    }];
}


- (void)br_toLookWord:(UIButton *)sender{
    NSString *url = [_submitBtn.accessibilityLabel fullImg];
    LDPublicWebViewController *web = [[LDPublicWebViewController alloc] init];
    web.webUrl = url;
    web.title = @"查看附件";
    [self.navigationController pushViewController:web animated:YES];

//    UIDocumentInteractionController *doc= [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:url]];
//    doc.delegate = self;
//    [doc presentPreviewAnimated:YES];
//    [[BROpenWordManager share] br_openAWordWithUrl:url fileId:_ID vc:self];
    
}

-(void) detailLayout:(NSArray *)dataArr{
    
    dataArr = [GJToolsHelp processDictionaryIsNSNull:dataArr];

    _submitBtn.hidden = NO;
    NSInteger CheckState = [[[dataArr firstObject] objectForKey:@"CheckState"] integerValue];
    //0 未审核 1已审核 TempUrl  2 未通过
    if (CheckState == 2) {
        _submitBtn.userInteractionEnabled = NO;
        _submitBtn.backgroundColor = [UIColor redColor];
        [_submitBtn setTitle:@"未通过" forState:UIControlStateNormal];
    }
    else if (CheckState == 1){
        [_submitBtn removeTarget:self action:@selector(passAction:) forControlEvents:UIControlEventTouchUpInside];
        [_submitBtn addTarget:self action:@selector(br_toLookWord:) forControlEvents:UIControlEventTouchUpInside];
        NSString *tempUrl = [[dataArr firstObject] objectForKey:@"TempUrl"];
        if ([tempUrl isKindOfClass:[NSNull class]]) {
            tempUrl = @"";
        }
        _submitBtn.accessibilityLabel = tempUrl;
        [_submitBtn setTitle:@"查看word文件" forState:UIControlStateNormal];

    }
    _topView = [[UIView alloc]init];
    _topView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _contentView.frame.size.height * 0.12);
    _topView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_topView];
    
    CALayer *bottomLayer = [CALayer layer];
    bottomLayer.frame = CGRectMake(_topView.frame.size.width * 0.05, _topView.frame.size.height - 1, _topView.frame.size.width * 0.9, 1);
    bottomLayer.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    [_topView.layer addSublayer:bottomLayer];
    
    _imgView = [[UIImageView alloc]init];
    _imgView.frame = CGRectMake(_topView.frame.size.width * 0.05, _topView.frame.size.height * 0.15, _topView.frame.size.height * 0.7, _topView.frame.size.height * 0.7);
    _imgView.layer.cornerRadius = 5;
    _imgView.layer.masksToBounds = YES;
    _imgView.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
    _imgView.layer.borderWidth = 1;
    
    _imgView.image = [UIImage imageNamed:@"gj_msglogo2"];
    [_topView addSubview:_imgView];
    
    _nameLab = [[UILabel alloc]init];
    _nameLab.frame = CGRectMake(_imgView.frame.size.width + _imgView.frame.origin.x + _topView.frame.size.width * 0.03, _imgView.frame.origin.y, _topView.frame.size.width * 0.5, _imgView.frame.size.height * 0.5);
    _nameLab.text = [[dataArr objectAtIndex:0] objectForKey:@"StudentName"];
    _nameLab.font = [UIFont systemFontOfSize:18.0];
    [_topView addSubview:_nameLab];
    
    
    _dateLab = [[UILabel alloc]init];
    _dateLab.frame = CGRectMake(_nameLab.frame.origin.x, _nameLab.frame.size.height + _nameLab.frame.origin.y, _topView.frame.size.width * 0.7, _nameLab.frame.size.height);
    NSString *dateStr = [PhoneInfo handleDateStr:[[dataArr objectAtIndex:0] objectForKey:@"UpdateDate"] handleFormat:@"yyyy-MM-dd"];
    _dateLab.text = [NSString stringWithFormat:@"提交时间:%@",dateStr];
    _dateLab.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    _dateLab.font = [UIFont systemFontOfSize:15.0];
    [_topView addSubview:_dateLab];
    
    
    _workContentView = [[UIView alloc]init];
    _workContentView.frame = CGRectMake(0, _topView.frame.size.height + _topView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height * 0.3);
    _workContentView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_workContentView];
    
    CALayer *workLayer = [CALayer layer];
    workLayer.frame = CGRectMake(_workContentView.frame.size.width * 0.05, _workContentView.frame.size.height - 1, _workContentView.frame.size.width * 0.9, 1);
    workLayer.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    [_workContentView.layer addSublayer:workLayer];
    
    _titleLab = [[UILabel alloc]init];
    _titleLab.frame = CGRectMake(_workContentView.frame.size.width * 0.05, _workContentView.frame.size.width * 0.02, _workContentView.frame.size.width * 0.9, _contentView.frame.size.height * 0.05);
    _titleLab.text = [[dataArr objectAtIndex:0] objectForKey:@"WeeklyTitle"];
    _titleLab.textColor = [UIColor blackColor];
    [_workContentView addSubview:_titleLab];
    
    _workLab = [[UILabel alloc]init];
    _workLab.frame = CGRectMake(_workContentView.frame.size.width * 0.05, _titleLab.frame.size.height + _titleLab.frame.origin.y + _workContentView.frame.size.width * 0.01, _workContentView.frame.size.width * 0.9, _contentView.frame.size.height * 0.05);
    _workLab.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    _workLab.text = @"工作内容:";
    _workLab.font = [UIFont systemFontOfSize:16.0];
    [_workContentView addSubview:_workLab];
    
    CGFloat workContentHeight = _workContentView.frame.size.height - (_workContentView.frame.size.width * 0.02 * 2 + _titleLab.frame.size.height + _workLab.frame.size.height + _workContentView.frame.size.width * 0.01);
    _workContentVal = [[UITextView alloc]init];
    _workContentVal.frame = CGRectMake(_workLab.frame.origin.x, _workLab.frame.origin.y + _workLab.frame.size.height, _workContentView.frame.size.width * 0.9,workContentHeight);
    _workContentVal.text = [[dataArr objectAtIndex:0] objectForKey:@"Field1"] == [NSNull null]?@"":[[dataArr objectAtIndex:0] objectForKey:@"Field1"];
    _workContentVal.backgroundColor = [UIColor clearColor];
    _workContentVal.font = [UIFont systemFontOfSize:16.0];
    [_workContentVal setEditable:NO];
    [_workContentView addSubview:_workContentVal];
    
    
    _problemView = [[UIView alloc]init];
    _problemView.frame = CGRectMake(0, _workContentView.frame.size.height + _workContentView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height * 0.3);
    _problemView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_problemView];
    
    CALayer *problemLayer = [CALayer layer];
    problemLayer.frame = CGRectMake(_problemView.frame.size.width * 0.05, _problemView.frame.size.height - 1, _problemView.frame.size.width * 0.9, 1);
    problemLayer.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    [_problemView.layer addSublayer:problemLayer];
    
    
    _problemLab = [[UILabel alloc]init];
    _problemLab.frame = CGRectMake(_problemView.frame.size.width * 0.05, _problemView.frame.size.width * 0.01, _problemView.frame.size.width * 0.9, _contentView.frame.size.height * 0.05);
    _problemLab.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    _problemLab.text = @"遇到的问题:";
    _problemLab.font = [UIFont systemFontOfSize:16.0];
    [_problemView addSubview:_problemLab];
    
    
    CGFloat problemContentHeight = _problemView.frame.size.height - (_problemView.frame.size.width * 0.02 * 2 + _problemLab.frame.size.height + _problemView.frame.size.width * 0.01);
    _problemVal = [[UITextView alloc]init];
    _problemVal.frame = CGRectMake(_problemLab.frame.origin.x, _problemLab.frame.origin.y + _problemLab.frame.size.height, _problemView.frame.size.width * 0.9,problemContentHeight);
    _problemVal.text = [[dataArr objectAtIndex:0] objectForKey:@"Field2"] == [NSNull null]?@"":[[dataArr objectAtIndex:0] objectForKey:@"Field2"];
    _problemVal.backgroundColor = [UIColor clearColor];
    _problemVal.font = [UIFont systemFontOfSize:16.0];
    [_problemVal setEditable:NO];
    [_problemView addSubview:_problemVal];
    
    
    _solveView = [[UIView alloc]init];
    _solveView.frame = CGRectMake(0, _problemView.frame.size.height + _problemView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height * 0.3);
    _solveView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_solveView];
    
    CALayer *solveLayer = [CALayer layer];
    solveLayer.frame = CGRectMake(_solveView.frame.size.width * 0.05, _solveView.frame.size.height - 1, _solveView.frame.size.width * 0.9, 1);
    solveLayer.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    [_solveView.layer addSublayer:solveLayer];
    
    
    _solveLab = [[UILabel alloc]init];
    _solveLab.frame = CGRectMake(_solveView.frame.size.width * 0.05, _solveView.frame.size.width * 0.01, _solveView.frame.size.width * 0.9, _contentView.frame.size.height * 0.05);
    _solveLab.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    _solveLab.text = @"解决方案:";
    _solveLab.font = [UIFont systemFontOfSize:16.0];
    [_solveView addSubview:_solveLab];
    
    
    CGFloat solveContentHeight = _solveView.frame.size.height - (_solveView.frame.size.width * 0.02 * 2 + _solveLab.frame.size.height + _solveView.frame.size.width * 0.01);
    _solveVal = [[UITextView alloc]init];
    _solveVal.frame = CGRectMake(_solveLab.frame.origin.x, _solveLab.frame.origin.y + _solveLab.frame.size.height, _solveLab.frame.size.width * 0.9,solveContentHeight);
    _solveVal.text = [[dataArr objectAtIndex:0] objectForKey:@"Field3"] == [NSNull null]?@"":[[dataArr objectAtIndex:0] objectForKey:@"Field3"];
    _solveVal.backgroundColor = [UIColor clearColor];
    _solveVal.font = [UIFont systemFontOfSize:16.0];
    [_solveVal setEditable:NO];
    [_solveView addSubview:_solveVal];
    
    
    
    _lightView = [[UIView alloc]init];
    _lightView.frame = CGRectMake(0, _solveView.frame.size.height + _solveView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height * 0.3);
    _lightView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_lightView];
    
    CALayer *lightLayer = [CALayer layer];
    lightLayer.frame = CGRectMake(_lightView.frame.size.width * 0.05, _lightView.frame.size.height - 1, _lightView.frame.size.width * 0.9, 1);
    lightLayer.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    [_lightView.layer addSublayer:lightLayer];
    
    
    _lightLab = [[UILabel alloc]init];
    _lightLab.frame = CGRectMake(_lightView.frame.size.width * 0.05, _lightView.frame.size.width * 0.01, _lightView.frame.size.width * 0.9, _contentView.frame.size.height * 0.05);
    _lightLab.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    _lightLab.text = @"工作亮点:";
    _lightLab.font = [UIFont systemFontOfSize:16.0];
    [_lightView addSubview:_lightLab];
    
    
    CGFloat lightContentHeight = _lightView.frame.size.height - (_lightView.frame.size.width * 0.02 * 2 + _lightLab.frame.size.height + _lightView.frame.size.width * 0.01);
    _lightVal = [[UITextView alloc]init];
    _lightVal.frame = CGRectMake(_lightLab.frame.origin.x, _lightLab.frame.origin.y + _lightLab.frame.size.height, _lightLab.frame.size.width * 0.9,lightContentHeight);
    _lightVal.text = [[dataArr objectAtIndex:0] objectForKey:@"Field4"] == [NSNull null]?@"":[[dataArr objectAtIndex:0] objectForKey:@"Field4"];
    _lightVal.backgroundColor = [UIColor clearColor];
    _lightVal.font = [UIFont systemFontOfSize:16.0];
    [_lightVal setEditable:NO];
    [_lightView addSubview:_lightVal];
    
    
    
    _insufficientView = [[UIView alloc]init];
    _insufficientView.frame = CGRectMake(0, _lightView.frame.size.height + _lightView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height * 0.3);
    _insufficientView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_insufficientView];
    
    
    _insufficientLab = [[UILabel alloc]init];
    _insufficientLab.frame = CGRectMake(_insufficientView.frame.size.width * 0.05, _insufficientView.frame.size.width * 0.01, _insufficientView.frame.size.width * 0.9, _contentView.frame.size.height * 0.05);
    _insufficientLab.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    _insufficientLab.text = @"存在的不足:";
    _insufficientLab.font = [UIFont systemFontOfSize:16.0];
    [_insufficientView addSubview:_insufficientLab];
    
    
    CGFloat insufficientContentHeight = _insufficientView.frame.size.height - (_insufficientView.frame.size.width * 0.02 * 2 + _insufficientLab.frame.size.height + _insufficientView.frame.size.width * 0.01);
    _insufficientVal = [[UITextView alloc]init];
    _insufficientVal.frame = CGRectMake(_insufficientLab.frame.origin.x, _insufficientLab.frame.origin.y + _insufficientLab.frame.size.height, _insufficientLab.frame.size.width * 0.9,insufficientContentHeight);
    _insufficientVal.text = [[dataArr objectAtIndex:0] objectForKey:@"Field5"] == [NSNull null]?@"":[[dataArr objectAtIndex:0] objectForKey:@"Field5"];
    _insufficientVal.backgroundColor = [UIColor clearColor];
    _insufficientVal.font = [UIFont systemFontOfSize:16.0];
    [_insufficientVal setEditable:NO];
    [_insufficientView addSubview:_insufficientVal];
    
    
    _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, CGRectGetMaxY(_insufficientView.frame));

    //[self pinglunLayout];
}


-(void) pinglunLayout{
    _pinglunView = [[UIView alloc]init];
    _pinglunView.frame = CGRectMake(0, _insufficientView.frame.size.height + _insufficientView.frame.origin.y + _contentView.frame.size.height * 0.05, _scrollView.frame.size.width, _contentView.frame.size.height * 0.05);
    _pinglunView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_pinglunView];
    
    CALayer *pinglunLayer = [CALayer layer];
    pinglunLayer.frame = CGRectMake(_pinglunView.frame.size.width * 0.05, _pinglunView.frame.size.height - 1, _pinglunView.frame.size.width * 0.9, 1);
    pinglunLayer.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    [_pinglunView.layer addSublayer:pinglunLayer];
    
    _pinglunLab = [[UILabel alloc]init];
    _pinglunLab.frame = CGRectMake(0, 0, _pinglunView.frame.size.width, _pinglunView.frame.size.height);
    _pinglunLab.text = @"留言区";
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


/*FIXME:取消 */
-(void) PopCancelAction:(UIButton *)sender{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [_activityIndicatorView startAnimating];
    NSString *ID = _ID;
    NSString *currTime = [PhoneInfo getNowTimeTimestamp3];
    NSString *content = _commentView.text;
    
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    
    NSString *token = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@GJApply%@",ID,currTime]];
    
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:ID,@"WeeklyID",CurrAdminID,@"AdminID",@"false",@"State",content,@"Content",currTime,@"TimeStamp",token,@"Token", nil];
    NSLog(@"%@",params);
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiActivityWeekly/Check",kCacheHttpRoot];
    
    [AizenHttp asynRequest:url httpMethod:@"POST" params:params success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[jsonDic objectForKey:@"Message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        
        [UIView beginAnimations:@"hidePop" context:@"stop"];
        [UIView setAnimationDuration:0.1];
        UIColor *hideColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0];
        _MongoView.backgroundColor = hideColor;
        [self.view insertSubview:_MongoView atIndex:0];
        [UIView commitAnimations];
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败---审核周记");
    }];
}


/*FIXME:提交 */
-(void) PopConfirmAction:(UIButton *)sender{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [_activityIndicatorView startAnimating];
    NSString *ID = _ID;
    NSString *currTime = [PhoneInfo getNowTimeTimestamp3];
    NSString *content = _commentView.text;
    
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];

    NSString *token = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@GJApply%@",ID,currTime]];
    
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:ID,@"WeeklyID",CurrAdminID,@"AdminID",@"true",@"State",content,@"Content",currTime,@"TimeStamp",token,@"Token", nil];
    NSLog(@"%@",params);
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiActivityWeekly/Check",kCacheHttpRoot];
    
    [AizenHttp asynRequest:url httpMethod:@"POST" params:params success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[jsonDic objectForKey:@"Message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.delegate = self;
        //撒打算打算的
        NSInteger ResultType = [jsonDic[@"ResultType"] integerValue];
        if (ResultType == 0) {
            alertView.tag = kSuccessCodeTag;
        }
        [alertView show];

        [UIView beginAnimations:@"hidePop" context:@"stop"];
        [UIView setAnimationDuration:0.1];
        UIColor *hideColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0];
        _MongoView.backgroundColor = hideColor;
        [self.view insertSubview:_MongoView atIndex:0];
        [UIView commitAnimations];
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败---审核周记");
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (alertView.tag == kSuccessCodeTag) {
            if (self.updateBlock) {
                self.updateBlock(nil);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}


-(void) closeAction:(UITapGestureRecognizer *)sender{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    //[self.PopupView endEditing:YES];

    _commentView.text = @"";
    _scoreField.text = @"";
    [UIView beginAnimations:@"hidePop" context:@"stop"];
    [UIView setAnimationDuration:0.1];
    UIColor *hideColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0];
    _MongoView.backgroundColor = hideColor;
    [self.view insertSubview:_MongoView atIndex:0];
    [UIView commitAnimations];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
