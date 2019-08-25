//
//  GJUserInfoViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/1/17.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "GJUserInfoViewController.h"
#import "ChooseSingImage.h"
#import "BRMoifyUserInfoViewController.h"
#import "People.h"
#import "PhoneInfo.h"
#import "AizenMD5.h"
#import "DGActivityIndicatorView.h"
#import "AizenHttp.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "MineQianMingViewController.h"
@interface GJUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UITextField *xingming;
@property (weak, nonatomic) IBOutlet UITextField *tel;
@property (weak, nonatomic) IBOutlet UITextField *bumen;
@property (nonatomic, strong) UIImage *chooseImg;
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@end

@implementation GJUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"基本信息";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *header_url = getObj.FactUrl.fullImg;
    [self.headImgView br_SDWebSetImageWithURLString:header_url placeholderImage:nil];
    self.xingming.text = getObj.USERNAME;
    self.tel.text = getObj.PHONE;
    NSString *sign_url = getObj.signUrl.fullImg;
    [self.signButton sd_setBackgroundImageWithURL:[NSURL URLWithString:sign_url] forState:UIControlStateNormal];
    if (getObj.CLASSNAME==nil) {
        self.bumen.text = getObj.COLLEGENAME;
    }else{
        self.bumen.text = getObj.CLASSNAME;
    }
}
- (IBAction)choosePhoto:(id)sender {
    [[ChooseSingImage  shareChooseImage] showPhotoWithVC:self withBlock:^(UIImage *image, NSDictionary *dict) {
        self.chooseImg = image;
        [self.headImgView setImage:image];
    }];
}
- (IBAction)tijiao:(id)sender {
        if (self.tel.text.length == 0) {
            [BRMoifyUserInfoViewController br_showAlterMsg:self.tel.placeholder];
            return;
        }
        NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
        NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
        People *getObj = existArr[0];
        NSString *CurrAdminID = [getObj.USERID stringValue];
        NSString *CurrTimeStamp = [PhoneInfo getNowTimeTimestamp3];
        NSString *CurrToken = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@GJInfo%@",CurrAdminID,CurrTimeStamp]];
        NSString *email = getObj.EMAIL;
        NSString *cardNo = getObj.USERNO;
        [_activityIndicatorView startAnimating];
        
        [GJUserInfoViewController br_uploadImage:self.chooseImg  block:^(BOOL success, NSString *msg) {
            if (success) {
                NSString *url = [NSString stringWithFormat:@"%@/ApiLogin/ModifyAdminInfo?AdminID=%@&Mobile=%@&TimeStamp=%@&Token=%@&Email=%@&CardNo=%@&FactUrl=%@",kCacheHttpRoot,CurrAdminID,self.tel.text,CurrTimeStamp,CurrToken,email,cardNo,msg];
                NSString *urlencode = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                [AizenHttp asynRequest:urlencode httpMethod:@"GET" params:nil success:^(id result) {
                    [_activityIndicatorView stopAnimating];
                    NSDictionary *jsonDic = result;
                    if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
                        //[self handleOtherView:[jsonDic objectForKey:@"AppendData"]];
                        getObj.PHONE = self.tel.text;
                        if (msg.length > 0) {
                            getObj.FactUrl = msg;
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MineQianMingViewController *vc = segue.destinationViewController;
    vc.updateBlock = ^(id info) {
        NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
        NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
        People *getObj = existArr[0];
        NSString *sign_url = getObj.signUrl.fullImg;
        [self.signButton sd_setBackgroundImageWithURL:[NSURL URLWithString:sign_url] forState:UIControlStateNormal];
    };
}

- (IBAction)sign:(id)sender {
    
}
@end
