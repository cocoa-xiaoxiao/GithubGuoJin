//
//  PatrolTaskLookViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/6/9.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "PatrolTaskLookViewController.h"
#import <MapKit/MapKit.h>
#import "DisplayMap.h"
#import <AVFoundation/AVFoundation.h>     //添加静态库头文件
#import "MoLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "PGDatePickManager.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "AizenHttp.h"
#import "AizenMD5.h"
#import "AizenStorage.h"
#import "People.h"
#import "PhoneInfo.h"
#import "RAlertView.h"

@interface PatrolTaskLookViewController ()<MKMapViewDelegate,CLLocationManagerDelegate,PGDatePickerDelegate,UITextFieldDelegate>

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIScrollView *dataScrollView;
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@property(nonatomic,strong) MKMapView *mapView;
@property(nonatomic,strong) CLLocationManager *mag;
@property(nonatomic,strong) CLGeocoder *ceocoder;

@property(nonatomic,strong) UIButton *submitBtn;

@property(nonatomic,strong) UIView *locationView;
@property(nonatomic,strong) UILabel *locationLab;


@property(nonatomic,strong) UIView *dateView;
@property(nonatomic,strong) UILabel *dateLab;
@property(nonatomic,strong) UILabel *dateValue;


@property(nonatomic,strong) UIView *titleView;
@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) UITextField *titleValue;

@property(nonatomic,strong) NSMutableDictionary *detailAllDic;


@property double placeLat;
@property double placeLon;

@end

@implementation PatrolTaskLookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"查看报告";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[self reSizeImage:[UIImage imageNamed:@"shanchu"] toSize:CGSizeMake(30, 30)] style:UIBarButtonItemStyleDone target:self action:@selector(deleteAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
    [self startLayout];
}

-(void) startLayout{
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_NAVBAR + HEIGHT_STATUSBAR, self.view.frame.size.width, self.view.frame.size.height - (HEIGHT_STATUSBAR + HEIGHT_NAVBAR));
    _contentView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
    
    
    _dataScrollView = [[UIScrollView alloc]init];
    _dataScrollView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height - _contentView.frame.size.height * 0.08);
    _dataScrollView.delegate = self;
    _dataScrollView.contentSize = CGSizeMake(_contentView.frame.size.width, _contentView.frame.size.height * 2);
    [_contentView addSubview:_dataScrollView];
    
    
    _submitBtn = [[UIButton alloc]init];
    _submitBtn.frame = CGRectMake(0, _contentView.frame.size.height - _contentView.frame.size.height * 0.08, _contentView.frame.size.width, _contentView.frame.size.height * 0.08);
    _submitBtn.backgroundColor = [UIColor colorWithRed:1/255.0 green:137/255.0 blue:255/255.0 alpha:1];
    [_submitBtn setTitle:@"修改" forState:UIControlStateNormal];
    _submitBtn.font = [UIFont systemFontOfSize:18.0];
    [_submitBtn addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_submitBtn];
    
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[UIColor lightGrayColor]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [_dataScrollView addSubview:_activityIndicatorView];
    
    
    [self httpFind];
}


-(void) httpFind{
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipInspectionTeamInfo/GetByID?RecordID=%@",kCacheHttpRoot,[_dataDic objectForKey:@"ID"]];
    
    _detailAllDic = [[NSMutableDictionary alloc]init];
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
            _detailAllDic = [[[jsonDic objectForKey:@"AppendData"] objectAtIndex:0] mutableCopy];
            [self detailLayout];
        }
    } failue:^(NSError *error) {
        NSLog(@"请求失败--获取巡察报告列表");
    }];
    
}


-(void) detailLayout{

    _mapView = [[MKMapView alloc]init];
    _mapView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height * 0.3);
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    _mapView.userInteractionEnabled = NO;
    [_dataScrollView addSubview:_mapView];
    
    _mag = [[CLLocationManager alloc]init];
    _mag.delegate = self;
    _mag.desiredAccuracy=kCLLocationAccuracyBest;//指定需要的精度级别
    _mag.distanceFilter=1000.0f;//设置距离筛选器
    [_mag startUpdatingLocation];
    [_mag requestAlwaysAuthorization];
    
    
    _locationView = [[UIView alloc]init];
    _locationView.frame = CGRectMake(0, _mapView.frame.size.height + _mapView.frame.origin.y, _mapView.frame.size.width, _contentView.frame.size.height * 0.05);
    [_dataScrollView addSubview:_locationView];
    
    _locationLab = [[UILabel alloc]init];
    _locationLab.frame = CGRectMake(_locationView.frame.size.width * 0.03, _locationView.frame.size.height * 0.1, _locationView.frame.size.width * 0.94, _locationView.frame.size.height * 0.8);
    _locationLab.text = [NSString stringWithFormat:@"提交位置：%@",[_detailAllDic objectForKey:@"RecordPlace"]];
    _locationLab.textColor = [UIColor lightGrayColor];
    _locationLab.font = [UIFont systemFontOfSize:13.0];
    [_locationView addSubview:_locationLab];
    
    UIView *locationLine = [[UIView alloc]init];
    locationLine.frame = CGRectMake(_locationView.frame.size.width * 0.03, _locationView.frame.size.height - 1, _locationView.frame.size.width * 0.94, 1);
    locationLine.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_locationView addSubview:locationLine];
    
    
    
    _dateView = [[UIView alloc]init];
    _dateView.frame = CGRectMake(0, _locationView.frame.size.height + _locationView.frame.origin.y, _mapView.frame.size.width, _contentView.frame.size.height * 0.08);
    [_dataScrollView addSubview:_dateView];
    
    _dateLab = [[UILabel alloc]init];
    _dateLab.frame = CGRectMake(_dateView.frame.size.width * 0.03, _dateView.frame.size.height * 0.1, _dateView.frame.size.width * 0.3, _dateView.frame.size.height * 0.8);
    _dateLab.font = [UIFont systemFontOfSize:15.0];
    _dateLab.text = @"报告时间：";
    [_dateView addSubview:_dateLab];
    
    _dateValue = [[UILabel alloc]init];
    _dateValue.frame = CGRectMake(_dateLab.frame.size.width + _dateLab.frame.origin.x, _dateLab.frame.origin.y, _dateView.frame.size.width * 0.64, _dateView.frame.size.height * 0.8);
    _dateValue.textAlignment = UITextAlignmentRight;
    _dateValue.text = [PhoneInfo handleDateStr:[_detailAllDic objectForKey:@"RecordDate"] handleFormat:@"yyyy-MM-dd"];
    if(![[_detailAllDic objectForKey:@"RecordDate"] isEqualToString:@""]){
        _dateValue.textColor = [UIColor blackColor];
    }
    _dateValue.font = [UIFont systemFontOfSize:16.0];
    _dateValue.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    _dateValue.userInteractionEnabled = YES;
    UITapGestureRecognizer *dateTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateAction:)];
    [_dateValue addGestureRecognizer:dateTap];
    [_dateView addSubview:_dateValue];
    
    
    UIView *dateLine = [[UIView alloc]init];
    dateLine.frame = CGRectMake(_dateView.frame.size.width * 0.03, _dateView.frame.size.height - 1, _dateView.frame.size.width * 0.97, 1);
    dateLine.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_dateView addSubview:dateLine];
    
    
    
    _titleView = [[UIView alloc]init];
    _titleView.frame = CGRectMake(0, _dateView.frame.size.height + _dateView.frame.origin.y, _dateView.frame.size.width, _dateView.frame.size.height);
    [_dataScrollView addSubview:_titleView];
    
    
    _titleLab = [[UILabel alloc]init];
    _titleLab.frame = CGRectMake(_titleView.frame.size.width * 0.03, _titleView.frame.size.height * 0.1, _titleView.frame.size.width * 0.3, _titleView.frame.size.height * 0.8);
    _titleLab.text = @"报告标题：";
    _titleLab.font = [UIFont systemFontOfSize:15.0];
    [_titleView addSubview:_titleLab];
    
    
    
    _titleValue = [[UITextField alloc]init];
    _titleValue.frame = CGRectMake(_titleLab.frame.origin.x + _titleLab.frame.size.width, _titleView.frame.size.height * 0.1, _titleView.frame.size.width * 0.64, _titleView.frame.size.height * 0.8);
    _titleValue.placeholder = @"请输入标题";
    _titleValue.text = [_detailAllDic objectForKey:@"RecordTitle"];
    _titleValue.textAlignment = UITextAlignmentRight;
    _titleValue.delegate = self;
    _titleValue.userInteractionEnabled = YES;
    [_titleView addSubview:_titleValue];
    
    UIView *titleLine = [[UIView alloc]init];
    titleLine.frame = CGRectMake(_titleView.frame.size.width * 0.03, _titleView.frame.size.height - 1, _titleView.frame.size.width * 0.97, 1);
    titleLine.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_titleView addSubview:titleLine];
    
    
    
    [self httpField];
    
}


-(void) httpField{
    NSLog(@"%@",_dataDic);
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipInspectionTeamInfo/GetRecordConfig?TeamID=%@",kCacheHttpRoot,[_frontDataDic objectForKey:@"InspectionTeamID"]];
    NSLog(@"%@",url);
    [_activityIndicatorView startAnimating];
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
            [self handleDynamic:jsonDic];
        }
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败--获取巡察获取动态字段");
    }];
}




-(void) handleDynamic:(NSDictionary *)sender{
    CGFloat height = _contentView.frame.size.height * 0.3;
    
    CGFloat oneView = _dateView.frame.size.height;
    
    NSDictionary *dataDic = [sender objectForKey:@"AppendData"];
    NSArray *keys = dataDic.allKeys;
    int num = 0;
    for(int i = 0;i<keys.count;i++){
        if([keys[i] containsString:@"Field"]){
            if(![dataDic[keys[i]] isEqualToString:@""]){
                /*写布局------------------------------------start*/
                if ([dataDic[keys[i]] isKindOfClass:[NSNull class]]) {
                    continue;
                }
                UIView *FieldView = [[UIView alloc]init];
                FieldView.frame = CGRectMake(0, _titleView.frame.origin.y + _titleView.frame.size.height + height * num, _dataScrollView.frame.size.width,height);
                FieldView.accessibilityLabel = keys[i];
                [_dataScrollView addSubview:FieldView];
                
                
                UILabel *FieldLab = [[UILabel alloc]init];
                FieldLab.frame = CGRectMake(FieldView.frame.size.width * 0.03, oneView * 0.1, FieldView.frame.size.width * 0.47, oneView * 0.8);
                FieldLab.text = [NSString stringWithFormat:@"%@：",dataDic[keys[i]]];
                FieldLab.font = [UIFont systemFontOfSize:15.0];
                [FieldView addSubview:FieldLab];
                
                
                UITextView *FieldText = [[UITextView alloc]init];
                FieldText.frame = CGRectMake(FieldLab.frame.origin.x, FieldLab.frame.size.height + FieldLab.frame.origin.y,FieldView.frame.size.width * 0.94, FieldView.frame.size.height - oneView * 0.2 - FieldLab.frame.size.height);
                FieldText.backgroundColor = [UIColor clearColor];
                NSLog(@"%@",keys[i]);
                FieldText.text = [_detailAllDic objectForKey:keys[i]] == [NSNull null]?@"":[_detailAllDic objectForKey:keys[i]];
                FieldText.accessibilityLabel = @"haveValue";
                [FieldView addSubview:FieldText];
                
                
                UIView *Line = [[UIView alloc]init];
                Line.frame = CGRectMake(FieldView.frame.size.width * 0.03, FieldView.frame.size.height - 1, FieldView.frame.size.width * 0.97, 1);
                Line.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
                [FieldView addSubview:Line];
                /*写布局------------------------------------end*/
                
                num++;
            }
        }
    }
    
    CGFloat scrollHeight = _mapView.frame.size.height + _dateView.frame.size.height + _titleView.frame.size.height + height * num + _locationView.frame.size.height;
    _dataScrollView.contentSize = CGSizeMake(_contentView.frame.size.width, scrollHeight + 100);
    
}





-(void) dateAction:(UITapGestureRecognizer *)sender{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGDatePickerType3;//PGPickerViewType3;
    datePicker.datePickerMode = PGDatePickerModeDate;
    datePicker.accessibilityHint = @"date";
    [self presentViewController:datePickManager animated:false completion:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- UIScrollViewDelege
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y<0){
        //往下拉是小于0
        NSLog(@"%f",scrollView.contentOffset.y);
    }
}


#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    // 位置发生变化调用
    NSLog(@"lan = %f, long = %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    _placeLat = userLocation.coordinate.latitude;
    _placeLon = userLocation.coordinate.longitude;
    
}


#pragma mark - CLLocationManager
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        casekCLAuthorizationStatusNotDetermined:
            if([self.mag respondsToSelector:@selector(requestAlwaysAuthorization)]){
                [self.mag requestWhenInUseAuthorization];
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
    _placeLat = oldCoordinate.latitude;
    _placeLon = oldCoordinate.longitude;
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //获取城市
            NSString *city = placemark.locality;
            NSMutableDictionary *addressDic = [[NSMutableDictionary alloc]init];
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"city = %@", city);
            NSLog(@"locality = %@",placemark.locality);
            NSLog(@"subLocality = %@",placemark.subLocality);
            NSLog(@"thoroughfare = %@",placemark.thoroughfare);
            NSLog(@"subThoroughfare = %@",placemark.subThoroughfare);
            NSLog(@"name = %@",placemark.name);
            NSLog(@"postalCode = %@",placemark.postalCode);
            
            NSString *addressStr = [NSString stringWithFormat:@"当前位置：%@%@%@%@",city == nil?@"":city,placemark.subLocality == nil?@"":placemark.subLocality,placemark.thoroughfare == nil?@"":placemark.thoroughfare,placemark.subThoroughfare == nil?@"":placemark.subThoroughfare];
            
//            _locationLab.text = addressStr;
            
        }else if (error == nil && [array count] == 0){
            NSLog(@"No results were returned.");
        }else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
        
    }];
    
    [manager stopUpdatingLocation];
}


#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    
    if([datePicker.accessibilityHint isEqualToString:@"date"]){
        NSString *dateStr = [NSString stringWithFormat:@"%d-%d-%d",dateComponents.year,dateComponents.month,dateComponents.day];
        _dateValue.text = dateStr;
        _dateValue.textColor = [UIColor blackColor];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_dataScrollView endEditing:YES];
}

#pragma mark UITextFieldDeletege
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}



-(void) modifyAction:(UIButton *)sender{
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipInspectionTeamInfo/Modify",kCacheHttpRoot];
    
    
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    
    
    if([_titleValue.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写报告名称" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        if([_dateValue.text isEqualToString:@"请选择"] || [_dateValue.text isEqualToString:@""]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写报告时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            [params setObject:CurrAdminID forKey:@"Creater"];
            [params setObject:[_dataDic objectForKey:@"ID"] forKey:@"ID"];
            [params setObject:_dateValue.text forKey:@"RecordDate"];
            [params setObject:_titleValue.text forKey:@"RecordTitle"];
            
            
            for(UIView *subView in _dataScrollView.subviews){
                if(subView.accessibilityLabel != nil){
                    for(UITextView *subTextView in subView.subviews){
                        if([subTextView.accessibilityLabel isEqualToString:@"haveValue"]){
                            [params setObject:subTextView.text forKey:subView.accessibilityLabel];
                        }
                    }
                }
            }
            
            
            NSString *currTime = [PhoneInfo getNowTimeTimestamp3];
            [params setObject:currTime forKey:@"TimeStamp"];
            
            NSString *tokenStr = [NSString stringWithFormat:@"%@GJInspection%@",[_dataDic objectForKey:@"ID"],currTime];
            NSString *getToken = [AizenMD5 MD5ForUpper16Bate:tokenStr];
            [params setObject:getToken forKey:@"Token"];
            
            NSString *placeLatStr = [NSString stringWithFormat:@"%f",_placeLat];
            NSString *placeLonStr = [NSString stringWithFormat:@"%f",_placeLon];
            [params setObject:placeLatStr forKey:@"RecordLat"];
            [params setObject:placeLonStr forKey:@"RecordLon"];
            
            
            NSString *locationStr = [_locationLab.text stringByReplacingOccurrencesOfString:@"当前位置：" withString:@""];
            [params setObject:locationStr forKey:@"RecordPlace"];
            
            [_activityIndicatorView startAnimating];
            [AizenHttp asynRequest:url httpMethod:@"POST" params:params success:^(id result) {
                [_activityIndicatorView stopAnimating];
                NSDictionary *jsonDic = result;
                if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
                    RAlertView *alert = [[RAlertView alloc] initWithStyle:ConfirmAlert];
                    alert.headerTitleLabel.text = @"提示";
                    alert.contentTextLabel.attributedText = [TextHelper attributedStringForString:[jsonDic objectForKey:@"Message"] lineSpacing:5];
                    [alert.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
                    [alert.confirmButton setBackgroundColor:[UIColor colorWithRed:20/255.0 green:184/255.0 blue:247/255.0 alpha:1]];
                    alert.confirm = ^(){
                        NSLog(@"Click on the Ok");
                    };
                }else{
                    RAlertView *alert = [[RAlertView alloc] initWithStyle:ConfirmAlert];
                    alert.headerTitleLabel.text = @"提示";
                    alert.contentTextLabel.attributedText = [TextHelper attributedStringForString:[jsonDic objectForKey:@"Message"] lineSpacing:5];
                    [alert.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
                    [alert.confirmButton setBackgroundColor:[UIColor colorWithRed:240/255.0 green:46/255.0 blue:55/255.0 alpha:1]];
                    alert.confirm = ^(){
                        NSLog(@"Click on the Ok");
                    };
                }
            } failue:^(NSError *error) {
                [_activityIndicatorView stopAnimating];
                NSLog(@"请求失败--提交巡察报告");
            }];
            
            
        }
    }

    
}


- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [reSizeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


-(void) deleteAction:(UIBarButtonItem *)sender{
    NSLog(@"%@",_dataDic);
    NSLog(@"%@",_frontDataDic);
    
   
    
    RAlertView *alert = [[RAlertView alloc] initWithStyle:CancelAndConfirmAlert];
    alert.headerTitleLabel.text = @"提示";
    alert.contentTextLabel.attributedText = [TextHelper attributedStringForString:@"确定要删除该报告吗？" lineSpacing:5];
    [alert.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [alert.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [alert.confirmButton setBackgroundColor:[UIColor colorWithRed:20/255.0 green:184/255.0 blue:247/255.0 alpha:1]];
    alert.confirm = ^(){
        
        NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
        NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
        People *getObj = existArr[0];
        NSString *CurrAdminID = [getObj.USERID stringValue];
        NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
        
        NSString *currTime = [PhoneInfo getNowTimeTimestamp3];
        
        NSString *getToken = [NSString stringWithFormat:@"%@GJInspection%@",[_dataDic objectForKey:@"ID"],currTime];
        NSString *handleToken = [AizenMD5 MD5ForUpper16Bate:getToken];
        
        NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipInspectionTeamInfo/Delete?RecordID=%@&AdminID=%@&TimeStamp=%@&Token=%@",kCacheHttpRoot,[_dataDic objectForKey:@"ID"],CurrAdminID,currTime,handleToken];

        
        [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
            NSDictionary *jsonDic = result;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[jsonDic objectForKey:@"Message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        } failue:^(NSError *error) {
            NSLog(@"请求失败--删除报告");
        }];
        
        
    };
    alert.cancel = ^(){
        NSLog(@"cancel");
    };
}



@end
