//
//  SXTaskRecordVC.m
//  GJKJAPP
//
//  Created by 肖啸 on 2020/3/19.
//  Copyright © 2020 谭耀焯. All rights reserved.
//

#import "SXTaskRecordVC.h"
#import "SXTaskRecordCell.h"
#import "RequestHelper.h"
#import "SXTaskReModel.h"
#import "PhoneInfo.h"
@interface SXTaskRecordVC ()<UITableViewDelegate,UITableViewDataSource,QQtableViewRequestDelegate>
@property (nonatomic , strong) NSMutableArray * dataArray;

@end

@implementation SXTaskRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray array];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"DEMO";
    [self.view addSubview:_tableView];

    //请求数据
    [self.tableView setUpWithUrl:[RequestHelper requestApiWith:GJAPIType_GetRecordListByDetailID] Parameters:@{@"ActivityTaskDetailID":self.taskId} formController:self];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableView.scrollViewDidScroll) {
        self.tableView.scrollViewDidScroll(self.tableView);
    }
}
- (void)QQtableView:(QQtableView *)QQtableView requestFailed:(NSError *)error
{
    
}
-(void)QQtableView:(QQtableView *)QQtableView isPullDown:(BOOL)PullDown SuccessData:(id)SuccessData
{

    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in [[SuccessData objectForKey:@"AppendData"] objectForKey:@"rows"]) {
        SXTaskReModel *model = [[SXTaskReModel alloc]init];
        model.UserName = [NSString checkNull:[dict objectForKey:@"UserName"]];
        model.CheckName = [NSString checkNull:[dict objectForKey:@"CheckName"]];
        NSMutableString *submitstr = [NSString checkNull:[dict objectForKey:@"SubmitAttachment"]];
        NSArray *ar = [submitstr componentsSeparatedByString:@"/"];
        model.SubmitAttachment = ar.lastObject;
        submitstr = [NSString checkNull:[dict objectForKey:@"CheckAttachment"]];
        ar = [submitstr componentsSeparatedByString:@"/"];
        model.CheckAttachment = ar.lastObject;
        model.CheckContent = [NSString checkNull:[dict objectForKey:@"CheckContent"]];
        model.SubmitContent = [NSString checkNull:[dict objectForKey:@"SubmitContent"]];
        NSRange rang = {0,10};
        NSString *StartTime =[PhoneInfo timestampSwitchTime:[[[[[dict objectForKey:@"UpdateDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang]integerValue] andFormatter:@"YYYY-MM-dd"];
        model.UpdateDate = StartTime;
        model.SubmitAttachmentAll = [NSString checkNull:[dict objectForKey:@"SubmitAttachment"]];
        model.CheckAttachmentAll = [NSString checkNull:[dict objectForKey:@"CheckAttachment"]];
        [array addObject:model];
    }
    self.dataArray = [array mutableCopy];
    [self.tableView reloadData];
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXTaskReModel *model = self.dataArray[indexPath.row];
    SXTaskRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recordTaskID"];
    cell.dtnameLb.text = model.UserName;
    cell.dtcontentLb.text = model.SubmitContent;
    [cell.dtAttachBtn setTitle:model.SubmitAttachment forState:UIControlStateNormal];
    cell.dttimeLb.text = model.UpdateDate;
    cell.thnameLb.text = model.CheckName;
    cell.thtimeLb.text = model.UpdateDate;
    [cell.thAttachBtn setTitle:model.CheckAttachment forState:UIControlStateNormal];
    
    cell.dtAttachBtn.accessibilityValue = model.SubmitAttachmentAll;
    cell.thAttachBtn.accessibilityValue = model.CheckAttachmentAll;
    [cell.dtAttachBtn addTarget:self action:@selector(selector:) forControlEvents:UIControlEventTouchUpInside];
    [cell.thAttachBtn addTarget:self action:@selector(selector:) forControlEvents:UIControlEventTouchUpInside];
    cell.thcontentLb.text = model.CheckContent;
    
    return cell;
}

-(void)selector:(UIButton *)sender
{
    if (_taskRecordAccessory) {
        self.taskRecordAccessory(sender.accessibilityValue);
    }
}
- (QQtableView *)tableView
{
    if (!_tableView) {
        _tableView = [[QQtableView alloc]initWithFrame:CGRectZero];
        _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50 - _navHeight());
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 50;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.RequestDelegate = self;
        //table是否有刷新
//        _tableView.isHasHeaderRefresh = YES;
        _tableView.emptyView.imageName = @"noList";
        _tableView.emptyView.imageSize = CGSizeMake(90, 90);
        _tableView.emptyView.hintText = @"暂无数据";
        _tableView.emptyView.hintTextFont = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
        _tableView.emptyView.hintTextColor = [UIColor redColor];

        [_tableView registerNib:[UINib nibWithNibName:@"SXTaskRecordCell" bundle:nil] forCellReuseIdentifier:@"recordTaskID"];
    }
    return _tableView;
}

@end
