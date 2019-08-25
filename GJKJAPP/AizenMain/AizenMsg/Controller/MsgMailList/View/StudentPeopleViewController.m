//
//  StudentPeopleViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/29.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "StudentPeopleViewController.h"
#import "MailPeopleTableViewCell.h"

@interface StudentPeopleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UITableView *peopleTableView;
@property(nonatomic,strong) NSMutableDictionary *dataSource;

@end

@implementation StudentPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_NAVBAR - HEIGHT_STATUSBAR - 44.0f);
    _contentView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_contentView];
    
    
    [self testArr];
    [self startLayout];
}

-(void) testArr{
    _dataSource = [[NSMutableDictionary alloc]init];
//    NSArray *arr = [[NSArray alloc]initWithObjects:[[NSDictionary alloc]initWithObjectsAndKeys:@"gj_msglogo1",@"Image",@"谭老师",@"Title", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"gj_msglogo2",@"Image",@"游老师",@"Title", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"gj_msglogo3",@"Image",@"小老师",@"Title", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"gj_msglogo2",@"Image",@"大老师",@"Title", nil], nil];
    
    NSArray *arr1 = [[NSArray alloc]initWithObjects:[[NSDictionary alloc]initWithObjectsAndKeys:@"gj_msglogo1",@"Image",@"谭小子",@"Title", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"gj_msglogo2",@"Image",@"游美女",@"Title", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"gj_msglogo3",@"Image",@"小大胖",@"Title", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"gj_msglogo2",@"Image",@"大肥仔",@"Title", nil], nil];
    
//    [_dataSource setObject:arr forKey:@"教师"];
    [_dataSource setObject:arr1 forKey:@"学生"];
}


-(void) startLayout{
    _peopleTableView = [[UITableView alloc]init];
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
    return [_dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_dataSource objectForKey:[_dataSource.allKeys objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    MailPeopleTableViewCell *mailCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!mailCell){
        mailCell = [[MailPeopleTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    mailCell.ImgStr = [[[_dataSource objectForKey:[_dataSource.allKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"Image"];
    mailCell.nameStr = [[[_dataSource objectForKey:[_dataSource.allKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"Title"];
    mailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return mailCell;
}


#pragma mark --- 每一组的headerview
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // 宽度为屏幕宽度, 高度是代理方法返回的高度.
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    headerLabel.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:245/255.0 alpha:1];
    headerLabel.textColor = [UIColor lightGrayColor];
    headerLabel.text = [NSString stringWithFormat:@"    %@",[_dataSource.allKeys objectAtIndex:section]];
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


@end
