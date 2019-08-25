//
//  MineQianMingViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/11/30.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MineQianMingViewController.h"
#import "UBSignatureDrawingViewController.h"
#import "People.h"
#import "PhoneInfo.h"
#import "AizenMD5.h"
#import "DGActivityIndicatorView.h"
#import "AizenHttp.h"
#import "BRMoifyUserInfoViewController.h"
@interface MineQianMingViewController ()<UBSignatureDrawingViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (nonatomic) UBSignatureDrawingViewController *signatureViewController;
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@end

@implementation MineQianMingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signatureViewController = [[UBSignatureDrawingViewController alloc] initWithImage:nil];
    self.signatureViewController.delegate = self;
    [self addChildViewController:self.signatureViewController];
    [self.view addSubview:self.self.signatureViewController.view];
    [self.signatureViewController didMoveToParentViewController:self];
    [self.view bringSubviewToFront:self.saveButton];
    [self.view bringSubviewToFront:self.clearButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - Private
- (IBAction)reset:(id)sender {
    [self.signatureViewController reset];
    
}
- (IBAction)save:(id)sender {
    UIImage* signatureImage=[self.signatureViewController fullSignatureImage];
    
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *CurrTimeStamp = [PhoneInfo getNowTimeTimestamp3];
    NSString *CurrToken = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@GJInfo%@",CurrAdminID,CurrTimeStamp]];
    NSString *email = getObj.EMAIL;
    NSString *cardNo = getObj.USERNO;
    NSString *tel = getObj.PHONE;
    NSString *faceurl = getObj.FactUrl;
    [_activityIndicatorView startAnimating];
    
    [MineQianMingViewController br_uploadImage:signatureImage  block:^(BOOL success, NSString *msg) {
        if (success) {
            NSString *url = [NSString stringWithFormat:@"%@/ApiLogin/ModifyAdminInfo?AdminID=%@&Mobile=%@&TimeStamp=%@&Token=%@&Email=%@&CardNo=%@&FactUrl=%@&SignUrl=%@",kCacheHttpRoot,CurrAdminID,tel,CurrTimeStamp,CurrToken,email,cardNo,faceurl,msg];
            NSString *urlencode = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [AizenHttp asynRequest:urlencode httpMethod:@"GET" params:nil success:^(id result) {
                [_activityIndicatorView stopAnimating];
                NSDictionary *jsonDic = result;
                if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
                    //[self handleOtherView:[jsonDic objectForKey:@"AppendData"]];
                    if (msg.length > 0) {
                        getObj.signUrl = msg;
                    }
                    [getObj bg_saveOrUpdate];
                    [BRMoifyUserInfoViewController br_showAlterMsg:@"更新成功"];
                    if (self.updateBlock) {
                        self.updateBlock(nil);
                    }
                }
            } failue:^(NSError *error) {
                [_activityIndicatorView stopAnimating];
                NSLog(@"请求失败--我负责的任务");
            }];
        }
    }];
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
    NSString *CurrToken = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@%@UpFile%@",CurrAdminID,CurrTimeStamp,@"Internship"]];
    NSString *url = [NSString stringWithFormat:@"ApiInternshipApplyEnterpriseInfo/UploadFile?AdminID=%@&ModuleName=%@&TimeStamp=%@&Token=%@",CurrAdminID,@"Internship",CurrTimeStamp,CurrToken];
    NSString *urlencode = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[HTTPOpration sharedHTTPOpration] NetRequestPOSTFileWithRequestURL:urlencode WithParameter:nil WithFiles:@{@"file":UIImageJPEGRepresentation(img, 0.5)} WithReturnValeuBlock:^(HTTPData *data) {
        if (data.code == 0) {
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
}
#pragma mark - <UBSignatureDrawingViewControllerDelegate>

- (void)signatureDrawingViewController:(UBSignatureDrawingViewController *)signatureDrawingViewController isEmptyDidChange:(BOOL)isEmpty
{
}
@end
