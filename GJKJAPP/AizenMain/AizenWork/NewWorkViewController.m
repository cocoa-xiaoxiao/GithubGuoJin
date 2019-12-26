//
//  NewWorkViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/24.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "NewWorkViewController.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "WorkCollectionViewCell.h"
#import "WorkHeaderCollectionReusableView.h"
#import "DDCollectionViewFlowLayout.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "SpinnerViewController.h"
#import "TestViewController.h"
#import "LeaveAuditViewController.h"
#import "BatchViewController.h"
#import "BatchViewController.h"
#import "AizenStorage.h"
#import "WorkTableViewCell.h"
#import "GJStudentSOSOpenViewController.h"
#import "IBCreatHelper.h"
@interface NewWorkViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,DDCollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>{
    UIBarButtonItem *leftBtn;
    int _Link; //选择的模块类型link
}

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UICollectionView *ftnView;
@property(nonatomic,strong) DGActivityIndicatorView *animationView;
@property(nonatomic,strong) NSMutableArray *TopModuleArr;
@property(nonatomic,strong) NSMutableArray *SubModuleArr;

@property(nonatomic,strong) BaseTablewView *dataTableView;

@property (nonatomic, strong) NSMutableArray *nameList;

@end

@implementation NewWorkViewController{
    NSMutableDictionary *dataDict;
    NSArray *sortedArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _TopModuleArr = [[NSMutableArray alloc]init];
    _SubModuleArr = [[NSMutableArray alloc]init];
    
    _TopModuleArr = [AizenStorage readUserDataWithKey:@"TopModule"];
    _TopModuleArr = [[_TopModuleArr reverseObjectEnumerator]allObjects];
    _SubModuleArr = [[AizenStorage readUserDataWithKey:@"SubModule"] mutableCopy];
    
    NSLog(@"%@",_TopModuleArr);
    
    
    _animationView = [[DGActivityIndicatorView alloc]initWithType:DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _animationView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 100)/2, 100, 100);
    [self.view addSubview:_animationView];
    
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1/255.0 green:137/255.0 blue:255/255.0 alpha:1];
    leftBtn = [[UIBarButtonItem alloc]
               initWithTitle:[[_TopModuleArr objectAtIndex:0]objectForKey:@"Name"]
               style:UIBarButtonItemStylePlain
               target:self
               action:nil];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:20.0f],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, _navHeight(), self.view.frame.size.width, self.view.frame.size.height - _navHeight()-_tabbarHeight());
    [self.view addSubview:_contentView];
    
    
    
    _dataTableView = [[BaseTablewView alloc]init];
    _dataTableView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    _dataTableView.delegate = self;
    _dataTableView.dataSource = self;
    _dataTableView.separatorColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
    _dataTableView.separatorStyle = UITableViewStyleGrouped;
    _dataTableView.rowHeight = 40.0f;
    _dataTableView.sectionHeaderHeight = 20.0f;
    [_contentView addSubview:_dataTableView];
    
    _Link = [[_TopModuleArr.firstObject objectForKey:@"LinkUrl"] intValue];
    [self initData:[[[_TopModuleArr objectAtIndex:0]objectForKey:@"ID"] stringValue]];

    
    UIButton *rightCustomButton1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
    [rightCustomButton1 addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightCustomButton1.widthAnchor constraintEqualToConstant:33].active = YES;
    [rightCustomButton1.heightAnchor constraintEqualToConstant:33].active = YES;
    
    [rightCustomButton1 setImage:[UIImage imageNamed:@"icon_arrow_bottom"] forState:UIControlStateNormal];
    [rightCustomButton1 setImage:[UIImage imageNamed:@"icon_arrow_top"] forState:UIControlStateSelected];
    UIBarButtonItem * rightButtonItem1 =[[UIBarButtonItem alloc] initWithCustomView:rightCustomButton1];
    self.navigationItem.rightBarButtonItem = rightButtonItem1;
    
}
-(void)br_toTextVC{
    GJStudentSOSOpenViewController *vc = [[GJStudentSOSOpenViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void) initDataTest{
    if(!dataDict)
        dataDict = [[NSMutableDictionary alloc]init];
    for (int i=0; i<3; i++) {
        NSMutableArray *picArray = [[NSMutableArray alloc]init];
        for (int j=0; j<10; j++) {
            //            [picArray addObject:[NSString stringWithFormat:@"gj_msglogo1.jpeg"]];
            [picArray addObject:[NSArray arrayWithObjects:@"gj_msglogo1.jpeg",@"打卡", nil]];
        }
        [dataDict setObject:picArray forKey:[NSString stringWithFormat:@"标题%d",i+10]];
    }
}


-(void) initData:(NSString *)topID{
    /*这里需要removeview，重新add*/
    NSLog(@"刷新");
    if([topID isEqualToString:@"0"]){
        if(!dataDict){
            dataDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSArray arrayWithObjects:[NSArray arrayWithObjects:@"gj_workrb.png",@"日报", nil], [NSArray arrayWithObjects:@"gj_workzb.png",@"周报", nil],[NSArray arrayWithObjects:@"gj_workyb.png",@"月报", nil],[NSArray arrayWithObjects:@"gj_workjxzp.png",@"绩效自评", nil],nil],@"业务汇报",[NSArray arrayWithObjects:[NSArray arrayWithObjects:@"gj_workkqdk.png",@"考勤打卡", nil], [NSArray arrayWithObjects:@"gj_workqd.png",@"签到", nil],[NSArray arrayWithObjects:@"gj_workqj.png",@"请假", nil],[NSArray arrayWithObjects:@"gj_workwc.png",@"外出", nil],[NSArray arrayWithObjects:@"gj_workcc.png",@"出差", nil],[NSArray arrayWithObjects:@"gj_workjb.png",@"加班", nil],nil],@"内外勤管理", nil];
        }
        
        if([_TopModuleArr count] > 0){
        }
    }else{
        dataDict = [[NSMutableDictionary alloc]init];
        self.nameList = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *getData = [[NSMutableArray alloc]init];
        for(int i = 0;i<[_SubModuleArr count];i++){
            NSString *flagID = [_SubModuleArr[i][0][@"ParentID"] stringValue];
            if([flagID isEqualToString:topID]){
                getData = _SubModuleArr[i];
            }
        }
        
        for(NSDictionary *secondDic in getData){
            
            NSMutableArray *newSecondArr = [[NSMutableArray alloc]init];
            NSString *secondName = [secondDic objectForKey:@"Name"];
            NSArray *subModule = [secondDic objectForKey:@"SysModuleVMs"];
            for(NSDictionary *thirdDic in subModule){
                NSString *subName = [thirdDic objectForKey:@"Name"];
                NSString *subIcon = [thirdDic objectForKey:@"Icon"];
                NSString *subLink = [thirdDic objectForKey:@"LinkUrl"];
                
                if([subIcon isEqualToString:@""]){
                    subIcon = @"gj_workqd.png";
                }
                
                NSArray *newThirdArr = [[NSArray alloc]initWithObjects:subIcon,subName,subLink,nil];
                
                [newSecondArr addObject:newThirdArr];
            }
            if([newSecondArr count] != 0){
                [dataDict setObject:newSecondArr forKey:secondName];
                [self.nameList addObject:secondName];
            }
        }
        
        if([_TopModuleArr count] > 0){
            [_dataTableView reloadData];
        }
    }
}

#pragma mark - leftBtn
- (void) leftAction:(UIBarButtonItem *)sender{
    
    UIButton *btn = (UIButton *)sender;
    btn.selected = YES;
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择模块" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for(int i = 0;i<[_TopModuleArr count];i++){
        NSMutableDictionary *data = [_TopModuleArr objectAtIndex:i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:[data objectForKey:@"Name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            btn.selected = NO;
            NSString *topModuleID = action.accessibilityValue;
            
            NSString *Title = @"";
            int linkR = 0;
            for(NSDictionary *TopModuleDic in action.accessibilityElements){
                if([topModuleID isEqualToString:[[TopModuleDic objectForKey:@"ID"]stringValue]]){
                    Title = [TopModuleDic objectForKey:@"Name"];
                    linkR = [[TopModuleDic objectForKey:@"LinkUrl"] intValue];
                }
            }
            NSString *Changetitle = [NSString stringWithFormat:@"%@",Title];
            [leftBtn setTitle:Changetitle];
            
            if (linkR != _Link) {
                _Link = linkR;
                [AizenStorage removeUserDataWithkey:@"batchID"];
                [self initData:topModuleID];
            }
        }];
        action.accessibilityValue = [[data objectForKey:@"ID"] stringValue];
        action.accessibilityElements = _TopModuleArr;
        [alertVC addAction:action];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        btn.selected = NO;
    }];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger num = 0;
    num = [self.nameList count];
    return num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = 0;
    NSString *aky = [self.nameList objectAtIndex:section];
    NSArray *temp = [dataDict objectForKey:aky];
    num = temp.count;
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    WorkTableViewCell *workCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!workCell){
        workCell = [[WorkTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    workCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *aky = [self.nameList objectAtIndex:indexPath.section];
    NSArray *temp = [dataDict objectForKey:aky];
    NSArray *a_dict = temp[indexPath.row];
    
//    workCell.workNameStr = [[[dataDict objectForKey:[dataDict.allKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]objectAtIndex:1];
//    workCell.workImgStr = [[[dataDict objectForKey:[dataDict.allKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]objectAtIndex:0];
    workCell.workNameStr = a_dict[1];
    workCell.workImgStr  = a_dict[0];
    return workCell;
}

#pragma mark 返回每组的头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // 宽度为屏幕宽度, 高度是代理方法返回的高度.
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    headerLabel.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:245/255.0 alpha:1];
    headerLabel.text =  [NSString stringWithFormat:@"    %@",self.nameList[section]];
    headerLabel.textColor = [UIColor lightGrayColor];
    headerLabel.font = [UIFont systemFontOfSize:14.0];
    return headerLabel;
    
}

#pragma mark 返回组头的高度 : 第一组的头部一定要通过代理设置
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *aky = [self.nameList objectAtIndex:indexPath.section];
    NSArray *temp = [dataDict objectForKey:aky];
    NSArray *a_dict = temp[indexPath.row];
    NSString *controllerName  = [a_dict lastObject];
    controllerName = [NSString stringWithFormat:@"%@ViewController",controllerName];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    NSLog(@"%@",batchID);
    if([batchID isEqualToString:@""] || batchID == nil || [controllerName isEqualToString:@"BatchViewController"]){
        BatchViewController *batchView = [[BatchViewController alloc]init];
        batchView.link = _Link;
        batchView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:batchView animated:YES];
    }else{
            UIViewController * obj = [[NSClassFromString(controllerName) alloc]init];
            obj.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:obj animated:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
