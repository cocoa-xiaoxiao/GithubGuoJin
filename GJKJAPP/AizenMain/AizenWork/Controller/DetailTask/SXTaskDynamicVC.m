
//
//  SXTaskDynamicVC.m
//  GJKJAPP
//
//  Created by 肖啸 on 2020/3/19.
//  Copyright © 2020 谭耀焯. All rights reserved.
//

#import "SXTaskDynamicVC.h"
#import "SXTaskDynamicCell.h"
#import "RequestHelper.h"
#import "SXTaskDyModel.h"

@interface SXTaskDynamicVC ()<UITableViewDelegate,UITableViewDataSource,QQtableViewRequestDelegate>
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , strong) NSLock * lock;

@end

@implementation SXTaskDynamicVC

-  (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"DEMO";
    [self.view addSubview:self.tableView];
    
    [self.tableView setUpWithUrl:[RequestHelper requestApiWith:GJAPIType_GetByID] Parameters:@{@"TaskID":self.taskId} formController:self];
}
- (void)viewDidAppear:(BOOL)animated
{
}
//这里是必须存在的方法 传递tableView的偏移量
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
    for (NSDictionary *dict in [SuccessData objectForKey:@"AppendData"]) {
        SXTaskDyModel *model = [[SXTaskDyModel alloc]init];
        model.SubmitContent = [NSString checkNull:[dict objectForKey:@"SubmitContent"]];
        NSMutableString *submitstr = [NSString checkNull:[dict objectForKey:@"SubmitAttachment"]];
        NSArray *ar = [submitstr componentsSeparatedByString:@"/"];
        model.SubmitAttachment = ar.lastObject;
        submitstr = [NSString checkNull:[dict objectForKey:@"CheckAttachment"]];
        ar = [submitstr componentsSeparatedByString:@"/"];
        model.CheckAttachment = ar.lastObject;
        model.CheckContent = [NSString checkNull:[dict objectForKey:@"CheckContent"]];
        model.OverdueScore = [NSString checkNull:[dict objectForKey:@"OverdueScore"]];
        model.TeacherScore = [NSString checkNull:[dict objectForKey:@"TeacherScore"]];
        model.FinalScore = [NSString checkNull:[dict objectForKey:@"FinalScore"]];
        model.SubmitAttachmentAll = [NSString checkNull:[dict objectForKey:@"SubmitAttachment"]];
        model.CheckAttachmentAll = [NSString checkNull:[dict objectForKey:@"CheckAttachment"]];
        [array addObject:model];
    }
    self.dataArray = [array mutableCopy];
    //处理返回的SuccessData 数据之后刷新table
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
    SXTaskDyModel *model = self.dataArray[indexPath.row];
    SXTaskDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dynamicCellID"];
    cell.submitLb.text = model.SubmitAttachment;
    cell.submitContentLb.text = model.SubmitContent;
    cell.checkLb.text = model.CheckAttachment;
    cell.checkContentLb.text= model.CheckContent;
    cell.checkBtn.text = [NSString stringWithFormat:@"审核评分:%@",model.TeacherScore];
    cell.overBtn.text = [NSString stringWithFormat:@"超期罚分:%@",model.OverdueScore];
    cell.finalBtn.text = [NSString stringWithFormat:@"最终得分:%@",model.FinalScore];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoBack:)];
    cell.submitLb.userInteractionEnabled = YES;
    tap1.accessibilityValue = model.SubmitAttachmentAll;
    [cell.submitLb addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoBack:)];
    tap2.accessibilityValue = model.CheckAttachmentAll;
    cell.checkLb.userInteractionEnabled = YES;
    [cell.checkLb addGestureRecognizer:tap2];
    return cell;
}

-(void)gotoBack:(UITapGestureRecognizer*)tap
{
    if (self.lookUplodAccessory) {
        self.lookUplodAccessory(tap.accessibilityValue);
    }
}

- (QQtableView *)tableView
{
    if (!_tableView) {
        /**
         注意⚠️这里初始化QQtableView  千万不能使用[[QQtableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50 - 64)];
         这样初始化的话会造成走俩次创建方法 生成俩个tableView对象。
            具体原因不详，初步猜测是因为在ViewController中的self.demo1.tableView调用懒加载的时候initWithFrame。给的frame不为空
         view内部渲染涂层 ，没有及时的返回实例化对象 所以  [self.view addSubview:self.tableView];的时候_tableView还是nil所以又走了一次
         */
        _tableView = [[QQtableView alloc]initWithFrame:CGRectZero];
        //这里frame的高减了 64 是减去了nav的高度。  50 是PageView的中的titleView的高度就是搜索 、认证、我的 所处view的高度 具体请款视视图而定
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
        [_tableView registerNib:[UINib nibWithNibName:@"SXTaskDynamicCell" bundle:nil] forCellReuseIdentifier:@"dynamicCellID"];
    }
    return _tableView;

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
