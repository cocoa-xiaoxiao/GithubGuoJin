//
//  QRCodeScanViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/3/18.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "QRCodeScanViewController.h"
#import "LemonQRScan.h"
@interface QRCodeScanViewController()<LemonQRScanDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong,nonatomic)LemonQRScan *qrscan;
@end
@implementation QRCodeScanViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LemonQRScan requestAccessForCamera:^(BOOL enable) {
            if (enable) {
                self.qrscan = [LemonQRScan createQRScanIn:self.view];
                self.qrscan.delegate = self;
                
                [self.qrscan startRunning];
            }
        }];
    });
    
}
-(void)buttonOnclickCallBack:(LemonQRScanBtnOnclickEvent)status{
    switch (status) {
        case LemonQRScanBtnOnclickEventPhotoAlbum:{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该功能暂不开放！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case LemonQRScanBtnOnclickEventTorch:{
            [self.qrscan progressTorch];
        }
            break;
        case LemonQRScanBtnOnclickEventClose:{
            [self.qrscan stopRunning];
            [self dismissViewControllerAnimated:YES  completion:nil];
        }
            break;
        default:
            break;
    }
}
- (void)presentPhotoVC{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - result
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    [picker dismissViewControllerAnimated:YES completion:nil];
    if(!image){
        return;
    }
    NSLog(@"扫描结果：%@",[LemonQRScan stringValueFrom:image]);
}
-(void)qrCodeValueString:(NSString *)valueString{
    NSLog(@"扫描结果：%@",valueString);
}
@end

