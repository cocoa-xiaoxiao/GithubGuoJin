//
//  LWReadViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/2/23.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "LWReadViewController.h"
#import "UITextView+Placeholder.h"
#import "People.h"
#import "AizenMD5.h"
#import "Toast+UIView.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
@interface LWReadViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *scoreField;
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@end

@implementation LWReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_textView setPlaceholder:@"无需填写评阅" placeholdColor:[UIColor lightGrayColor]];
}

- (IBAction)submit:(id)sender {
    if (_scoreField.text.length < 1) {
        _scoreField.text = @"100.0";
    }
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [self.view addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    UInt64 currTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *currTimeStr = [NSString stringWithFormat:@"%ld",currTime];
    NSString *md5Str = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@GJProjectFinalization%@",self.lzId,currTimeStr]];
    [HttpService ProjectFinalizationScoreFromID:self.lzId andUpdater:CurrAdminID andScore:_scoreField.text andTimeStamp:currTimeStr andToken:md5Str success:^(id  _Nonnull responseObject) {
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
}

@end
