//
//  NewDetailWeeklyViewController.m
//  GJKJAPP
//
//  Created by 肖啸 on 2020/3/27.
//  Copyright © 2020 谭耀焯. All rights reserved.
//

#import "NewDetailWeeklyViewController.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "People.h"
#import "PhoneInfo.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "LDPublicWebViewController.h"
#import "APPAlertView.h"
@interface NewDetailWeeklyViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *wordBtn;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@property (weak, nonatomic) IBOutlet UIButton *approveBtn;
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@property (nonatomic, copy) NSString *TempUrl;
@end

@implementation NewDetailWeeklyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"周记详情";
    [self startLayout];
}

-(void)startLayout
{
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((_contentView.frame.size.width - 100)/2, (_contentView.frame.size.height - 200)/2, 100, 100);
    [_contentView addSubview:_activityIndicatorView];
    _activityIndicatorView.layer.zPosition = 1000;
    
    self.firstView.layer.shadowOpacity =1;
    self.firstView.layer.shadowColor = RGB_HEX(0xbebebe, 1).CGColor;
    self.firstView.layer.shadowOffset = CGSizeMake(0, 1);
    
    self.secondView.layer.shadowOpacity =1;
    self.secondView.layer.shadowColor = RGB_HEX(0xbebebe, 1).CGColor;
    self.secondView.layer.shadowOffset = CGSizeMake(0, 1);
    [self handleHttp];
    
}
-(void) handleHttp{
    [_activityIndicatorView startAnimating];
    
    NSString *weeklyID = _ID;
    NSString *activity = [AizenStorage readUserDataWithKey:@"batchID"];
    NSString *url = [NSString stringWithFormat:@"%@/ApiActivityWeekly/GetByID?WeeklyID=%@",kCacheHttpRoot,weeklyID];
    NSLog(@"%@",url);
    NSString *url2 = [NSString stringWithFormat:@"%@/ApiActivityWeekly/GetWeeklyConfig?ActivityID=%@",kCacheHttpRoot,activity];
    
    [AizenHttp asynRequest:url2 httpMethod:@"GET" params:nil success:^(id result) {
        
        NSDictionary *jsonDic = [result objectForKey:@"AppendData"];
         
        [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
               [_activityIndicatorView stopAnimating];

               if([[result objectForKey:@"ResultType"] integerValue] == 0){
                   NSDictionary *resultDict = [[result objectForKey:@"AppendData"] firstObject];
                   [self detailLayout:jsonDic resultDict:resultDict];
               }
               else{
                   [BaseViewController br_showAlterMsg:@"数据错误，请重试"];
               }
           } failue:^(NSError *error) {

           }];
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        [BaseViewController br_showAlterMsg:@"请求失败，请重试"];
    }];
}

-(void) detailLayout:(NSDictionary *)dataDict resultDict:(NSDictionary *)resultDict
{
    self.TempUrl =[NSString checkNull:[resultDict objectForKey:@"TempUrl"]];
    NSInteger state = [[resultDict objectForKey:@"CheckState"] integerValue];
    if ([self.role isEqualToString:@"teacher"]) {
        if (state == 0||state == 2) {
            self.wordBtn.hidden = YES;
        }else{
            self.refuseBtn.hidden = YES;
            self.approveBtn.hidden = YES;
            
        }
    }else{
        self.refuseBtn.hidden = YES;
        self.approveBtn.hidden = YES;
    }
    NSString *dateStr = [PhoneInfo handleDateStr:[resultDict objectForKey:@"CreateDate"] handleFormat:@"yyyy-MM-dd"];
    NSString *modif = [PhoneInfo handleDateStr:[resultDict objectForKey:@"UpdateDate"] handleFormat:@"yyyy-MM-dd"];
    NSString *begin = [PhoneInfo handleDateStr:[resultDict objectForKey:@"BeginDate"] handleFormat:@"yyyy-MM-dd"];
    NSString *end = [PhoneInfo handleDateStr:[resultDict objectForKey:@"EndDate"] handleFormat:@"yyyy-MM-dd"];
    self.uploaderLb.text = [NSString checkNull:[resultDict objectForKey:@"StudentName"]];
    self.uploadTimeLb.text = [NSString checkNull:dateStr];
    self.modifiTimeLb.text = [NSString checkNull:modif];
    self.startTimeLb.text = [NSString checkNull:begin];
    self.endTimeLb.text = [NSString checkNull:end];
    self.titleLb.text = [NSString checkNull:[resultDict objectForKey:@"WeeklyTitle"]];
    NSString *key1 = [NSString checkNull:[dataDict objectForKey:@"Field1"]];
    NSString *key2 = [NSString checkNull:[dataDict objectForKey:@"Field2"]];
    NSString *key3 = [NSString checkNull:[dataDict objectForKey:@"Field3"]];
    NSString *key4 = [NSString checkNull:[dataDict objectForKey:@"Field4"]];
    NSString *key5 = [NSString checkNull:[dataDict objectForKey:@"Field5"]];
    
    NSString *value1 = [NSString checkNull:[resultDict objectForKey:@"Field1"]];
    NSString *value2 = [NSString checkNull:[resultDict objectForKey:@"Field2"]];
    NSString *value3 = [NSString checkNull:[resultDict objectForKey:@"Field3"]];
    NSString *value4 = [NSString checkNull:[resultDict objectForKey:@"Field4"]];
    NSString *value5 = [NSString checkNull:[resultDict objectForKey:@"Field5"]];

    NSArray *keys = @[key1,key2,key3,key4,key5];
    NSArray *values = @[value1,value2,value3,value4,value5];
    
    UILabel *currentLb = nil;
    for (int i = 0 ; i < keys.count; i++) {
        if (![keys[i] isEqualToString:@""]) {
            UILabel *titleLb = [[UILabel alloc]init];
            titleLb.text = [NSString stringWithFormat:@"%@?",keys[i]];
            [self.secondView addSubview:titleLb];
            UILabel *detailLb = [[UILabel alloc]init];
            detailLb.text = values[i];
            detailLb.font = [UIFont systemFontOfSize:15];
            detailLb.textColor = [UIColor darkGrayColor];
            detailLb.numberOfLines = 0;
            [self.secondView addSubview:detailLb];
            
            if (i== 0) {
                [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.endTimeLayerV.mas_bottom).offset(20);
                    make.left.mas_offset(10);
                    make.right.mas_offset(-10);
                }];
                [detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(titleLb.mas_bottom).offset(10);
                    make.left.mas_offset(10);
                    make.right.mas_offset(-10);
                }];
            }else{
                [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(currentLb.mas_bottom).offset(20);
                    make.left.mas_offset(10);
                    make.right.mas_offset(-10);
                }];
                [detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(titleLb.mas_bottom).offset(10);
                    make.left.mas_offset(10);
                    make.right.mas_offset(-10);
                }];
            }
            currentLb = detailLb;
        }
    }
    
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(currentLb.mas_bottom).offset(20);
    }];
    
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)lookWord:(id)sender {
    NSString *url = [self.TempUrl fullImg];
    LDPublicWebViewController *web = [[LDPublicWebViewController alloc] init];
    web.webUrl = url;
    web.title = @"查看附件";
    [self.navigationController pushViewController:web animated:YES];
}
- (IBAction)refuse:(id)sender {
    APPStationChenckAlertView *alert =[[APPStationChenckAlertView alloc]initWithStringArray:@[
    @"周记内容不符合要求，请重新提交。",
    @"周记太简单了，请补充后提交。",
    ] applyID:self.ID andIsOppose:YES isWeeklyCheck:YES successblock:^(id  _Nonnull responseObject) {
        
    }];
    [alert show];
}
- (IBAction)approve:(id)sender {
    APPStationChenckAlertView *alert =[[APPStationChenckAlertView alloc]initWithStringArray:@[
    @"已收阅，再接再厉！",
    @"请多向身边的前辈请教，快速成长",
    @"实习在外，请注意人身安全。如有异常，请及时联系我。",
    @"请电话联系我详谈。",
                                                                                              @"看到你所取得的进步，我由衷地为你感到高兴。请继续努力！",@"希望你能积极工作，团结同事，学以致用。",@"希望你能在工作中努力提升理论水平及操作能力，早日成才。",@"实习期间，不怕苦，不怕累，将所学到的知识技能运用到实际工作当中。",@"看到你的进步，我深感欣慰！b盼继续努力工作，发挥优势，再创佳绩！"] applyID:self.ID andIsOppose:NO isWeeklyCheck:YES successblock:^(id  _Nonnull responseObject) {
        
    }];
    [alert show];
}

@end
