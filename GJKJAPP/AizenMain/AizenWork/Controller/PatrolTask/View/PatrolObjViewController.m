//
//  PatrolObjViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/14.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "PatrolObjViewController.h"
#import "PatrolModelViewController.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "DGActivityIndicatorView.h"
#import "AizenStorage.h"
#import "MainViewController.h"
#import "People.h"
#import "PersonModel.h"
#import "PatrolModelXViewController.h"
#import "PatrolStudentListViewController.h"
#import "PatrolTaskSubmitViewController.h"
#import "PatrolTaskLookListViewController.h"


@interface PatrolObjViewController ()

@property(nonatomic,strong) UIView *contentView;

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@property int handleStudentNum;
@property int handleReportNum;

@end

@implementation PatrolObjViewController

static PatrolObjViewController *setSelf;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(setSelf == nil){
        setSelf = self;
    }
    [self startLayout];
}


-(void) startLayout{
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44.0f - HEIGHT_STATUSBAR - HEIGHT_NAVBAR);
    _contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, _contentView.frame.size.height * 2);
    [_contentView addSubview:_scrollView];
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [_scrollView addSubview:_activityIndicatorView];
    
    
    [self handleHttp];
//    [self detailLayout];
}


-(void) handleHttp{
    [_activityIndicatorView startAnimating];
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipInspectionTeamInfo/GetMyEnterpriseList?AdminID=%@&ActivityID=%@&rows=1000&page=1",kCacheHttpRoot,CurrAdminID,batchID];
    
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        if (![result isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSDictionary *jsonDic = result;
        NSLog(@"%@",jsonDic);
        if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
            [self detailLayout:jsonDic getBatchID:batchID];
        }
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败--获取巡察对象");
    }];
}



-(void) detailLayout:(NSDictionary *)sender getBatchID:(NSString *)batchID{
    CGFloat width = _contentView.frame.size.width;
    CGFloat height = _contentView.frame.size.height / 4;
    
    int count = (int)[[sender objectForKey:@"AppendData"] objectForKey:@"total"];
    _handleStudentNum = 0;
    
    NSMutableArray *handleData = [[NSMutableArray alloc]init];
    NSDictionary *dataDic = [sender objectForKey:@"AppendData"];
    for(int x = 0;x < [[dataDic objectForKey:@"total"] integerValue];x++){
        NSMutableDictionary *companyDic = [NSMutableDictionary dictionaryWithDictionary:[[dataDic objectForKey:@"rows"] objectAtIndex:x]];
    
        [companyDic setObject:batchID forKey:@"batchID"];
        NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipInspectionTeamInfo/GetStudentByEnterpriseID?EnterpriseID=%@&ActivityID=%@&rows=1000&page=1",kCacheHttpRoot,[companyDic objectForKey:@"EnterpriseID"],batchID];
        [_activityIndicatorView startAnimating];
        [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
            [_activityIndicatorView stopAnimating];
            NSDictionary *jsonDic = result;
            if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
                [companyDic setObject:[[jsonDic objectForKey:@"AppendData"] objectForKey:@"total"] forKey:@"studentTotal"];
            }else{
                [companyDic setObject:@"暂无数据" forKey:@"studentTotal"];
            }
            [handleData addObject:companyDic];
            _handleStudentNum++;
            [self handleStudentData:_handleStudentNum getTotal:[[dataDic objectForKey:@"total"] integerValue] getDataArr:handleData getWidth:width getHeight:height];
        } failue:^(NSError *error) {
            [_activityIndicatorView stopAnimating];
            [companyDic setObject:@"暂无数据" forKey:@"studentTotal"];
            _handleStudentNum++;
            [self handleStudentData:_handleStudentNum getTotal:[[dataDic objectForKey:@"total"] integerValue] getDataArr:handleData getWidth:width getHeight:height];
            NSLog(@"请求失败--获取企业内的学生列表");
        }];
    }
    
}



-(void) handleStudentData:(int)currNum getTotal:(int)totalNum getDataArr:(NSMutableArray *)dataArr getWidth:(CGFloat)width getHeight:(CGFloat)height{
    if(currNum == totalNum){
        [self httpReport:dataArr getWidth:width getHeight:height];
    }
}


-(void) httpReport:(NSMutableArray *)dataArr getWidth:(CGFloat)width getHeight:(CGFloat)height{
    NSMutableArray *handleDataArr = [[NSMutableArray alloc]init];
    int totalNum = [dataArr count];
    _handleReportNum = 0;
    for(int x = 0;x<totalNum;x++){
        NSMutableDictionary *getDic = [dataArr objectAtIndex:x];
        NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipInspectionTeamInfo/GetInternshipInspectionTeamRecordList?EnterpriseID=%@&TeamInfoID=%@&ActivityID=%@&rows=1000&page=1",kCacheHttpRoot,[getDic objectForKey:@"EnterpriseID"],[getDic objectForKey:@"InspectionTeamID"],[getDic objectForKey:@"batchID"]];
        [_activityIndicatorView startAnimating];
        [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
            [_activityIndicatorView stopAnimating];
            NSDictionary *jsonDic = result;
            if([[jsonDic objectForKey:@"ResultType"]integerValue] == 0){
                [getDic setObject:[[jsonDic objectForKey:@"AppendData"] objectForKey:@"total"] forKey:@"reportTotal"];
            }else{
                [getDic setObject:@"暂无报告" forKey:@"reportTotal"];
            }
            _handleReportNum++;
            [handleDataArr addObject:getDic];
            [self handleReport:_handleReportNum getTotal:totalNum getData:handleDataArr getWidth:width getHeight:height];
        } failue:^(NSError *error) {
            [_activityIndicatorView stopAnimating];
            [getDic setObject:@"暂无报告" forKey:@"reportTotal"];
            _handleReportNum++;
            [handleDataArr addObject:getDic];
            [self handleReport:_handleReportNum getTotal:totalNum getData:handleDataArr getWidth:width getHeight:height];
            NSLog(@"请求失败---获取企业报告列表");
        }];
    }
}


-(void) handleReport:(int)currNum getTotal:(int)totalNum getData:(NSMutableArray *)dataArr getWidth:(CGFloat)width getHeight:(CGFloat)height{
    if(currNum == totalNum){
        for(int x = 0;x<currNum;x++){
            PatrolModelXViewController *model = [[PatrolModelXViewController alloc]init_Value:x width:&width height:&height dataDic:[dataArr objectAtIndex:x] statusType:@"obj"];
            model.lastVC = self;
            model.view.frame = CGRectMake(0, x * height, width, height);
            [_scrollView addSubview:model.view];
        }
        
        _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, height * [dataArr count]);
        
    }
}

+(void) recordAction:(UIButton *)sender{
    NSMutableDictionary *getDic = sender.accessibilityElements;
    NSLog(@"%@",getDic);
    PatrolTaskSubmitViewController *taskSubmit = [[PatrolTaskSubmitViewController alloc]init];
    taskSubmit.dataDic = getDic;
    [[BaseViewController getCurrentNav] pushViewController:taskSubmit animated:YES];
}

+(void) studentAction:(UIButton *)sender{
    
    
    NSMutableDictionary *getDic = sender.accessibilityElements;
    PatrolStudentListViewController *studentList = [[PatrolStudentListViewController alloc]init];
    studentList.dataDic = getDic;
    NSString *rott = [NSString stringWithFormat:@"%@",[BaseViewController getCurrentNav]];
    [[BaseViewController getCurrentNav] pushViewController:studentList animated:YES];
}


+(void) lookRecordAction:(UIButton *)sender{
    NSMutableDictionary *getDic = sender.accessibilityElements;
    PatrolTaskLookListViewController *lookRecord = [[PatrolTaskLookListViewController alloc]init];
    lookRecord.dataDic = getDic;
    [[BaseViewController getCurrentNav] pushViewController:lookRecord animated:YES];
}


int(^(testCount))() = ^(){
    return 10;
};




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
