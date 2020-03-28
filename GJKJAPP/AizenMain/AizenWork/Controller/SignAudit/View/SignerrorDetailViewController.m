//
//  SignerrorDetailViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/3/27.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "SignerrorDetailViewController.h"
#import <MapKit/MapKit.h>
#import "DisplayMap.h"
#import <AVFoundation/AVFoundation.h>     //添加静态库头文件
#import "MoLocationManager.h"
#import "ZKAnnotation.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "PhoneInfo.h"
#import "People.h"
#import "MainViewController.h"
#import "DGActivityIndicatorView.h"
@interface SignerrorDetailViewController ()<MKMapViewDelegate>

@property(nonatomic,strong) MKMapView *mapView;
@property(nonatomic,strong) CLLocationManager *mag;
@property(nonatomic,strong) CLGeocoder *ceocoder;

@property(nonatomic,strong) UIView *contentView;

@property(nonatomic,strong) UIView *detailView;

@property(nonatomic,strong) UIView *auditView;
@property(nonatomic,strong) UILabel *auditLab;
@property(nonatomic,strong) UILabel *auditValue;

@property(nonatomic,strong) UIView *dateView;
@property(nonatomic,strong) UILabel *dateLab;
@property(nonatomic,strong) UILabel *dateValue;

@property(nonatomic,strong) UIView *placeView;
@property(nonatomic,strong) UILabel *placeLab;
@property(nonatomic,strong) UITextView *placeValue;

@property(nonatomic,strong) UIView *remarkView;
@property(nonatomic,strong) UILabel *remarkLab;
@property(nonatomic,strong) UITextView *remarkValue;

@property(nonatomic,strong) UIButton *confirmBtn;

@property (nonatomic, strong) DGActivityIndicatorView *activityIndicatorView;

@end

@implementation SignerrorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *title = [NSString stringWithFormat:@"%@的签退审核",[_getArr objectForKey:@"UserName"]];
    self.navigationItem.title = title;
    
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_STATUSBAR - HEIGHT_NAVBAR);
    _contentView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
    UIColor *loadingColor = [[MainViewController colorWithHexString:@"#0092ff"] copy];
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:loadingColor];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    _activityIndicatorView.layer.zPosition = 1000;
    [_contentView addSubview:_activityIndicatorView];
    
    
    _mapView = [[MKMapView alloc]init];
    _mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, _contentView.frame.size.height * 0.3);
    _mapView.delegate = self;
//    [_mapView setShowsUserLocation:NO];
//    _mapView.showsUserLocation = NO;
//    _mapView.userTrackingMode = MKUserTrackingModeFollow;
//    _mapView.userInteractionEnabled = NO;
    [_contentView addSubview:_mapView];
    
    
//    _mag = [[CLLocationManager alloc]init];
//    _mag.delegate = self;
//    _mag.desiredAccuracy=kCLLocationAccuracyBest;//指定需要的精度级别
//    _mag.distanceFilter=1000.0f;//设置距离筛选器
//    [_mag startUpdatingLocation];
//    [_mag requestAlwaysAuthorization];
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiCheckWork/GetByID?ID=%@",kCacheHttpRoot,[_getArr objectForKey:@"ID"]];
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        NSDictionary *jsonDic = result;
        [self setAnnotation:[jsonDic objectForKey:@"AppendData"]];
        NSLog(@"%@",jsonDic);
    } failue:^(NSError *error) {
        NSLog(@"请求网络错误----签退详情");
    }];
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if (annotation == mapView.userLocation){
        NSLog(@"user看看谁先进来");
        return nil;
    }
    else if ([annotation isKindOfClass:[ZKAnnotation class]]) {
        MKPinAnnotationView *view = (id)[mapView dequeueReusableAnnotationViewWithIdentifier:@"sadasdaasd"];
        if (view == nil) {
            view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"sadasdaasd"];
            
        }
        view.annotation = annotation;
        view.pinTintColor = [kAppMainColor copy];
     
        return view;
        
      
        
    }
    return nil;
  
}
-(void) setAnnotation:(NSArray *)dataArr{
    if (![dataArr isKindOfClass:[NSArray class]] || dataArr.count <= 0) {
        return;
    }
    NSDictionary *getDic = dataArr[0];
    NSLog(@"%@",getDic);
    
    ZKAnnotation *annotation = [[ZKAnnotation alloc]init];
    CLLocationDegrees lat = [[getDic objectForKey:@"CheckOutLat"] doubleValue];
    CLLocationDegrees lon = [[getDic objectForKey:@"CheckOutLon"] doubleValue];
    annotation.coordinate = CLLocationCoordinate2DMake(lat,lon);
    annotation.title = @"打卡地点";
    annotation.subtitle = [getDic objectForKey:@"CheckOutPlace"];
    [_mapView addAnnotation:annotation];
  //  [_mapView selectAnnotation:annotation animated:YES];
    
//    MKCoordinateSpan span = [self.mapView sp];
//    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
   
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion reqion = MKCoordinateRegionMake(annotation.coordinate, span);
    [_mapView setRegion:reqion];
 //   [_mapView setCenterCoordinate:annotation.coordinate animated:YES];
    _detailView = [[UIView alloc]init];
    _detailView.frame = CGRectMake(0, _mapView.frame.size.height + _mapView.frame.origin.y + _contentView.frame.size.height * 0.02, self.view.frame.size.width, _contentView.frame.size.height - _mapView.frame.size.height - _contentView.frame.size.height * 0.02);
    _detailView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_detailView];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(_detailView.frame.size.width * 0.05, 0, _detailView.frame.size.width * 0.95, 1);
    lineView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [_detailView addSubview:lineView];
    
    
    _auditView = [[UIView alloc]init];
    _auditView.frame = CGRectMake(_detailView.frame.size.width * 0.05, 0, _detailView.frame.size.width * 0.9,_detailView.frame.size.height * 0.1);
    [_detailView addSubview:_auditView];
    
    _auditLab = [[UILabel alloc]init];
    _auditLab.frame = CGRectMake(0, 0, _auditView.frame.size.width * 0.25, _auditView.frame.size.height);
    _auditLab.text = @"打卡类型:";
    _auditLab.textColor = [UIColor colorWithRed:133/255.0 green:142/255.0 blue:153/255.0 alpha:1];
    _auditLab.font = [UIFont systemFontOfSize:16.0];
    [_auditView addSubview:_auditLab];
    
    
    _auditValue = [[UILabel alloc]init];
    _auditValue.frame = CGRectMake(_auditLab.frame.size.width, 0, _auditView.frame.size.width * 0.75, _auditView.frame.size.height);
    _auditValue.textColor = [UIColor blackColor];
    _auditValue.text = @"下班签到"; // [[_getArr objectForKey:@"ID"] stringValue];
    _auditValue.font = [UIFont systemFontOfSize:16.0];
    [_auditView addSubview:_auditValue];
    
    
    _dateView = [[UIView alloc]init];
    _dateView.frame = CGRectMake(_detailView.frame.size.width * 0.05, _auditView.frame.size.height + _auditView.frame.origin.y, _detailView.frame.size.width * 0.9, _detailView.frame.size.height * 0.1);
    [_detailView addSubview:_dateView];
    
    
    NSRange rang = {0,10};
    NSString *timeStartStr = [[[[_getArr objectForKey:@"CheckOutDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
    
    
    _dateLab = [[UILabel alloc]init];
    _dateLab.frame = CGRectMake(0, 0, _dateView.frame.size.width * 0.25, _dateView.frame.size.height);
    _dateLab.textColor = [UIColor colorWithRed:133/255.0 green:142/255.0 blue:153/255.0 alpha:1];
    _dateLab.text = @"签到时间:";
    _dateLab.font = [UIFont systemFontOfSize:16.0];
    [_dateView addSubview:_dateLab];
    
    _dateValue = [[UILabel alloc]init];
    _dateValue.frame = CGRectMake(_dateLab.frame.size.width, 0, _dateView.frame.size.width * 0.75, _dateView.frame.size.height);
    _dateValue.textColor = [UIColor blackColor];
    _dateValue.text = [PhoneInfo timestampSwitchTime:[timeStartStr integerValue]  andFormatter:@"YYYY-MM-dd HH:mm:ss"];
    _dateValue.font = [UIFont systemFontOfSize:16.0];
    [_dateView addSubview:_dateValue];
    
    
    _placeView = [[UIView alloc]init];
    _placeView.frame = CGRectMake(_detailView.frame.size.width * 0.05, _dateView.frame.size.height + _dateView.frame.origin.y, _detailView.frame.size.width * 0.9, _detailView.frame.size.height * 0.2);
    [_detailView addSubview:_placeView];
    
    
    _placeLab = [[UILabel alloc]init];
    _placeLab.frame = CGRectMake(0, 0, _placeView.frame.size.width * 0.25, _placeView.frame.size.height * 0.5);
    _placeLab.textColor = [UIColor colorWithRed:133/255.0 green:142/255.0 blue:153/255.0 alpha:1];
    _placeLab.font = [UIFont systemFontOfSize:16.0];
    _placeLab.text = @"打卡地点:";
    [_placeView addSubview:_placeLab];
    
    
    _placeValue = [[UITextView alloc]init];
    _placeValue.frame = CGRectMake(_placeLab.frame.size.width, 0, _placeView.frame.size.width * 0.75, _placeView.frame.size.height);
    _placeValue.textColor = [UIColor blackColor];
    _placeValue.font = [UIFont systemFontOfSize:16.0];
    _placeValue.text = [_getArr objectForKey:@"CheckOutPlace"];
    _placeValue.textAlignment = NSTextAlignmentLeft;
    [_placeValue setEditable:NO];
    [_placeView addSubview:_placeValue];
    
    
    
    _remarkView = [[UIView alloc]init];
    _remarkView.frame = CGRectMake(_detailView.frame.size.width * 0.05, _placeView.frame.size.height + _placeView.frame.origin.y, _detailView.frame.size.width * 0.9, _detailView.frame.size.height * 0.2);
    [_detailView addSubview:_remarkView];
    
    
    _remarkLab = [[UILabel alloc]init];
    _remarkLab.frame = CGRectMake(0, 0, _remarkView.frame.size.width * 0.25, _remarkView.frame.size.height * 0.5);
    _remarkLab.textColor = [UIColor colorWithRed:133/255.0 green:142/255.0 blue:153/255.0 alpha:1];
    _remarkLab.font = [UIFont systemFontOfSize:16.0];
    _remarkLab.text = @"备注内容:";
    [_remarkView addSubview:_remarkLab];
    
    
    _remarkValue = [[UITextView alloc]init];
    _remarkValue.frame = CGRectMake(_remarkLab.frame.size.width, 0, _remarkView.frame.size.width * 0.75, _remarkView.frame.size.height);
    _remarkValue.textColor = [UIColor blackColor];
    _remarkValue.font = [UIFont systemFontOfSize:16.0];
    _remarkValue.textAlignment = NSTextAlignmentLeft;
    [_remarkView addSubview:_remarkValue];
    
    
    
    
    
    _confirmBtn = [[UIButton alloc]init];
    _confirmBtn.frame = CGRectMake(0, _detailView.frame.size.height * 0.88, _detailView.frame.size.width, _detailView.frame.size.height * 0.12);
    _confirmBtn.backgroundColor = [UIColor colorWithRed:43/255.0 green:161/255.0 blue:244/255.0 alpha:1];
    [_confirmBtn setTitle:@"审批" forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [_detailView addSubview:_confirmBtn];
    
}


-(void) confirmAction:(UIButton *)sender{
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *ID = [_getArr objectForKey:@"ID"];
    NSString *Remark = _remarkValue.text;
    NSString *CurrTime = [PhoneInfo getNowTimeTimestamp3];
    NSString *Token = [AizenMD5 MD5ForUpper16Bate: [NSString stringWithFormat:@"%@%@GJCheck%@",ID,CurrTime,CurrAdminID]];
    [_activityIndicatorView startAnimating];
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiCheckWork/ConfirmCheckOut",kCacheHttpRoot];
    NSLog(@"%@",url);
    NSDictionary *param = @{@"AdminID":CurrAdminID,
                            @"ID":ID,
                            @"Remark":Remark,
                            @"TimeStamp":CurrTime,
                            @"Token":Token
    };
    
    
    [AizenHttp asynRequest:url httpMethod:@"GET" params:param success:^(id result) {
        NSDictionary *jsonDic = result;
        [_activityIndicatorView stopAnimating];

        NSString *msg = [jsonDic objectForKey:@"Message"];
        if ([msg isKindOfClass:[NSNull class]]) {
            msg = @"提交失败，请重试";
        }
        if([[jsonDic objectForKey:@"ReslutType"] intValue] == 0){
            NSLog(@"%@",[jsonDic objectForKey:@"Message"]);
            msg = @"提交成功";
            [BaseViewController br_showAlterMsg:msg sureBlock:^(id info) {
                if (self.updateBlock) {
                    self.updateBlock(nil);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        }else{
            NSLog(@"%@",[jsonDic objectForKey:@"Message"]);
            [BaseViewController br_showAlterMsg:msg];
            
        }
    } failue:^(NSError *error) {
        NSLog(@"请求失败----确认签到");
        [_activityIndicatorView stopAnimating];
        [BaseViewController br_showAlterMsg:@"提交失败，请重试"];


    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
