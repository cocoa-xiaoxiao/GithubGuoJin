//
//  GJASOSDetailViewController.m
//  GJKJAPP
//
//  Created by git burning on 2018/10/13.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "GJASOSDetailViewController.h"
#import <MapKit/MapKit.h>
#import "GJSOSNewsTableViewCell.h"

#import "GJSOSRemarkTableViewCell.h"
#import "GJSOSDetailRemark1TableViewCell.h"
#import "GJStudentContactTableViewCell.h"
#import "GJPublicCellModel.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "WorkBaseModel.h"
#import "PhoneInfo.h"
#import "People.h"
const NSInteger kYuJiangInfoStatusTag= 1;
const NSInteger kYuJiangInfoDesTag= 2;

const NSInteger kYuJiangChuliMarkTag= 3;
const NSInteger kYuJiangChuliContactTag= 4;
const NSInteger kYuJiangChuliRcodeTag= 5;//记录


@interface GJASOSDetailViewController ()<MKMapViewDelegate>
@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic,strong) CLLocationManager *mag;
@property (nonatomic,strong) CLGeocoder *ceocoder;
@property (nonatomic, strong) SOSInfoModel *sosContentModel;
@property (nonatomic, strong) NSMutableArray *dataList;
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@end

@implementation GJASOSDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"预警详情";
    _mapView = [[MKMapView alloc]init];
    _mapView.frame = CGRectMake(0, 0, WIDTH_SCREEN,150);
    _mapView.delegate = self;
    //    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    [self.contentView addSubview:_mapView];
    
    GJSOSNewsTableViewCell *addressView = [[[NSBundle mainBundle] loadNibNamed:@"GJSOSNewsTableViewCell" owner:self options:nil] firstObject];
    [self.contentView addSubview:addressView];
    addressView.statusLabel.hidden = YES;
    addressView.frame = CGRectMake(0, _mapView.frame.size.height,WIDTH_SCREEN, [GJSOSNewsTableViewCell br_getUITableViewCellHeight]);
    
    [self br_configData];
    
    [self addGrounpTablewDelegate:self];

    [self.categoryTablew removeFromSuperview];
    [self.contentView addSubview:self.categoryTablew];
    
    [self.categoryTablew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.categoryTablew.separatorStyle = UITableViewCellSelectionStyleNone;
    self.categoryTablew.rowHeight = UITableViewAutomaticDimension;
    self.categoryTablew.estimatedRowHeight = 100;
    
//    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.top.mas_equalTo(self.mapView.mas_bottom);
//        make.right.mas_equalTo(0);
//        make.height.mas_equalTo([GJSOSNewsTableViewCell br_getUITableViewCellHeight]);
//    }];
    // Do any additional setup after loading the view.
    [self getNewData];
}
-(void)getNewData
{
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [self.contentView addSubview:_activityIndicatorView];
    [HttpService GetSosMapListByID:self.sosID success:^(id  _Nonnull responseObject) {
        NSDictionary *dict1 = [responseObject[@"AppendData"] objectAtIndex:0] ;
        [HttpService GetSosByID:self.sosID success:^(id  _Nonnull responseObject) {
            NSDictionary *dict2 = [responseObject[@"AppendData"] objectAtIndex:0];
            [self detailLayoutDict:dict1 andDict:dict2];
            [_activityIndicatorView stopAnimating];
        } failure:^(NSError * _Nonnull error) {
            [_activityIndicatorView stopAnimating];
        }];
    } failure:^(NSError * _Nonnull error) {
        [_activityIndicatorView stopAnimating];
    }];
}
-(void)detailLayoutDict:(NSDictionary *)dict1 andDict:(NSDictionary *)dict2{
    self.sosContentModel = [[SOSInfoModel alloc]init];
    self.sosContentModel.lat = [[dict1 objectForKey:@"x"] doubleValue];
    self.sosContentModel.lon = [[dict1 objectForKey:@"y"] doubleValue];
    self.sosContentModel.sosPlace = [dict1 objectForKey:@"place"];
    self.sosContentModel.title = [dict2 objectForKey:@"WarnTitle"];
    self.sosContentModel.sosContent = [dict2 objectForKey:@"WarnContent"];
    NSRange rang = {0,10};
    NSString *StartTime = [[[[dict2 objectForKey:@"WarnDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
    self.sosContentModel.sosTime = [PhoneInfo timestampSwitchTime:[StartTime integerValue] andFormatter:@"YYYY-MM-dd HH:mm:ss"];
    [self.categoryTablew reloadData];
    
    CLLocationCoordinate2D coordinate = {self.sosContentModel.lon, self.sosContentModel.lat};
    [_mapView setCenterCoordinate:coordinate animated:YES];
    
    for (UIView *vs in self.contentView.subviews) {
        if ([vs isKindOfClass:[GJSOSNewsTableViewCell class]]) {
            GJSOSNewsTableViewCell *sosNewsCell = (GJSOSNewsTableViewCell *)vs;
            sosNewsCell.timeLabel.text = self.sosContentModel.sosTime;
            sosNewsCell.addressLabel.text = self.sosContentModel.sosPlace;
        }
    }
}
- (void)br_configData{
    self.dataList = [NSMutableArray arrayWithCapacity:0];
    
    GJPublicCellModel *sectionOne = [[GJPublicCellModel alloc] init];
    sectionOne.rowArrays = [NSMutableArray arrayWithCapacity:0];
    
    sectionOne.sectionHeaderHeight = 10.0;
    sectionOne.sectionFooderHeight = 0.0001;
    
    GJPublicCellModel *row1 =  [GJPublicCellModel new];
    row1.cellID = kYuJiangInfoStatusTag;
    row1.cellHeight = 40.0;
    [sectionOne.rowArrays addObject:row1];
    
    GJPublicCellModel *row2 =  [GJPublicCellModel new];
    row2.cellID = kYuJiangInfoDesTag;
    row2.cellHeight = UITableViewAutomaticDimension;
    [sectionOne.rowArrays addObject:row2];
    
    //GJSOSDetailRemark1TableViewCell
    
    
    GJPublicCellModel *sectionTwo = [GJPublicCellModel new];
    sectionTwo.rowArrays = [NSMutableArray arrayWithCapacity:0];
    sectionTwo.sectionHeaderHeight = 10.0;
    sectionTwo.sectionFooderHeight = 0.0001;
    GJPublicCellModel *row3 =  [GJPublicCellModel new];
    row3.cellID = kYuJiangChuliMarkTag;
    row3.cellHeight = 40;
    [sectionTwo.rowArrays addObject:row3];
    GJPublicCellModel *row4 =  [GJPublicCellModel new];
    row4.cellID = kYuJiangChuliContactTag;
    row4.cellHeight = 40;
    [sectionTwo.rowArrays addObject:row4];
    
    GJPublicCellModel *row5 =  [GJPublicCellModel new];
    row5.cellID = kYuJiangChuliRcodeTag;
    row5.cellHeight = UITableViewAutomaticDimension;
    [sectionTwo.rowArrays addObject:row5];
    
    [self.dataList addObject:sectionOne];
    [self.dataList addObject:sectionTwo];

    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    GJPublicCellModel *sectionModel = self.dataList[section];
    return sectionModel.rowArrays.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    GJPublicCellModel *sectionModel = self.dataList[indexPath.section];
    GJPublicCellModel *a_model = sectionModel.rowArrays[indexPath.row];
    
    return a_model.cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GJPublicCellModel *sectionModel = self.dataList[indexPath.section];
    GJPublicCellModel *a_model = sectionModel.rowArrays[indexPath.row];
    
    UITableViewCell *cell;
    switch (a_model.cellID) {
        case kYuJiangInfoStatusTag:
        case kYuJiangChuliMarkTag:
        {
            GJSOSRemarkTableViewCell *tempCell = [tableView dequeueReusableCellWithIdentifier:@"sadasdasd123"];
            if (tempCell == nil) {
                tempCell = [[GJSOSRemarkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sadasdasd123"];
            }
            if (a_model.cellID == kYuJiangChuliMarkTag) {
                tempCell.statusTitle.hidden = YES;
                tempCell.remarkTitle.text = @"预警处理";
            }
            else{
                tempCell.statusTitle.hidden = NO;
                tempCell.remarkTitle.text = @"预警信息";
            }
            return tempCell;
        }
        case kYuJiangInfoDesTag:
        case kYuJiangChuliRcodeTag:
        {
            
            //GJSOSDetailRemark1TableViewCell
            GJSOSDetailRemark1TableViewCell *tempCell = [tableView dequeueReusableCellWithIdentifier:@"GJSOSDetailRemark1TableViewCell123"];
            if (tempCell == nil) {
                tempCell = [[GJSOSDetailRemark1TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GJSOSDetailRemark1TableViewCell123"];
            }
            if (a_model.cellID == kYuJiangChuliRcodeTag) {
                tempCell.contentLabel.text = self.sosContentModel.title;

            }
            else{
                tempCell.contentLabel.text = self.sosContentModel.sosContent;

            }
            return tempCell;
            
        }
            break;
            /*FIXME:预警处理，联系人 */
        case kYuJiangChuliContactTag:{
            GJStudentContactTableViewCell *tempCell = [tableView dequeueReusableCellWithIdentifier:@"GJStudentContactTableViewCell"];
            if (tempCell == nil) {
                tempCell = [[[NSBundle mainBundle] loadNibNamed:@"GJStudentContactTableViewCell" owner:self options:nil] firstObject];
                tempCell.teacherNameLabelLeftConstraint.constant = 15.0;
            }
            NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
            NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
            People *getObj = existArr[0];
            tempCell.teacherNameLabel.text = getObj.USERNAME;
            tempCell.telLabel.text = getObj.PHONE;
            return tempCell;
            break;
        }
            
        default:
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sdadsajdklasd"];
            break;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    GJPublicCellModel *sectionModel = self.dataList[section];
    return sectionModel.sectionFooderHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    GJPublicCellModel *sectionModel = self.dataList[section];
    return sectionModel.sectionHeaderHeight;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
