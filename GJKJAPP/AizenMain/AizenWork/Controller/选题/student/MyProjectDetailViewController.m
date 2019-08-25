//
//  MyProjectDetailViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/10.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MyProjectDetailViewController.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "People.h"
#import "AizenMD5.h"
#import "Toast+UIView.h"
#import "GJShenheViewController.h"
#import "IBCreatHelper.h"
#import "LDPublicWebViewController.h"
@interface MyProjectDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *pNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *pGroupLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView1;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView2;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView3;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@end

@implementation MyProjectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.laoshi) {
        UIBarButtonItem *rbar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"shanchu"] style:UIBarButtonItemStyleDone target:self action:@selector(delete)];
        self.navigationItem.rightBarButtonItem = rbar;
    }
    [self getDetailFromNet:self.pID];
}

-(void)delete
{
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    UInt64 currTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *currTimeStr = [NSString stringWithFormat:@"%ld",currTime];
    NSString *md5Str = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@GJProjectApply%@",CurrAdminID,currTimeStr]];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"您要删除当前的选题记录吗?"] preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_activityIndicatorView startAnimating];
        [HttpService DeleteProjectApplyInfoID:self.pID fromAdminID:CurrAdminID withTimeStamp:currTimeStr withToken:md5Str success:^(NSDictionary *dict) {
            [_activityIndicatorView stopAnimating];
            NSString *msg = [dict objectForKey:@"Message"];
            if ([msg isEqualToString:@"删除数据成功！"]) {
                if (self.deleteblock) {
                    self.deleteblock();
                }
                [self.navigationController popViewControllerAnimated:YES];
                [[UIApplication sharedApplication].keyWindow makeToast:msg duration:2.0 position:@"bottom"];
                return;
            }
            [self.view makeToast:msg duration:2.0 position:@"center"];
        } failure:^(NSError * _Nonnull error) {
            [_activityIndicatorView stopAnimating];
        }];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
-(void)getDetailFromNet:(NSString *)pid
{
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [_scrollView addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    [HttpService GetProjectApplyInfoByID:pid success:^(NSDictionary *resp) {
        [_activityIndicatorView stopAnimating];
         NSArray *array = [resp objectForKey:@"AppendData"][@"rows"];
         NSDictionary *detailDict = array.firstObject;
         [self detailLayout:detailDict];
    } failure:^(NSError * _Nonnull error) {
        [_activityIndicatorView stopAnimating];
    }];
}
-(void) detailLayout:(NSDictionary *)dict{
    NSString *xuantiming = [dict objectForKey:@"ProjectName"];
    NSString *fubiaoti = [dict objectForKey:@"ProjectSubName"];
    BOOL IsTeam = [[dict objectForKey:@"IsTeam"] boolValue];
    NSString *qitashuoming = [dict objectForKey:@"DepartmentName"];
    NSString *cankaoziliao = [dict objectForKey:@"ReferenceMaterial"];
    NSString *shenbaotishi = [dict objectForKey:@"Tips"];
    self.pNameLabel.text = xuantiming;
    self.subtitleLabel.text = fubiaoti;
    self.detailTextView1.text = shenbaotishi;
    self.detailTextView2.text = cankaoziliao;
    self.detailTextView3.text = qitashuoming;
    if (!IsTeam) {
        _fubiaotiView.hidden= YES;
        _shenbaotishiTop.constant =  -35;
        [self.view layoutIfNeeded];
        [self.pGroupLabel setTitle:@"独立完成" forState:UIControlStateNormal];
    }else{
        [self.pGroupLabel setTitle:@"团队合作" forState:UIControlStateNormal];
    }
    int checkState = [[dict objectForKey:@"CheckState"] intValue];
    if (self.laoshi == YES) {
        if (checkState == 0) {
            self.lookwordBtn.hidden = NO;
            [self.lookwordBtn setTitle:@"审核" forState:UIControlStateNormal];
        }else if (checkState == 1)
        {
            self.lookwordBtn.hidden = NO;
            self.lookwordBtn.accessibilityLabel = [dict objectForKey:@"FileUrl"];
        }else{
            
        }
    }else{
        if (checkState == 1) {
            self.lookwordBtn.hidden = NO;
            self.lookwordBtn.accessibilityLabel = [dict objectForKey:@"FileUrl"];
        }
    }
}
- (IBAction)submit:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"审核"]) {
        GJShenheViewController *vc = getControllerFromStoryBoard(@"Worker", @"myshenheSbID");
        vc.pid = self.pID;
        vc.shenheType = shenheType_xuanti;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSString *url = [sender.accessibilityLabel fullImg];
        LDPublicWebViewController *web = [[LDPublicWebViewController alloc] init];
        web.webUrl = url;
        web.title = @"查看附件";
        [self.navigationController pushViewController:web animated:YES];
    }
}

-(void)dealloc
{
    NSLog(@"控制器释放");
}
@end
