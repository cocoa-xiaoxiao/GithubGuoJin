//
//  MsgViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/1/12.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MsgViewController.h"
#import "MsgTableViewCell.h"
#import "MsgServiceViewController.h"

@interface MsgViewController ()<UITableViewDelegate,UITableViewDataSource>

typedef enum _NoticeType {
     SystemNotice = 1 << 0,
     SystemService = 1 << 1,
     SystemNormal = 1 << 2
} NoticeType;

@property(nonatomic) CGFloat ViewHeight;
@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic,strong) NSArray *sourceData;

@end

@implementation MsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];

    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]
                                initWithTitle:@"消息"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:nil];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    self.navigationItem.title = @"";
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:20.0f],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    _ViewHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    [self startLayout];
    
}


-(void) startLayout{
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, _ViewHeight, self.view.frame.size.width, self.view.frame.size.height - _ViewHeight - 44)];
    _contentView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height)];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0, _contentView.frame.size.width, 10)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_searchBar setPlaceholder:@"搜索"];
    [_searchBar sizeToFit];
    [_searchBar setDelegate:self];
    [_searchBar.layer setBorderWidth:0.5f];
    [_searchBar.layer setBorderColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor];
    [_searchBar setBackgroundColor:[UIColor whiteColor]];
    [_tableView setTableHeaderView:_searchBar];
    [_contentView addSubview:_tableView];
    
    _sourceData = [self getData];
}

-(NSArray *) getData{
    NSArray *result = [[NSArray alloc]init];
    result = @[
               @{
                   @"msgId":@1,
                   @"type":@"SystemNotice",
                   @"title":@"系统消息",
                   @"date":@"昨天11:30",
                   @"message":@"请假消息：谭小二向您申请。",
                   @"imgUrl":@"gj_msglogo1.jpg",
                   @"messageCount":@20
                   },
               @{
                   @"msgId":@2,
                   @"type":@"SystemService",
                   @"title":@"公司服务",
                   @"date":@"11:21",
                   @"message":@"有困难，请找公司服务",
                   @"imgUrl":@"gj_welcomelogo.jpg",
                   @"messageCount":@10
                   },
               @{
                   @"msgId":@3,
                   @"type":@"SystemNormal",
                   @"title":@"张小三",
                   @"date":@"11:21",
                   @"message":@"昨天，马云发布了最新一代产品澳洲原瓶原装进口红酒2支...",
                   @"imgUrl":@"gj_msglogo3.jpg",
                   @"messageCount":@10
                   },
               @{
                   @"msgId":@4,
                   @"type":@"SystemNormal",
                   @"title":@"李大四",
                   @"date":@"下午7:21",
                   @"message":@"今天，马云发布了最新一代产品澳洲原瓶原装进口红酒2支...",
                   @"imgUrl":@"gj_msglogo2.jpg",
                   @"messageCount":@10
                   }
               ];
    return result;
}


#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_sourceData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    return HEIGHT_ROW;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    MsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        //单元格样式设置为UITableViewCellStyleDefault
        cell = [[MsgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID Info:_sourceData[indexPath.row]];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSArray *arrData = [self getData];
    NSString *type = [[arrData objectAtIndex:indexPath.row] objectForKey:@"type"];
    
    if([type isEqualToString:@"SystemNotice"]){
        
        [self jumpNoticePage:SystemNotice];
        
        
    }else if([type isEqualToString:@"SystemService"]){
        [self jumpNoticePage:SystemService];
    }else if([type isEqualToString:@"SystemNormal"]){
        [self jumpNoticePage:SystemNormal];
    }
}



-(void) jumpNoticePage:(NoticeType)para{
    if(para & SystemNotice){
        
    }else if(para & SystemService){
        MsgServiceViewController *servicePage = [[MsgServiceViewController alloc]init];
        [self.navigationController pushViewController:servicePage animated:YES];
    }else if(para & SystemNormal){
        
    }
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
