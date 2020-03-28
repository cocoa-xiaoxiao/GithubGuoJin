//
//  NewStationDetailViewController.m
//  GJKJAPP
//
//  Created by 肖啸 on 2020/3/25.
//  Copyright © 2020 谭耀焯. All rights reserved.
//

#import "NewStationDetailViewController.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "People.h"
#import "PhoneInfo.h"
#import "Toast+UIView.h"
#import "APPAlertView.h"
@interface NewStationDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (nonatomic, strong) NSArray *dataArr;
@property (weak, nonatomic) IBOutlet UILabel *view1CompanyName;
@property (weak, nonatomic) IBOutlet UILabel *view1CompanyCode;
@property (weak, nonatomic) IBOutlet UILabel *view1CompanyLoc;
@property (weak, nonatomic) IBOutlet UILabel *view1CompanyPeople;
@property (weak, nonatomic) IBOutlet UILabel *view1CompanyOnBase;
@property (weak, nonatomic) IBOutlet UILabel *view2StationName;
@property (weak, nonatomic) IBOutlet UILabel *view2StationPeople;
@property (weak, nonatomic) IBOutlet UILabel *view2StationInfo;
@property (weak, nonatomic) IBOutlet UILabel *view3OfferName;
@property (weak, nonatomic) IBOutlet UILabel *view3OfferMobile;
@property (weak, nonatomic) IBOutlet UILabel *view3OfferTel;
@property (weak, nonatomic) IBOutlet UILabel *view3OfferEmil;
@property (weak, nonatomic) IBOutlet UILabel *view4OwnMoy;
@property (weak, nonatomic) IBOutlet UILabel *view4OwnDate;
@property (weak, nonatomic) IBOutlet UILabel *view4OwnBase;
@property (weak, nonatomic) IBOutlet UILabel *view4OwnEat;
@property (weak, nonatomic) IBOutlet UILabel *view4OwnDeal;
@property (weak, nonatomic) IBOutlet UILabel *viewOwnIntrol;
@property (weak, nonatomic) IBOutlet UILabel *view5Major;
@property (weak, nonatomic) IBOutlet UILabel *view5danger;
@property (weak, nonatomic) IBOutlet UILabel *view5Sleep;
@property (weak, nonatomic) IBOutlet UILabel *view5Overtime;
@property (weak, nonatomic) IBOutlet UILabel *view5Train;
@property (weak, nonatomic) IBOutlet UILabel *view5Teach;
@property (weak, nonatomic) IBOutlet UILabel *view5System;
@property (weak, nonatomic) IBOutlet UILabel *view5From;
@property (weak, nonatomic) IBOutlet UILabel *view5Exceed;
@property (weak, nonatomic) IBOutlet UILabel *view5Exceed2;
@property (weak, nonatomic) IBOutlet UILabel *view5Intervene;
@property (weak, nonatomic) IBOutlet UILabel *view5Force;
@property (weak, nonatomic) IBOutlet UILabel *view5Safeguard;
@property (weak, nonatomic) IBOutlet UILabel *view5Safeguard2;
@property (weak, nonatomic) IBOutlet UILabel *view5Safeguard3;
@property (weak, nonatomic) IBOutlet UILabel *view5Safeguard4;
@property (weak, nonatomic) IBOutlet UILabel *view5Site;
@property (weak, nonatomic) IBOutlet UILabel *view5Agent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewBoomLayout;

@end

@implementation NewStationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"审核岗位";
    if ([self.role isEqualToString:@"student"]) {
        self.title = @"岗位详情";
    }
    [self addShadow];
    [self addActionBtnView];
    [self handleHttp];
}

-(void)addActionBtnView
{
    if (self.ischenck) {
        UIButton *opposeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [opposeBtn setTitle:@"不同意" forState:UIControlStateNormal];
        [opposeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [opposeBtn setBackgroundColor:[UIColor systemPinkColor]];
        [opposeBtn addTarget:self action:@selector(opposeStation) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:opposeBtn];
        [opposeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.left.equalTo(self.view);
            make.height.mas_offset(50);
        }];
        
        UIButton *tongyiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tongyiBtn setTitle:@"同意" forState:UIControlStateNormal];
        [tongyiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tongyiBtn setBackgroundColor:DEFAULT_APPTHEME_COLOR];
        [tongyiBtn addTarget:self action:@selector(tongyiStation) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:tongyiBtn];
        [tongyiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.right.equalTo(self.view);
            make.left.equalTo(opposeBtn.mas_right);
            make.width.equalTo(opposeBtn);
            make.height.mas_offset(50);
        }];
        
    }else{
        if (![self.role isEqualToString:@"student"]) {
            UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [cancelBtn setTitle:@"取消审核" forState:UIControlStateNormal];
            [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cancelBtn setBackgroundColor:DEFAULT_APPTHEME_COLOR];
            [cancelBtn addTarget:self action:@selector(cancelstation) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:cancelBtn];
            [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view);
                make.left.right.equalTo(self.view);
                make.height.mas_offset(50);
            }];
        }else{
            self.scrollviewBoomLayout.constant = 0;
        }
        
    }
}


-(void)opposeStation
{
    APPStationChenckAlertView *alert =[[APPStationChenckAlertView alloc]initWithStringArray:@[@"实习岗位专业不相关，请修改。",
                                                                                              @"信息不真实，请修改后重新提交。",@"该单位不符合实习要求，请修改实习调查信息或换单位。",@"企业地址不详细，请修改。",@"岗位信息不详细，请修改。",@"企业联系方式不详细，请修改。",@"请再填写信息时，认真完成实习调查。"] applyID:self.ID andIsOppose:YES isWeeklyCheck:NO successblock:^(id  _Nonnull responseObject) {
        
    }];
    [alert show];
}

-(void)tongyiStation
{
    APPStationChenckAlertView *alert =[[APPStationChenckAlertView alloc]initWithStringArray:@[@"恭喜你迈出了职业生涯的重要一步，盼再接再厉！",
    @"请多向身边的前辈请教，快速成长！",
    @"实习在外，请注意人身安全。如有异常，请及时联系我。",
    @"盼在工作中能够主动地学习，虚心求教，完成老师和领导安排的任务。",
                                                                                              @"在实习期间,请严格遵守各项规章制度，与单位同事和睦相处。"] applyID:self.ID andIsOppose:NO isWeeklyCheck:NO successblock:^(id  _Nonnull responseObject) {
        
    }];
    [alert show];
}
-(void)cancelstation
{
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您要取消之前的审核记录吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cancelMyStationAction];
    }];
    [alert addAction:cancel];
    [alert addAction:sure];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

-(void)cancelMyStationAction
{
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipApplyEnterpriseInfo/NoCheck",kCacheHttpRoot];
       NSString *CurrTimeStamp = [PhoneInfo getNowTimeTimestamp3];
       NSString *CurrToken = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@GJApply%@",self.ID,CurrTimeStamp]];
       NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
       NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
       People *getObj = existArr[0];
       NSString *CurrAdminID = [getObj.USERID stringValue];
    
       NSDictionary *param = @{@"ApplyID":self.ID,
                               @"Token":CurrToken,
                               @"TimeStamp":CurrTimeStamp,
                               @"AdminID":CurrAdminID,
       };
       [[HTTPOpration sharedHTTPOpration] NetRequestGETWithRequestURL:url WithParameter:param WithReturnValeuBlock:^(HTTPData *data) {
            [[UIApplication sharedApplication].keyWindow makeToast:data.msg duration:2.0 position:@"bottom"];
           [self.navigationController popViewControllerAnimated:YES];
       } WithFailureBlock:^(id error) {
           [BaseViewController br_showAlterMsg:@"发送失败"];
       }];
}

-(void)addShadow
{
    NSArray *array = @[self.view1,self.view2,self.view3,self.view4,self.view5];
    for (int i = 0; i < array.count; i++) {
        UIView *view = array[i];
        view.layer.shadowOpacity = 1;
        view.layer.shadowColor = RGB_HEX(0xbebebe, 1).CGColor;
        view.layer.shadowOffset = CGSizeMake(0, 3);
    }
}

-(void) handleHttp{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipApplyEnterpriseInfo/GetByID?ApplyID=%@",kCacheHttpRoot,self.ID];
    NSLog(@"%@",url);
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
            NSArray *array = [GJToolsHelp processDictionaryIsNSNull:[jsonDic objectForKey:@"AppendData"]];
            NSDictionary *first = [array firstObject];
            NSMutableArray *array_ = [NSMutableArray arrayWithCapacity:0];
            first = [GJToolsHelp processDictionaryIsNSNull:first];
            if (first) {
                [array_ addObject:first];
            }
            self.dataArr = array_;
        }
    } failue:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"请求失败--获取申请详情");
    }];
}


-(void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    UIColor *BaseColor = nil;
    NSString *BaseStr = @"";
       if([[[dataArr objectAtIndex:0] objectForKey:@"IsPracticeBase"] boolValue]){
           BaseStr = @"是";
           BaseColor = [UIColor colorWithRed:23/255.0 green:194/255.0 blue:149/255.0 alpha:1];
       }else{
           BaseStr = @"否";
           BaseColor = [UIColor redColor];
       }
    NSString *DateStr = [PhoneInfo handleDateStr:[[dataArr objectAtIndex:0] objectForKey:@"ComeWorkDate"] handleFormat:@"yyyy-MM-dd"];
    NSString *stayStr = @"";
       if([[[dataArr objectAtIndex:0] objectForKey:@"AccommodationType"] integerValue] == 0){
           stayStr = @"不提供";
       }else if([[[dataArr objectAtIndex:0] objectForKey:@"AccommodationType"] integerValue] == 1){
           stayStr = @"提供但自费";
       }else if([[[dataArr objectAtIndex:0] objectForKey:@"AccommodationType"] integerValue] == 2){
           stayStr = @"免费住宿";
       }else if([[[dataArr objectAtIndex:0] objectForKey:@"AccommodationType"] integerValue] == 3){
           stayStr = @"其他";
       }
    NSString *foodStr = @"";
    if([[[dataArr objectAtIndex:0] objectForKey:@"FoodType"] integerValue] == 0){
        foodStr = @"不提供";
    }else if([[[dataArr objectAtIndex:0] objectForKey:@"FoodType"] integerValue] == 1){
        foodStr = @"提供但自费";
    }else if([[[dataArr objectAtIndex:0] objectForKey:@"FoodType"] integerValue] == 2){
        foodStr = @"免费提供";
    }else if([[[dataArr objectAtIndex:0] objectForKey:@"FoodType"] integerValue] == 3){
        foodStr = @"其他";
    }
    NSString *RelevantTypeStr = @"";
    if([[[dataArr objectAtIndex:0] objectForKey:@"RelevantType"] boolValue]){
        RelevantTypeStr = @"是";
    }else{
        RelevantTypeStr = @"否";
    }
    NSString *IsWorkplaceStr = @"";
    if([[[dataArr objectAtIndex:0] objectForKey:@"IsWorkplace"] boolValue]){
        IsWorkplaceStr = @"是";
    }else{
        IsWorkplaceStr = @"否";
    }
    NSString *IsRestStr = @"";
    if([[[dataArr objectAtIndex:0] objectForKey:@"IsRest"] boolValue]){
        IsRestStr = @"是";
    }else{
        IsRestStr = @"否";
    }
    NSString *IsOvertimeStr = @"";
       if([[[dataArr objectAtIndex:0] objectForKey:@"IsOvertime"] boolValue]){
           IsOvertimeStr = @"是";
       }else{
           IsOvertimeStr = @"否";
       }
    NSString *IsPlanStr = @"";
    if([[[dataArr objectAtIndex:0] objectForKey:@"IsPlan"] boolValue]){
        IsPlanStr = @"是";
    }else{
        IsPlanStr = @"否";
    }
    NSString *IsEducationStr = @"";
    if([[[dataArr objectAtIndex:0] objectForKey:@"IsEducation"] boolValue]){
        IsEducationStr = @"是";
    }else{
        IsEducationStr = @"否";
    }
    NSString *IsGuaranteeStr = @"";
    if([[[dataArr objectAtIndex:0] objectForKey:@"IsGuarantee"] boolValue]){
        IsGuaranteeStr = @"是";
    }else{
        IsGuaranteeStr = @"否";
    }
    
    NSString *EnterpriseSourceStr = @"";
    if([[[dataArr objectAtIndex:0] objectForKey:@"EnterpriseSource"] integerValue] == 0){
        EnterpriseSourceStr = @"学校";
    }else if([[[dataArr objectAtIndex:0] objectForKey:@"EnterpriseSource"] integerValue] == 1){
        EnterpriseSourceStr = @"教师";
    }else if([[[dataArr objectAtIndex:0] objectForKey:@"EnterpriseSource"] integerValue] == 2){
        EnterpriseSourceStr = @"自己联系";
    }else if([[[dataArr objectAtIndex:0] objectForKey:@"EnterpriseSource"] integerValue] == 3){
        EnterpriseSourceStr = @"其他";
    }
    NSString *IsENumberStr = @"";
    if([[[dataArr objectAtIndex:0] objectForKey:@"IsENumber"] boolValue]){
        IsENumberStr = @"是";
    }else{
        IsENumberStr = @"否";
    }
    NSString *IsPNumberStr = @"";
    if([[[dataArr objectAtIndex:0] objectForKey:@"IsPNumber"] boolValue]){
        IsPNumberStr = @"是";
    }else{
        IsPNumberStr = @"否";
    }
    NSString *IsExInterventionStr = @"";
    if([[[dataArr objectAtIndex:0] objectForKey:@"IsExIntervention"] boolValue]){
        IsExInterventionStr = @"是";
    }else{
        IsExInterventionStr = @"否";
    }
    NSString *IsExForceStr = @"";
    if([[[dataArr objectAtIndex:0] objectForKey:@"IsExForce"] boolValue]){
        IsExForceStr = @"是";
    }else{
        IsExForceStr = @"否";
    }
    NSString *IsGradeOneStr = @"";
    if([[[dataArr objectAtIndex:0] objectForKey:@"IsGradeOne"] boolValue]){
        IsGradeOneStr = @"是";
    }else{
        IsGradeOneStr = @"否";
    }
    NSString *IsAdultStr = @"";
    if([[[dataArr objectAtIndex:0] objectForKey:@"IsAdult"] boolValue]){
        IsAdultStr = @"是";
    }else{
        IsAdultStr = @"否";
    }
    NSString *IsTabooStr = @"";
    if([[[dataArr objectAtIndex:0] objectForKey:@"IsTaboo"] boolValue]){
        IsTabooStr = @"是";
    }else{
        IsTabooStr = @"否";
    }
    NSString *IsWomenTabooStr = @"";
    if([[[dataArr objectAtIndex:0] objectForKey:@"IsWomenTaboo"] boolValue]){
        IsWomenTabooStr = @"是";
    }else{
        IsWomenTabooStr = @"否";
    }
    NSString *IsBarStr = @"";
    if([[[dataArr objectAtIndex:0] objectForKey:@"IsBar"] boolValue]){
        IsBarStr = @"是";
    }else{
        IsBarStr = @"否";
    }
    NSString *IsIntermediaryStr = @"";
    if([[[dataArr objectAtIndex:0] objectForKey:@"IsIntermediary"] boolValue]){
        IsIntermediaryStr = @"是";
    }else{
        IsIntermediaryStr = @"否";
    }
    self.view1CompanyName.text = [[dataArr objectAtIndex:0] objectForKey:@"EnterpriseName"];
    self.view1CompanyCode.text = [[dataArr objectAtIndex:0] objectForKey:@"CreditCode"];
    self.view1CompanyLoc.text = [[dataArr objectAtIndex:0] objectForKey:@"Address"];
    self.view1CompanyOnBase.text = BaseStr;
    self.view1CompanyOnBase.textColor = BaseColor;
    self.view1CompanyPeople.text = [[[dataArr objectAtIndex:0] objectForKey:@"StaffTotal"] stringValue];
    
    self.view2StationName.text = [[dataArr objectAtIndex:0] objectForKey:@"PositionName"];
    self.view2StationPeople.text = [[[dataArr objectAtIndex:0] objectForKey:@"PStaffTotal"] stringValue];
    self.view2StationInfo.text = [[dataArr objectAtIndex:0] objectForKey:@"PDescription"] == [NSNull null]?@"无":[[dataArr objectAtIndex:0] objectForKey:@"PDescription"];
    
    self.view3OfferName.text = [[dataArr objectAtIndex:0] objectForKey:@"LinkManName"];
    self.view3OfferMobile.text = [[dataArr objectAtIndex:0] objectForKey:@"LinkManMobile"];
    self.view3OfferTel.text = [[dataArr objectAtIndex:0] objectForKey:@"LinkManTel"] == [NSNull null]?@"无":[[dataArr objectAtIndex:0] objectForKey:@"LinkManTel"];
    self.view3OfferEmil.text = [[dataArr objectAtIndex:0] objectForKey:@"LinkManEmail"];
    
    self.view4OwnMoy.text = [[[dataArr objectAtIndex:0] objectForKey:@"MonthlySalary"] stringValue];
    self.view4OwnDate.text =  DateStr;
    self.view4OwnBase.text =  stayStr;
    self.view4OwnEat.text =  foodStr;
    self.view4OwnDeal.text = @"无";
    self.viewOwnIntrol.text=  [[dataArr objectAtIndex:0] objectForKey:@"Description"] == [NSNull null]?@"无":[[dataArr objectAtIndex:0] objectForKey:@"Description"];
    
    self.view5Major.text = RelevantTypeStr;
    self.view5danger.text =  IsWorkplaceStr;
    self.view5Sleep.text = IsRestStr;
    self.view5Overtime.text = IsOvertimeStr;
    self.view5Train.text = IsPlanStr;
    self.view5Teach.text =  IsEducationStr;
    self.view5System.text = IsGuaranteeStr;
    self.view5From.text =  EnterpriseSourceStr;
    self.view5Exceed.text = IsENumberStr;
    self.view5Exceed2.text = IsPNumberStr;
    self.view5Intervene.text = IsExInterventionStr;
    self.view5Force.text = IsExForceStr;
    self.view5Safeguard.text =  IsGradeOneStr;
    self.view5Safeguard2.text =  IsAdultStr;
    self.view5Safeguard3.text = IsTabooStr;
    self.view5Safeguard4.text =  IsWomenTabooStr;
    self.view5Site.text = IsBarStr;
    self.view5Agent.text =  IsIntermediaryStr;
}


@end
