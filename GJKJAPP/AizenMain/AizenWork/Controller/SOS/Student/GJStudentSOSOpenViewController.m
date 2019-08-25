//
//  GJStudentSOSOpenViewController.m
//  GJKJAPP
//
//  Created by git burning on 2018/10/9.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "GJStudentSOSOpenViewController.h"
#import <MapKit/MapKit.h>
#import "GJStudentSOSHistoryViewController.h"
#import "GJPublicCellModel.h"
#import "GJSOSNewsTableViewCell.h"
#import "GJSOSRemarkTableViewCell.h"
#import "GJSOSDetailRemark1TableViewCell.h"
#import "GJStudentContactTableViewCell.h"


const NSInteger kStudentMarkTag = 1;
const NSInteger kStudentContactTag = 2;
const NSInteger kStudentNewsTag = 3;

@interface GJStudentSOSOpenViewController ()<MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) MKMapView *mapView;

@property double currLon;
@property double currLat;
@property (nonatomic,copy) NSString *br_locationStr;

@property(nonatomic,strong) CLLocationManager *mag;
@property(nonatomic,strong) CLGeocoder *ceocoder;

@property (nonatomic, strong) UILabel *locationLabel;

//@property (nonatomic,strong) UITableView *mTablewView;

@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation GJStudentSOSOpenViewController
-(void)setBr_locationStr:(NSString *)br_locationStr {
    _br_locationStr = br_locationStr;
//    self.locationLabel.text = [NSString stringWithFormat:@"当前位置:%@",br_locationStr];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"安全预警";
    _mapView = [[MKMapView alloc]init];
    _mapView.frame = CGRectMake(0, 0, WIDTH_SCREEN,150);
    _mapView.delegate = self;
//    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    [self.contentView addSubview:_mapView];
    self.locationLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.locationLabel];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.equalTo(self.mapView.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-10);
    }];
    self.locationLabel.text = @"当前位置:";
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"历史" style:UIBarButtonItemStyleDone target:self action:@selector(br_toList)];
    self.navigationItem.rightBarButtonItem = right;
    
    [self addGrounpTablewDelegate:self];
    
    [self.categoryTablew removeFromSuperview];
    [self.contentView addSubview:self.categoryTablew];
    
    [self.categoryTablew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.locationLabel.mas_bottom).offset(5);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.categoryTablew.separatorStyle = UITableViewCellSelectionStyleNone;
    self.categoryTablew.rowHeight = UITableViewAutomaticDimension;
    self.categoryTablew.estimatedRowHeight = 100;
    [self br_configData];
    
    UIButton *buttomBut = [UIButton buttonWithType:UIButtonTypeSystem];
    buttomBut.backgroundColor = kAppMainColor;
    [buttomBut setTitle:@"SOS 预警处理" forState:UIControlStateNormal];
    [self.contentView addSubview:buttomBut];
    [buttomBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [buttomBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view.
}

- (void)br_toList{
    GJStudentSOSHistoryViewController *next = [[GJStudentSOSHistoryViewController alloc] init];
    [self.navigationController pushViewController:next animated:YES];

}


#pragma mark - CLLocationManager
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if([self.mag respondsToSelector:@selector(requestAlwaysAuthorization)]){
                [self.mag requestWhenInUseAuthorization];
                break;
            }
        case kCLAuthorizationStatusDenied:{
            [BaseViewController br_showAlterMsg:@"请去设置中心开启相关权限" sureBlock:^(id info) {
                [BaseViewController br_toSetting];
            }];
        }
            
            break;
        default:
            break;
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *newLocation = locations[0];
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"city = %@", city);
            
            if([[AizenStorage readUserDataWithKey:@"isCheck"] isEqualToString:@"1"]){
                _currLat = oldCoordinate.latitude;
                _currLon = oldCoordinate.longitude;
                //                UITapGestureRecognizer *goCheckAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CheckOutAction:)];
                //                goCheckAction.accessibilityHint = [NSString stringWithFormat:@"%@%@%@",city,placemark.subLocality,placemark.name];
                //                [_InnerRingView addGestureRecognizer:goCheckAction];
                
                self.br_locationStr = [[NSString stringWithFormat:@"%@%@%@",city,placemark.subLocality,placemark.name] copy];
                
            }else{
                _currLat = oldCoordinate.latitude;
                _currLon = oldCoordinate.longitude;
                //                UITapGestureRecognizer *goCheckAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CheckWorkAction:)];
                //                goCheckAction.accessibilityHint = [NSString stringWithFormat:@"%@%@%@",city,placemark.subLocality,placemark.name];
                //                [_InnerRingView addGestureRecognizer:goCheckAction];
                
                self.br_locationStr = [[NSString stringWithFormat:@"%@%@%@",city,placemark.subLocality,placemark.name] copy];
                
            }
        }else if (error == nil && [array count] == 0){
            NSLog(@"No results were returned.");
        }else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
        
    }];
    
    [manager stopUpdatingLocation];
}



- (void)br_configData{
    self.dataList = [NSMutableArray arrayWithCapacity:0];
    
    GJPublicCellModel *sectionOne = [[GJPublicCellModel alloc] init];
    sectionOne.rowArrays = [NSMutableArray arrayWithCapacity:0];
    
    sectionOne.sectionHeaderHeight = 10.0;
    sectionOne.sectionFooderHeight = 0.0001;
    
    GJPublicCellModel *row1 =  [GJPublicCellModel new];
    row1.cellID = kStudentMarkTag;
    row1.cellHeight = 40.0;
    [sectionOne.rowArrays addObject:row1];

    //kStudentContactTag
    GJPublicCellModel *row2 =  [GJPublicCellModel new];
    row2.cellID = kStudentContactTag;
    row2.cellHeight = 40.0;
    [sectionOne.rowArrays addObject:row2];
    GJPublicCellModel *row3 =  [GJPublicCellModel new];
    row3.cellID = kStudentContactTag;
    row3.cellHeight = 40.0;
    [sectionOne.rowArrays addObject:row3];
    
    //kStudentNewsTag
    
    GJPublicCellModel *sectionTwo = [[GJPublicCellModel alloc] init];
    sectionTwo.rowArrays = [NSMutableArray arrayWithCapacity:0];
    sectionTwo.sectionHeaderHeight = 0.0001;
    sectionTwo.sectionFooderHeight = 40.0;
    
    GJPublicCellModel *row4 =  [GJPublicCellModel new];
    row4.cellID = kStudentNewsTag;
    row4.cellHeight = [GJSOSNewsTableViewCell br_getUITableViewCellHeight];
    [sectionTwo.rowArrays addObject:row4];
    GJPublicCellModel *row5 =  [GJPublicCellModel new];
    row5.cellID = kStudentNewsTag;
    row5.cellHeight = [GJSOSNewsTableViewCell br_getUITableViewCellHeight];
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    GJPublicCellModel *sectionModel = self.dataList[section];
    return sectionModel.sectionFooderHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    GJPublicCellModel *sectionModel = self.dataList[section];
    return sectionModel.sectionHeaderHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GJPublicCellModel *sectionModel = self.dataList[indexPath.section];
    GJPublicCellModel *a_model = sectionModel.rowArrays[indexPath.row];
    
    UITableViewCell *cell;
    switch (a_model.cellID) {
        case kStudentMarkTag:
        {
            GJSOSRemarkTableViewCell *tempCell = [tableView dequeueReusableCellWithIdentifier:@"sadasdasd123"];
            if (tempCell == nil) {
                tempCell = [[GJSOSRemarkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sadasdasd123"];
            }

                tempCell.statusTitle.hidden = YES;
                tempCell.remarkTitle.text = @"紧急联系人";
            return tempCell;
        }
        
            /*FIXME:预警处理，联系人 */
        case kStudentContactTag:{
            GJStudentContactTableViewCell *tempCell = [tableView dequeueReusableCellWithIdentifier:@"GJStudentContactTableViewCell"];
            if (tempCell == nil) {
                tempCell = [[[NSBundle mainBundle] loadNibNamed:@"GJStudentContactTableViewCell" owner:self options:nil] firstObject];
                tempCell.teacherNameLabelLeftConstraint.constant = 15.0;
            }
            return tempCell;
            break;
        }
        case kStudentNewsTag:{
            
            GJSOSNewsTableViewCell *tempCell = [tableView dequeueReusableCellWithIdentifier:@"GJSOSNewsTableViewCell"];
            if (tempCell == nil) {
                tempCell = [[[NSBundle mainBundle] loadNibNamed:@"GJSOSNewsTableViewCell" owner:self options:nil] firstObject];
            }
            return tempCell;
            break;
        }
            
        default:
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sdadsajdklasd"];
            break;
    }
    
    return cell;
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
