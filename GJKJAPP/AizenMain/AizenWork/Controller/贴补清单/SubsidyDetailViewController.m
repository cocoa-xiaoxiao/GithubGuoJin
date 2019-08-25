//
//  SubsidyDetailViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/4/4.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "SubsidyDetailViewController.h"
#import "AizenHttp.h"
#import "People.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"

@interface SubsidyDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UILabel *xuncharenwuLb;
@property (weak, nonatomic) IBOutlet UILabel *cishuLb;
@property (weak, nonatomic) IBOutlet UILabel *danjiaLb;
@property (weak, nonatomic) IBOutlet UILabel *jineLb;
@property (weak, nonatomic) IBOutlet UILabel *pianquLb;
@property (weak, nonatomic) IBOutlet UILabel *xunchacishuLb;
@property (weak, nonatomic) IBOutlet UILabel *qiyeLb;
@property (weak, nonatomic) IBOutlet UILabel *baogaoLb;
@property (weak, nonatomic) IBOutlet UILabel *benyuebutieLb;
@property (weak, nonatomic) IBOutlet UILabel *yifafangLb;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subviewHeight;
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@end

@implementation SubsidyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"补贴详情";
    
    self.xuncharenwuLb.text = [NSString stringWithFormat:@"巡查任务  %@",self.timeDate];
    self.xunchacishuLb.text = [NSString stringWithFormat:@"巡查次数: %@",[self.sourceDict objectForKey:@"RecordCount"]];
    self.qiyeLb.text = [NSString stringWithFormat:@"企        业: %@",[self.sourceDict objectForKey:@"EnterpriseCount"]];
    self.baogaoLb.text = [NSString stringWithFormat:@"报        告: %@",[self.sourceDict objectForKey:@"StudentCount"]];
    self.benyuebutieLb.text = [NSString stringWithFormat:@"%@",[self.sourceDict objectForKey:@"TotalPrice"]];
    self.yifafangLb.text = [NSString stringWithFormat:@"%@",[self.sourceDict objectForKey:@"TotalPrice"]];
    [self startLayout];
}

-(void)startLayout
{
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [_scrollView addSubview:_activityIndicatorView];
    [self httpRequest];
}

-(void)httpRequest
{
    NSString *activity = [AizenStorage readUserDataWithKey:@"batchID"];
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipInspectionTeamInfo/GetTeacherRecordReportDetail?AdminID=%@&ActivityID=%@&Month=%@",kCacheHttpRoot,CurrAdminID,activity,self.timeDate];
    [_activityIndicatorView startAnimating];
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] intValue] == 0){
            NSArray *dataArr = [jsonDic objectForKey:@"AppendData"];
            [self handlePianQuList:dataArr];
        }
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败");
    }];
}

-(void)handlePianQuList:(NSArray *)dataArr{
    CGFloat height = self.view.xo_height * 0.08;
    int num = 0;
    for(int i = 0;i<[dataArr count];i++){
        NSDictionary *dict = dataArr[i];
        UIView *FieldView = [[UIView alloc]init];
        FieldView.frame = CGRectMake(0, _pianquLb.xo_bottomY + height * num, _subView.xo_width,height);
        [_subView addSubview:FieldView];
        
        UILabel *numLb = [[UILabel alloc]init];
        numLb.frame = CGRectMake(FieldView.frame.size.width * 0.03, height * 0.25, height*0.5, height * 0.5);
        numLb.text = [NSString stringWithFormat:@"%d",num+1];
        numLb.layer.cornerRadius = height*0.25;
        numLb.clipsToBounds = YES;
        numLb.textColor = [UIColor whiteColor];
        numLb.textAlignment = NSTextAlignmentCenter;
        numLb.backgroundColor = [UIColor blueColor];
        numLb.font = [UIFont systemFontOfSize:14.0];
        [FieldView addSubview:numLb];
        
        UILabel *FieldLab = [[UILabel alloc]init];
        FieldLab.frame = CGRectMake(self.pianquLb.xo_x, height * 0.1, FieldView.frame.size.width * 0.2, height * 0.8);
        FieldLab.text = [NSString stringWithFormat:@"%@：",[dict objectForKey:@"SubsidyTitle"] ];
        FieldLab.font = [UIFont systemFontOfSize:14.0];
        [FieldView addSubview:FieldLab];

        UILabel *cishu = [[UILabel alloc]init];
        cishu.frame = CGRectMake(self.cishuLb.xo_x,height * 0.1, self.cishuLb.xo_width, height * 0.8);
        cishu.textAlignment = NSTextAlignmentCenter;
        cishu.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Count"]];
        cishu.font = [UIFont systemFontOfSize:14.0];
        cishu.textColor = [UIColor blackColor];
        [FieldView addSubview:cishu];

        UILabel *danjia = [[UILabel alloc]init];
        danjia.frame = CGRectMake(self.danjiaLb.xo_x,height * 0.1, self.danjiaLb.xo_width, height * 0.8);
        danjia.textAlignment = NSTextAlignmentCenter;
        danjia.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"UnitPrice"]];
        danjia.font = [UIFont systemFontOfSize:14.0];
        danjia.textColor = [UIColor blackColor];
        [FieldView addSubview:danjia];
        
        UILabel *jine = [[UILabel alloc]init];
        jine.frame = CGRectMake(self.jineLb.xo_x,height * 0.1, self.jineLb.xo_width, height * 0.8);
        jine.textAlignment = NSTextAlignmentCenter;
        jine.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"TotalPrice"]];
        jine.font = [UIFont systemFontOfSize:14.0];
        jine.textColor = [UIColor blackColor];
        [FieldView addSubview:jine];
        
        UIView *Line = [[UIView alloc]init];
        Line.frame = CGRectMake(FieldView.frame.size.width * 0.03, FieldView.frame.size.height - 1, FieldView.frame.size.width * 0.97, 1);
        Line.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        [FieldView addSubview:Line];
        /*写布局------------------------------------end*/
        
        num++;
    }
    _subviewHeight.constant = _subView.xo_height + height *num;
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}
@end
