//
//  UnitFiveVC.m
//  GJKJAPP
//
//  Created by 肖啸 on 2019/12/17.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "UnitFiveVC.h"
#import "AizenMD5.h"
#import "AizenStorage.h"
#import "AizenHttp.h"
#import "PhoneInfo.h"
#import "People.h"
#import "RAlertView.h"

@interface UnitFiveVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UISwitch *sw1;
@property (weak, nonatomic) IBOutlet UISwitch *sw2;
@property (weak, nonatomic) IBOutlet UISwitch *sw3;
@property (weak, nonatomic) IBOutlet UISwitch *sw4;
@property (weak, nonatomic) IBOutlet UISwitch *sw5;
@property (weak, nonatomic) IBOutlet UISwitch *sw6;
@property (weak, nonatomic) IBOutlet UISwitch *sw7;
@property (weak, nonatomic) IBOutlet UISwitch *sw8;
@property (weak, nonatomic) IBOutlet UISwitch *sw9;
@property (weak, nonatomic) IBOutlet UISwitch *sw10;
@property (weak, nonatomic) IBOutlet UISwitch *sw11;
@property (weak, nonatomic) IBOutlet UISwitch *sw12;
@property (weak, nonatomic) IBOutlet UISwitch *sw13;
@property (weak, nonatomic) IBOutlet UISwitch *sw14;
@property (weak, nonatomic) IBOutlet UISwitch *sw15;
@property (weak, nonatomic) IBOutlet UISwitch *sw16;
@property (weak, nonatomic) IBOutlet UISwitch *sw17;
@property (weak, nonatomic) IBOutlet UISwitch *sw18;

@end

@implementation UnitFiveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"企业提交";
       
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
}

- (IBAction)submit:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    
    NSString *isQYFlag = @"";
    if(_uploadQYFlag){
        isQYFlag = @"true";
    }else{
        isQYFlag = @"false";
    }
    
    
    NSString *CurrTime = [PhoneInfo getNowTimeTimestamp3];
    
    NSString *setToken = [NSString stringWithFormat:@"%@GJApply%@",CurrAdminID,CurrTime];
    NSString *Token = [AizenMD5 MD5ForUpper16Bate:setToken];
    
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipApplyEnterpriseInfo/Apply",kCacheHttpRoot];
    
    NSMutableDictionary *params1 = [NSMutableDictionary dictionaryWithCapacity:0];
    [params1 setObject:isQYFlag forKey:@"IsPracticeBase"];
    [params1 setObject:CurrAdminID forKey:@"Creater"];
    [params1 setObject:batchID forKey:@"ActivityID"];
    
    [params1 setObject:Token forKey:@"Token"];

    [params1 setObject:CurrTime forKey:@"TimeStamp"];
    [params1 setObject:@"A" forKey:@"ApplyType"];//A-新增申请、U-转岗、D-辞职
    //"中介代理限制：通过中介机构或有偿代理组织、安排和管理学生实习工作"
    [params1 setObject:_sw18.on?@"true":@"false" forKey:@"IsIntermediary"];

    //me = "娱乐场所限制：到酒吧、夜总会、歌厅、洗浴中心等营业性娱乐场所实习")
    [params1 setObject:_sw17.on?@"true":@"false" forKey:@"IsBar"];

    //= "女职工保障：女学生从事《女职工劳动保护特别规定》中禁忌从事的劳动"
    [params1 setObject:_sw16.on?@"true":@"false" forKey:@"IsWomenTaboo"];

    //= "未成年工保障：未成年学生从事《未成年工特殊保护规定》中禁忌从事的劳动
    [params1 setObject:_sw15.on?@"true":@"false" forKey:@"IsTaboo"];

    //"学生年龄保障：未满16周岁的学生参加跟岗实习、顶岗实习")
    [params1 setObject:_sw14.on?@"true":@"false" forKey:@"IsAdult"];

    //"在校年级保障：一年级在校学生参加顶岗实习")
    [params1 setObject:_sw13.on?@"true":@"false" forKey:@"IsGradeOne"];
    
    //"外部强制情况：存在强制职业学校安排学生到指定单位实习的情况
    [params1 setObject:_sw12.on?@"true":@"false" forKey:@"IsExForce"];

    //"外部干预情况：存在学校以外的单位干预实习安排的情况")
    [params1 setObject:_sw11.on?@"true":@"false" forKey:@"IsExIntervention"];

    //= "岗位员工数：具体岗位的实习生人数高于该岗位职工总人数的20%"
    [params1 setObject:_sw10.on?@"true":@"false" forKey:@"IsPNumber"];

    //"单位员工数：实习生人数超过实习单位在岗职工总数的10%")
    [params1 setObject:_sw9.on?@"true":@"false" forKey:@"IsENumber"];
    //"实习岗位来源"
    [params1 setObject:_sw8.on?@"true":@"false" forKey:@"EnterpriseSource"];
    
    //"预警机制")
    [params1 setObject:@(0) forKey:@"IsWarning"];

    //"制度保障")
    [params1 setObject:_sw7.on?@"true":@"false" forKey:@"IsGuarantee"];

    //"实习教育"
    [params1 setObject:_sw6.on?@"true":@"false" forKey:@"IsEducation"];

    //"实习计划"
    [params1 setObject:_sw5.on?@"true":@"false" forKey:@"IsPlan"];
    //"加班夜班：存在安排学生加班和上夜班的情况")
    [params1 setObject:_sw4.on?@"true":@"false" forKey:@"IsOvertime"];
    //"休息休假：存在安排学生在法定节假日实习的情况"
    [params1 setObject:_sw3.on?@"true":@"false" forKey:@"IsRest"];
    //e = "工作场所：从事高空、井下、放射性、有毒、易燃易爆，以及其他具有较高安全风险的实习"
    [params1 setObject:_sw2.on?@"true":@"false" forKey:@"IsWorkplace"];
    //"专业相关程度
    [params1 setObject:_sw1.on?@"true":@"false" forKey:@"RelevantType"];
    
    if (_uploadAgreement == nil) {//"实习协议"
        _uploadAgreement = @"";
    }
    [params1 setObject:_uploadAgreement forKey:@"AgreementUrl"];

    if (_uploadJSID == nil || [_uploadJSID isEqualToString:@"0"]) {//"企业指导老师ID（可为空）"
        _uploadJSID = @"";
    }
    [params1 setObject:_uploadJSID forKey:@"LinkManID"]; //这里判断一下是否为0

    
    if (_uploadDescr == nil) {//"说明"
        _uploadDescr = @"";
    }
    [params1 setObject:_uploadDescr forKey:@"Description"];

    if (_uploadFood == nil) {//"伙食条件"
        _uploadFood = @"";
    }
    [params1 setObject:_uploadFood forKey:@"FoodType"];

    if (_uploadStay == nil) {//"住宿条件"
        _uploadStay = @"";
    }
    [params1 setObject:_uploadStay forKey:@"AccommodationType"];

    if (_uploadDate == nil) {//"上岗日期
        _uploadDate = @"";
    }
    [params1 setObject:_uploadDate forKey:@"ComeWorkDate"];

    if (_uploadSaraly == nil) {//月收入
        _uploadSaraly = @"";
    }
    [params1 setObject:_uploadSaraly forKey:@"MonthlySalary"];

    
    if (_uploadID == nil || [_uploadID isEqualToString:@"0"]) { //"所属企业ID（可为空）
        _uploadID = @"";
    }
    [params1 setObject:_uploadID forKey:@"EnterpriseID"]; //这里判断一下是否为0

    if (_uploadStationID == nil|| [_uploadStationID isEqualToString:@"0"]) {//所属岗位ID（可为空
        _uploadStationID = @"";
    }
    [params1 setObject:_uploadStationID forKey:@"PositionID"]; //这里判断一下是否为0

    if (_uploadQYName == nil) {
        //"企业名称
        _uploadQYName = @"";
    }
    [params1 setObject:_uploadQYName forKey:@"EnterpriseName"];

    if (_uploadQYCode == nil) {//企业代码"
        _uploadQYCode = @"";
    }
    [params1 setObject:_uploadQYCode forKey:@"CreditCode"];

    
    if (_uploadQYAddress == nil) {//企业地址
        _uploadQYAddress = @"";
    }
    [params1 setObject:_uploadQYAddress forKey:@"Address"];

    if (_uploadQYTotal == nil) {//StaffTotal
        _uploadQYTotal = @"";
    }
    [params1 setObject:_uploadQYTotal forKey:@"StaffTotal"];

//    if (_uploadQYCode) {//企业代码"
//        [params1 setObject:_uploadQYCode forKey:@"CreditCode"];
//    }
    //是否实习基地"
    [params1 setObject:@(_uploadQYFlag) forKey:@"IsPracticeBase"];
    
    
    if (_uploadStationName == nil) {//岗位名称"
        _uploadStationName = @"";
    }
    [params1 setObject:_uploadStationName forKey:@"PositionName"];

    if (_uploadStationTotal == nil) {//"在岗员工数"
        _uploadStationTotal = @"";
    }
    
    [params1 setObject:_uploadStationTotal forKey:@"PStaffTotal"];

    if (_uploadStationIntro == nil) {//"岗位说明")
        _uploadStationIntro = @"";
    }
    [params1 setObject:_uploadStationIntro forKey:@"PDescription"];

    if (_uploadJSName == nil) {//"企业指导老师"
        _uploadJSName = @"";
    }
    [params1 setObject:_uploadJSName forKey:@"LinkManName"];

    if (_uploadJSPhone == nil) {//"老师手机"
        _uploadJSPhone = @"";
    }
    [params1 setObject:_uploadJSPhone forKey:@"LinkManMobile"];

    if (_uploadJSTel == nil) {//"老师电话"
        _uploadJSTel = @"";
    }
    [params1 setObject:_uploadJSTel forKey:@"LinkManTel"];

    if (_uploadJSEmail == nil) {//"企业邮箱"
        _uploadJSEmail = @"";
    }
    [params1 setObject:_uploadJSEmail forKey:@"LinkManEmail"];

    
    
    
    
    NSString* encodeUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [AizenHttp asynRequest:url httpMethod:@"GET" params:params1 success:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    } failue:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"请求失败--提交岗位申请");
    }];
    
    
}

@end
