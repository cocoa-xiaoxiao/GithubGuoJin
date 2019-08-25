//
//  MyStudentsViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/3/20.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MyStudentsViewController.h"
#import "RDVTabBarController.h"
#import "XHJAddressBook.h"
#import "PersonModel.h"
#import "PersonCell.h"
#import "AizenMD5.h"
#import "AizenStorage.h"
#import "AizenHttp.h"
#import "People.h"
#import "HandlePersonList.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "StudentDetailViewController.h"
#import "XOMyStuDSViewController.h"
#import "XOStuYSViewController.h"
#import "ZLNavTabBarController.h"
@interface MyStudentsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *listContent;
@property (strong, nonatomic) NSMutableArray *sectionTitles;

@property (strong, nonatomic) PersonModel *people;

@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

@end

#define  mainWidth [UIScreen mainScreen].bounds.size.width
#define  mainHeigth  [UIScreen mainScreen].bounds.size.height


@implementation MyStudentsViewController{
    BaseTablewView *_tableShow;
    XHJAddressBook *_addBook;
}
-(void) detailLayout{
    
    XOMyStuDSViewController *obj = [[XOMyStuDSViewController alloc]init];
    
    obj.title = @"已通过";
    
    XOStuYSViewController *group = [[XOStuYSViewController alloc]init];
    group.title = @"待审核";
    
    ZLNavTabBarController *navTabBarController = [[ZLNavTabBarController alloc] init];
    navTabBarController.subViewControllers = @[obj, group];
    navTabBarController.navTabBarColor = [UIColor whiteColor];
    navTabBarController.mainViewBounces = YES;
    navTabBarController.selectedToIndex = 2;
    navTabBarController.unchangedToIndex = 1;
    navTabBarController.showArrayButton = NO;
    [navTabBarController addParentController:self];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
};

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self rdv_tabBarController]setTabBarHidden:YES animated:YES];
    self.title=@"我的学生";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    
//    _sectionTitles=[NSMutableArray new];
//    _tableShow=[[BaseTablewView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, mainHeigth)];
//    _tableShow.delegate=self;
//    _tableShow.dataSource=self;
//    [self.view addSubview:_tableShow];
    
//    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
//    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
//    [_tableShow addSubview:_activityIndicatorView];
//    [_activityIndicatorView startAnimating];
    
    
//    _tableShow.sectionIndexBackgroundColor=[UIColor clearColor];
//    _tableShow.sectionIndexColor = [UIColor blackColor];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self initData];
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            [self setTitleList];
//            [_tableShow reloadData];
//        });
//    });
    
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction:)];
    [backBtnItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.hidesBackButton = YES;

    self.navigationItem.leftBarButtonItem = backBtnItem ;
    
    [self detailLayout];
}

-(void)backAction:(UIBarButtonItem *)sender{
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)setTitleList{
//    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
//    [self.sectionTitles removeAllObjects];
//    [self.sectionTitles addObjectsFromArray:[theCollation sectionTitles]];
//    NSMutableArray * existTitles = [NSMutableArray array];
//    for(int i=0;i<[_listContent count];i++){
//        //过滤 就取存在的索引条标签
//        PersonModel *pm=_listContent[i][0];
//        for(int j=0;j<_sectionTitles.count;j++){
//            if(pm.sectionNumber==j)
//                [existTitles addObject:self.sectionTitles[j]];
//        }
//    }
//
//
//
//
//    [self.sectionTitles removeAllObjects];
//    self.sectionTitles =existTitles;
//
//}
//
//
//-(NSMutableArray*)listContent{
//    if(_listContent==nil){
//        _listContent=[NSMutableArray new];
//    }
//    return _listContent;
//}
//
//
//
//-(void) handleList:(NSArray *)dataArr{
//    self.listContent = [HandlePersonList handlelist:dataArr];
//
//    if(_listContent==nil){
//        NSLog(@"数据为空");
//        return;
//    }
//    [self setTitleList];
//    [_tableShow reloadData];
//}
//
//-(void)initData{
//
//    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
//    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
//    People *getObj = existArr[0];
//    NSString *CurrAdminID = [getObj.USERID stringValue];
//    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
//
//    NSString *url = [NSString stringWithFormat:@"%@/ApiActivity/GetMyStudent?AdminID=%@&ActivityID=%@",kCacheHttpRoot,CurrAdminID,batchID];
//    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
//        [_activityIndicatorView stopAnimating];
//        NSDictionary *jsonDic = result;
//        if([[jsonDic objectForKey:@"ResultType"] intValue] == 0){
//            NSArray *dataArr = [jsonDic objectForKey:@"AppendData"];
//            [self handleList:dataArr];
//        }
//    } failue:^(NSError *error) {
//        [_activityIndicatorView stopAnimating];
//        NSLog(@"请求失败");
//    }];
//
//}
//
////几个section
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return [_listContent count];
//
//}
////对应的section有多少row
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//
//    return [[_listContent objectAtIndex:(section)] count];
//
//}
////cell的高度
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 60;
//}
////section的高度
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 22;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    if(self.sectionTitles==nil||self.sectionTitles.count==0)
//        return nil;
//    UIView *contentView = [[UIView alloc] init];
//    contentView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"uitableviewbackground"]];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
//    label.backgroundColor = [UIColor clearColor];
//    NSString *sectionStr=[self.sectionTitles objectAtIndex:(section)];
//    [label setText:sectionStr];
//    [contentView addSubview:label];
//    return contentView;
//
//}
//
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cellIdenfer=@"addressCell";
//    PersonCell *personcell=(PersonCell*)[tableView dequeueReusableCellWithIdentifier:cellIdenfer];
//    if(personcell==nil){
//        personcell=[[PersonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenfer];
//    }
//
//    NSArray *sectionArr=[_listContent objectAtIndex:indexPath.section];
//    _people = (PersonModel *)[sectionArr objectAtIndex:indexPath.row];
//    [personcell setData:_people];
//
//    return personcell;
//
//}
//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    // NSString *key = [self.listContent objectAtIndex:indexPath.section];
//    NSArray *sectionArr=[_listContent objectAtIndex:indexPath.section];
//    self.people = (PersonModel *)[sectionArr objectAtIndex:indexPath.row];
////    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_people.phonename
////                                                    message:_people.tel
////                                                   delegate:self
////                                          cancelButtonTitle:@"取消"
////                                          otherButtonTitles:@"本地打电话",  nil];
////    [alert show];
//
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    StudentDetailViewController *student = [[StudentDetailViewController alloc]init];
//    student.person = self.people;
//    [self.navigationController pushViewController:student animated:YES];
//
//}
//
//#pragma mark - UIAlertViewDelegate
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    UIApplication *app = [UIApplication sharedApplication];
//    if (buttonIndex == 1){
//        [app openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", alertView.message]]];
//    }else if (buttonIndex == 2){
//
//    }
//}
//
//
//
////开启右侧索引条
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    return self.sectionTitles;
//}
//
//
//-(void) viewWillDisappear:(BOOL)animated{
////    [[self rdv_tabBarController]setTabBarHidden:NO animated:YES];
//}
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
@end
