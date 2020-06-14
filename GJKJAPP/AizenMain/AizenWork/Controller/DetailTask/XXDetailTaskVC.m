//
//  XXDetailTaskVC.m
//  GJKJAPP
//
//  Created by 肖啸 on 2020/3/16.
//  Copyright © 2020 谭耀焯. All rights reserved.
//

#import "XXDetailTaskVC.h"
#import "MCHoveringView.h"
#import "MJRefresh/MJRefresh.h"
#import "SXTaskDynamicVC.h"
#import "SXTaskRecordVC.h"
#import "SXTaskHeadVC.h"
#import "APPAlertView.h"
#import "LDPublicWebViewController.h"
@interface XXDetailTaskVC ()<MCHoveringListViewDelegate,APPAlertViewDelegate>
@property (nonatomic , strong) SXTaskDynamicVC * demo1;
@property (nonatomic , strong) SXTaskRecordVC * demo2;
@property (nonatomic , strong) MCHoveringView * hoveringView;
@property (nonatomic , strong) SXTaskHeadVC * headVC;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, copy) NSString *jianfen;
@end

@implementation XXDetailTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title =  @"任务详情";
    self.navigationController.navigationBar.translucent = NO;
    self.demo1 = [SXTaskDynamicVC new];
    self.demo1.taskId = self.taskID;

    self.demo2 = [SXTaskRecordVC new];
    self.demo2.taskId = self.taskID;
    self.headVC = getControllerFromStoryBoard(@"sxTask", @"SXTaskHeadID");
    self.headVC.taskID = self.taskID;
    self.headVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 182);
    __weak typeof(self) weakself = self;
    self.headVC.bulidBlock = ^(CGFloat height, NSInteger cansubmit,NSString *jianfen) {
        weakself.jianfen = jianfen;
        weakself.headVC.view.frame = CGRectMake(0, 0, weakself.view.frame.size.width, height);
        [weakself initViewFrom:cansubmit];
    };
    self.headVC.lookDetailFuj = ^(NSString * _Nonnull url) {
        LDPublicWebViewController *web = [[LDPublicWebViewController alloc] init];
        web.webUrl = url.fullImg;
        web.title = @"查看附件";
        [weakself.navigationController pushViewController:web animated:YES];
    };
    self.demo1.lookUplodAccessory = ^(NSString * _Nonnull url) {
        LDPublicWebViewController *web = [[LDPublicWebViewController alloc] init];
        web.webUrl = url.fullImg;
        web.title = @"查看附件";
        [weakself.navigationController pushViewController:web animated:YES];
    };
    self.demo2.taskRecordAccessory = ^(NSString * _Nonnull url) {
        LDPublicWebViewController *web = [[LDPublicWebViewController alloc] init];
        web.webUrl = url.fullImg;
        web.title = @"查看附件";
        [weakself.navigationController pushViewController:web animated:YES];
    };
//    [self httprequest];
}

-(void)initViewFrom:(NSInteger)also
{
    self.hoveringView = [[MCHoveringView alloc]initWithFrame:CGRectMake(0, 0, self.view.xo_width, self.view.xo_height - 50) deleaget:self];
    self.hoveringView.isMidRefresh = NO;
    [self.view addSubview:self.hoveringView];
    //设置搜索 、认证、我的的字体颜色。
    self.hoveringView.pageView.defaultTitleColor = [UIColor blackColor];
    self.hoveringView.pageView.selectTitleColor = DEFAULT_APPTHEME_COLOR;
    [self.view addSubview:self.submitBtn];
    if ([self.flagRole isEqualToString:@"student"]) {
        if (also == 0 || also == 1) {
            [self.submitBtn setBackgroundColor:[UIColor lightGrayColor]];
            self.submitBtn.enabled = NO;
        }
    }
    //设置头部刷新的方法。头部刷新的话isMidRefresh 必须为NO
//    hovering.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [hovering.scrollView.mj_header endRefreshing];
//    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (NSArray *)listView
{
    return @[self.demo1.tableView,self.demo2.tableView];
}
- (UIView *)headView
{
    return self.headVC.view;
}
- (NSArray<UIViewController *> *)listCtroller
{
    return @[self.demo1,self.demo2];
}
- (NSArray<NSString *> *)listTitle
{
    return @[@"任务动态",@"处理记录"];
}

-(UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.frame =CGRectMake(0, self.view.xo_height -50,self.view.xo_width, 50);
        
        if ([self.flagRole isEqualToString:@"student"]) {
            [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        }
        if ([self.flagRole isEqualToString:@"teacher"]) {
            [_submitBtn setTitle:@"审核" forState:UIControlStateNormal];
        }
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn setBackgroundColor:DEFAULT_APPTHEME_COLOR];
        [_submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

-(void)submit:(UIButton*)sender
{
    if ([self.flagRole isEqualToString:@"student"]) {
        APPAlertView *view = [[APPAlertView alloc]AlertFactoryInitPracticeTaskSubmitViewfromController:self taskID:self.taskID successblock:^(id  _Nonnull responseObject) {
            [self.demo1.tableView.mj_header beginRefreshing];
            [self.submitBtn setBackgroundColor:[UIColor lightGrayColor]];
            self.submitBtn.enabled = NO;
        }];
        [view show];
    }
    if ([self.flagRole isEqualToString:@"teacher"]) {
        APPTaskCheckAlertView *alert = [[APPTaskCheckAlertView alloc]initWithTaskCheckAlertStringArray:@[@"已收阅，再接再厉！",@"在截止日期前提交。",@"请认真修改后提交。",@"请电话联系我详谈。",@"这个任务完成了，不错，继续l努力！"] applyID:self.taskID successblock:^(id  _Nonnull responseObject) {
            
        } Controller:self koufen:self.jianfen];
        [alert show];
    }
    
}
@end
