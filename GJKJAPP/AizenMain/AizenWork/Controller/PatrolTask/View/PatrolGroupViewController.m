//
//  PatrolGroupViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/14.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "PatrolGroupViewController.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "People.h"
#import "PhoneInfo.h"
#import "PatrolTableViewCell.h"

@interface PatrolGroupViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) BaseTablewView *tableView;
@property int groupNum;
@property int peopleNum;
@property int companyNum;
@property(nonatomic,strong) NSMutableDictionary *dataDic;



@end

@implementation PatrolGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self startLayout];
}


-(void) startLayout{
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - (HEIGHT_STATUSBAR + HEIGHT_NAVBAR + 44.0f));
    _contentView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_contentView];
    
    
    _tableView = [[BaseTablewView alloc]init];
    _tableView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewStyleGrouped;
    _tableView.rowHeight = 28.0f;
    _tableView.sectionHeaderHeight = 28.0f;
    _tableView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [_contentView addSubview:_tableView];
    
    [self httpData];
}


-(void) httpData{
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    
    _dataDic = [[NSMutableDictionary alloc]init];
    _groupNum = 0;
    _peopleNum = 0;
    _companyNum = 0;
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipInspectionTeamInfo/GetMyTeamInfoList?AdminID=%@&ActivityID=%@&rows=1000&page=1",kCacheHttpRoot,CurrAdminID,batchID];
    
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
            NSDictionary *getDic = [jsonDic objectForKey:@"AppendData"];
            
            int totalNum = [[getDic objectForKey:@"rows"] count];
            
            for(int i = 0;i<[[getDic objectForKey:@"rows"] count];i++){
                NSDictionary *detailDic = [[getDic objectForKey:@"rows"]objectAtIndex:i];
                
                NSString *keyStr = [[[getDic objectForKey:@"rows"] objectAtIndex:i] objectForKey:@"InspectionTeamName"];
                
                NSString *urlForPeople = [NSString stringWithFormat:@"%@/ApiInternshipInspectionTeamInfo/GetTeacherList?TeamInfoID=%@&rows=1000&page=1",kCacheHttpRoot,[detailDic objectForKey:@"InspectionTeamID"]];
                
                NSString *urlForCompany = [NSString stringWithFormat:@"%@/ApiInternshipInspectionTeamInfo/GetEnterpriseList?TeamInfoID=%@&rows=1000&page=1",kCacheHttpRoot,[detailDic objectForKey:@"InspectionTeamID"]];
                
                NSLog(@"%@",urlForPeople);
                NSLog(@"%@",urlForCompany);
                [AizenHttp asynRequest:urlForPeople httpMethod:@"GET" params:nil success:^(id result) {
                    NSDictionary *jsonForPeopleDic = result;
                    if([[jsonForPeopleDic objectForKey:@"ResultType"] integerValue] == 0){
                        NSMutableArray *newHandleArr = [[NSMutableArray alloc]init];
                        NSArray *getArr = [[jsonForPeopleDic objectForKey:@"AppendData"] objectForKey:@"rows"];
                        
                        for(int i = 0;i<[getArr count];i++){
                            NSMutableDictionary *newHandleDic = [[NSMutableDictionary alloc]init];
                            
                            NSDictionary *subDic = [getArr objectAtIndex:i];
                            NSArray *subDicKeys = subDic.allKeys;
                            for(int x = 0;x<subDicKeys.count;x++){
                                newHandleDic[subDicKeys[x]] = subDic[subDicKeys[x]];
                            }
                            newHandleDic[@"type"] = @"people";
                            
                            [newHandleArr addObject:newHandleDic];
                        }

                        [self handleDataDic:keyStr getDataArr:newHandleArr getCurrNum:_groupNum getTotalNum:totalNum];
                        
                    }
                    
                    [AizenHttp asynRequest:urlForCompany httpMethod:@"GET" params:nil success:^(id result) {
                        NSDictionary *jsonForCompanyDic = result;
                        if([[jsonForCompanyDic objectForKey:@"ResultType"] integerValue] == 0){
                            NSMutableArray *newHandleArr = [[NSMutableArray alloc]init];
                            NSArray *getArr = [[jsonForCompanyDic objectForKey:@"AppendData"]objectForKey:@"rows"];
                            
                            for(int i = 0;i<[getArr count];i++){
                                NSMutableDictionary *newHandleDic = [[NSMutableDictionary alloc]init];
                                
                                NSDictionary *subDic = [getArr objectAtIndex:i];
                                NSArray *subDicKeys = subDic.allKeys;
                                for(int x = 0;x<subDicKeys.count;x++){
                                    newHandleDic[subDicKeys[x]] = subDic[subDicKeys[x]];
                                }
                                newHandleDic[@"type"] = @"company";
                                
                                [newHandleArr addObject:newHandleDic];
                            }
                            _groupNum++;
                            [self handleDataDic:keyStr getDataArr:newHandleArr getCurrNum:_groupNum getTotalNum:totalNum];
                            
                        }
                        
                    } failue:^(NSError *error) {
                        NSLog(@"请求失败--获取小组巡察企业列表");
                    }];
                } failue:^(NSError *error) {
                    NSLog(@"请求失败--获取小组巡察成员列表");
                }];
                
                
                
                
                
                
            }
        }
    } failue:^(NSError *error) {
        NSLog(@"请求失败--获取我的小组");
    }];
}


-(void) handleDataDic:(NSString *)key getDataArr:(NSMutableArray *)dataArr getCurrNum:(int)currNum getTotalNum:(int)totalNum{
    int dicNum = (int)[_dataDic[key] count];
    if(_dataDic[key]){
        for(int i = 0;i<[dataArr count];i++){
            _dataDic[key][dicNum + i] = [dataArr objectAtIndex:i];
        }
    }else{
        _dataDic[key] = dataArr;
    }
    
    if(currNum == totalNum){
        /*进行数组布局*/
        [_tableView reloadData];
    }
}


#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataDic count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int num = 0;
    NSArray *getArr = _dataDic[_dataDic.allKeys[section]];
    num = (int)[getArr count];
    return num;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    PatrolTableViewCell *patrolCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!patrolCell){
        patrolCell = [[PatrolTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    patrolCell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *getAllkeys = _dataDic.allKeys;
    NSArray *getArr = [_dataDic objectForKey:[getAllkeys objectAtIndex:indexPath.section]];
    patrolCell.detailDic = [getArr objectAtIndex:indexPath.row];
    return patrolCell;
}

#pragma mark 返回每组的头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // 宽度为屏幕宽度, 高度是代理方法返回的高度.
    UIView *headView = [[UIView alloc]init];
    headView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 28.0f);
    headView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *headImg = [[UIImageView alloc]init];
    headImg.frame = CGRectMake(headView.frame.size.width * 0.03, (headView.frame.size.height - 24)/2.0, 24, 24);
    headImg.image = [UIImage imageNamed:@"xuncha_1"];
    [headView addSubview:headImg];
    
    UILabel *headTitle = [[UILabel alloc]init];
    headTitle.frame = CGRectMake(headImg.frame.origin.x + headImg.frame.size.width + 5, headView.frame.size.height * 0.1, headView.frame.size.width * 0.7, headView.frame.size.height * 0.8);
    headTitle.text = _dataDic.allKeys[section];
    headTitle.font = [UIFont systemFontOfSize:14.0];
    [headView addSubview:headTitle];
    
    
    return headView;
}

#pragma mark 返回组头的高度 : 第一组的头部一定要通过代理设置
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 28.0f;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
