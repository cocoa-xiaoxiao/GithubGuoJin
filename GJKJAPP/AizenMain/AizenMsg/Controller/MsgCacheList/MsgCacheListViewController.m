//
//  MsgCacheListViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/29.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MsgCacheListViewController.h"
#import "RDVTabBarController.h"
#import "MsgCacheTableViewCell.h"


@interface MsgCacheListViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UITableView *cacheTableView;
@property(nonatomic,strong) UISearchBar *cacheSearchBar;
@property(nonatomic,strong) NSMutableDictionary *sourceData;

@end

@implementation MsgCacheListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _cacheSearchBar = [[UISearchBar alloc]init];
    _cacheSearchBar.delegate = self;
    self.navigationItem.titleView = _cacheSearchBar;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    [[self rdv_tabBarController]setTabBarHidden:YES animated:YES];
    
    _sourceData = [[NSMutableDictionary alloc]init];
    [self startLayout];
}


-(void) testArr{
    NSArray *arr1 = [[NSArray alloc]initWithObjects:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"gj_news",@"Image",@"部门通知",@"Title",@"9条相关的聊天记录",@"Msg", nil],[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"gj_notice",@"Image",@"业务办理",@"Title",@"2条相关的聊天记录",@"Msg", nil], nil];
    
    NSArray *arr2 = [[NSArray alloc]initWithObjects:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"gj_msglogo1",@"Image",@"Denny王",@"Title",@"4条相关的聊天记录",@"Msg", nil],[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"gj_msglogo2",@"Image",@"林志豪",@"Title",@"2条相关的聊天记录",@"Msg", nil],[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"gj_msglogo3",@"Image",@"李志聪",@"Title",@"6条相关的聊天记录",@"Msg", nil], nil];
    
    
    [_sourceData setObject:arr2 forKey:@"聊天记录"];
    [_sourceData setObject:arr1 forKey:@"业务办理"];
    
}


-(void) startLayout{
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_NAVBAR + HEIGHT_STATUSBAR + 12, self.view.frame.size.width, self.view.frame.size.height);
    _contentView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_contentView];
    
    
    _cacheTableView = [[UITableView alloc]init];
    _cacheTableView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    _cacheTableView.delegate = self;
    _cacheTableView.dataSource = self;
    _cacheTableView.separatorStyle = UITableViewStyleGrouped;
    _cacheTableView.rowHeight = 70.0f;
    _cacheTableView.sectionHeaderHeight = 20.0f;
    [_contentView addSubview:_cacheTableView];
}



#pragma mark --- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_sourceData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_sourceData objectForKey:[_sourceData.allKeys objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    MsgCacheTableViewCell *msgcacheCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!msgcacheCell){
        msgcacheCell = [[MsgCacheTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    msgcacheCell.cacheImgStr = [[[_sourceData objectForKey:[_sourceData.allKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"Image"];
    msgcacheCell.cacheTitleStr = [[[_sourceData objectForKey:[_sourceData.allKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"Title"];
    msgcacheCell.cacheMsgStr = [[[_sourceData objectForKey:[_sourceData.allKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"Msg"];
    msgcacheCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return msgcacheCell;
}


#pragma mark --- 每一组的headerview
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // 宽度为屏幕宽度, 高度是代理方法返回的高度.
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    headerLabel.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:245/255.0 alpha:1];
    headerLabel.textColor = [UIColor lightGrayColor];
    headerLabel.text = [NSString stringWithFormat:@"    %@",[_sourceData.allKeys objectAtIndex:section]];
    headerLabel.font = [UIFont systemFontOfSize:14.0];
    return headerLabel;
    
}

#pragma mark 返回组头的高度 : 第一组的头部一定要通过代理设置
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"搜索");
    [self testArr];
    [_cacheTableView reloadData];
}


-(void)viewWillDisappear:(BOOL)animated{
    [[self rdv_tabBarController]setTabBarHidden:NO animated:YES];
}


@end
