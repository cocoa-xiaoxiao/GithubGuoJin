//
//  PatrolTaskSubmitViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/6/7.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "PatrolTaskSubmitViewController.h"
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
#import "CZPickerView.h"



@interface PatrolTaskSubmitViewController ()<MKMapViewDelegate,CLLocationManagerDelegate,PGDatePickerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,CZPickerViewDelegate,CZPickerViewDataSource>
{
    BOOL _isPerson;
    NSArray *_seleStudentArray;
    NSString *_selePianquID;
}

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

@property (nonatomic, strong) UIView *pianquView;
@property (nonatomic, strong) UILabel *pianquLb;
@property (nonatomic, strong) UILabel *pianquValue;

@property (nonatomic, strong) UIView *xunchaView;
@property (nonatomic, strong) UILabel *xunchaLb;
@property (nonatomic, strong) UILabel *xunchaValue;

@property (nonatomic, strong) UIView *photoView;
@property(nonatomic,strong) UIView *photoTopView;
@property (nonatomic, strong) UIImageView             * showFirstImg;
@property (nonatomic, strong) UIImageView             * showSecondImg;
@property (nonatomic, strong) UIImageView             * showThirdImg;
@property (nonatomic, strong) UIImageView             * showFourthImg;
@property(nonatomic,strong) UIView *photoContentView;
@property(nonatomic,strong) UIImageView *takePhoto;
@property(nonatomic,strong) UIView *photoContentTopView;
@property(nonatomic,strong) UIView *photoContentBottomView;
@property (nonatomic, strong) NSMutableArray *ImgArr;
@property (nonatomic, strong) UIImagePickerController * picker;
@property(nonatomic,strong) CZPickerView *studentPicker;
@property(nonatomic,strong) CZPickerView *pianquPicker;
@property(nonatomic,strong) NSMutableArray *peopleArr;
@property(nonatomic,strong) NSMutableArray *pianquArr;
@property double placeLat;
@property double placeLon;

@end

@implementation PatrolTaskSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"提交报告";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _ImgArr = [[NSMutableArray alloc]initWithObjects:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"NO",@"value", @"1",@"Num",nil],[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"NO",@"value", @"2",@"Num",nil],[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"NO",@"value", @"3",@"Num",nil],[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"NO",@"value", @"4",@"Num",nil], nil];
    _peopleArr = [[NSMutableArray alloc]init];
    _pianquArr = [[NSMutableArray alloc]init];
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
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    _submitBtn.font = [UIFont systemFontOfSize:18.0];
    [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_submitBtn];
    
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [_dataScrollView addSubview:_activityIndicatorView];
    
    [self student];
    [self pianqu];
    [self detailLayout];
}


-(void) detailLayout{
    _mapView = [[MKMapView alloc]init];
    _mapView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height * 0.3);
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    _mapView.userInteractionEnabled = NO;
    [_dataScrollView addSubview:_mapView];
    
    
    _locationView = [[UIView alloc]init];
    _locationView.frame = CGRectMake(0, _mapView.frame.size.height + _mapView.frame.origin.y, _mapView.frame.size.width, _contentView.frame.size.height * 0.05);
    [_dataScrollView addSubview:_locationView];
    
    _locationLab = [[UILabel alloc]init];
    _locationLab.frame = CGRectMake(_locationView.frame.size.width * 0.03, _locationView.frame.size.height * 0.1, _locationView.frame.size.width * 0.94, _locationView.frame.size.height * 0.8);
    _locationLab.text = @"当前位置：定位中...";
    _locationLab.textColor = [UIColor lightGrayColor];
    _locationLab.font = [UIFont systemFontOfSize:13.0];
    [_locationView addSubview:_locationLab];
    
    UIView *locationLine = [[UIView alloc]init];
    locationLine.frame = CGRectMake(_locationView.frame.size.width * 0.03, _locationView.frame.size.height - 1, _locationView.frame.size.width * 0.94, 1);
    locationLine.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_locationView addSubview:locationLine];
    
    
    _mag = [[CLLocationManager alloc]init];
    _mag.delegate = self;
    _mag.desiredAccuracy=kCLLocationAccuracyBest;//指定需要的精度级别
    _mag.distanceFilter=1000.0f;//设置距离筛选器
    [_mag startUpdatingLocation];
    [_mag requestAlwaysAuthorization];

    
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
    _dateValue.textAlignment = NSTextAlignmentRight;
    _dateValue.text = @"请选择";
    _dateValue.font = [UIFont systemFontOfSize:15.0];
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
    _titleValue.textAlignment = NSTextAlignmentRight;
    _titleValue.delegate = self;
    _titleValue.userInteractionEnabled = YES;
    [_titleView addSubview:_titleValue];
    
    UIView *titleLine = [[UIView alloc]init];
    titleLine.frame = CGRectMake(_titleView.frame.size.width * 0.03, _titleView.frame.size.height - 1, _titleView.frame.size.width * 0.97, 1);
    titleLine.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_titleView addSubview:titleLine];
    
    
    _pianquView = [[UIView alloc]init];
    _pianquView.frame = CGRectMake(0, _titleView.xo_bottomY, _dateView.xo_width, _dateView.xo_height);
    [_dataScrollView addSubview:_pianquView];
    
    _pianquLb = [[UILabel alloc]init];
    _pianquLb.frame = CGRectMake(_pianquView.xo_width * 0.03, _pianquView.xo_height * 0.1, _pianquView.xo_width * 0.3, _pianquView.xo_height * 0.8);
    _pianquLb.font = [UIFont systemFontOfSize:15.0];
    _pianquLb.text = @"所属片区：";
    [_pianquView addSubview:_pianquLb];
    
    _pianquValue = [[UILabel alloc]init];
    _pianquValue.frame = CGRectMake(_pianquLb.xo_width + _pianquLb.xo_x, _pianquLb.frame.origin.y, _pianquView.frame.size.width * 0.64, _pianquView.frame.size.height * 0.8);
    _pianquValue.textAlignment = NSTextAlignmentRight;
    _pianquValue.text = @"请选择";
    _pianquValue.font = [UIFont systemFontOfSize:15.0];
    _pianquValue.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    _pianquValue.userInteractionEnabled = YES;
    UITapGestureRecognizer *pianquTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pianquAction:)];
    [_pianquValue addGestureRecognizer:pianquTap];
    [_pianquView addSubview:_pianquValue];
    UIView *pianquLine = [[UIView alloc]init];
    pianquLine.frame = CGRectMake(_pianquView.frame.size.width * 0.03, _pianquView.frame.size.height - 1, _pianquView.frame.size.width * 0.97, 1);
    pianquLine.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_pianquView addSubview:pianquLine];
    
    _xunchaView = [[UIView alloc]init];
    _xunchaView.frame = CGRectMake(0, _pianquView.xo_bottomY, _dateView.xo_width, _dateView.xo_height);
    [_dataScrollView addSubview:_xunchaView];
    
    _xunchaLb = [[UILabel alloc]init];
    _xunchaLb.frame = CGRectMake(_xunchaView.xo_width * 0.03, _xunchaView.xo_height * 0.1, _xunchaView.xo_width * 0.3, _xunchaView.xo_height * 0.8);
    _xunchaLb.font = [UIFont systemFontOfSize:15.0];
    _xunchaLb.text = @"所巡学生：";
    [_xunchaView addSubview:_xunchaLb];
    
    _xunchaValue = [[UILabel alloc]init];
    _xunchaValue.frame = CGRectMake(_xunchaLb.xo_width + _xunchaLb.xo_x, _xunchaLb.frame.origin.y, _xunchaView.frame.size.width * 0.64, _xunchaView.frame.size.height * 0.8);
    _xunchaValue.textAlignment = NSTextAlignmentRight;
    _xunchaValue.text = @"请选择";
    _xunchaValue.font = [UIFont systemFontOfSize:15.0];
    _xunchaValue.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    _xunchaValue.userInteractionEnabled = YES;
    UITapGestureRecognizer *xunchaTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xunchaAction:)];
    [_xunchaValue addGestureRecognizer:xunchaTap];
    [_xunchaView addSubview:_xunchaValue];
    UIView *xunchaLine = [[UIView alloc]init];
    xunchaLine.frame = CGRectMake(_xunchaView.frame.size.width * 0.03, _xunchaView.frame.size.height - 1, _xunchaView.frame.size.width * 0.97, 1);
    xunchaLine.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_xunchaView addSubview:xunchaLine];
    
    _photoView = [[UIView alloc]init];
    _photoView.frame = CGRectMake(0, _xunchaView.xo_bottomY, _dateView.xo_width, 200);
    [_dataScrollView addSubview:_photoView];
    
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
    
    UIView *photoLine = [[UIView alloc]init];
    photoLine.frame = CGRectMake(_photoView.frame.size.width * 0.03, _photoView.frame.size.height - 1, _photoView.frame.size.width * 0.97, 1);
    photoLine.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_photoView addSubview:photoLine];
    [self httpField];
    
    
    
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
#define kuploadImageUrlKey @"sadasdasdkuploadImageUrlKey"

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

-(void) httpField{
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipInspectionTeamInfo/GetRecordConfig?TeamID=%@",kCacheHttpRoot,[_dataDic objectForKey:@"InspectionTeamID"]];
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
            if ([dataDic[keys[i]] isKindOfClass:[NSNull class]]) {
                continue;
            }
            if(![dataDic[keys[i]] isEqualToString:@""]){
                /*写布局------------------------------------start*/
                
                UIView *FieldView = [[UIView alloc]init];
                FieldView.frame = CGRectMake(0, _photoView.frame.origin.y + _photoView.frame.size.height + height * num, _dataScrollView.frame.size.width,height);
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
    
    CGFloat scrollHeight = _mapView.frame.size.height + _dateView.frame.size.height + _titleView.frame.size.height + height * num + _locationView.frame.size.height + _pianquView.xo_height + _xunchaView.xo_height + _photoView.xo_height;
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

-(void)xunchaAction:(UITapGestureRecognizer *)sender
{
    _isPerson = YES;
    [_studentPicker show];
}
-(void)pianquAction:(UITapGestureRecognizer *)sender
{
    _isPerson = NO;
    [_pianquPicker show];
}
-(void)pianqu
{
    _pianquPicker = [[CZPickerView alloc] initWithHeaderTitle:@"选择片区"
                                             cancelButtonTitle:@"取消"
                                            confirmButtonTitle:@"提交"];
    _pianquPicker.delegate = self;
    _pianquPicker.dataSource = self;
    _pianquPicker.needFooterView = YES;
    _pianquPicker.headerBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    _pianquPicker.confirmButtonBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    
    [_activityIndicatorView startAnimating];
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipInspectionTeamInfo/GetInspectionSubsidyList",kCacheHttpRoot];
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] intValue] == 0){
            NSArray *dataArr = [jsonDic objectForKey:@"AppendData"];
            [self handlePianQuList:dataArr];
        }
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败");
    }];
}
-(void) handlePianQuList:(NSArray *)dataArr{
    [_pianquArr removeAllObjects];
    for(int i = 0;i<[dataArr count];i++){
        NSMutableDictionary *getDic = [[NSMutableDictionary alloc]init];
        [getDic setObject:[[dataArr objectAtIndex:i] objectForKey:@"SubsidyTitle"] forKey:@"pianquName"];
        [getDic setObject:[[[dataArr objectAtIndex:i] objectForKey:@"ID"] stringValue] forKey:@"ID"];
        [_pianquArr addObject:getDic];
    }
}
-(void)student
{
    _studentPicker = [[CZPickerView alloc] initWithHeaderTitle:@"选择学生"
                                      cancelButtonTitle:@"取消"
                                     confirmButtonTitle:@"提交"];
    _studentPicker.delegate = self;
    _studentPicker.dataSource = self;
    _studentPicker.needFooterView = YES;
    _studentPicker.allowMultipleSelection = YES;
    _studentPicker.headerBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    _studentPicker.confirmButtonBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    
    [_activityIndicatorView startAnimating];
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipInspectionTeamInfo/GetStudentByEnterpriseID?EnterpriseID=%@&ActivityID=%@&rows=1000&page=1",kCacheHttpRoot,[_dataDic objectForKey:@"EnterpriseID"],batchID];
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] intValue] == 0){
            NSArray *dataArr = [jsonDic objectForKey:@"AppendData"][@"rows"];
            [self handleList:dataArr];
        }
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败");
    }];
}
-(void) handleList:(NSArray *)dataArr{
    [_peopleArr removeAllObjects];
    for(int i = 0;i<[dataArr count];i++){
        NSMutableDictionary *getDic = [[NSMutableDictionary alloc]init];
        [getDic setObject:[[dataArr objectAtIndex:i] objectForKey:@"UserName"] forKey:@"UserName"];
        [getDic setObject:[[[dataArr objectAtIndex:i] objectForKey:@"StudentID"] stringValue] forKey:@"ID"];
        [_peopleArr addObject:getDic];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- UIScrollViewDelege
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y<0){
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
            
            _locationLab.text = addressStr;
            
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
#pragma mark - CZPickerViewDataSource
/* number of items for picker */
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    if (!_isPerson) {
        return _pianquArr.count;
    }
    return [_peopleArr count];
}

/* picker item title for each row */
- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row{
    if (!_isPerson) {
        return [[_pianquArr objectAtIndex:row] objectForKey:@"pianquName"];
    }
    return [[_peopleArr objectAtIndex:row]objectForKey:@"UserName"];
}

#pragma mark - CZPickerViewDelegate
/** delegate method for picking one item */
- (void)czpickerView:(CZPickerView *)pickerView
didConfirmWithItemAtRow:(NSInteger)row{
    if (!_isPerson) {
        NSString *name = [[_pianquArr objectAtIndex:row] objectForKey:@"pianquName"];
        _pianquValue.text = name;
        _pianquValue.textColor = [UIColor blackColor];
        _selePianquID = [[_pianquArr objectAtIndex:row]objectForKey:@"ID"];
    }
}

/** delegate method for picking multiple items,
 implement this method if allowMultipleSelection is YES,
 rows is an array of NSNumbers
 */
- (void)czpickerView:(CZPickerView *)pickerView
didConfirmWithItemsAtRows:(NSArray *)rows{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < rows.count; i++) {
        NSDictionary *dict = [self.peopleArr objectAtIndex:[[rows objectAtIndex:i]intValue]];
        [array addObject:[dict objectForKey:@"ID"] ];
    }
    _seleStudentArray = [array mutableCopy];
    _xunchaValue.text = [NSString stringWithFormat:@"%ld人",_seleStudentArray.count];
    _xunchaValue.textColor = [UIColor blackColor];
}
/** delegate method for canceling */
- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView{
    
}

#pragma mark -上传

-(void) submitAction:(UIButton *)sender{
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipInspectionTeamInfo/Submit",kCacheHttpRoot];
    
    
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    
    if([_dateValue.text isEqualToString:@"请选择"] || [_dateValue.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择报告时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if([_titleValue.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写报告名称" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([_pianquValue.text isEqualToString:@"请选择"] || [_pianquValue.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择片区" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([_xunchaValue.text isEqualToString:@"请选择"] || [_xunchaValue.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择学生" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:batchID forKey:@"ActivityID"];
            [params setObject:CurrAdminID forKey:@"Creater"];
            [params setObject:[_dataDic objectForKey:@"ID"] forKey:@"TeamEnterpriseID"];
            [params setObject:_dateValue.text forKey:@"RecordDate"];
            [params setObject:_titleValue.text forKey:@"RecordTitle"];
        
        NSMutableString *stString = [[NSMutableString alloc]init];
        for (int i = 0; i < _seleStudentArray.count; i++) {
            if (i== 0) {
                [stString appendString:_seleStudentArray[i]];
            }else{
                [stString appendFormat:@",%@",_seleStudentArray[i]];
            }
        }
            [params setObject:stString forKey:@"StudentIDS"];
            [params setObject:_selePianquID forKey:@"SubsidyConfigID"];
            for(UIView *subView in _dataScrollView.subviews){
                if(subView.accessibilityLabel != nil){
                    for(UITextView *subTextView in subView.subviews){
                        if([subTextView.accessibilityLabel isEqualToString:@"haveValue"]){
                            [params setObject:subTextView.text forKey:subView.accessibilityLabel];
                        }
                    }
                }
            }
        
        NSMutableArray *imageArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in _ImgArr) {
            if ([[dict objectForKey:@"value"]boolValue]) {
                [imageArray addObject:[dict objectForKey:kuploadImageUrlKey]];
            }
        }
        [params setObject:imageArray forKey:@"RecordPic"];
        
        
        
            NSString *currTime = [PhoneInfo getNowTimeTimestamp3];
            [params setObject:currTime forKey:@"TimeStamp"];

            NSString *tokenStr = [NSString stringWithFormat:@"%@GJInspection%@",[_dataDic objectForKey:@"InspectionTeamID"],currTime];
            NSString *getToken = [AizenMD5 MD5ForUpper16Bate:tokenStr];
            [params setObject:getToken forKey:@"Token"];
            
            NSString *placeLatStr = [NSString stringWithFormat:@"%f",_placeLat];
            NSString *placeLonStr = [NSString stringWithFormat:@"%f",_placeLon];
            [params setObject:placeLatStr forKey:@"RecordLat"];
            [params setObject:placeLonStr forKey:@"RecordLon"];
            
            
            NSString *locationStr = [_locationLab.text stringByReplacingOccurrencesOfString:@"当前位置：" withString:@""];
            [params setObject:locationStr forKey:@"RecordPlace"];
        
        
            
            [_activityIndicatorView startAnimating];
        __weak typeof(self) weakself = self;
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
                        [weakself.navigationController popViewControllerAnimated:YES];
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


@end
