//
//  NewMsgViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/27.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "NewMsgViewController.h"
#import "MsgBusinessTableViewCell.h"
#import "RDVTabBarController.h"
#import "MsgCacheListViewController.h"
#import "MsgMailListViewController.h"
#import "People.h"
#import "BaseTablewView.h"
#import "BRMessageModel.h"

#import "XYDJViewController.h"
#import "TLUserHelper.h"
@interface NewMsgViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIView *contentView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic,strong) NSMutableDictionary *sourceData;
@property(nonatomic,strong) BaseTablewView *tableView;


@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation NewMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1/255.0 green:137/255.0 blue:255/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];

    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]
                                initWithTitle:@"消息"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:nil];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.title = @"";
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:20.0f],NSFontAttributeName, nil] forState:UIControlStateNormal];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1/255.0 green:137/255.0 blue:255/255.0 alpha:1];
    
    
//    UIButton *leftCustomButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [leftCustomButton addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
//    [leftCustomButton.widthAnchor constraintEqualToConstant:30].active = YES;
//    [leftCustomButton.heightAnchor constraintEqualToConstant:30].active = YES;
//
//    [leftCustomButton setImage:[UIImage imageNamed:@"gj_fangdajing"] forState:UIControlStateNormal];
//    UIBarButtonItem * leftButtonItem =[[UIBarButtonItem alloc] initWithCustomView:leftCustomButton];
//
    
    UIButton *leftCustomButton1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
    [leftCustomButton1 addTarget:self action:@selector(mailAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftCustomButton1.widthAnchor constraintEqualToConstant:33].active = YES;
    [leftCustomButton1.heightAnchor constraintEqualToConstant:33].active = YES;
    
    [leftCustomButton1 setImage:[UIImage imageNamed:@"contactList"] forState:UIControlStateNormal];
    UIBarButtonItem * leftButtonItem1 =[[UIBarButtonItem alloc] initWithCustomView:leftCustomButton1];
    
    self.navigationItem.rightBarButtonItem = leftButtonItem1;

    self.dataList = [NSMutableArray arrayWithCapacity:0];
//    [self testArr];
    [self startLayout];
    WS(ws);
    [self addFreshPull:self.tableView withBlock:^(id info) {
        [ws br_getMessageList];
    }];
    [self headerBeginFreshPull];
    
    [self br_getUserInfo];

   // [self br_getMessageList];
}
- (void)br_getUserInfo{
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    ZXUser *user = [[ZXUser alloc] init];
    user.username = getObj.USERNAME;
    user.avatarURL = [getObj.FactUrl fullImg];
    user.userID = [NSString stringWithFormat:@"%@",getObj.USERID];
    [TLUserHelper sharedUserHelper].user = user;
}

-(void) testArr{
    _sourceData = [[NSMutableDictionary alloc]init];
    
    NSArray *typeArr1 = [[NSArray alloc]initWithObjects:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"gj_news",@"Image",@"部门通知",@"Title",@"您的银行卡余额剩下1000000元",@"Msg",@"10",@"count",@"05-28 17:00",@"date", nil],[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"gj_notice",@"Image",@"业务办理",@"Title",@"您有3单未办理的违章罚单",@"Msg",@"05-28 17:00",@"date", nil],[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"gj_msglogo2",@"Image",@"张小三",@"Title",@"在吗？整天拖我工资快还我",@"Msg",@"10",@"count",@"05-28 17:00",@"date", nil], [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"gj_msglogo1",@"Image",@"李小四",@"Title",@"上个月的款项打过来没有啊？",@"Msg",@"05-28 17:00",@"date", nil],[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"gj_msglogo3",@"Image",@"王小五",@"Title",@"erp出错了",@"Msg",@"2",@"count",@"05-28 17:00",@"date", nil],[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"gj_msglogo1",@"Image",@"李志聪",@"Title",@"不做啦，我回新加坡啦",@"Msg",@"1",@"count",@"05-28 17:00",@"date", nil], nil];
    
    [_sourceData setObject:typeArr1 forKey:@"business"];
    
}


-(void) startLayout{
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_STATUSBAR - HEIGHT_NAVBAR - HEIGHT_TABBAR);
    _contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:_contentView];
        
    
    
    _tableView = [[BaseTablewView alloc]init];
    _tableView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewStyleGrouped;
    _tableView.rowHeight = 70.0f;
    _tableView.sectionHeaderHeight = 18.0f;
    [_contentView addSubview:_tableView];
}


#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    MsgBusinessTableViewCell *msgCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!msgCell){
        msgCell = [[MsgBusinessTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    msgCell.selectionStyle = UITableViewCellSelectionStyleNone;
//    msgCell.mainImgStr = _sourceData[[_sourceData.allKeys objectAtIndex:indexPath.section]][indexPath.row][@"Image"];
//    msgCell.mainTitleStr = _sourceData[[_sourceData.allKeys objectAtIndex:indexPath.section]][indexPath.row][@"Title"];
//    msgCell.mainMsgStr = _sourceData[[_sourceData.allKeys objectAtIndex:indexPath.section]][indexPath.row][@"Msg"];
//    if([[[_sourceData objectForKey:[_sourceData.allKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"count"]){
//        msgCell.mainNumStr = [[[_sourceData objectForKey:[_sourceData.allKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"count"];
//    }else{
//        msgCell.mainNumStr = @"";
//    }
//    msgCell.mainDateStr = [[[_sourceData objectForKey:[_sourceData.allKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"date"];
    
    BRMessageModel *mdoel = self.dataList[indexPath.row];
    msgCell.mainTitleStr = mdoel.UserName;
    msgCell.mainMsgStr = mdoel.MessageContent;
   // [msgCell.imgView ]
    [msgCell.imgView br_SDWebSetImageWithURLString:mdoel.FactUrl.fullImg placeholderImage:kUserDefualtImage];
    msgCell.mainNumStr = mdoel.Num;
    msgCell.mainDateStr = mdoel.CreateDate;
    return msgCell;
    
}

#pragma mark 返回每组的头部视图
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    // 宽度为屏幕宽度, 高度是代理方法返回的高度.
//    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
//    headerLabel.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:245/255.0 alpha:1];
//    headerLabel.textColor = [UIColor blueColor];
//    return headerLabel;
//
//}

#pragma mark 返回组头的高度 : 第一组的头部一定要通过代理设置
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00111;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //https://github.com/xhzengAIB/MessageDisplayKit
    
    BRMessageModel *model = self.dataList[indexPath.row];
    ZXUser *user = [[ZXUser alloc] init];
    user.userID = model.Creater;
    user.username = model.UserName;
    user.avatarURL = [model.FactUrl fullImg];
    XYDJViewController *chat = [[XYDJViewController alloc] init];
    chat.user = user;
    chat.updateBlock = ^(id info) {
        if (info) {
            model.MessageContent = info;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    };
    model.Num = @"0";
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    chat.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chat animated:YES];
    
}



-(void) detailAction:(UIBarButtonItem *)sender{
    MsgCacheListViewController *msgCache = [[MsgCacheListViewController alloc]init];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [backBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.backBarButtonItem = backBtn;
    
    [self.navigationController pushViewController:msgCache animated:YES];
}


-(void) mailAction:(UIBarButtonItem *)sender{
    MsgMailListViewController *msgMail = [[MsgMailListViewController alloc]init];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [backBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.backBarButtonItem = backBtn;
    msgMail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:msgMail animated:YES];
}



- (void)br_getMessageList{
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiSystem/GetMessageSender",kCacheHttpRoot];
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    
    [[HTTPOpration sharedHTTPOpration] NetRequestGETWithRequestURL:url WithParameter:@{@"AdminID":CurrAdminID} WithReturnValeuBlock:^(HTTPData *data) {
        [self headerEndFreshPull];
        NSArray *temp = data.returnData[kRootDataKey];
        if ([temp isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
            [temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BRMessageModel *model = [[BRMessageModel alloc] initWithDictionary:obj error:nil];
                [array addObject:model];
            }];
            self.dataList = array;
            [self.tableView reloadData];
        }
        
    } WithFailureBlock:^(id error) {
        [self headerEndFreshPull];
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController]setTabBarHidden:NO animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
