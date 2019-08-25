//
//  BRMoifyUserInfoViewController.m
//  GJKJAPP
//
//  Created by git burning on 2018/9/12.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "BRMoifyUserInfoViewController.h"
#import <RDVTabBarController/RDVTabBarController.h>
#import "BRUserInfoModifyView.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "AizenStorage.h"
#import "People.h"
#import "PhoneInfo.h"
#import "AizenMD5.h"
#import "AFNetworking.h"
#import "HTTPOpration.h"

#import "ChooseSingImage.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "AizenHttp.h"
@interface BRMoifyUserInfoViewController ()
@property (nonatomic, strong) BRUserInfoModifyView *headerView;
@property (nonatomic, strong) UIImage *chooseImg;
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

@end

@implementation BRMoifyUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑资料";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];

    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    self.isApear = NO;
    
    
    BRUserInfoModifyView *view = [BRUserInfoModifyView br_getBRUserInfoModifyView];
    view.frame = CGRectMake(0, self.nav_offset, view.frame.size.width, view.frame.size.height);
    [self.view addSubview:view];
    
    
    UIButton *buttom = [UIButton buttonWithType:UIButtonTypeSystem];
    [buttom setTitle:@"提交" forState:UIControlStateNormal];
    [buttom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttom.backgroundColor = self.navigationController.navigationBar.barTintColor;
    [self.view addSubview:buttom];
    [buttom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kIphonexButtomHeight());
        make.height.mas_equalTo(40);
    }];
    [buttom addTarget:self action:@selector(br_selectedPost) forControlEvents:UIControlEventTouchUpInside];
    self.headerView = view;
    [view.headerBtn addTarget:self action:@selector(br_choosePhoto) forControlEvents:UIControlEventTouchUpInside];
   
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    if ([getObj.FactUrl isKindOfClass:[NSNull class]]) {
        getObj.FactUrl = @"";
    }
    NSString *header_url = getObj.FactUrl.fullImg;
   
    [view.headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:header_url] forState:UIControlStateNormal];
   
    view.telTextFeild.text = getObj.PHONE;
    view.emailTextFeild.text = getObj.EMAIL;
    view.cardTextFeild.text = getObj.USERNO;
    
    
    UIColor *loadingColor = [[MainViewController colorWithHexString:@"#0092ff"] copy];
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:loadingColor];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [self.view addSubview:_activityIndicatorView];
    // Do any additional setup after loading the view.
}

- (void)br_selectedPost{
    
    if (self.headerView.telTextFeild.text.length == 0) {
        [BRMoifyUserInfoViewController br_showAlterMsg:self.headerView.telTextFeild.placeholder];
        return;
    }
    if (self.headerView.emailTextFeild.text.length == 0) {
        [BRMoifyUserInfoViewController br_showAlterMsg:self.headerView.emailTextFeild.placeholder];
        return;
    }
    if (self.headerView.cardTextFeild.text.length == 0) {
        [BRMoifyUserInfoViewController br_showAlterMsg:self.headerView.cardTextFeild.placeholder];
        return;
    }
    
/*
 测试路径:http://www.hzp1123.com/ApiLogin/ModifyAdminInfo
 参数：[Display(Name = "当前用户ID")]int AdminID
 [Display(Name = "手机号码")]string Mobile
 [Display(Name = " Email")]string Email
 [Display(Name = "头像路径")] string FactUrl
 [Display(Name = "身份证号码")] string CardNo
 [Display(Name = "时间戳")] string TimeStamp
 [Display(Name = "握手密钥")] string Token
 
 Token加密方式：MD5(AdminID +"GJInfo"+ TimeStamp)，16位大写

 */
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *CurrTimeStamp = [PhoneInfo getNowTimeTimestamp3];
    NSString *CurrToken = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@GJInfo%@",CurrAdminID,CurrTimeStamp]];
    
    [_activityIndicatorView startAnimating];

    [BRMoifyUserInfoViewController br_uploadImage:self.chooseImg  block:^(BOOL success, NSString *msg) {
        if (success) {
            NSString *url = [NSString stringWithFormat:@"%@/ApiLogin/ModifyAdminInfo?AdminID=%@&Mobile=%@&TimeStamp=%@&Token=%@&Email=%@&CardNo=%@&FactUrl=%@",kCacheHttpRoot,CurrAdminID,self.headerView.telTextFeild.text,CurrTimeStamp,CurrToken,self.headerView.emailTextFeild.text,self.headerView.cardTextFeild.text,msg];
            NSString *urlencode = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
       
            [AizenHttp asynRequest:urlencode httpMethod:@"GET" params:nil success:^(id result) {
                [_activityIndicatorView stopAnimating];
                NSDictionary *jsonDic = result;
                if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
                    //[self handleOtherView:[jsonDic objectForKey:@"AppendData"]];
                    getObj.PHONE = self.headerView.telTextFeild.text;
                    getObj.EMAIL = self.headerView.emailTextFeild.text;
                    getObj.USERNO = self.headerView.cardTextFeild.text;
                    if (msg.length > 0) {
                        getObj.FactUrl = msg;
                    }
                    [getObj bg_saveOrUpdate];
                    [BRMoifyUserInfoViewController br_showAlterMsg:@"更新成功"];
                    if (self.updateBlock) {
                        self.updateBlock(nil);
                    }
//                    view.telTextFeild.text = getObj.PHONE;
//                    view.emailTextFeild.text = getObj.EMAIL;
//                    view.cardTextFeild.text = getObj.USERNO;
                }
            } failue:^(NSError *error) {
                [_activityIndicatorView stopAnimating];
                NSLog(@"请求失败--我负责的任务");
            }];
        }
    }];
    
   
    
    
    
    
}

- (void)br_choosePhoto {
    [[ChooseSingImage  shareChooseImage] showPhotoWithVC:self withBlock:^(UIImage *image, NSDictionary *dict) {

        self.chooseImg = image;
        [self.headerView.headerBtn setBackgroundImage:image forState:UIControlStateNormal];
        
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


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isApear) {
        self.isApear = NO;
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

    }

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isApear = YES;
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
