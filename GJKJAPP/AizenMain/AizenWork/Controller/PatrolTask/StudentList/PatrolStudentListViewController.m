//
//  PatrolStudentListViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/6/6.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "PatrolStudentListViewController.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "DGActivityIndicatorView.h"
#import "PersonViewController.h"
#import "BRCompanyStudentListTableViewCell.h"
#import "BaseTablewView.h"
#import "BRStudentPatolListModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "XYDJViewController.h"
#import "ZXUser.h"

@interface PatrolStudentListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIScrollView *scrollView;
@property DGActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) BaseTablewView *tablew;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation PatrolStudentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"学生名单";
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tablew = [[BaseTablewView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tablew.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_NAVBAR - HEIGHT_STATUSBAR);
    [self.view addSubview:_tablew];
    _tablew.delegate = self;
    _tablew.dataSource = self;
    _tablew.rowHeight = 88.0;//[BRCompanyStudentListTableViewCell br];
    _tablew.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN , CGFLOAT_MIN)];     _tablew.tableFooterView = [UIView new];
    [self detailLayout];
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[UIColor lightGrayColor]];
    _activityIndicatorView.frame = CGRectMake((_contentView.frame.size.width - 100)/2, (_contentView.frame.size.height - 200)/2, 100, 100);
    _activityIndicatorView.layer.zPosition = 1000;
    [self.view addSubview:_activityIndicatorView];
   // [self startLayout];
}

-(void)setDataDic:(NSMutableDictionary *)dataDic{
    _dataDic = dataDic;
}
-(void) startLayout{
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_NAVBAR - HEIGHT_STATUSBAR);
    [self.view addSubview:_contentView];
    
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    [_contentView addSubview:_scrollView];
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[UIColor lightGrayColor]];
    _activityIndicatorView.frame = CGRectMake((_contentView.frame.size.width - 100)/2, (_contentView.frame.size.height - 200)/2, 100, 100);
    [_scrollView addSubview:_activityIndicatorView];
    
    
    [self detailLayout];
}



-(void) detailLayout{
    [_activityIndicatorView startAnimating];
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipInspectionTeamInfo/GetStudentByEnterpriseID?EnterpriseID=%@&ActivityID=%@&rows=1000&page=1",kCacheHttpRoot,[self.dataDic objectForKey:@"EnterpriseID"],[self.dataDic objectForKey:@"batchID"]];
    
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
            [self handleLayout:jsonDic];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[jsonDic objectForKey:@"Message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败--获取企业学生名单");
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return  88.0;
    }
    else{
        return 44;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        UITableViewCell *sendCell = [tableView dequeueReusableCellWithIdentifier:@"asdasdasdasdasd12314"];
        if (!sendCell) {
            sendCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"asdasdasdasdasd12314"];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIButton *sender = [UIButton buttonWithType:UIButtonTypeCustom];
            [sender setTitle:@"发消息" forState:UIControlStateNormal];
            [sendCell.contentView addSubview:sender];
            [sender mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.center.equalTo(sendCell.contentView);
                make.width.mas_equalTo(60);
                make.height.mas_equalTo(40);
            }];
            [sender setTitleColor:kAppMainColor forState:UIControlStateNormal];
            sender.userInteractionEnabled = NO;
        }
        
        return sendCell;
        
        
    }
    BRCompanyStudentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BRCompanyStudentListTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BRCompanyStudentListTableViewCell" owner:self options:nil] firstObject];
    }
    BRStudentPatolListModel *info = self.dataArray[indexPath.section];
    [cell.headerImg sd_setImageWithURL:[NSURL URLWithString:info.FactUrl.fullImg] placeholderImage:kUserDefualtImage ];
    cell.studentLabel.text = [NSString stringWithFormat:@"学生: %@",info.UserName];
    cell.studentTelLabel.text = info.Mobile;
    
    cell.teacheLabel.text = [NSString stringWithFormat:@"老师: %@",info.TeacherUserName];
    cell.teacherTelLabel.text = info.TeacherMobile;
    
    cell.roleLabel.text = info.PositionName;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        BRStudentPatolListModel *model = self.dataArray[indexPath.section];
        
        ZXUser *user = [[ZXUser alloc] init];
        user.userID = model.StudentID;
        user.username = model.UserName;
        user.avatarURL = [model.FactUrl fullImg];
        XYDJViewController *chat = [[XYDJViewController alloc] init];
        chat.user = user;
        //    chat.updateBlock = ^(id info) {
        //        if (info) {
        //            model.MessageContent = info;
        //            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        //        }
        //    };
        chat.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chat animated:YES];
    }
  
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(void) handleLayout:(NSDictionary *)sender{
    NSArray *getArr = [[sender objectForKey:@"AppendData"] objectForKey:@"rows"];
    [getArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BRStudentPatolListModel *info = [[BRStudentPatolListModel alloc] initWithDictionary:obj error:nil];
        [self.dataArray addObject:info];
    }];
    [self.tablew reloadData];
    
    return;
    CGFloat width = _scrollView.frame.size.width;
    CGFloat height = _scrollView.frame.size.height / 10;
    
    
    for(int i = 0;i < [getArr count];i++){
        PersonViewController *person = [[PersonViewController alloc]init_Value:i width:&width height:&height dataDic:[getArr objectAtIndex:i]];
        person.view.frame = CGRectMake(0, i * height, width, height);
//        UITapGestureRecognizer *personTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personAction:)];
//        personTap.accessibilityElements = [getArr objectAtIndex:i];
//        [person.view addGestureRecognizer:personTap];
        [_scrollView addSubview:person.view];
    }
    _scrollView.frame = CGRectMake(0, 0, _contentView.frame.size.width,getArr.count * height);

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
