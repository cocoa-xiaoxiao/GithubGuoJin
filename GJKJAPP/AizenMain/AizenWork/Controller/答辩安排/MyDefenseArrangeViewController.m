//
//  MyDefenseArrangeViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/11.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MyDefenseArrangeViewController.h"
#import "WorkBaseModel.h"
#import "MyDefenseArrangeTableViewCell.h"
#import "IBCreatHelper.h"
#import "SDCycleScrollView.h"
#import "People.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "PhoneInfo.h"
#import "Toast+UIView.h"
@interface MyDefenseArrangeViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *netImages;  //网络图片
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@end

@implementation MyDefenseArrangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"答辩安排";
    [self startLayout];
    [self getDataSourceFromHttp];
}
-(void)getDataSourceFromHttp
{
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [self.view addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    [HttpService GetMyDefenceTeam:CurrAdminID with:batchID with:@"" and:20 and:1 success:^(id  _Nonnull responseObject) {
        NSDictionary *jsonDic = responseObject;
        [_activityIndicatorView stopAnimating];
        [self detailLayout:[jsonDic objectForKey:@"AppendData"][@"rows"]];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [_activityIndicatorView stopAnimating];
    }];
}

-(void) detailLayout:(NSArray *)dataArr{
    if (dataArr) {
        NSDictionary *dict = dataArr.firstObject;
        myDefenseArrangeModel *model = [[myDefenseArrangeModel alloc]init];
        model.dname = [dict objectForKey:@"ProjectSubName"];
        model.dauthor = [dict objectForKey:@"StudentName"];
        model.dtutor = [dict objectForKey:@"TeacherName"];
        model.dqualification = @"有";
        model.dteam = [dict objectForKey:@"InspectionTeamName"];
        NSRange rang = {0,10};
        NSString *StartTime = [[[[dict objectForKey:@"BeginDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
        model.dtime = [PhoneInfo timestampSwitchTime:[StartTime integerValue] andFormatter:@"YYYY-MM-dd HH:mm:ss"];// HH:mm:ss
        model.dplace = [dict objectForKey:@"InspectionTeamPlace"];
        NSArray *modelArray = @[
                                @{@"论文选题":model.dname},
                                @{@"论文作者":model.dauthor},
                                @{@"指导老师":model.dtutor},
                                @{@"答辩资格":model.dqualification},
                                @{@"答辩小组":model.dteam},
                                @{@"答辩时间":model.dtime},
                                @{@"答辩地点":model.dplace}];
        self.dataSourceArray = [modelArray mutableCopy];
    }
}
-(void)startLayout
{
    _tableView = [[BaseTablewView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 65;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = self.cycleScrollView;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = RGB_HEX(0xffb6c1, 1);
    [self.view addSubview:_tableView];
}
-(NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc]init];
    }
    return _dataSourceArray;
}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyDefenseArrangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyDefenseArrangeCellID"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MyDefenseArrangeTableViewCell" owner:self options:nil].firstObject;
    }
    NSDictionary *dict = self.dataSourceArray[indexPath.row];
    cell.fTitleLabel.text = dict.allKeys.firstObject;
    cell.fDetailLabel.text = dict.allValues.firstObject;
    return cell;
}
#pragma mark 返回组头的高度 : 第一组的头部一定要通过代理设置
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
/**
 *  懒加载网络图片数据
 */
-(NSArray *)netImages{
    
    if (!_netImages) {
        _netImages = @[
                       @"http://d.hiphotos.baidu.com/zhidao/pic/item/72f082025aafa40f507b2e99aa64034f78f01930.jpg",
                       @"http://b.hiphotos.baidu.com/zhidao/pic/item/4b90f603738da9770889666fb151f8198718e3d4.jpg",
                       @"http://g.hiphotos.baidu.com/zhidao/pic/item/f2deb48f8c5494ee4e84ef5d2cf5e0fe98257ed4.jpg",
                       @"http://d.hiphotos.baidu.com/zhidao/pic/item/9922720e0cf3d7ca104edf32f31fbe096b63a93e.jpg"
                       ];
    }
    return _netImages;
}

-(SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0,self.view.bounds.size.width,200) delegate:self placeholderImage:[UIImage imageNamed:@"PlacehoderImage.png"]];
        
        //设置网络图片数组
        _cycleScrollView.imageURLStringsGroup = self.netImages;
        
        //设置图片视图显示类型
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        
        //设置轮播视图的分页控件的显示
        _cycleScrollView.showPageControl = YES;
        
        //设置轮播视图分也控件的位置
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        
        //当前分页控件小圆标图片
        _cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageCon.png"];
        
        //其他分页控件小圆标图片
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageConSel.png"];
        
    }
    return _cycleScrollView;
}
#pragma mark - 代理方法
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    //NSLog(@"%ld",index);
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
    //NSLog(@"%ld",index);
}
@end
