//
//  SignViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/3/1.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "SignViewController.h"
#import "RDVTabBarController.h"
#import <MapKit/MapKit.h>
#import "SignButton.h"
#import "RAlertView.h"
#import <AVFoundation/AVFoundation.h>     //添加静态库头文件
#import <CoreLocation/CoreLocation.h>
#import "QRCodeScanViewController.h"


@interface SignViewController ()

@property (nonatomic, strong) UIView *contentView;

@property(nonatomic,strong) MKMapView *mapView;
@property(nonatomic,strong) CLLocationManager *mag;
@property(nonatomic,strong) CLGeocoder *ceocoder;

@property(nonatomic,strong) UIView *detailView;

@property(nonatomic,strong) UIView *meetingView;
@property(nonatomic,strong) UIView *meetingTitleView;
@property(nonatomic,strong) UIView *meetingTitleLineView;
@property(nonatomic,strong) UILabel *meetingTitleLab;
@property(nonatomic,strong) UILabel *meetingValue;
@property(nonatomic,strong) NSString *meetingSetVaue;

@property(nonatomic,strong) UIView *descrView;
@property(nonatomic,strong) UIView *descrTitleView;
@property(nonatomic,strong) UIView *descrTitleLineView;
@property(nonatomic,strong) UILabel *descrTitleLab;
@property(nonatomic,strong) UITextField *descrValue;


@property(nonatomic,strong) UIView *photoView;
@property(nonatomic,strong) UIView *photoTitleView;
@property(nonatomic,strong) UIView *photoTitleLineView;
@property(nonatomic,strong) UILabel *photoTitleLab;
@property(nonatomic,strong) UIView *photoContentView;
@property(nonatomic,strong) UIImageView *photoFirst;
@property(nonatomic,strong) UIImageView *photoSecond;
@property(nonatomic,strong) UIImageView *photoThird;
@property(nonatomic,strong) UIImageView *photoFourth;
@property int recordImg;
@property int currRecordImg;


@property(nonatomic,strong) UIView *btnView;
@property(nonatomic,strong) SignButton *cardBtn;
@property(nonatomic,strong) SignButton *scanBtn;

@property(nonatomic,strong) RAlertView *alert;

@property (nonatomic, strong) UIImagePickerController * picker;
@property (nonatomic, strong) AVPlayer                * player;

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"集会签到";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [[self rdv_tabBarController]setTabBarHidden:YES animated:YES];
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = backBtnItem ;
    
    [self startLayout];
}

-(void)backAction:(UIBarButtonItem *)sender{
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) startLayout{
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, self.view.frame.size.width, self.view.frame.size.height - (HEIGHT_STATUSBAR + HEIGHT_NAVBAR));
    _contentView.userInteractionEnabled = YES;
    _contentView.backgroundColor = GRAY_BACKGROUND;
    [self.view addSubview:_contentView];
    
    _mapView = [[MKMapView alloc]init];
    _mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, _contentView.frame.size.height * 0.25);
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    _mapView.userInteractionEnabled = NO;
    [_contentView addSubview:_mapView];
    
    _mag = [[CLLocationManager alloc]init];
    _mag.delegate = self;
    _mag.desiredAccuracy=kCLLocationAccuracyBest;//指定需要的精度级别
    _mag.distanceFilter=1000.0f;//设置距离筛选器
    [_mag startUpdatingLocation];
    [_mag requestAlwaysAuthorization];
    
    
    _detailView = [[UIView alloc]init];
    _detailView.frame = CGRectMake(0, _mapView.frame.size.height + _mapView.frame.origin.y + 10, _contentView.frame.size.width, _contentView.frame.size.height - _mapView.frame.size.height - 10);
    _detailView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_detailView];
    
    [self detailLayout];
}



-(void) detailLayout{
    _recordImg = 0;
    _currRecordImg = 0;
    
    _meetingView = self.loadSubView;
    _meetingView.frame = CGRectMake(0, 0, _detailView.frame.size.width, _detailView.frame.size.height * 0.15);
    [_detailView addSubview:_meetingView];
    
    
    _meetingTitleView = self.loadSubView;
    _meetingTitleView.frame = CGRectMake(0, 0, _meetingView.frame.size.width, _meetingView.frame.size.height * 0.25);
    [_meetingView addSubview:_meetingTitleView];
    
    
    _meetingTitleLineView = self.loadSubView;
    _meetingTitleLineView.frame = CGRectMake(_meetingTitleView.frame.size.width * 0.05, _meetingTitleView.frame.size.height * 0.15, 5, _meetingTitleView.frame.size.height * 0.7);
    _meetingTitleLineView.backgroundColor = [UIColor colorWithRed:0/255.0 green:142/255.0 blue:255/255.0 alpha:1];
    [_meetingTitleView addSubview:_meetingTitleLineView];
    
    
    _meetingTitleLab = self.loadSubLab;
    _meetingTitleLab.frame = CGRectMake(_meetingTitleLineView.frame.size.width + _meetingTitleLineView.frame.origin.x + 10, _meetingTitleLineView.frame.origin.y, _meetingTitleView.frame.size.width * 0.8, _meetingTitleView.frame.size.height * 0.7);
    _meetingTitleLab.text = @"选择集会";
    _meetingTitleLab.textColor = [UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:1];
    _meetingTitleLab.font = [UIFont systemFontOfSize:14.0];
    [_meetingTitleView addSubview:_meetingTitleLab];
    
    
    
    _meetingValue = self.loadSubLab;
    _meetingValue.frame = CGRectMake(_meetingTitleView.frame.size.width * 0.05, _meetingTitleView.frame.size.height + _meetingView.frame.size.height * 0.1, _meetingView.frame.size.width * 0.9, _meetingView.frame.size.height * 0.75 - _meetingView.frame.size.height * 0.2);
    _meetingValue.text = @"请选择";
    _meetingValue.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    _meetingValue.font = [UIFont systemFontOfSize:18.0];
    [_meetingView addSubview:_meetingValue];
    
    UIView *oneLineView = self.loadSubView;
    oneLineView.frame = CGRectMake(_meetingView.frame.size.width * 0.05, _meetingView.frame.size.height - 8, _meetingView.frame.size.width * 0.95, 1);
    oneLineView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_meetingView addSubview:oneLineView];
    
    
    
    _descrView = self.loadSubView;
    _descrView.frame = CGRectMake(0, _meetingView.frame.size.height + _meetingView.frame.origin.y, _detailView.frame.size.width, _detailView.frame.size.height * 0.15);
    [_detailView addSubview:_descrView];
    
    
    _descrTitleView = self.loadSubView;
    _descrTitleView.frame = CGRectMake(0, 0, _descrView.frame.size.width, _descrView.frame.size.height * 0.25);
    [_descrView addSubview:_descrTitleView];
    
    
    _descrTitleLineView = self.loadSubView;
    _descrTitleLineView.frame = CGRectMake(_descrTitleView.frame.size.width * 0.05, _descrTitleView.frame.size.height * 0.15, 5, _descrTitleView.frame.size.height * 0.7);
    _descrTitleLineView.backgroundColor = [UIColor colorWithRed:0/255.0 green:142/255.0 blue:255/255.0 alpha:1];
    [_descrTitleView addSubview:_descrTitleLineView];
    
    
    _descrTitleLab = self.loadSubLab;
    _descrTitleLab.frame = CGRectMake(_descrTitleLineView.frame.size.width + _descrTitleLineView.frame.origin.x + 10, _descrTitleLineView.frame.origin.y, _descrTitleView.frame.size.width * 0.8, _descrTitleView.frame.size.height * 0.7);
    _descrTitleLab.text = @"集会描述";
    _descrTitleLab.textColor = [UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:1];
    _descrTitleLab.font = [UIFont systemFontOfSize:14.0];
    [_descrTitleView addSubview:_descrTitleLab];
    
    
    
    _descrValue = self.loadSubField;
    _descrValue.frame = CGRectMake(_descrTitleView.frame.size.width * 0.05, _descrTitleView.frame.size.height + _descrView.frame.size.height * 0.1, _descrView.frame.size.width * 0.9, _descrView.frame.size.height * 0.75 - _descrView.frame.size.height * 0.2);
    _descrValue.placeholder = @"请输入(非必填)";
    _descrValue.font = [UIFont systemFontOfSize:18.0];
    [_descrView addSubview:_descrValue];
    
    
    UIView *twoLineView = self.loadSubView;
    twoLineView.frame = CGRectMake(_descrView.frame.size.width * 0.05, _descrView.frame.size.height - 8, _descrView.frame.size.width * 0.95, 1);
    twoLineView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_descrView addSubview:twoLineView];
    
    
    
    _photoView = self.loadSubView;
    _photoView.frame = CGRectMake(0, _descrView.frame.size.height + _descrView.frame.origin.y, _detailView.frame.size.width, _detailView.frame.size.height * 0.2);
    [_detailView addSubview:_photoView];
    
    
    _photoTitleView = self.loadSubView;
    _photoTitleView.frame = CGRectMake(0, 0, _photoView.frame.size.width, _photoView.frame.size.height * 0.2);
    [_photoView addSubview:_photoTitleView];
    
    
    _photoTitleLineView = self.loadSubView;
    _photoTitleLineView.frame = CGRectMake(_photoTitleView.frame.size.width * 0.05, _photoTitleView.frame.size.height * 0.15, 5, _photoTitleView.frame.size.height * 0.7);
    _photoTitleLineView.backgroundColor = [UIColor colorWithRed:0/255.0 green:142/255.0 blue:255/255.0 alpha:1];
    [_photoTitleView addSubview:_photoTitleLineView];
    
    
    _photoTitleLab = self.loadSubLab;
    _photoTitleLab.frame = CGRectMake(_photoTitleLineView.frame.size.width + _photoTitleLineView.frame.origin.x + 10, _photoTitleLineView.frame.origin.y, _photoTitleView.frame.size.width * 0.8, _photoTitleView.frame.size.height * 0.7);
    _photoTitleLab.text = @"上传照片";
    _photoTitleLab.textColor = [UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:1];
    _photoTitleLab.font = [UIFont systemFontOfSize:14.0];
    [_photoTitleView addSubview:_photoTitleLab];
    
    
    _photoContentView = self.loadSubView;
    _photoContentView.frame = CGRectMake(_photoView.frame.size.width * 0.05, _photoTitleView.frame.size.height + _photoTitleView.frame.origin.y + _photoView.frame.size.height * 0.05, _photoView.frame.size.width * 0.9, _photoView.frame.size.height * 0.8 - _photoView.frame.size.height * 0.1);
    _photoContentView.userInteractionEnabled = YES;
    [_photoView addSubview:_photoContentView];
    
    
    
    _photoFirst = self.loadSubImgView;
    _photoFirst.frame = CGRectMake(0, 0, _photoContentView.frame.size.height, _photoContentView.frame.size.height);
    _photoFirst.image = [UIImage imageNamed:@"gj_signaddimg"];
    _photoFirst.userInteractionEnabled = YES;
    UITapGestureRecognizer *FirstTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoAction:)];
    FirstTap.accessibilityLabel = @"First";
    [_photoFirst addGestureRecognizer:FirstTap];
    [_photoContentView addSubview:_photoFirst];
    
    _photoSecond = self.loadSubImgView;
    _photoSecond.frame = CGRectMake( _photoContentView.frame.size.height + (_photoContentView.frame.size.width - _photoContentView.frame.size.height * 4) / 3,0, _photoContentView.frame.size.height, _photoContentView.frame.size.height);
    _photoSecond.userInteractionEnabled = YES;
    UITapGestureRecognizer *SecondTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoAction:)];
    SecondTap.accessibilityLabel = @"Second";
    [_photoSecond addGestureRecognizer:SecondTap];
    [_photoContentView addSubview:_photoSecond];
    
    
    _photoThird = self.loadSubImgView;
    _photoThird.frame = CGRectMake(_photoSecond.frame.origin.x + _photoSecond.frame.size.width + (_photoContentView.frame.size.width - _photoContentView.frame.size.height * 4) / 3, 0, _photoContentView.frame.size.height, _photoContentView.frame.size.height);
    _photoThird.userInteractionEnabled = YES;
    UITapGestureRecognizer *ThirdTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoAction:)];
    ThirdTap.accessibilityLabel = @"Third";
    [_photoThird addGestureRecognizer:ThirdTap];
    [_photoContentView addSubview:_photoThird];
    
    
    _photoFourth = self.loadSubImgView;
    _photoFourth.frame = CGRectMake(_photoThird.frame.origin.x + _photoThird.frame.size.width + (_photoContentView.frame.size.width - _photoContentView.frame.size.height * 4) / 3, 0, _photoContentView.frame.size.height, _photoContentView.frame.size.height);
    _photoFourth.userInteractionEnabled = YES;
    UITapGestureRecognizer *FourthTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoAction:)];
    FourthTap.accessibilityLabel = @"Fourth";
    [_photoFourth addGestureRecognizer:FourthTap];
    [_photoContentView addSubview:_photoFourth];
    
    
    _btnView = self.loadSubView;
    _btnView.frame = CGRectMake(0, _detailView.frame.size.height - _detailView.frame.size.height * 0.2, _detailView.frame.size.width, _detailView.frame.size.height * 0.2);
    [_detailView addSubview:_btnView];
    
    
    _cardBtn = [[SignButton alloc]init];
    _cardBtn.frame = CGRectMake(_btnView.frame.size.width * 0.05, _btnView.frame.size.height * 0.2, _btnView.frame.size.width * 0.4, _btnView.frame.size.height * 0.6);
    _cardBtn.layer.cornerRadius = 10;
    _cardBtn.layer.masksToBounds = YES;
    _cardBtn.backgroundColor = [UIColor colorWithRed:68/255.0 green:158/255.0 blue:247/255.0 alpha:1];
    _cardBtn.layoutStyle = JXLayoutButtonStyleLeftImageRightTitle;
    [_cardBtn setTitle:@"定位签到" forState:UIControlStateNormal];
    [_cardBtn setImage:[UIImage imageNamed:@"gj_signlocation"] forState:UIControlStateNormal];
    _cardBtn.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [_cardBtn addTarget:self action:@selector(cardAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnView addSubview:_cardBtn];
    
    _scanBtn = [[SignButton alloc]init];
    _scanBtn.frame = CGRectMake(_btnView.frame.size.width * 0.05 * 2 + _cardBtn.frame.size.width + _cardBtn.frame.origin.x, _btnView.frame.size.height * 0.2, _btnView.frame.size.width * 0.4, _btnView.frame.size.height * 0.6);
    _scanBtn.layer.cornerRadius = 10;
    _scanBtn.layer.masksToBounds = YES;
    _scanBtn.backgroundColor = [UIColor colorWithRed:241/255.0 green:177/255.0 blue:99/255.0 alpha:1];
    _scanBtn.layoutStyle = JXLayoutButtonStyleLeftImageRightTitle;
    [_scanBtn setTitle:@"扫码签到" forState:UIControlStateNormal];
    [_scanBtn setImage:[UIImage imageNamed:@"gj_signscan1"] forState:UIControlStateNormal];
    _scanBtn.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [_scanBtn addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnView addSubview:_scanBtn];
    
    
    
    
}


-(void)photoAction:(UITapGestureRecognizer *)sender{
    NSString *whichPhoto = sender.accessibilityLabel;
    if([whichPhoto isEqualToString:@"First"]){
        [self handlePhoto:_recordImg clickImg:0];
    }else if([whichPhoto isEqualToString:@"Second"]){
        [self handlePhoto:_recordImg clickImg:1];
    }else if([whichPhoto isEqualToString:@"Third"]){
        [self handlePhoto:_recordImg clickImg:2];
    }else if([whichPhoto isEqualToString:@"Fourth"]){
        [self handlePhoto:_recordImg clickImg:3];
    }
}



-(void)handlePhoto:(int)recordImg clickImg:(int)numImg{
    if(recordImg == numImg){
        NSLog(@"打开相机");
        _currRecordImg = numImg;
        [self FromCamera];
    }else{
        if(recordImg > numImg){
            _alert = [[RAlertView alloc] initWithStyle:CancelAndConfirmAlert];
            _alert.headerTitleLabel.text = @"提示";
            _alert.contentTextLabel.attributedText = [TextHelper attributedStringForString:@"您要删除该照片吗？" lineSpacing:5];
            [_alert.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
            [_alert.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            [_alert.confirmButton setBackgroundColor:[UIColor colorWithRed:20/255.0 green:184/255.0 blue:247/255.0 alpha:1]];
            _alert.confirm = ^(){
                [self deleteImgAction:numImg];
            };
            _alert.cancel = ^(){
                NSLog(@"不删除");
            };
        }
    }
}



-(void) deleteImgAction:(int)numImg{
    if((numImg == _recordImg - 1) && numImg == 0){
        /*只有一张图片时*/
        NSLog(@"只有一张图片时");
        _photoFirst.image = [UIImage imageNamed:@"gj_signaddimg"];
        _photoSecond.image = NULL;
        _recordImg = 0;
    }else{
        if(_recordImg == 2){
            /*有两张图片时*/
            NSLog(@"有两张图片时");
            if(numImg == 0){
                NSLog(@"删除第一张");
                _photoFirst.image = _photoSecond.image;
                _photoSecond.image = [UIImage imageNamed:@"gj_signaddimg"];
                _photoThird.image = NULL;
                _recordImg--;
            }else if(numImg == 1){
                NSLog(@"删除第二张");
                _photoSecond.image = [UIImage imageNamed:@"gj_signaddimg"];
                _photoThird.image = NULL;
                _recordImg--;
            }
        }else if(_recordImg == 3){
            NSLog(@"有三张图片时");
            if(numImg == 0){
                NSLog(@"删除第一张");
                _photoFirst.image = _photoSecond.image;
                _photoSecond.image = _photoThird.image;
                _photoThird.image = [UIImage imageNamed:@"gj_signaddimg"];
                _photoFourth.image = NULL;
                _recordImg--;
            }else if(numImg == 1){
                NSLog(@"删除第二张");
                _photoSecond.image = _photoThird.image;
                _photoThird.image = [UIImage imageNamed:@"gj_signaddimg"];
                _photoFourth.image = NULL;
                _recordImg--;
            }else if(numImg == 2){
                NSLog(@"删除第三张");
                _photoThird.image = [UIImage imageNamed:@"gj_signaddimg"];
                _photoFourth.image = NULL;
                _recordImg--;
            }
        }else if(_recordImg == 4){
            NSLog(@"有四张图片时");
            if(numImg == 0){
                NSLog(@"删除第一张");
                _photoFirst.image = _photoSecond.image;
                _photoSecond.image = _photoThird.image;
                _photoThird.image = _photoFourth.image;
                _photoFourth.image = [UIImage imageNamed:@"gj_signaddimg"];
                _recordImg--;
            }else if(numImg == 1){
                NSLog(@"删除第二张");
                _photoSecond.image = _photoThird.image;
                _photoThird.image = _photoFourth.image;
                _photoFourth.image = [UIImage imageNamed:@"gj_signaddimg"];
                _recordImg--;
            }else if(numImg == 2){
                NSLog(@"删除第三张");
                _photoThird.image = _photoFourth.image;
                _photoFourth.image = [UIImage imageNamed:@"gj_signaddimg"];
                _recordImg--;
            }else if(numImg == 3){
                NSLog(@"删除第四张");
                _photoFourth.image = [UIImage imageNamed:@"gj_signaddimg"];
                _recordImg--;
            }
        }
    }
}



-(void) cardAction:(SignButton *)sender{
    NSString *meetingLab = _meetingValue.text;
    NSString *descrValue = _descrValue.text;
    if([meetingLab isEqualToString:@"请选择"]){
        RAlertView *alertView = [[RAlertView alloc] initWithStyle:ConfirmAlert];
        alertView.headerTitleLabel.text = @"提示";
        alertView.contentTextLabel.attributedText = [TextHelper attributedStringForString:@"请选择集会！" lineSpacing:5];
        [alertView.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    }else{
        NSLog(@"调用打卡接口");
    }
}

-(void) scanAction:(SignButton *)sender{
    QRCodeScanViewController *scan = [[QRCodeScanViewController alloc]init];
    [self presentViewController:scan animated:YES completion:nil];
}



// 调起拍照功能
- (void)FromCamera{
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



-(UIView *)loadSubView{
    UIView *view = [[UIView alloc]init];
    return view;
}


-(UILabel *)loadSubLab{
    UILabel *lab = [[UILabel alloc]init];
    return lab;
}

-(UITextField *)loadSubField{
    UITextField *field = [[UITextField alloc]init];
    return field;
}


-(UIImageView *)loadSubImgView{
    UIImageView *imgView = [[UIImageView alloc]init];
    return imgView;
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
    
    if(_currRecordImg == 0){
        _photoFirst.image = editedImg;
        _photoSecond.image = [UIImage imageNamed:@"gj_signaddimg"];
    }else if(_currRecordImg == 1){
        _photoSecond.image = editedImg;
        _photoThird.image = [UIImage imageNamed:@"gj_signaddimg"];
    }else if(_currRecordImg == 2){
        _photoThird.image = editedImg;
        _photoFourth.image = [UIImage imageNamed:@"gj_signaddimg"];
    }else if(_currRecordImg == 3){
        _photoFourth.image = editedImg;
    }
    _recordImg++;
    
    //移除图片选择的控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
