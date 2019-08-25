//
//  GJShenheViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/1/2.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "GJShenheViewController.h"
#import "UITextView+Placeholder.h"
#import "People.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "PhoneInfo.h"
#import "Toast+UIView.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
@interface GJShenheViewController ()
{
    NSString *_FlowDetailID;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UISwitch *passSwitch;
@property (weak, nonatomic) IBOutlet UIView *quitAnswerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@end

@implementation GJShenheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDetailFromNet];
    [_textView setPlaceholder:@"请输入审核评语" placeholdColor:[UIColor lightGrayColor]];
    NSArray *qs = @[@"已收阅,再接再厉!",@"在截止日期前提交.",@"请认真修改后提交.",@"请电话联系我详谈.",@"这个任务完成了！不错嘛,继续努力."];
    [self addActivity];
    [self createLabelWithArray:qs FontSize:14 SpcX:10 SpcY:10];
    
}
-(void)addActivity
{
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [_scrollView addSubview:_activityIndicatorView];
}
-(void)getDetailFromNet
{
    if (self.shenheType == shenheType_xuanti) {
        [_activityIndicatorView startAnimating];
        [HttpService GetProjectApplyInfoNowCheckStepByID:self.pid success:^(NSDictionary *resp) {
            [_activityIndicatorView stopAnimating];
            NSArray *dictArray = [resp objectForKey:@"AppendData"];
            [self getIdFromArray:dictArray.firstObject];
        } failure:^(NSError * _Nonnull error) {
            [_activityIndicatorView startAnimating];
        }];
    }else if (self.shenheType == shenheType_kaitibaogao)
    {
        [_activityIndicatorView startAnimating];
        [HttpService GetProjectTaskBookNowCheckStepByID:self.pid success:^(id  _Nonnull responseObject) {
            [_activityIndicatorView stopAnimating];
            NSArray *dictArray = [responseObject objectForKey:@"AppendData"];
            [self getIdFromArray:dictArray.firstObject];
        } failure:^(NSError * _Nonnull error) {
             [_activityIndicatorView startAnimating];
        }];
    }
    
}

-(void)getIdFromArray:(NSDictionary *)dict
{
    _FlowDetailID = [[dict objectForKey:@"ID"] stringValue];
}

- (void)createLabelWithArray:(NSArray *)titleArr FontSize:(CGFloat)fontSize SpcX:(CGFloat)spcX SpcY:(CGFloat)spcY
{
    //创建标签位置变量
    CGFloat positionX = spcX;
    CGFloat positionY = spcY;
    //临界值判断变量
    CGFloat bgViewWidth = _quitAnswerView.frame.size.width;
    //创建label
    for(int i = 0; i < titleArr.count; i++)
    {
        CGSize labelSize = [self getSizeByString:titleArr[i] AndFontSize:fontSize];
        CGFloat labelWidth = labelSize.width;
        CGFloat labelHeight = labelSize.height;
        if(positionX + labelWidth > bgViewWidth)
        {
            positionX = spcX;
            positionY = positionY + labelSize.height + 5;
        }
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(positionX, positionY, labelWidth, labelHeight)];
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(quickTap:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 10;
        button.layer.borderWidth = 1;
        button.tag = i + 100;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        positionX += (labelWidth + 5);
        [_quitAnswerView addSubview:button];
    }
}
//获取字符串长度的方法
- (CGSize)getSizeByString:(NSString*)string AndFontSize:(CGFloat)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(999, 25) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    size.width += 20;
    size.height += 10;
    return size;
}

-(void)quickTap:(UIButton *)sender
{
    self.textView.text = sender.titleLabel.text;
}
- (IBAction)shenhe:(id)sender {
    
    if (_FlowDetailID == nil) {
        if (self.shenheType == shenheType_xuanti || self.shenheType == shenheType_kaitibaogao) {
            [self.view makeToast:@"文件获取失败" duration:1.0 position:@"center"];
            return;
        }
        
    }
    if (_textView.text.length == 0) {
        [self.view makeToast:@"请输入评语" duration:1.0 position:@"center"];
        return;
    }
    int checkstate = self.passSwitch.isOn?1:2;
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    UInt64 currTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *currTimeStr = [NSString stringWithFormat:@"%ld",currTime];
    NSString *md5Str = nil;
    [_activityIndicatorView startAnimating];
    if (self.shenheType == shenheType_xuanti) {
        md5Str = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@GJProjectApply%@",CurrAdminID,currTimeStr]];
        [HttpService ProjectApplyCheckByID:self.pid andAdminID:CurrAdminID andFlowDetailID:_FlowDetailID andCheckState:checkstate andCheckRemark:_textView.text andTimeStamp:currTimeStr andToken:md5Str success:^(NSDictionary * responseObject) {
            [_activityIndicatorView stopAnimating];
            NSString *message = [responseObject objectForKey:@"Message"];
            if ([[responseObject objectForKey:@"ResultType"] intValue] == 0 ) {
                [self.navigationController popViewControllerAnimated:YES];
                [[UIApplication sharedApplication].keyWindow makeToast:message duration:2.0 position:@"center"];
            }else{
                [self.view makeToast:message duration:1.0 position:@"center"];
            }
        } failure:^(NSError * _Nonnull error) {
            [_activityIndicatorView stopAnimating];
        }];
    }else if (self.shenheType == shenheType_kaitibaogao)
    {
        md5Str = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@GJProjectDocuments%@",CurrAdminID,currTimeStr]];
        [HttpService ProjectDocumentsCheckFromID:self.pid andAdminID:CurrAdminID andFlowDetailID:_FlowDetailID andCheckState:checkstate andCheckRemark:_textView.text andTimeStamp:currTimeStr andToken:md5Str success:^(id  _Nonnull responseObject) {
            [_activityIndicatorView stopAnimating];
            NSString *message = [responseObject objectForKey:@"Message"];
            if ([[responseObject objectForKey:@"ResultType"] intValue] == 0 ) {
                [self.navigationController popViewControllerAnimated:YES];
                [[UIApplication sharedApplication].keyWindow makeToast:message duration:2.0 position:@"center"];
            }else{
                [self.view makeToast:message duration:1.0 position:@"center"];
            }
        } failure:^(NSError * _Nonnull error) {
            [_activityIndicatorView stopAnimating];
        }];
    }else if (self.shenheType == shenheType_report)
    {
        
        md5Str = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@GJInspection%@",CurrAdminID,currTimeStr]];
        NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipInspectionTeamInfo/BatchCheck?AdminID=%@&CheckState=%@&IDs=%@&Content=%@&TimeStamp=%@&Token=%@",kCacheHttpRoot,CurrAdminID,[NSString stringWithFormat:@"%d",checkstate],self.pid,_textView.text,currTimeStr,md5Str];
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [_activityIndicatorView startAnimating];
        [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
            [_activityIndicatorView stopAnimating];
            NSString *message = [result objectForKey:@"Message"];
            if ([[result objectForKey:@"ResultType"] intValue] == 0 ) {
                [self.navigationController popViewControllerAnimated:YES];
                [[UIApplication sharedApplication].keyWindow makeToast:message duration:2.0 position:@"center"];
            }else{
                [self.view makeToast:message duration:1.0 position:@"center"];
            }
        } failue:^(NSError *error) {
            [_activityIndicatorView stopAnimating];
            NSLog(@"请求失败");
        }];
    }
    else if (self.shenheType == shenheType_reportcexiao)
    {
        
        md5Str = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@GJInspection%@",CurrAdminID,currTimeStr]];
        NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipInspectionTeamInfo/BatchCheck?AdminID=%@&CheckState=%@&IDs=%@&Content=%@&TimeStamp=%@&Token=%@",kCacheHttpRoot,CurrAdminID,[NSString stringWithFormat:@"%d",3],self.pid,_textView.text,currTimeStr,md5Str];
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [_activityIndicatorView startAnimating];
        [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
            [_activityIndicatorView stopAnimating];
            NSString *message = [result objectForKey:@"Message"];
            if ([[result objectForKey:@"ResultType"] intValue] == 0 ) {
                [self.navigationController popViewControllerAnimated:YES];
                [[UIApplication sharedApplication].keyWindow makeToast:message duration:2.0 position:@"center"];
            }else{
                [self.view makeToast:message duration:1.0 position:@"center"];
            }
        } failue:^(NSError *error) {
            [_activityIndicatorView stopAnimating];
            NSLog(@"请求失败");
        }];
    }
}
@end
