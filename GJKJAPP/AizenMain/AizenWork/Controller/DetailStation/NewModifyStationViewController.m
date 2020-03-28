//
//  NewModifyStationViewController.m
//  GJKJAPP
//
//  Created by 肖啸 on 2020/3/28.
//  Copyright © 2020 谭耀焯. All rights reserved.
//

#import "NewModifyStationViewController.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "People.h"
#import "PhoneInfo.h"
#import "Toast+UIView.h"
#import "PGDatePickManager.h"
#import "CZPickerView.h"
#import "RAlertView.h"
@interface NewModifyStationViewController ()<PGDatePickerDelegate,CZPickerViewDelegate,CZPickerViewDataSource,UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UITextField *view1CompanyNameF;
@property (weak, nonatomic) IBOutlet UITextField *view1CompanyCodeF;
@property (weak, nonatomic) IBOutlet UITextField *view1CompanyLocF;
@property (weak, nonatomic) IBOutlet UITextField *view1CompanyPeopleF;
@property (weak, nonatomic) IBOutlet UISwitch *view1CompanyOnBaseS;
@property (weak, nonatomic) IBOutlet UITextField *view2StationNameF;
@property (weak, nonatomic) IBOutlet UITextField *view2StationPeopleF;
@property (weak, nonatomic) IBOutlet UITextField *view2StationInfoF;
@property (weak, nonatomic) IBOutlet UITextField *view3OfferNameF;
@property (weak, nonatomic) IBOutlet UITextField *view3OfferMobileF;
@property (weak, nonatomic) IBOutlet UITextField *view3OfferTelF;
@property (weak, nonatomic) IBOutlet UITextField *view3OfferEmilF;
@property (weak, nonatomic) IBOutlet UITextField *view4OwnMoyF;
@property (weak, nonatomic) IBOutlet UIButton *view4OwnDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *view4OwnBaseBtn;
@property (weak, nonatomic) IBOutlet UIButton *view4OwnEatBtn;
@property (weak, nonatomic) IBOutlet UIButton *view4OwnDealBtn;
@property (weak, nonatomic) IBOutlet UITextField *viewOwnIntrolF;
@property (weak, nonatomic) IBOutlet UISwitch *view5Major;
@property (weak, nonatomic) IBOutlet UISwitch *view5danger;
@property (weak, nonatomic) IBOutlet UISwitch *view5Sleep;
@property (weak, nonatomic) IBOutlet UISwitch *view5Overtime;
@property (weak, nonatomic) IBOutlet UISwitch *view5Train;
@property (weak, nonatomic) IBOutlet UISwitch *view5Teach;
@property (weak, nonatomic) IBOutlet UISwitch *view5System;
@property (weak, nonatomic) IBOutlet UISwitch *view5From;
@property (weak, nonatomic) IBOutlet UISwitch *view5Exceed;
@property (weak, nonatomic) IBOutlet UISwitch *view5Exceed2;
@property (weak, nonatomic) IBOutlet UISwitch *view5Intervene;
@property (weak, nonatomic) IBOutlet UISwitch *view5Force;
@property (weak, nonatomic) IBOutlet UISwitch *view5Safeguard;
@property (weak, nonatomic) IBOutlet UISwitch *view5Safeguard2;
@property (weak, nonatomic) IBOutlet UISwitch *view5Safeguard3;
@property (weak, nonatomic) IBOutlet UISwitch *view5Safeguard4;
@property (weak, nonatomic) IBOutlet UISwitch *view5Site;
@property (weak, nonatomic) IBOutlet UISwitch *view5Agent;
@property (nonatomic, strong) NSArray *dataArr;
@property(nonatomic,strong) NSMutableArray *stayArr;
@property(nonatomic,strong) NSMutableArray *foodArr;
@property(nonatomic,strong) NSMutableArray *problemArr;
@property(nonatomic,strong) NSString *stayVal;
@property(nonatomic,strong) NSString *foodVal;
@property(nonatomic,strong) NSString *problemVal;
@property(nonatomic,strong) NSString *companyID;
@property(nonatomic,strong) NSString *stationID;
@property(nonatomic,strong) NSString *teacherID;
@end

@implementation NewModifyStationViewController

- (IBAction)modifyStation:(id)sender {
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipApplyEnterpriseInfo/Modify",kCacheHttpRoot];
    
    NSString *currTime = [PhoneInfo getNowTimeTimestamp3];
    NSString *token = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@GJApply%@",_ID,currTime]];
    if (_companyID == nil || [_companyID isEqualToString:@"0"]) {//"企业指导老师ID（可为空）"
        _companyID = @"";
    }
    if (_stationID == nil || [_stationID isEqualToString:@"0"]) {//"企业指导老师ID（可为空）"
        _stationID = @"";
    }
    if (_teacherID == nil || [_teacherID isEqualToString:@"0"]) {//"企业指导老师ID（可为空）"
        _teacherID = @"";
    }
    
    // _baseSwitch.on == YES ? @"true" :@"false",@"IsPracticeBase",
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:self.ID forKey:@"ID"];
    [params setObject:CurrAdminID forKey:@"Creater"];
    [params setObject:batchID forKey:@"ActivityID"];
    [params setObject:self.companyID forKey:@"EnterpriseID"];
    [params setObject:self.stationID forKey:@"PositionID"];
    [params setObject:self.view1CompanyNameF.text forKey:@"EnterpriseName"];
    [params setObject:self.view1CompanyCodeF.text forKey:@"CreditCode"];
    [params setObject:self.view1CompanyLocF.text forKey:@"Address"];
    [params setObject:self.view1CompanyPeopleF.text forKey:@"StaffTotal"];
    [params setObject:self.view1CompanyOnBaseS.isOn?@"true":@"false" forKey:@"IsPracticeBase"];
    [params setObject:self.view2StationNameF.text forKey:@"PositionName"];
    [params setObject:self.view2StationPeopleF.text forKey:@"PStaffTotal"];
    [params setObject:self.view2StationInfoF.text forKey:@"PDescription"];
    [params setObject:self.view3OfferNameF.text forKey:@"LinkManName"];
    [params setObject:self.view3OfferMobileF.text forKey:@"LinkManMobile"];
    [params setObject:self.view3OfferTelF.text forKey:@"LinkManTel"];
    [params setObject:self.view3OfferEmilF.text forKey:@"LinkManEmail"];
    [params setObject:self.view4OwnMoyF.text forKey:@"MonthlySalary"];
    [params setObject:self.view4OwnDateBtn.titleLabel.text forKey:@"ComeWorkDate"];
    [params setObject:_stayVal == nil?@"0":_stayVal forKey:@"AccommodationType"];
    [params setObject:_foodVal == nil?@"0":_foodVal forKey:@"FoodType"];
    [params setObject:self.viewOwnIntrolF.text forKey:@"Description"];
    [params setObject:_teacherID forKey:@"LinkManID"];
    [params setObject:self.view4OwnBaseBtn.titleLabel.text forKey:@"AgreementUrl"];


    //"中介代理限制：通过中介机构或有偿代理组织、安排和管理学生实习工作"
       [params setObject:self.view5Agent.on?@"true":@"false" forKey:@"IsIntermediary"];

       //me = "娱乐场所限制：到酒吧、夜总会、歌厅、洗浴中心等营业性娱乐场所实习")
       [params setObject:self.view5Site.on?@"true":@"false" forKey:@"IsBar"];

       //= "女职工保障：女学生从事《女职工劳动保护特别规定》中禁忌从事的劳动"
       [params setObject:self.view5Safeguard4.on?@"true":@"false" forKey:@"IsWomenTaboo"];

       //= "未成年工保障：未成年学生从事《未成年工特殊保护规定》中禁忌从事的劳动
       [params setObject:self.view5Safeguard3.on?@"true":@"false" forKey:@"IsTaboo"];

       //"学生年龄保障：未满16周岁的学生参加跟岗实习、顶岗实习")
       [params setObject:self.view5Safeguard2.on?@"true":@"false" forKey:@"IsAdult"];

       //"在校年级保障：一年级在校学生参加顶岗实习")
       [params setObject:self.view5Safeguard.on?@"true":@"false" forKey:@"IsGradeOne"];
       
       //"外部强制情况：存在强制职业学校安排学生到指定单位实习的情况
       [params setObject:self.view5Force.on?@"true":@"false" forKey:@"IsExForce"];

       //"外部干预情况：存在学校以外的单位干预实习安排的情况")
       [params setObject:self.view5Intervene.on?@"true":@"false" forKey:@"IsExIntervention"];

       //= "岗位员工数：具体岗位的实习生人数高于该岗位职工总人数的20%"
       [params setObject:self.view5Exceed2.on?@"true":@"false" forKey:@"IsPNumber"];

       //"单位员工数：实习生人数超过实习单位在岗职工总数的10%")
       [params setObject:self.view5Exceed.on?@"true":@"false" forKey:@"IsENumber"];
       //"实习岗位来源"
       [params setObject:self.view5From.on?@"true":@"false" forKey:@"EnterpriseSource"];
       
       //"预警机制")
       [params setObject:@(0) forKey:@"IsWarning"];

       //"制度保障")
       [params setObject:self.view5System.on?@"true":@"false" forKey:@"IsGuarantee"];

       //"实习教育"
       [params setObject:self.view5Teach.on?@"true":@"false" forKey:@"IsEducation"];

       //"实习计划"
       [params setObject:self.view5Train.on?@"true":@"false" forKey:@"IsPlan"];
       //"加班夜班：存在安排学生加班和上夜班的情况")
       [params setObject:self.view5Overtime.on?@"true":@"false" forKey:@"IsOvertime"];
       //"休息休假：存在安排学生在法定节假日实习的情况"
       [params setObject:self.view5Sleep.on?@"true":@"false" forKey:@"IsRest"];
       //e = "工作场所：从事高空、井下、放射性、有毒、易燃易爆，以及其他具有较高安全风险的实习"
       [params setObject:self.view5danger.on?@"true":@"false" forKey:@"IsWorkplace"];
       //"专业相关程度
       [params setObject:self.view5Major.on?@"true":@"false" forKey:@"RelevantType"];
    [params setObject:currTime forKey:@"TimeStamp"];
    [params setObject:token forKey:@"Token"];
    [MBProgressHUD showHUDAddedTo:self.scrollView animated:YES];
    [AizenHttp asynRequest:url httpMethod:@"GET" params:params success:^(id result) {
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] intValue] == 0){
                    RAlertView *alert = [[RAlertView alloc]initWithStyle:ConfirmAlert];
                    alert.headerTitleLabel.text = @"提示";
                    alert.contentTextLabel.text = [jsonDic objectForKey:@"Message"];
        //            alert.isClickBackgroundCloseWindow = YES;
                    alert.confirm = ^{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    };
                    
                }else{
                    RAlertView *alert = [[RAlertView alloc]initWithStyle:SimpleAlert];
                    alert.headerTitleLabel.text = @"提示";
                    alert.contentTextLabel.text = [jsonDic objectForKey:@"Message"];
                    alert.isClickBackgroundCloseWindow = YES;
                }
        [MBProgressHUD hideHUDForView:self.scrollView animated:YES];
    } failue:^(NSError *error) {
        NSLog(@"请求失败--修改岗位");
        [MBProgressHUD hideHUDForView:self.scrollView animated:YES];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"岗位详情";
    [self addShadow];
    [self handleHttp];
    _stayArr = [[NSMutableArray alloc]initWithObjects:@"不提供",@"提供但自费",@"免费住宿",@"其他", nil];
    _foodArr = [[NSMutableArray alloc]initWithObjects:@"不提供",@"提供但自费",@"免费提供",@"其他", nil];
    _problemArr = [[NSMutableArray alloc]initWithObjects:@"学校",@"教师",@"自己联系",@"其他", nil];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)huoshi:(id)sender {
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"请选额"
                                                   cancelButtonTitle:@"取消"
                                                  confirmButtonTitle:@"提交"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    picker.headerBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    picker.confirmButtonBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    picker.accessibilityValue = @"food";
    [picker show];
}
- (IBAction)zhusu:(id)sender {
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"请选额"
                                                   cancelButtonTitle:@"取消"
                                                  confirmButtonTitle:@"提交"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    picker.headerBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    picker.confirmButtonBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    picker.accessibilityValue = @"stay";
    [picker show];
}
- (IBAction)shanggangriqi:(id)sender {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGDatePickerType3;//PGPickerViewType3;
    datePicker.datePickerMode = PGDatePickerModeDate;
    [self presentViewController:datePickManager animated:false completion:nil];
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSString *dateStr = [NSString stringWithFormat:@"%d-%d-%d",dateComponents.year,dateComponents.month,dateComponents.day,dateComponents.hour,dateComponents.minute,dateComponents.second];
    [self.view4OwnDateBtn setTitle:dateStr forState:UIControlStateNormal];
}


#pragma mark - CZPickerViewDataSource
/* number of items for picker */
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    if([pickerView.accessibilityValue isEqualToString:@"stay"]){
        return [_stayArr count];
    }else if([pickerView.accessibilityValue isEqualToString:@"food"]){
        return [_foodArr count];
    }else{
        return [_problemArr count];
    }
    
}

/*
 Implement at least one of the following method,
 czpickerView:(CZPickerView *)pickerView
 attributedTitleForRow:(NSInteger)row has higer priority
 */

/* attributed picker item title for each row */
//- (NSAttributedString *)czpickerView:(CZPickerView *)pickerView
//               attributedTitleForRow:(NSInteger)row{
//    NSAttributedString *att = [[NSAttributedString alloc]
//                               initWithString:@"哈哈"
//                               attributes:@{
//                                            NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:18.0]
//                                            }];
//    return att;
//}

/* picker item title for each row */
- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row{
    if([pickerView.accessibilityValue isEqualToString:@"stay"]){
        return [_stayArr objectAtIndex:row];
    }else if([pickerView.accessibilityValue isEqualToString:@"food"]){
        return [_foodArr objectAtIndex:row];
    }else{
        return [_problemArr objectAtIndex:row];
    }
    
}




#pragma mark - CZPickerViewDelegate
/** delegate method for picking one item */
- (void)czpickerView:(CZPickerView *)pickerView
didConfirmWithItemAtRow:(NSInteger)row{
    if([pickerView.accessibilityValue isEqualToString:@"stay"]){
        NSString *stayStr = [_stayArr objectAtIndex:row];
        
        [_view4OwnBaseBtn setTitle:stayStr forState:UIControlStateNormal];
        
        if([stayStr isEqualToString:@"不提供"]){
            _stayVal = @"0";
        }else if([stayStr isEqualToString:@"提供但自费"]){
            _stayVal = @"1";
        }else if([stayStr isEqualToString:@"免费住宿"]){
            _stayVal = @"2";
        }else{
            _stayVal = @"3";
        }
    }else if([pickerView.accessibilityValue isEqualToString:@"food"]){
        NSString *foodStr = [_foodArr objectAtIndex:row];
        
        [_view4OwnEatBtn setTitle:foodStr forState:UIControlStateNormal];

        if([foodStr isEqualToString:@"不提供"]){
            _foodVal = @"0";
        }else if([foodStr isEqualToString:@"提供但自费"]){
            _foodVal = @"1";
        }else if([foodStr isEqualToString:@"免费提供"]){
            _foodVal = @"2";
        }else{
            _foodVal = @"3";
        }
    }else if([pickerView.accessibilityValue isEqualToString:@"problem"]){
        NSString *problemStr = [_problemArr objectAtIndex:row];
//
//        _group5Switch1.text = problemStr;
//        _group5Switch1.textColor = [UIColor blackColor];
        
        
        if([problemStr isEqualToString:@"学校"]){
            _problemVal = @"0";
        }else if([problemStr isEqualToString:@"教师"]){
            _problemVal = @"1";
        }else if([problemStr isEqualToString:@"自己联系"]){
            _problemVal = @"2";
        }else{
            _problemVal = @"3";
        }
    }
}

/** delegate method for picking multiple items,
 implement this method if allowMultipleSelection is YES,
 rows is an array of NSNumbers
 */
- (void)czpickerView:(CZPickerView *)pickerView
didConfirmWithItemsAtRows:(NSArray *)rows{
    
}
/** delegate method for canceling */
- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView{
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_scrollView endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    return YES;
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
    _ID = [[[dataArr objectAtIndex:0] objectForKey:@"ID"] stringValue];
    _companyID = [[[dataArr objectAtIndex:0]objectForKey:@"EnterpriseID"] stringValue];
    _stationID = [[[dataArr objectAtIndex:0]objectForKey:@"PositionID"] stringValue];

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
    self.view1CompanyNameF.text = [[dataArr objectAtIndex:0] objectForKey:@"EnterpriseName"];
    self.view1CompanyCodeF.text = [[dataArr objectAtIndex:0] objectForKey:@"CreditCode"];
    self.view1CompanyLocF.text = [[dataArr objectAtIndex:0] objectForKey:@"Address"];
    if ([BaseStr isEqualToString:@"是"]) {
        
    }
    [self.view1CompanyOnBaseS setOn:[BaseStr isEqualToString:@"是"]];
    self.view1CompanyPeopleF.text = [[[dataArr objectAtIndex:0] objectForKey:@"StaffTotal"] stringValue];
    
    self.view2StationNameF.text = [[dataArr objectAtIndex:0] objectForKey:@"PositionName"];
    self.view2StationPeopleF.text = [[[dataArr objectAtIndex:0] objectForKey:@"PStaffTotal"] stringValue];
    self.view2StationInfoF.text = [[dataArr objectAtIndex:0] objectForKey:@"PDescription"] == [NSNull null]?@"无":[[dataArr objectAtIndex:0] objectForKey:@"PDescription"];
    
    self.view3OfferNameF.text = [[dataArr objectAtIndex:0] objectForKey:@"LinkManName"];
    self.view3OfferMobileF.text = [[dataArr objectAtIndex:0] objectForKey:@"LinkManMobile"];
    self.view3OfferTelF.text = [[dataArr objectAtIndex:0] objectForKey:@"LinkManTel"] == [NSNull null]?@"无":[[dataArr objectAtIndex:0] objectForKey:@"LinkManTel"];
    self.view3OfferEmilF.text = [[dataArr objectAtIndex:0] objectForKey:@"LinkManEmail"];
    
    self.view4OwnMoyF.text = [[[dataArr objectAtIndex:0] objectForKey:@"MonthlySalary"] stringValue];
    [self.view4OwnDateBtn setTitle:DateStr forState:UIControlStateNormal];
    [self.view4OwnBaseBtn setTitle:stayStr forState:UIControlStateNormal];
    [self.view4OwnEatBtn setTitle:foodStr forState:UIControlStateNormal];
    [self.view4OwnDealBtn setTitle:@"" forState:UIControlStateNormal];
    self.viewOwnIntrolF.text=  [[dataArr objectAtIndex:0] objectForKey:@"Description"] == [NSNull null]?nil:[[dataArr objectAtIndex:0] objectForKey:@"Description"];

    [self.view5Major setOn:[RelevantTypeStr isEqualToString:@"是"]];
    [self.view5danger setOn:[IsWorkplaceStr isEqualToString:@"是"]];
    [self.view5Sleep setOn:[IsRestStr isEqualToString:@"是"]];
    [self.view5Overtime setOn:[IsOvertimeStr isEqualToString:@"是"]];
    [self.view5Train setOn:[IsPlanStr isEqualToString:@"是"]];
    [self.view5Teach setOn:[IsEducationStr isEqualToString:@"是"]];
    [self.view5System setOn:[IsGuaranteeStr isEqualToString:@"是"]];
    [self.view5From setOn:[EnterpriseSourceStr isEqualToString:@"是"]];
    [self.view5Exceed setOn:[IsENumberStr isEqualToString:@"是"]];
    [self.view5Exceed2 setOn:[IsPNumberStr isEqualToString:@"是"]];
    [self.view5Intervene setOn:[IsExInterventionStr isEqualToString:@"是"]];
    [self.view5Force setOn:[IsExForceStr isEqualToString:@"是"]];
    [self.view5Safeguard setOn:[IsGradeOneStr isEqualToString:@"是"]];
    [self.view5Safeguard2 setOn:[IsAdultStr isEqualToString:@"是"]];
    [self.view5Safeguard3 setOn:[IsTabooStr isEqualToString:@"是"]];
    [self.view5Safeguard4 setOn:[IsWomenTabooStr isEqualToString:@"是"]];
    [self.view5Site setOn:[IsBarStr isEqualToString:@"是"]];
    [self.view5Agent setOn:[IsIntermediaryStr isEqualToString:@"是"]];
}
@end
