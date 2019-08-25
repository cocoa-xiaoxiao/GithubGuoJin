//
//  MyFinalizationViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/11.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MyFinalizationViewController.h"
#import "WorkBaseModel.h"
#import "MyFinalizationTableViewCell.h"
#import "MyProjectDetailViewController.h"
#import "IBCreatHelper.h"
#import "NewMyProjectViewController.h"
#import "SDCycleScrollView.h"
#import "People.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "PhoneInfo.h"
#import "Toast+UIView.h"

@interface MyFinalizationViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,MyFinalizationTableViewCellDelegate>
{
    int _page;
}
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *netImages;  //网络图片
@property (strong, nonatomic) NSMutableArray *dataSourceArray; //数据源
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

@end

@implementation MyFinalizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的定稿";
    UIButton *leftCustomButton1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
    [leftCustomButton1 addTarget:self action:@selector(addProject:) forControlEvents:UIControlEventTouchUpInside];
    [leftCustomButton1.widthAnchor constraintEqualToConstant:33].active = YES;
    [leftCustomButton1.heightAnchor constraintEqualToConstant:33].active = YES;
    [leftCustomButton1 setImage:[UIImage imageNamed:@"iv_addicom"] forState:UIControlStateNormal];
    UIBarButtonItem * leftButtonItem1 =[[UIBarButtonItem alloc] initWithCustomView:leftCustomButton1];
    self.navigationItem.rightBarButtonItem = leftButtonItem1;
    [self startLayout];
    [self getDataSourceFromHttpIsFooterRefresh:NO];
}
-(void)getDataSourceFromHttpIsFooterRefresh:(BOOL)FooterRefresh
{
    if (FooterRefresh == YES) {
        _page ++ ;
    }else{
        _page = 1;
    }
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    [HttpService GetProjectFinalizationListByStudentID:CurrAdminID andActivityID:batchID and:20 and:_page success:^(id  _Nonnull responseObject) {
        if (FooterRefresh == YES) {
            [self.dataSourceArray addObjectsFromArray:[self detailLayout:[responseObject objectForKey:@"AppendData"][@"rows"]]];
        }else{
            self.dataSourceArray = [[self detailLayout:[responseObject objectForKey:@"AppendData"][@"rows"]] mutableCopy];
        }
        [self.tableView reloadData];
        [self headerEndFreshPull];
        [_activityIndicatorView stopAnimating];
    } failure:^(NSError * _Nonnull error) {
        [self headerEndFreshPull];
        [_activityIndicatorView stopAnimating];
    }];
}

-(NSArray *) detailLayout:(NSArray *)dataArr{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0 ; i < dataArr.count; i++) {
        NSDictionary *dict = dataArr[i];
        myFinalizationModel *model = [[myFinalizationModel alloc]init];
        model.fname = [dict objectForKey:@"ProjectName"];
        NSRange rang = {0,10};
        NSString *StartTime = [[[[dict objectForKey:@"CreateDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
        model.ftime = [PhoneInfo timestampSwitchTime:[StartTime integerValue] andFormatter:@"YYYY-MM-dd"];// HH:mm:ss
        model.fID = [[dict objectForKey:@"ID"] stringValue];
        int check =  [[dict objectForKey:@"CheckState"] intValue];
        if (check == 0) {
            model.fcheck = @"审核中";
        }else if (check==1)
        {
            model.fcheck = @"审核通过";
        }else if(check==2){
            model.fcheck = @"审核未通过";
        }else{
            model.fcheck = @"已作废";
        }
        model.fscore = @"无";
        model.fstate = @"查重状态:未查重";
        model.is_chachong = 0;
        if (![[dict objectForKey:@"Detectionstate"]isKindOfClass:[NSNull class]]) {
            model.is_chachong = YES;
            if ([[dict objectForKey:@"Detectionstate"] isEqualToString:@"检测中"]) {
                model.fstate = @"查重状态:查重中";
                model.is_chachong = 1;
            }
            else{
                model.fstate = [NSString stringWithFormat:@"查重状态:相似度%.2f%@",[[dict objectForKey:@"GeneralRate"]floatValue],@"%"];
                model.is_chachong = 2;
            }
        }
        
        if ([dict objectForKey:@"FinalScore"]) {
            if (![[dict objectForKey:@"FinalScore"] isKindOfClass:[NSNull class]]) {
                model.fscore = [dict objectForKey:@"FinalScore"] ;
            }
        }
        [array addObject:model];
    }
    return array;
}
-(void)addProject:(UIButton *)sender
{
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    [HttpService ProjectFinalizationIsAllowAdd:CurrAdminID and:batchID success:^(id  _Nonnull responseObject) {
        NSDictionary *jsonDic = responseObject;
        int ResultType = [jsonDic[@"ResultType"] intValue];
        NSString *result = jsonDic[@"Message"];
        if (ResultType == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请登录电脑端上传相应文件." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }else{
            [self.view makeToast:result duration:2.0 position:@"bottom"];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
-(void)startLayout
{
    _tableView = [[BaseTablewView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 100;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = self.cycleScrollView;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = RGB_HEX(0xFFB6C1, 1);
    WS(ws);
    [self addFreshPull:self.tableView withBlock:^(id info) {
        [ws getDataSourceFromHttpIsFooterRefresh:NO];
    }];
    [self addFooterFresh:self.tableView withBlock:^(id info) {
        [ws getDataSourceFromHttpIsFooterRefresh:YES];
    }];
    [self.view addSubview:_tableView];
    //旋转
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [self.view addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyFinalizationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyFinalizationCellID"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MyFinalizationTableViewCell" owner:self options:nil].firstObject;
    }
    myFinalizationModel *model = self.dataSourceArray[indexPath.row];
    cell.fNameLabel.text = model.fname;
    cell.fTimeLabel.text = [NSString stringWithFormat:@"提交日期:%@",model.ftime];
    cell.fTeachLabel.text = [NSString stringWithFormat:@"导师审阅:%@",model.fcheck];;
    cell.fScoreLabel.text = [NSString stringWithFormat:@"审阅评分:%@",model.fscore];
    cell.fStateLabel.text = model.fstate;
    if ([model.fcheck isEqualToString:@"已作废"]) {
        cell.chachongButton.hidden = YES;
    }else{
        cell.chachongButton.hidden = NO;
        if (model.is_chachong == 2) {
            [cell.chachongButton setTitle:@"报告" forState:UIControlStateNormal];
        }else if(model.is_chachong == 0){
            [cell.chachongButton setTitle:@"查重" forState:UIControlStateNormal];
        }else{
            [cell.chachongButton setTitle:@"刷新" forState:UIControlStateNormal];
        }
    }
    cell.cellIndex = indexPath;
    cell.delegate = self;
    return cell;
}

-(void)chachongWithIndexPath:(NSIndexPath *)index
{
    myFinalizationModel *model = self.dataSourceArray[index.row];
    [_activityIndicatorView startAnimating];
    if (model.is_chachong == 0) {
        [HttpService ProjectFinalizationCheckRepeatByID:model.fID success:^(id  _Nonnull responseObject){
            [_activityIndicatorView stopAnimating];
            model.is_chachong = 1;
            [self.tableView reloadData];
        } failure:^(NSError * _Nonnull error) {
            [_activityIndicatorView stopAnimating];
        }];
    }
    if (model.is_chachong == 1) {
        [HttpService ProjectFinalizationCheckRepeatResultByID:model.fID success:^(id  _Nonnull responseObject) {
            [_activityIndicatorView stopAnimating];
            NSString *chachong = responseObject[@"AppendData"][@"Detectionstate"];
            if ([chachong isEqualToString:@"检测中"]) {
                model.is_chachong = 1;
            }else{
                model.is_chachong = 2;
            }
            [self.tableView reloadData];
        } failure:^(NSError * _Nonnull error) {
            [_activityIndicatorView stopAnimating];
        }];
    }
    if (model.is_chachong == 2) {
        [HttpService ProjectFinalizationCheckRepeatDownloadByID:model.fID success:^(id  _Nonnull responseObject) {
            [_activityIndicatorView stopAnimating];
        } failure:^(NSError * _Nonnull error) {
            [_activityIndicatorView stopAnimating];
        }];
    }
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
-(NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc]init];
        
    }
    return _dataSourceArray;
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
