//
//  AllPeopleViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/29.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "AllPeopleViewController.h"
#import "MailPeopleTableViewCell.h"
#import "People.h"
#import "BRContantPeopleModel.h"
#import "BRAllPeopleViewTableViewCell.h"

#import "ZXUser.h"
#import "XYDJViewController.h"

@interface AllPeopleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) BaseTablewView *peopleTableView;
@property(nonatomic,strong) NSMutableDictionary *dataSource;

@property(nonatomic, strong) NSMutableArray *dataList;

@end

@implementation AllPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_NAVBAR - HEIGHT_STATUSBAR - 44.0f);
    _contentView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_contentView];
    self.dataList = [NSMutableArray arrayWithCapacity:0];
    
  //  [self testArr];
    [self startLayout];
    WS(ws);
    [self addFreshPull:self.peopleTableView withBlock:^(id info) {
        [ws br_getHttpData];
    }];
    [self headerBeginFreshPull];
}

- (void)br_getHttpData{
    NSString *url = [NSString stringWithFormat:@"%@/ApiSystem/GetMyLinkMan",kCacheHttpRoot];
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
                BRContantPeopleModel *model = [[BRContantPeopleModel alloc] initWithDictionary:obj error:nil];
                [array addObject:model];
            }];
            self.dataList = array;
            [self.peopleTableView reloadData];
        }
        
    } WithFailureBlock:^(id error) {
        [self headerEndFreshPull];
    }];
    
}
-(void) testArr{
    _dataSource = [[NSMutableDictionary alloc]init];
    NSArray *arr = [[NSArray alloc]initWithObjects:[[NSDictionary alloc]initWithObjectsAndKeys:@"gj_msglogo1",@"Image",@"谭老师",@"Title", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"gj_msglogo2",@"Image",@"游老师",@"Title", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"gj_msglogo3",@"Image",@"小老师",@"Title", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"gj_msglogo2",@"Image",@"大老师",@"Title", nil], nil];
    
    NSArray *arr1 = [[NSArray alloc]initWithObjects:[[NSDictionary alloc]initWithObjectsAndKeys:@"gj_msglogo1",@"Image",@"谭小子",@"Title", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"gj_msglogo2",@"Image",@"游美女",@"Title", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"gj_msglogo3",@"Image",@"小大胖",@"Title", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"gj_msglogo2",@"Image",@"大肥仔",@"Title", nil], nil];
    
    NSArray *arr2 = [[NSArray alloc]initWithObjects:[[NSDictionary alloc]initWithObjectsAndKeys:@"gj_news",@"Image",@"业务办理",@"Title", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"gj_notice",@"Image",@"部门通知",@"Title", nil], nil];
    
    [_dataSource setObject:arr forKey:@"教师"];
    [_dataSource setObject:arr1 forKey:@"学生"];
    [_dataSource setObject:arr2 forKey:@"其他"];
}


-(void) startLayout{
    _peopleTableView = [[BaseTablewView alloc]init];
    _peopleTableView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    _peopleTableView.delegate = self;
    _peopleTableView.dataSource = self;
    _peopleTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _peopleTableView.rowHeight = 70.0f;
    _peopleTableView.sectionHeaderHeight = 20.0f;
    [_contentView addSubview:_peopleTableView];
}



#pragma mark --- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"BRAllPeopleViewTableViewCell";
    
    BRAllPeopleViewTableViewCell *mailCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!mailCell){
        mailCell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] firstObject];
    }
    BRContantPeopleModel *model = self.dataList[indexPath.row];
    mailCell.nameLabel.text = model.UserName;
    mailCell.telNameLabel.text = [NSString stringWithFormat:@"电话: %@",model.Mobile];
    [mailCell.headerImg br_SDWebSetImageWithURLString:[model.FactUrl fullImg] placeholderImage:kUserDefualtImage];
//    mailCell.ImgStr = [[[_dataSource objectForKey:[_dataSource.allKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"Image"];
//    mailCell.nameStr = [[[_dataSource objectForKey:[_dataSource.allKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"Title"];
//    mailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return mailCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BRContantPeopleModel *model = self.dataList[indexPath.row];

    ZXUser *user = [[ZXUser alloc] init];
    user.userID = model.ID;
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

#pragma mark --- 每一组的headerview
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    // 宽度为屏幕宽度, 高度是代理方法返回的高度.
//    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
//    headerLabel.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:245/255.0 alpha:1];
//    headerLabel.textColor = [UIColor lightGrayColor];
//    headerLabel.text = [NSString stringWithFormat:@"    %@",[_dataSource.allKeys objectAtIndex:section]];
//    headerLabel.font = [UIFont systemFontOfSize:14.0];
//    return headerLabel;
//
//}

#pragma mark 返回组头的高度 : 第一组的头部一定要通过代理设置
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
