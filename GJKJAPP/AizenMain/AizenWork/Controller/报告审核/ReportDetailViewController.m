
//
//  ReportDetailViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/4/4.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "ReportDetailViewController.h"
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
#import "GJShenheViewController.h"
#import "IBCreatHelper.h"
#import "ZKAnnotation.h"
@interface ReportDetailViewController ()<MKMapViewDelegate,CLLocationManagerDelegate,PGDatePickerDelegate,UITextFieldDelegate>
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

@property (nonatomic, strong) UIView *xuegongView;
@property (nonatomic, strong) UILabel *tijiaorenLb;
@property (nonatomic, strong) UILabel *xuehaoLb;
@property (nonatomic, strong) UILabel *xuehaoValueLb;

@property (nonatomic, strong) UIView *phoneView;
@property (nonatomic, strong) UILabel *phoneLb;
@property (nonatomic, strong) UILabel *phoneValue;

@property (nonatomic, strong) UIView *xiaozuView;
@property (nonatomic, strong) UILabel *xiaozuLb;
@property (nonatomic, strong) UILabel *xiaozuKey;
@property (nonatomic, strong) UILabel *xiaozuValue;

@property (nonatomic, strong) UIView *kaishiView;
@property (nonatomic, strong) UILabel *kaishiLb;
@property (nonatomic, strong) UILabel *kaishiValue;

@property (nonatomic, strong) UIView *jieshuView;
@property (nonatomic, strong) UILabel *jieshuLb;
@property (nonatomic, strong) UILabel *jieshuValue;

@property (nonatomic, strong) UIView *qiyeView;
@property (nonatomic, strong) UILabel *qiyeLb;
@property (nonatomic, strong) UILabel *qiyeValue;


@property double placeLat;
@property double placeLon;
@end

@implementation ReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"报告详情";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    [_submitBtn setTitle:self.shenhe == 1?@"审核":@"撤销审核" forState:UIControlStateNormal];
    _submitBtn.font = [UIFont systemFontOfSize:18.0];
    [_submitBtn addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_submitBtn];
    
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[UIColor lightGrayColor]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [_dataScrollView addSubview:_activityIndicatorView];
    
    
    [self httpFind];
}


-(void) httpFind{
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipInspectionTeamInfo/GetByID?RecordID=%@",kCacheHttpRoot,self.recordID];
    
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

//-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
//    if (annotation == mapView.userLocation){
//        NSLog(@"user看看谁先进来");
//        return nil;
//    }
//    else if ([annotation isKindOfClass:[ZKAnnotation class]]) {
//        MKPinAnnotationView *view = (id)[mapView dequeueReusableAnnotationViewWithIdentifier:@"sadasdaasd"];
//        if (view == nil) {
//            view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"sadasdaasd"];
//            
//        }
//        view.annotation = annotation;
//        view.pinTintColor = [kAppMainColor copy];
//        
//        return view;
//        
//        
//        
//    }
//    return nil;
//    
//}

-(void)setAnnotation
{
    ZKAnnotation *annotation = [[ZKAnnotation alloc]init];
    CLLocationDegrees lat = [[_detailAllDic objectForKey:@"RecordLat"]doubleValue];
    CLLocationDegrees lon = [[_detailAllDic objectForKey:@"RecordLon"]doubleValue];
    annotation.coordinate = CLLocationCoordinate2DMake(lat,lon);
    annotation.title = @"巡查地点";
    annotation.subtitle = [_detailAllDic objectForKey:@"RecordPlace"];
    [_mapView addAnnotation:annotation];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion reqion = MKCoordinateRegionMake(annotation.coordinate, span);
    [_mapView setRegion:reqion];
}

-(void) detailLayout{
    
    _mapView = [[MKMapView alloc]init];
    _mapView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height * 0.3);
    _mapView.delegate = self;
    [_dataScrollView addSubview:_mapView];
    [self setAnnotation];
    
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
    
    
    _xuegongView = [[UIView alloc]initWithFrame:CGRectMake(0, _locationView.xo_bottomY, _locationView.xo_width, _contentView.frame.size.height *0.12)];
    [_dataScrollView addSubview:_xuegongView];
    
    _tijiaorenLb = [[UILabel alloc]init];
    _tijiaorenLb.frame = CGRectMake(_xuegongView.frame.size.width * 0.03, _xuegongView.frame.size.height * 0.05, _xuegongView.frame.size.width * 0.40, _xuegongView.frame.size.height * 0.30);
    _tijiaorenLb.text = @"提交人信息";
    _tijiaorenLb.textColor = [UIColor lightGrayColor];
    _tijiaorenLb.font = [UIFont systemFontOfSize:13.0];
    [_xuegongView addSubview:_tijiaorenLb];
    
    _xuehaoLb = [[UILabel alloc]init];
    _xuehaoLb.frame = CGRectMake(_xuegongView.frame.size.width * 0.03, _xuegongView.frame.size.height * 0.45, _xuegongView.frame.size.width * 0.40, _xuegongView.frame.size.height * 0.45);
    _xuehaoLb.text = @"学工号";
    _xuehaoLb.font = [UIFont systemFontOfSize:15.0];
    [_xuegongView addSubview:_xuehaoLb];
    
    _xuehaoValueLb = [[UILabel alloc]init];
    _xuehaoValueLb.frame = CGRectMake(_xuegongView.xo_width * 0.50, _xuegongView.frame.size.height * 0.45, _xuegongView.frame.size.width * 0.45, _xuegongView.frame.size.height * 0.45);
    _xuehaoValueLb.text = [_detailAllDic objectForKey:@"UserNo"];
    _xuehaoValueLb.textAlignment = NSTextAlignmentRight;
    _xuehaoValueLb.font = [UIFont systemFontOfSize:16.0];
    [_xuegongView addSubview:_xuehaoValueLb];
    UIView *xuehaoLine = [[UIView alloc]init];
    xuehaoLine.frame = CGRectMake(_xuegongView.frame.size.width * 0.03, _xuegongView.frame.size.height - 1, _xuegongView.frame.size.width * 0.97, 1);
    xuehaoLine.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_xuegongView addSubview:xuehaoLine];

    
    _phoneView = [[UIView alloc]initWithFrame:CGRectMake(0, _xuegongView.xo_bottomY, _xuegongView.xo_width, _contentView.frame.size.height *0.08)];
    [_dataScrollView addSubview:_phoneView];
    
    _phoneLb = [[UILabel alloc]init];
    _phoneLb.frame = CGRectMake(_phoneView.frame.size.width * 0.03, _phoneView.frame.size.height * 0.1, _phoneView.frame.size.width * 0.40, _phoneView.frame.size.height * 0.8);
    _phoneLb.text = @"联系电话";
    _phoneLb.font = [UIFont systemFontOfSize:15.0];
    [_phoneView addSubview:_phoneLb];
    
    _phoneValue = [[UILabel alloc]init];
    _phoneValue.frame = CGRectMake(_phoneView.xo_width * 0.50, _phoneView.frame.size.height * 0.1, _phoneView.frame.size.width * 0.45, _phoneView.frame.size.height * 0.8);
    _phoneValue.text = [_detailAllDic objectForKey:@"Mobile"];
    _phoneValue.textAlignment = NSTextAlignmentRight;
    _phoneValue.font = [UIFont systemFontOfSize:16.0];
    [_phoneView addSubview:_phoneValue];
    
    UIView *phoneLine = [[UIView alloc]init];
    phoneLine.frame = CGRectMake(_phoneView.frame.size.width * 0.03, _phoneView.frame.size.height - 1, _phoneView.frame.size.width * 0.97, 1);
    phoneLine.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_phoneView addSubview:phoneLine];
    
    
    _xiaozuView = [[UIView alloc]initWithFrame:CGRectMake(0, _phoneView.xo_bottomY, _locationView.xo_width, _contentView.frame.size.height *0.12)];
    [_dataScrollView addSubview:_xiaozuView];
    
    _xiaozuLb = [[UILabel alloc]init];
    _xiaozuLb.frame = CGRectMake(_xiaozuView.frame.size.width * 0.03, _xiaozuView.frame.size.height * 0.05, _xiaozuView.frame.size.width * 0.40, _xiaozuView.frame.size.height * 0.30);
    _xiaozuLb.text = @"小组信息";
    _xiaozuLb.textColor = [UIColor lightGrayColor];
    _xiaozuLb.font = [UIFont systemFontOfSize:13.0];
    [_xiaozuView addSubview:_xiaozuLb];
    
    _xiaozuKey = [[UILabel alloc]init];
    _xiaozuKey.frame = CGRectMake(_xiaozuView.frame.size.width * 0.03, _xiaozuView.frame.size.height * 0.45, _xiaozuView.frame.size.width * 0.40, _xiaozuView.frame.size.height * 0.45);
    _xiaozuKey.text = @"小组";
    _xiaozuKey.font = [UIFont systemFontOfSize:15.0];
    [_xiaozuView addSubview:_xiaozuKey];
    
    _xiaozuValue = [[UILabel alloc]init];
    _xiaozuValue.frame = CGRectMake(_xiaozuView.xo_width * 0.50, _xiaozuView.frame.size.height * 0.45, _xiaozuView.frame.size.width * 0.45, _xiaozuView.frame.size.height * 0.45);
    _xiaozuValue.text = [_detailAllDic objectForKey:@"InspectionTeamName"];
    _xiaozuValue.textAlignment = NSTextAlignmentRight;
    _xiaozuValue.font = [UIFont systemFontOfSize:16.0];
    [_xiaozuView addSubview:_xiaozuValue];
    UIView *xiaozuLine = [[UIView alloc]init];
    xiaozuLine.frame = CGRectMake(_xiaozuView.frame.size.width * 0.03, _xiaozuView.frame.size.height - 1, _xuegongView.frame.size.width * 0.97, 1);
    xiaozuLine.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_xiaozuView addSubview:xiaozuLine];

    _kaishiView = [[UIView alloc]initWithFrame:CGRectMake(0, _xiaozuView.xo_bottomY, _locationView.xo_width, _contentView.frame.size.height *0.08)];
    [_dataScrollView addSubview:_kaishiView];
    
    _kaishiLb = [[UILabel alloc]init];
    _kaishiLb.frame = CGRectMake(_kaishiView.frame.size.width * 0.03, _kaishiView.frame.size.height * 0.1, _kaishiView.frame.size.width * 0.40, _kaishiView.frame.size.height * 0.8);
    _kaishiLb.text = @"开始时间";
    _kaishiLb.font = [UIFont systemFontOfSize:15.0];
    [_kaishiView addSubview:_kaishiLb];
    
    _kaishiValue = [[UILabel alloc]init];
    _kaishiValue.frame = CGRectMake(_kaishiView.xo_width * 0.50, _kaishiView.frame.size.height * 0.1, _kaishiView.frame.size.width * 0.45, _kaishiView.frame.size.height * 0.8);
    NSRange rang = {0,10};
    NSString *StartTime = [[[[_detailAllDic objectForKey:@"CreateDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
    _kaishiValue.text = [PhoneInfo timestampSwitchTime:[StartTime integerValue] andFormatter:@"YYYY-MM-dd"];// HH:mm:ss
    _kaishiValue.textAlignment = NSTextAlignmentRight;
    _kaishiValue.font = [UIFont systemFontOfSize:16.0];
    [_kaishiView addSubview:_kaishiValue];
    
    UIView *kaishiLine = [[UIView alloc]init];
    kaishiLine.frame = CGRectMake(_kaishiView.frame.size.width * 0.03, _kaishiView.frame.size.height - 1, _kaishiView.frame.size.width * 0.97, 1);
    kaishiLine.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_kaishiView addSubview:kaishiLine];
    
    _jieshuView = [[UIView alloc]initWithFrame:CGRectMake(0, _kaishiView.xo_bottomY, _locationView.xo_width, _contentView.frame.size.height *0.08)];
    [_dataScrollView addSubview:_jieshuView];
    
    _jieshuLb = [[UILabel alloc]init];
    _jieshuLb.frame = CGRectMake(_jieshuView.frame.size.width * 0.03, _jieshuView.frame.size.height * 0.1, _jieshuView.frame.size.width * 0.40, _jieshuView.frame.size.height * 0.8);
    _jieshuLb.text = @"结束时间";
    _jieshuLb.font = [UIFont systemFontOfSize:15.0];
    [_jieshuView addSubview:_jieshuLb];
    
    _jieshuValue = [[UILabel alloc]init];
    _jieshuValue.frame = CGRectMake(_jieshuView.xo_width * 0.50, _jieshuView.frame.size.height * 0.1, _jieshuView.frame.size.width * 0.45, _jieshuView.frame.size.height * 0.8);
    NSString *endTime = [[[[_detailAllDic objectForKey:@"EndDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
    _jieshuValue.text = [PhoneInfo timestampSwitchTime:[endTime integerValue] andFormatter:@"YYYY-MM-dd"];// HH:mm:ss
    _jieshuValue.textAlignment = NSTextAlignmentRight;
    _jieshuValue.font = [UIFont systemFontOfSize:16.0];
    [_jieshuView addSubview:_jieshuValue];
    
    UIView *jieshuLine = [[UIView alloc]init];
    jieshuLine.frame = CGRectMake(_jieshuView.frame.size.width * 0.03, _jieshuView.frame.size.height - 1, _jieshuView.frame.size.width * 0.97, 1);
    jieshuLine.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_jieshuView addSubview:jieshuLine];
    
    
    _qiyeView = [[UIView alloc]initWithFrame:CGRectMake(0, _jieshuView.xo_bottomY, _locationView.xo_width, _contentView.frame.size.height *0.08)];
    [_dataScrollView addSubview:_qiyeView];
    
    _qiyeLb = [[UILabel alloc]init];
    _qiyeLb.frame = CGRectMake(_qiyeView.frame.size.width * 0.03, _qiyeView.frame.size.height * 0.1, _qiyeView.frame.size.width * 0.40, _phoneView.frame.size.height * 0.8);
    _qiyeLb.text = @"受检企业";
    _qiyeLb.font = [UIFont systemFontOfSize:15.0];
    [_qiyeView addSubview:_qiyeLb];
    
    _qiyeValue = [[UILabel alloc]init];
    _qiyeValue.frame = CGRectMake(_qiyeView.xo_width * 0.50, _qiyeView.frame.size.height * 0.1, _qiyeView.frame.size.width * 0.45, _phoneView.frame.size.height * 0.8);
    _qiyeValue.text = [_detailAllDic objectForKey:@"EnterpriseName"];
    _qiyeValue.textAlignment = NSTextAlignmentRight;
    _qiyeValue.font = [UIFont systemFontOfSize:16.0];
    [_qiyeView addSubview:_qiyeValue];
    
    UIView *qiyeLine = [[UIView alloc]init];
    qiyeLine.frame = CGRectMake(_qiyeView.frame.size.width * 0.03, _qiyeView.frame.size.height - 1, _qiyeView.frame.size.width * 0.97, 1);
    qiyeLine.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_qiyeView addSubview:qiyeLine];
    [self httpField];
    
}


-(void) httpField{
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipInspectionTeamInfo/GetRecordConfig?TeamID=%@",kCacheHttpRoot,self.teamId];
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
    
    CGFloat oneView = _qiyeView.frame.size.height;
    
    NSDictionary *dataDic = [sender objectForKey:@"AppendData"];
    NSArray *keys = dataDic.allKeys;
    int num = 0;
    for(int i = 0;i<keys.count;i++){
        if([keys[i] containsString:@"Field"]){
            if(![[NSString checkNull:dataDic[keys[i]]] isEqualToString:@""]){
                /*写布局------------------------------------start*/
                if ([dataDic[keys[i]] isKindOfClass:[NSNull class]]) {
                    continue;
                }
                UIView *FieldView = [[UIView alloc]init];
                FieldView.frame = CGRectMake(0, _qiyeView.frame.origin.y + _qiyeView.frame.size.height + height * num, _dataScrollView.frame.size.width,height);
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
    
    CGFloat scrollHeight = _mapView.frame.size.height + _xuegongView.frame.size.height + _phoneView.frame.size.height + height * num + _locationView.frame.size.height + _xiaozuView.xo_height + _kaishiView.xo_height + _jieshuView.xo_height + _qiyeView.xo_height;
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


-(void)modifyAction:(UIButton *)sender
{
        GJShenheViewController *vc = getControllerFromStoryBoard(@"Worker", @"myshenheSbID");
        vc.pid = self.recordID;
        vc.shenheType = self.shenhe == 1?shenheType_report:shenheType_reportcexiao;
        [self.navigationController pushViewController:vc animated:YES];
}
@end
