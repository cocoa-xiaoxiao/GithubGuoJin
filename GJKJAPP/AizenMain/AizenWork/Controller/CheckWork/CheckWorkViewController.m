//
//  CheckWorkViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/2/9.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "CheckWorkViewController.h"
#import <MapKit/MapKit.h>
#import "DisplayMap.h"
#import <AVFoundation/AVFoundation.h>     //添加静态库头文件
#import "MoLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "People.h"
#import "AizenStorage.h"
#import "AizenHttp.h"
#import "AizenMD5.h"
#import "PhoneInfo.h"
#import "RDVTabBarController.h"
#import "DGActivityIndicatorView.h"
#import "BRCheckWorkModel.h"
#import "BRTodyRecordListViewController.h"
#define kuploadImageUrlKey @"sadasdasdkuploadImageUrlKey"
@interface CheckWorkViewController ()<MKMapViewDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,CLLocationManagerDelegate>{
    NSString *test;
}
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong) UIImagePickerController * picker;
@property (nonatomic, strong) UIImageView             * showFirstImg;
@property (nonatomic, strong) UIImageView             * showSecondImg;
@property (nonatomic, strong) UIImageView             * showThirdImg;
@property (nonatomic, strong) UIImageView             * showFourthImg;
@property (nonatomic, strong) AVPlayer                * player;

@property (nonatomic, strong) NSMutableArray *ImgArr;

@property(nonatomic,strong) MKMapView *mapView;
@property(nonatomic,strong) CLLocationManager *mag;
@property(nonatomic,strong) CLGeocoder *ceocoder;

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIView *decrView;
@property(nonatomic,strong) UIView *photoView;
@property(nonatomic,strong) UIView *BtnshowView;

@property(nonatomic,strong) UIView *decrTopView;
@property(nonatomic,strong) UITextField *decrTextView;

@property(nonatomic,strong) UIView *photoTopView;
@property(nonatomic,strong) UIView *photoContentView;
@property(nonatomic,strong) UIImageView *takePhoto;
@property(nonatomic,strong) UIView *photoContentTopView;
@property(nonatomic,strong) UIView *photoContentBottomView;

@property(nonatomic,strong) UIView *OuterRingView;
@property(nonatomic,strong) UIView *OuterRingView1;
@property CAAnimationGroup *groups;
@property(nonatomic,strong) UIView *InnerRingView;
@property(nonatomic,strong) UILabel *showStatusLab;

@property double currLon;
@property double currLat;
@property (nonatomic,copy) NSString *br_locationStr;

@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic,strong) BRCheckWorkModel *recodeInfo;
@end

@implementation CheckWorkViewController

-(void)setBr_locationStr:(NSString *)br_locationStr {
    _br_locationStr = br_locationStr;
    self.locationLabel.text = [NSString stringWithFormat:@"当前位置:%@",br_locationStr];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"打卡考勤";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    _ImgArr = [[NSMutableArray alloc]initWithObjects:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"NO",@"value", @"1",@"Num",nil],[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"NO",@"value", @"2",@"Num",nil],[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"NO",@"value", @"3",@"Num",nil],[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"NO",@"value", @"4",@"Num",nil], nil];
    [[self rdv_tabBarController]setTabBarHidden:YES animated:YES];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"今日记录" style:UIBarButtonItemStyleDone target:self action:@selector(br_toTodayRecodeList)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
    rightItem.enabled = NO;
    
    [self startLayout];

    WS(ws);
    [self br_CheckTodayHadWork:^(BOOL success, NSArray *list,NSString *msg) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws br_configOtherView];
            });
        }
        else{
            [BaseViewController br_showAlterMsg:msg];
        }
    }];
}


/**
 打卡记录
 */
- (void)br_toTodayRecodeList{
    if (self.recodeInfo.signCount == 0) {
        [BaseViewController br_showAlterMsg:@"今天没有打卡记录"];
        return;
    }
    
    BRTodyRecordListViewController *vc = [[BRTodyRecordListViewController alloc] init];
    vc.infoModel = self.recodeInfo;
    [self cb_presentPopupViewController:vc animationType:CBPopupViewAnimationSlideFromBottom aligment:CBPopupViewAligmentBottom overlayDismissed:^{
        
    }];
}

//MARK:今日签到状态
- (void)br_CheckTodayHadWork:(void(^)(BOOL success, NSArray*list,NSString* msg))block {

    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *CurrDate = [PhoneInfo getCurrentTimes:@"YYYY-MM-dd"];
//    CurrDate = @"2018-9-10";
    NSString *url = [NSString stringWithFormat:@"%@/ApiCheckWork/IsCheck?AdminID=%@&CheckDate=%@",kCacheHttpRoot,CurrAdminID,CurrDate];
    [_activityIndicatorView startAnimating];
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        [_activityIndicatorView stopAnimating];

        NSInteger ResultType = [jsonDic[@"ResultType"] integerValue];
        if (ResultType == 0) {
            self.recodeInfo = [[BRCheckWorkModel alloc] initWithDictionary:jsonDic[@"AppendData"] error:nil];
            if (block) {
                block(YES,nil,@"获取失败");
            }
        }
        else{
            NSString *Message = jsonDic[@"Message"];
            self.recodeInfo = [[BRCheckWorkModel alloc] init];
            if (block) {
                block(YES,nil,Message);
            }
        }
        self.navigationItem.rightBarButtonItem.enabled = YES;

     

    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        if (block) {
            block(NO,nil,@"获取失败");
        }
    }];

}

-(void) startLayout{
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, self.view.frame.size.width, self.view.frame.size.height - (HEIGHT_STATUSBAR + HEIGHT_NAVBAR));
    _contentView.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    [self.view addSubview:_contentView];
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[kAppMainColor copy]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    _activityIndicatorView.startingNotUserInterface = YES;
    [_contentView addSubview:_activityIndicatorView];
    _activityIndicatorView.layer.zPosition = 1000;
    
    _mapView = [[MKMapView alloc]init];
    _mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, _contentView.frame.size.height * 0.3);
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    _mapView.userInteractionEnabled = NO;
    [_contentView addSubview:_mapView];

    _locationLabel = [[UILabel alloc] init];
    [_mapView addSubview:_locationLabel];
    _locationLabel.font = [UIFont systemFontOfSize:15];
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
    }];
    
    _mag = [[CLLocationManager alloc]init];
    _mag.delegate = self;
    _mag.desiredAccuracy=kCLLocationAccuracyBest;//指定需要的精度级别
    _mag.distanceFilter=1000.0f;//设置距离筛选器
    [_mag startUpdatingLocation];
    [_mag requestAlwaysAuthorization];
    
//
//    CLLocationCoordinate2D coordinate = {30.26667, 120.20000};
//    [_mapView setCenterCoordinate:coordinate animated:YES];
//
//    [_mapView setCenterCoordinate:_mapView.userLocation.coordinate animated:YES];
//
//    MKCoordinateRegion theRegion = { {0.0, 0.0 }, { 0.0, 0.0 } };
//    theRegion.center=[[_mag location] coordinate];
//    [_mag release];
//    [_mapView setZoomEnabled:YES];
//    [_mapView setScrollEnabled:YES];
//    theRegion.span.longitudeDelta = 0.02f;
//    theRegion.span.latitudeDelta = 0.02f;
//    [_mapView setRegion:theRegion animated:YES];
//
//    DisplayMap *ann = [[DisplayMap alloc] init];
//    ann.title = @"这里才行";
//    ann.subtitle = @"打卡地点";
//    ann.coordinate = theRegion.center;
//    [_mapView addAnnotation:ann];
//
    
   
  
}

- (void)br_configOtherView {
    /*-------------------------------布局其他View-----------------------------------*/
    _decrView = [[UIView alloc]init];
    _decrView.frame = CGRectMake(0, _mapView.frame.size.height + _mapView.frame.origin.y + 8, _contentView.frame.size.width, _contentView.frame.size.height * 0.15);
    _decrView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_decrView];
    
    _photoView = [[UIView alloc]init];
    _photoView.frame = CGRectMake(0, _decrView.frame.size.height + _decrView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height * 0.25);
    _photoView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_photoView];
    
    _BtnshowView = [[UIView alloc]init];
    _BtnshowView.frame = CGRectMake(0, _photoView.frame.size.height + _photoView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height * 0.3 - 8);
    _BtnshowView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_BtnshowView];
    
    
    _decrTopView = [[UIView alloc]init];
    _decrTopView.frame = CGRectMake(0, 0, _decrView.frame.size.width, _decrView.frame.size.height * 0.25);
    [_decrView addSubview:_decrTopView];
    
    UIView *decrlefttop = [[UIView alloc]init];
    decrlefttop.frame = CGRectMake(_decrTopView.frame.size.width * 0.03, _decrTopView.frame.size.height * 0.15, 5, _decrTopView.frame.size.height * 0.7);
    decrlefttop.backgroundColor = [UIColor colorWithRed:0/255.0 green:142/255.0 blue:255/255.0 alpha:1];
    [_decrTopView addSubview:decrlefttop];
    
    UILabel *decrLab = [[UILabel alloc]init];
    decrLab.frame = CGRectMake(decrlefttop.frame.size.width * 3 + decrlefttop.frame.origin.x, _decrTopView.frame.size.height * 0.15, _decrTopView.frame.size.width * 0.5, _decrTopView.frame.size.height * 0.7);
    decrLab.text = @"打卡描述";
    decrLab.textColor = [UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:1];
    decrLab.font = [UIFont systemFontOfSize:13.0];
    [_decrTopView addSubview:decrLab];
    
    _decrTextView = [[UITextField alloc]init];
    _decrTextView.frame = CGRectMake(_decrView.frame.size.width * 0.03, _decrTopView.frame.size.height + _decrTopView.frame.origin.y, _decrView.frame.size.width * 0.94, _decrView.frame.size.height * 0.75);
    _decrTextView.placeholder = @"请填写打卡描述（非 必填）";
    [_decrView addSubview:_decrTextView];
    
    
    _photoTopView = [[UIView alloc]init];
    _photoTopView.frame = CGRectMake(0, 0, _photoView.frame.size.width, _photoView.frame.size.height * 0.15);
    [_photoView addSubview:_photoTopView];
    
    UIView *photolefttop = [[UIView alloc]init];
    photolefttop.frame = CGRectMake(_photoTopView.frame.size.width * 0.03, _photoTopView.frame.size.height * 0.15, 5, _photoTopView.frame.size.height * 0.7);
    photolefttop.backgroundColor = [UIColor colorWithRed:0/255.0 green:142/255.0 blue:255/255.0 alpha:1];
    [_photoTopView addSubview:photolefttop];
    
    UILabel *photoLab = [[UILabel alloc]init];
    photoLab.frame = CGRectMake(photolefttop.frame.size.width * 3 + photolefttop.frame.origin.x, _photoTopView.frame.size.height * 0.15, _photoTopView.frame.size.width * 0.5, _photoTopView.frame.size.height * 0.7);
    photoLab.text = @"拍照上传";
    photoLab.font = [UIFont systemFontOfSize:13.0];
    photoLab.textColor = [UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:1];
    [_photoTopView addSubview:photoLab];
    
    _photoContentView = [[UIView alloc]init];
    _photoContentView.frame = CGRectMake(_photoView.frame.size.width * 0.03, _photoTopView.frame.size.height + _photoTopView.frame.origin.y, _photoView.frame.size.width * 0.94, _photoView.frame.size.height * 0.85);
    [_photoView addSubview:_photoContentView];
    
    _photoContentTopView = [[UIView alloc]init];
    _photoContentTopView.frame = CGRectMake(0, 0, _photoContentView.frame.size.width, _photoContentView.frame.size.height * 0.6);
    [_photoContentView addSubview:_photoContentTopView];
    
    _photoContentBottomView = [[UIView alloc]init];
    _photoContentBottomView.frame = CGRectMake(0, _photoContentTopView.frame.size.height, _photoContentView.frame.size.width, _photoContentView.frame.size.height * 0.4);
    [_photoContentView addSubview:_photoContentBottomView];
    
    
    _showFirstImg = [[UIImageView alloc]init];
    _showFirstImg.frame = CGRectMake(((_photoContentTopView.frame.size.width / 4) - _photoContentTopView.frame.size.height * 0.8) / 2, _photoContentTopView.frame.size.height * 0.125, _photoContentTopView.frame.size.height * 0.8, _photoContentTopView.frame.size.height * 0.7);
    _showFirstImg.image = [UIImage imageNamed:@"gj_default"];
    UITapGestureRecognizer *FirstTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteImgView:)];
    FirstTap.accessibilityHint = @"1";
    _showFirstImg.userInteractionEnabled = YES;
    [_showFirstImg addGestureRecognizer:FirstTap];
    [_photoContentTopView addSubview:_showFirstImg];
    
    
    _showSecondImg = [[UIImageView alloc]init];
    _showSecondImg.frame = CGRectMake(_showFirstImg.frame.size.width + _showFirstImg.frame.origin.x + ((_photoContentTopView.frame.size.width / 4) - _photoContentTopView.frame.size.height * 0.8), _photoContentTopView.frame.size.height * 0.125, _photoContentTopView.frame.size.height * 0.8, _photoContentTopView.frame.size.height * 0.7);
    _showSecondImg.image = [UIImage imageNamed:@"gj_default"];
    UITapGestureRecognizer *SecondTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteImgView:)];
    SecondTap.accessibilityHint = @"2";
    _showSecondImg.userInteractionEnabled = YES;
    [_showSecondImg addGestureRecognizer:SecondTap];
    [_photoContentTopView addSubview:_showSecondImg];
    
    
    _showThirdImg = [[UIImageView alloc]init];
    _showThirdImg.frame = CGRectMake(_showSecondImg.frame.size.width + _showSecondImg.frame.origin.x + ((_photoContentTopView.frame.size.width / 4) - _photoContentTopView.frame.size.height * 0.8), _photoContentTopView.frame.size.height * 0.125, _photoContentTopView.frame.size.height * 0.8, _photoContentTopView.frame.size.height * 0.7);
    _showThirdImg.image = [UIImage imageNamed:@"gj_default"];
    UITapGestureRecognizer *ThirdTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteImgView:)];
    ThirdTap.accessibilityHint = @"3";
    [_showThirdImg addGestureRecognizer:ThirdTap];
    _showThirdImg.userInteractionEnabled = YES;
    [_photoContentTopView addSubview:_showThirdImg];
    
    
    _showFourthImg = [[UIImageView alloc]init];
    _showFourthImg.frame = CGRectMake(_showThirdImg.frame.size.width + _showThirdImg.frame.origin.x + ((_photoContentTopView.frame.size.width / 4) - _photoContentTopView.frame.size.height * 0.8), _photoContentTopView.frame.size.height * 0.125, _photoContentTopView.frame.size.height * 0.8, _photoContentTopView.frame.size.height * 0.7);
    _showFourthImg.image = [UIImage imageNamed:@"gj_default"];
    UITapGestureRecognizer *FourthTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteImgView:)];
    FourthTap.accessibilityHint = @"4";
    [_showFourthImg addGestureRecognizer:FourthTap];
    _showFourthImg.userInteractionEnabled = YES;
    [_photoContentTopView addSubview:_showFourthImg];
    
    _takePhoto = [[UIImageView alloc]init];
    _takePhoto.frame = CGRectMake(((_photoContentBottomView.frame.size.width / 4) - _photoContentBottomView.frame.size.height * 0.7) / 2, _photoContentBottomView.frame.size.height * 0.15, _photoContentBottomView.frame.size.height * 0.7, _photoContentBottomView.frame.size.height * 0.7);
    _takePhoto.image = [UIImage imageNamed:@"gj_takephoto"];
    UITapGestureRecognizer *takePhotoAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(FromCamera:)];
    [_takePhoto addGestureRecognizer:takePhotoAction];
    _takePhoto.userInteractionEnabled =YES;
    [_photoContentBottomView addSubview:_takePhoto];
    
    [self br_updateCheckStatusUI];
//    if([[AizenStorage readUserDataWithKey:@"isCheck"] isEqualToString:@"1"]){

    
}

/**
 刷新 打卡按钮状态UI
 */
- (void)br_updateCheckStatusUI{
//    self.recodeInfo.signCount = 2;
    if(self.recodeInfo.signCount == 1){
        NSLog(@"已经打卡");
        [_OuterRingView.layer removeAllAnimations];
        [_OuterRingView removeFromSuperview];
        _groups = nil;
        /*已经打卡*/
        _OuterRingView = [[UIView alloc]init];
        _OuterRingView.frame = CGRectMake((_BtnshowView.frame.size.width - _BtnshowView.frame.size.height * 0.8) / 2, _BtnshowView.frame.size.height * 0.1, _BtnshowView.frame.size.height * 0.8, _BtnshowView.frame.size.height * 0.8);
        _OuterRingView.backgroundColor = [UIColor colorWithRed:254/255.0 green:197/255.0 blue:103/255.0 alpha:1];
        _OuterRingView.layer.cornerRadius = _BtnshowView.frame.size.height * 0.8 / 2;
        _OuterRingView.layer.masksToBounds = YES;
        [_BtnshowView addSubview:_OuterRingView];
        
        _OuterRingView1 = [[UIView alloc]init];
        _OuterRingView1.frame = CGRectMake((_BtnshowView.frame.size.width - _BtnshowView.frame.size.height * 0.8) / 2, _BtnshowView.frame.size.height * 0.1, _BtnshowView.frame.size.height * 0.8, _BtnshowView.frame.size.height * 0.8);
        _OuterRingView1.backgroundColor = [UIColor colorWithRed:254/255.0 green:197/255.0 blue:103/255.0 alpha:1];
        _OuterRingView1.layer.cornerRadius = _BtnshowView.frame.size.height * 0.8 / 2;
        _OuterRingView1.layer.masksToBounds = YES;
        [_BtnshowView addSubview:_OuterRingView1];
        
        _InnerRingView = [[UIView alloc]init];
        _InnerRingView.frame = CGRectMake(_OuterRingView.frame.size.width * 0.075, _OuterRingView.frame.size.height * 0.075, _OuterRingView.frame.size.width * 0.85, _OuterRingView.frame.size.height * 0.85);
        _InnerRingView.backgroundColor = [UIColor whiteColor];
        _InnerRingView.layer.cornerRadius = _OuterRingView.frame.size.width * 0.85 / 2;
        _InnerRingView.layer.masksToBounds = YES;
        [_OuterRingView1 addSubview:_InnerRingView];
        
        
        _showStatusLab = [[UILabel alloc]init];
        _showStatusLab.frame = CGRectMake(_InnerRingView.frame.size.width * 0.15, _InnerRingView.frame.size.height * 0.4, _InnerRingView.frame.size.width * 0.75, _InnerRingView.frame.size.height * 0.2);
        _showStatusLab.text = @"下班打卡";
        _showStatusLab.textColor = [UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1];
        _showStatusLab.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:18];
        [_InnerRingView addSubview:_showStatusLab];
        
        
        [_OuterRingView.layer addAnimation:[self groups] forKey:nil];
        
        UITapGestureRecognizer *goCheckAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CheckOutAction:)];
        //        goCheckAction.accessibilityHint = [NSString stringWithFormat:@"%@%@%@",city,placemark.subLocality,placemark.name];
        [_InnerRingView addGestureRecognizer:goCheckAction];
    }else{
        NSLog(@"未打卡");
        /*未打卡*/
        [_OuterRingView.layer removeAllAnimations];
        [_OuterRingView removeFromSuperview];
        _groups = nil;
        _OuterRingView = [[UIView alloc]init];
        _OuterRingView.frame = CGRectMake((_BtnshowView.frame.size.width - _BtnshowView.frame.size.height * 0.8) / 2, _BtnshowView.frame.size.height * 0.1, _BtnshowView.frame.size.height * 0.8, _BtnshowView.frame.size.height * 0.8);
        _OuterRingView.backgroundColor = [UIColor colorWithRed:0/255.0 green:142/255.0 blue:255/255.0 alpha:1];
        _OuterRingView.layer.cornerRadius = _BtnshowView.frame.size.height * 0.8 / 2;
        _OuterRingView.layer.masksToBounds = YES;
        [_BtnshowView addSubview:_OuterRingView];
        
        _OuterRingView1 = [[UIView alloc]init];
        _OuterRingView1.frame = CGRectMake((_BtnshowView.frame.size.width - _BtnshowView.frame.size.height * 0.8) / 2, _BtnshowView.frame.size.height * 0.1, _BtnshowView.frame.size.height * 0.8, _BtnshowView.frame.size.height * 0.8);
        _OuterRingView1.backgroundColor = [UIColor colorWithRed:0/255.0 green:142/255.0 blue:255/255.0 alpha:1];
        _OuterRingView1.layer.cornerRadius = _BtnshowView.frame.size.height * 0.8 / 2;
        _OuterRingView1.layer.masksToBounds = YES;
        [_BtnshowView addSubview:_OuterRingView1];
        
        _InnerRingView = [[UIView alloc]init];
        _InnerRingView.frame = CGRectMake(_OuterRingView.frame.size.width * 0.075, _OuterRingView.frame.size.height * 0.075, _OuterRingView.frame.size.width * 0.85, _OuterRingView.frame.size.height * 0.85);
        _InnerRingView.backgroundColor = [UIColor whiteColor];
        _InnerRingView.layer.cornerRadius = _OuterRingView.frame.size.width * 0.85 / 2;
        _InnerRingView.layer.masksToBounds = YES;
        [_OuterRingView1 addSubview:_InnerRingView];
        
        
        _showStatusLab = [[UILabel alloc]init];
        _showStatusLab.frame = CGRectMake(0, _InnerRingView.frame.size.height * 0.4, _InnerRingView.frame.size.width * 1, _InnerRingView.frame.size.height * 0.2);
        _showStatusLab.text = @"上班打卡";
        _showStatusLab.textAlignment = NSTextAlignmentCenter;
        _showStatusLab.textColor = [UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1];
        _showStatusLab.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:18];
        [_InnerRingView addSubview:_showStatusLab];
        
        
        [_OuterRingView.layer addAnimation:[self groups] forKey:nil];
        
        
        
        if (self.recodeInfo.signCount == 0) {
            UITapGestureRecognizer *goCheckAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CheckWorkAction:)];
            //        goCheckAction.accessibilityHint = [NSString stringWithFormat:@"%@%@%@",city,placemark.subLocality,placemark.name];
            [_InnerRingView addGestureRecognizer:goCheckAction];
            _showStatusLab.adjustsFontSizeToFitWidth = NO;
            
        }
        else{
            _decrTextView.userInteractionEnabled = NO;
            _showStatusLab.text = @"今日完成上、下班打卡";
            _showStatusLab.adjustsFontSizeToFitWidth = YES;
            _takePhoto.userInteractionEnabled = NO;
            
        }
    }
}


-(void) deleteImgView:(UITapGestureRecognizer *)sender{
    NSString *flagStr = sender.accessibilityHint;
    
    BOOL *flagClick = NO;
    for(NSMutableDictionary *dic in _ImgArr){
        if([[dic objectForKey:@"Num"] isEqualToString:flagStr]){
            if([[dic objectForKey:@"value"] isEqualToString:@"YES"]){
                flagClick = YES;
            }
        }
    }
    
    
    
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否要删除此照片？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    if([flagStr isEqualToString:@"1"]){
        alertView.tag = 1;
    }else if([flagStr isEqualToString:@"2"]){
        alertView.tag = 2;
    }else if([flagStr isEqualToString:@"3"]){
        alertView.tag = 3;
    }else if([flagStr isEqualToString:@"4"]){
        alertView.tag = 4;
    }
    
    if(flagClick){
        [alertView show];
    }
    
}



// 调起拍照功能
- (void)FromCamera:(UITapGestureRecognizer *)sender{
    //相机功能是否可用，调用相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        //相机访问权限问题
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0) return;
        //Available in iOS 7.0 and later.
        AVAuthorizationStatus authstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authstatus ==AVAuthorizationStatusDenied){
            //用户关闭了权限
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"用户关闭了权限" delegate:self cancelButtonTitle:NSLocalizedString(@"OK",@"确定")otherButtonTitles:nil,nil];
            alertView.delegate =self;
            [alertView show];
        }else if (authstatus ==AVAuthorizationStatusRestricted){
            //The user is not allowed to access media capture devices.
            
            
        }else if (authstatus ==AVAuthorizationStatusNotDetermined){
            //Explicit user permission is required for media capture, but the user has not yet granted or denied such permission.
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted){
                    
                    
                }else{
                    
                }
            }];
        }else if (authstatus ==AVAuthorizationStatusAuthorized){
            //The user has explicitly granted permission for media capture, or explicit user permission is not necessary for the media type in question.
            
            NSString *flagImgView = @"";
            for(NSMutableDictionary *dic in _ImgArr){
                NSLog(@"%@",dic);
                if([[dic objectForKey:@"value"] isEqualToString:@"NO"]){
                    flagImgView = [dic objectForKey:@"Num"];
                    break;
                }
            }
            if (flagImgView.length == 0) {
                [BaseViewController br_showAlterMsg:@"最多选择4张图"];
                return;
            }
            
            _picker = [[UIImagePickerController alloc] init];
            _picker.delegate = (id)self;
            
            //1、默认选项是：UIImagePickerControllerSourceTypePhotoLibrary
            _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
#if 0
            //2-1、针对_picker.sourceType返回所有可用的mediaTypes.
            _picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            /*
             打印这个数组可以看到下边的结果
             mediaTypes = (
             "public.image",
             "public.movie"
             )
             */
            NSLog(@"mediaTypes = %@",_picker.mediaTypes);
#elif 0
            //2-2、所以还可以这么设置
            //             _picker.mediaTypes = [NSArray arrayWithObject:@"public.image"];
#elif 1
            //2-3、主要是下边的两能数，@"public.movie", @"public.image"  一个是录像，一个是拍照
            _picker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
#endif
            
            //3、是否允许对获得的图片进行编辑,default value is NO.
            _picker.allowsEditing   = YES;
            
            //4、显示相机的所有控件 默认YES
            _picker.showsCameraControls = YES;
            
            //5、set a view to overlay the preview view类似相框
            _picker.cameraOverlayView = nil;
            
            //6、设定图像缩放
            _picker.cameraViewTransform = CGAffineTransformScale(_picker.cameraViewTransform, 1.0, 1.0);
            
            //7、拍摄照片的清晰度，只有在照相机模式下可用
            /*
             拍摄照片的清晰度，只有在照相机模式下可用
             enum {
             UIImagePickerControllerQualityTypeHigh = 0,       // 高质量
             UIImagePickerControllerQualityType640x480 = 3,    // VGA quality
             UIImagePickerControllerQualityTypeMedium = 1,     // 中质量，适合于wifi传输
             UIImagePickerControllerQualityTypeLow = 2         // 低质量，适合于蜂窝数据传输
             };
             typedef NSUInteger UIImagePickerControllerQualityType;
             @property(nonatomic)           UIImagePickerControllerQualityType    videoQuality    //默认选中的是UIImagePickerControllerQualityTypeMedium
             */
            _picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
            
            
            //8、设置照相模式还是摄像模式
            /*
             可以设置照相机的模式，照相还是录视频，默认照相模式。
             enum {
             UIImagePickerControllerCameraCaptureModePhoto,//照相模式 默认模式
             UIImagePickerControllerCameraCaptureModeVideo//摄像模式
             };
             typedef NSUInteger   UIImagePickerControllerCameraCaptureMode;
             @property(nonatomic) UIImagePickerControllerCameraCaptureMode    cameraCaptureMode
             */
            _picker.cameraCaptureMode  = UIImagePickerControllerCameraCaptureModePhoto;
            
            //9、使用哪个摄像头
            /*
             typedef NS_ENUM(NSInteger, UIImagePickerControllerCameraDevice) {
             UIImagePickerControllerCameraDeviceRear,//后置摄像头
             UIImagePickerControllerCameraDeviceFront//前置摄像头
             } __TVOS_PROHIBITED;
             */
            _picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            
            //10、设置拍照时闪光灯模式
            /*
             enum {
             UIImagePickerControllerCameraFlashModeOff  = -1, //关闭
             UIImagePickerControllerCameraFlashModeAuto = 0,  //自动
             UIImagePickerControllerCameraFlashModeOn   = 1   //打开
             };
             typedef NSInteger UIImagePickerControllerCameraFlashMode;
             @property(nonatomic) UIImagePickerControllerCameraFlashMode   cameraFlashMode
             */
            _picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
            
            [self presentViewController:_picker animated:YES completion:^(){}];
        }
    }else{
        //如果没有相机访问功能，就进行提示
        NSLog(@"没有相机功能");
    }
}



#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    // 位置发生变化调用
    NSLog(@"lan = %f, long = %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    _currLon = userLocation.coordinate.longitude;
    _currLat = userLocation.coordinate.latitude;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


-(CALayer *) setBottom:(CGFloat)width doView:(UITextField*)fieldView{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, fieldView.frame.size.height - width, fieldView.frame.size.width, width);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    return layer;
}


- (CAAnimationGroup *)groups {
    if (!_groups){
        CABasicAnimation * scaleAnim = [CABasicAnimation animation];
        scaleAnim.keyPath = @"transform.scale";
        scaleAnim.fromValue = @1;
        scaleAnim.toValue = @1.2;
        scaleAnim.duration = 1.5;
        
        CABasicAnimation *opacityAnim=[CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim.fromValue= @1;
        opacityAnim.toValue= @0.1;
        opacityAnim.duration= 1.5;
        
        _groups =[CAAnimationGroup animation];
        _groups.animations = @[scaleAnim,opacityAnim];
        _groups.removedOnCompletion = NO;
        _groups.fillMode = kCAFillModeForwards;
        _groups.duration = 1.5;
        _groups.repeatCount = FLT_MAX;
    }
    return _groups;
}

#pragma mark--点击相册中的图片 货照相机照完后点击use  后触发的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    /* info dictionary keys
     UIImagePickerControllerOriginalImage  // a UIImage
     UIImagePickerControllerEditedImage    // a UIImage
     UIImagePickerControllerMediaURL       // an NSURL
     */
    
    //获取修改后的图片
    UIImage * originalImage  = info[UIImagePickerControllerOriginalImage];
    UIImage * editedImg = info[UIImagePickerControllerEditedImage];
    NSURL   * mediaUrl  = info[UIImagePickerControllerMediaURL];
    
    
    NSString *flagImgView = @"";
    for(NSMutableDictionary *dic in _ImgArr){
        NSLog(@"%@",dic);
        if([[dic objectForKey:@"value"] isEqualToString:@"NO"]){
            flagImgView = [dic objectForKey:@"Num"];
            break;
        }
    }
//    if (flagImgView.length == 0) {
//        [BaseViewController br_showAlterMsg:@"最多选择4张图"];
//        return;
//    }
    NSLog(@"%@",flagImgView);
    WS(ws);
    //上传成功了才能 显示
   // [_activityIndicatorView startAnimating];

    [self br_uploadImage:originalImage == nil ? editedImg : originalImage block:^(BOOL success, NSString *msg) {
        if([flagImgView isEqualToString:@"1"]){
            //选中图片进行了裁剪
            if (editedImg){
                ws.showFirstImg.image = editedImg;
            }else{
                //没有对图片进行裁剪
                ws.showFirstImg.image = originalImage;
            }
            if (msg) {
                [ws.ImgArr[0] setValue:msg forKey:kuploadImageUrlKey];
            }
            
        }else if([flagImgView isEqualToString:@"2"]){
            //选中图片进行了裁剪
            if (editedImg){
                ws.showSecondImg.image = editedImg;
            }else{
                //没有对图片进行裁剪
                ws.showSecondImg.image = originalImage;
            }
            if (msg) {
                [ws.ImgArr[1] setValue:msg forKey:kuploadImageUrlKey];
            }
        }else if([flagImgView isEqualToString:@"3"]){
            //选中图片进行了裁剪
            if (editedImg){
                ws.showThirdImg.image = editedImg;
            }else{
                //没有对图片进行裁剪
                ws.showThirdImg.image = originalImage;
            }
            if (msg) {
                [ws.ImgArr[2] setValue:msg forKey:kuploadImageUrlKey];
            }
        }else if([flagImgView isEqualToString:@"4"]){
            //选中图片进行了裁剪
            if (editedImg){
                ws.showFourthImg.image = editedImg;
            }else{
                //没有对图片进行裁剪
                ws.showFourthImg.image = originalImage;
            }
            if (msg) {
                [ws.ImgArr[3] setValue:msg forKey:kuploadImageUrlKey];
            }
        }
        
        for(int i = 0;i<[ws.ImgArr count];i++){
            NSMutableDictionary *getDic = ws.ImgArr[i];
            if([[getDic objectForKey:@"Num"] isEqualToString:flagImgView]){
                ws.ImgArr[i][@"value"] = @"YES";
            }
        }
        
    }];
   
    //移除图片选择的控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)br_uploadImage:(UIImage *)img block:(void(^)(BOOL success,NSString *msg))block {
    if (!img) {
        if (block) {
            block(YES,@"");
        }
        return;
    }
//    [_activityIndicatorView removeFromSuperview];
//    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:kAppMainColor];
//    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
//   // [_activityIndicatorView setSize:60];
//    _activityIndicatorView.startingNotUserInterface = YES;
//    [self.view addSubview:_activityIndicatorView];
//    _activityIndicatorView.layer.zPosition = 1000;
//    _activityIndicatorView.tintColor =
    [_activityIndicatorView startAnimating];
    
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *CurrTimeStamp = [PhoneInfo getNowTimeTimestamp3];
    NSString *CurrToken = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@%@UpFile%@",CurrAdminID,CurrTimeStamp,@"CheckWork"]];
    
    
    NSString *url = [NSString stringWithFormat:@"ApiCheckWork/UploadFile?AdminID=%@&ModuleName=%@&TimeStamp=%@&Token=%@",CurrAdminID,@"CheckWork",CurrTimeStamp,CurrToken];
    NSString *urlencode = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [[HTTPOpration sharedHTTPOpration] NetRequestPOSTFileWithRequestURL:urlencode WithParameter:nil WithFiles:@{@"file":UIImageJPEGRepresentation(img, 0.5)} WithReturnValeuBlock:^(HTTPData *data) {
        
        [_activityIndicatorView stopAnimating];

        if (data.code == 0) {
            /*
             {"ResultType":0,"Message":"上传成功！","LogMessage":null,"AppendData":"/Upload/Internship/2018/09/13003042387171.png"}
             
             */
            if ([data.returnData isKindOfClass:[NSDictionary class]]) {
                NSDictionary *temp = data.returnData;
                NSString *AppendData = temp[@"AppendData"];
                if (block) {
                    block(YES,AppendData);
                }
            }
            else{
                [BaseViewController br_showAlterMsg:@"数据异常"];
                
            }
        }
        else{
            [BaseViewController br_showAlterMsg:data.msg];
        }
        
    } WithFailureBlock:^(id error) {
        [_activityIndicatorView stopAnimating];

        [BaseViewController br_showAlterMsg:@"上传图片失败，请重试"];
    }];
    //    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    //    [params setObject:CurrAdminID forKey:@"AdminID"];
    //    [params setObject:@"Internship" forKey:@"ModuleName"];
    //    [params setObject:CurrTimeStamp forKey:@"TimeStamp "];
    //    [params setObject:CurrToken forKey:@"Token"];
}

#pragma mark - UIAlertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        /*确定删除*/
        if(alertView.tag == 1){
            _showFirstImg.image = [UIImage imageNamed:@"gj_default"];
            _ImgArr[0][@"value"] = @"NO";
        }else if(alertView.tag == 2){
            _showSecondImg.image = [UIImage imageNamed:@"gj_default"];
            _ImgArr[1][@"value"] = @"NO";
        }else if(alertView.tag == 3){
            _showThirdImg.image = [UIImage imageNamed:@"gj_default"];
            _ImgArr[2][@"value"] = @"NO";
        }else if(alertView.tag == 4){
            _showFourthImg.image = [UIImage imageNamed:@"gj_default"];
            _ImgArr[3][@"value"] = @"NO";
        }
        
    }
    
    if (alertView.tag == kSuccessCodeTag) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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

-(void) CheckOutAction:(UITapGestureRecognizer *)sender{
    NSLog(@"纬度：%f",_currLat);
    NSLog(@"经度：%f",_currLon);
    NSLog(@"位置：%@",sender.accessibilityHint);
    if (_currLat == 0 && _currLon == 0) {
        UIAlertView *successAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未获取到地理位置" delegate:self cancelButtonTitle:@"重试" otherButtonTitles:nil, nil];
        [successAlert show];
        
        //[_mag startUpdatingLocation];

        [_mag startUpdatingLocation];
        return;
    }
    sender.enabled = NO;
    [_activityIndicatorView startAnimating];

    NSString *CurrLat = [NSString stringWithFormat:@"%f",_currLat];
    NSString *CurrLon = [NSString stringWithFormat:@"%f",_currLon];
    NSString *CurrLocation = [NSString stringWithFormat:@"%@",_br_locationStr];
    NSString *CurrUDID = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *CurrDate = [PhoneInfo getCurrentTimes:@"YYYY-MM-dd HH:mm:ss"];
    NSString *CurrTimeStamp = [PhoneInfo getNowTimeTimestamp3];
    NSString *CurrToken = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@%@%@GJCheck%@%@",CurrAdminID,[PhoneInfo getCurrentTimes:@"yyyyMMdd"],CurrTimeStamp,CurrLat,CurrLon]];
    
//    __block NSString *CheckOutPic = @"";
//    [self.ImgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        NSString * value = obj[@"value"];
//        if ([value isEqualToString:@"YES"]) {
//            NSString *url = obj[kuploadImageUrlKey];
//            if (url.length > 0) {
//                if ( CheckOutPic.length > 0) {
//                    CheckOutPic = [NSString stringWithFormat:@"%@|%@",CheckOutPic,url];
//                }
//                else{
//                    CheckOutPic = url;
//                }
//            }
//        }
//    }];
     NSString *CheckOutPic = @"";
    for (NSDictionary *obj in self.ImgArr) {
        NSString * value = obj[@"value"];
        if ([value isEqualToString:@"YES"]) {
            NSString *url = obj[kuploadImageUrlKey];
            if (url.length > 0) {
                if ( CheckOutPic.length > 0) {
                    CheckOutPic = [NSString stringWithFormat:@"%@|%@",CheckOutPic,url];
                }
                else{
                    CheckOutPic = url;
                }
            }
        }
    }
   
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiCheckWork/CheckOut?StudentID=%@&CheckOutDate=%@&CheckOutLon=%@&CheckOutLat=%@&CheckOutPlace=%@&CheckInIMEI=%@&TimeStamp=%@&Token=%@&CheckOutPic=%@",kCacheHttpRoot,CurrAdminID,CurrDate,CurrLon,CurrLat,CurrLocation,CurrUDID,CurrTimeStamp,CurrToken,CheckOutPic];
    NSString *urlencode = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    [AizenHttp asynRequest:urlencode httpMethod:@"GET" params:nil success:^(id result) {
        NSDictionary *jsonDic = result;
        NSLog(@"%@",jsonDic);
        [_activityIndicatorView stopAnimating];

        NSInteger ResultType = [jsonDic[@"ResultType"] integerValue];
        UIAlertView *successAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:[jsonDic objectForKey:@"Message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [successAlert show];
        if (ResultType == 0) {
//            successAlert.tag = kSuccessCodeTag;
            
            self.recodeInfo.signCount = 2;
            self.recodeInfo.CheckOutDate = CurrDate;
            self.recodeInfo.CheckOutPlace = CurrLocation;
            [self br_updateCheckStatusUI];
            [self br_removeAllPhoto];


        }
        sender.enabled = YES;

        
    } failue:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [_activityIndicatorView stopAnimating];

        sender.enabled = YES;

    }];
    
    [AizenStorage writeUserDataWithKey:@"0" forKey:@"isCheck"];

}

- (void)br_removeAllPhoto{
    
      _ImgArr = [[NSMutableArray alloc]initWithObjects:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"NO",@"value", @"1",@"Num",nil],[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"NO",@"value", @"2",@"Num",nil],[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"NO",@"value", @"3",@"Num",nil],[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"NO",@"value", @"4",@"Num",nil], nil];
//    [self.ImgArr removeAllObjects];
    _showFirstImg.image = nil;
    _showSecondImg.image = nil;
    _showThirdImg.image = nil;
    _showFourthImg.image = nil;
    
}
-(void) CheckWorkAction:(UITapGestureRecognizer *)sender{
    NSLog(@"纬度：%f",_currLat);
    NSLog(@"经度：%f",_currLon);
    NSLog(@"位置：%@",sender.accessibilityHint);
    
    if (_currLat == 0 && _currLon == 0) {
        UIAlertView *successAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未获取到地理位置" delegate:self cancelButtonTitle:@"重试" otherButtonTitles:nil, nil];
        [successAlert show];
        
        //[_mag startUpdatingLocation];
        
        [_mag startUpdatingLocation];
        return;
    }
    
    [_activityIndicatorView startAnimating];
    
    
    sender.enabled = NO;

    NSString *CurrLat = [NSString stringWithFormat:@"%f",_currLat];
    NSString *CurrLon = [NSString stringWithFormat:@"%f",_currLon];
    NSString *CurrLocation = [NSString stringWithFormat:@"%@",_br_locationStr];
    NSString *CurrUDID = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *CurrDate = [PhoneInfo getCurrentTimes:@"YYYY-MM-dd HH:mm:ss"];
    NSString *CurrTimeStamp = [PhoneInfo getNowTimeTimestamp3];
    NSString *CurrToken = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@%@%@GJCheck%@%@",CurrAdminID,[PhoneInfo getCurrentTimes:@"yyyyMMdd"],CurrTimeStamp,CurrLat,CurrLon]];
    //CheckInPic
    
     NSString *CheckOutPic = @"";
    for (NSDictionary *obj in self.ImgArr) {
        NSString * value = obj[@"value"];
        if ([value isEqualToString:@"YES"]) {
            NSString *url = obj[kuploadImageUrlKey];
            if (url.length > 0) {
                if ( CheckOutPic.length > 0) {
                    CheckOutPic = [NSString stringWithFormat:@"%@|%@",CheckOutPic,url];
                }
                else{
                    CheckOutPic = url;
                }
            }
        }
    }
//    [self.ImgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//
//    }];
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiCheckWork/CheckIn?StudentID=%@&CheckInDate=%@&CheckInLon=%@&CheckInLat=%@&CheckInPlace=%@&CheckInIMEI=%@&TimeStamp=%@&Token=%@&CheckInPic=%@",kCacheHttpRoot,CurrAdminID,CurrDate,CurrLon,CurrLat,CurrLocation,CurrUDID,CurrTimeStamp,CurrToken,CheckOutPic];
    NSString *urlencode = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",url);
    [AizenHttp asynRequest:urlencode httpMethod:@"GET" params:nil success:^(id result) {
        NSDictionary *jsonDic = result;
        NSLog(@"%@",jsonDic);
        [_activityIndicatorView stopAnimating];
        NSInteger ResultType = [jsonDic[@"ResultType"] integerValue];
        UIAlertView *successAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:[jsonDic objectForKey:@"Message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [successAlert show];
        if (ResultType == 0) {
//            successAlert.tag = kSuccessCodeTag;
            self.recodeInfo.signCount = 1;
            self.recodeInfo.CheckInDate = CurrDate;
            self.recodeInfo.CheckInPlace = CurrLocation;
            [self br_removeAllPhoto];
            [self br_updateCheckStatusUI];
        }
        sender.enabled = YES;

        
    } failue:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [_activityIndicatorView stopAnimating];
        sender.enabled = YES;


    }];
    
    [AizenStorage writeUserDataWithKey:@"1" forKey:@"isCheck"];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
