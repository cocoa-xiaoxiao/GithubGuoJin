//
//  ChooseSingImage.m
//  Meirong
//
//  Created by gitBurning on 15/8/30.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import "ChooseSingImage.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
//#import "UINavigationController+Smooth.h"
//#import <BlocksKit/BlocksKit.h>
#import <BlocksKit/BlocksKit+UIKit.h>
#define kSystemVersionChooseImage  [[[UIDevice currentDevice] systemVersion] floatValue]

#define kChooseImageActionSheetTag 100
@interface ChooseSingImage()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property(weak,nonatomic) UIViewController * currentVC;
@property(copy,nonatomic) id block;

@end;
@implementation ChooseSingImage
+(instancetype)shareChooseImage
{
    static ChooseSingImage * manae=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manae=[[ChooseSingImage alloc] init];
    });
    return manae;
}
-(void)showPhotoWithVC:(UIViewController *)vc withBlock:(void (^)(UIImage *, NSDictionary *))chooseImageBlock
{
    NSLog(@"Current method: %@ %@",[self class],NSStringFromSelector(_cmd));
    if (chooseImageBlock) {
        self.block = chooseImageBlock;
        
    }
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:NO];
    
    UIActionSheet * action=[[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择相机",@"选择相册", nil];
    
    action.tag=kChooseImageActionSheetTag;
    [action showInView:window];
    self.currentVC=vc;
}

- (void)showCameraPhotoWithVC:(UIViewController *)vc withBlock:(void (^)(UIImage *, NSDictionary *))chooseImageBlock {
    
    self.currentVC = vc;
    self.block = chooseImageBlock;
    UIImagePickerControllerSourceType sourceType =UIImagePickerControllerSourceTypeCamera;
    
    
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
            NSString *cancle =@"取消";
            NSArray * others = @[@"设置"];
            
            if (kSystemVersionChooseImage < 8.0) {
                cancle = @"知道了";
                others = nil;
            }
            
            UIAlertView * test = [UIAlertView bk_showAlertViewWithTitle:@"没有开启相机权限" message:@"请打开 设置-隐私-相机 来进行设置" cancelButtonTitle:cancle otherButtonTitles:others handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                
                if (buttonIndex==1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
            [test show];
            
            
            return;
        }
        
        sourceType=UIImagePickerControllerSourceTypeCamera ;
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    
    if (self.navColor) {
        
        // [picker.navigationBar setBackgroundImage:[UIImage imageNamed:@"123页眉背景"] forBarMetrics:UIBarMetricsDefault];
        picker.navigationBar.barTintColor = self.navColor;
        
    }
    picker.delegate = self;
    picker.allowsEditing = self.canEidit;//设置可编辑
    picker.sourceType = sourceType;
    picker.navigationBar.tintColor = [UIColor blackColor];
    picker.navigationBar.barTintColor = self.navColor;
    [picker.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
    
    [self.currentVC presentViewController:picker animated:YES completion:nil];//进入照相界面
    picker=nil;
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag==kChooseImageActionSheetTag) {
        
        UIImagePickerControllerSourceType sourceType =UIImagePickerControllerSourceTypeCamera;
        
        if (buttonIndex==0) {
            
            NSString *mediaType = AVMediaTypeVideo;
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
                NSString *cancle =@"取消";
                NSArray * others = @[@"设置"];
                
                if (kSystemVersionChooseImage < 8.0) {
                    cancle = @"知道了";
                    others = nil;
                }
                
                UIAlertView * test = [UIAlertView bk_showAlertViewWithTitle:@"没有开启相机权限" message:@"请打开 设置-隐私-相机 来进行设置" cancelButtonTitle:cancle otherButtonTitles:others handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    
                    if (buttonIndex==1) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }
                }];
                [test show];
                
                
                return;
            }
            
            sourceType=UIImagePickerControllerSourceTypeCamera ;
            
        }
        else if (buttonIndex==1){
            
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied)
                {
                NSString *cancle =@"取消";
                NSArray * others = @[@"设置"];
                
                if (kSystemVersionChooseImage < 8.0) {
                    cancle = @"知道了";
                    others = nil;
                }
                
                UIAlertView * test = [UIAlertView bk_showAlertViewWithTitle:@"没有开启相册权限" message:@"请打开 设置-隐私-照片 来进行设置" cancelButtonTitle:cancle otherButtonTitles:others handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    
                    if (buttonIndex==1) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }
                }];
                [test show];
                
                
                
                return;
                }
            
            sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            
        }
        
        if (buttonIndex!=2) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
            
            if (self.navColor) {
                
               // [picker.navigationBar setBackgroundImage:[UIImage imageNamed:@"123页眉背景"] forBarMetrics:UIBarMetricsDefault];
                picker.navigationBar.barTintColor = self.navColor;
                
            }
            picker.delegate = self;
            picker.allowsEditing = self.canEidit;//设置可编辑
            picker.sourceType = sourceType;
            picker.navigationBar.tintColor = [UIColor blackColor];
            picker.navigationBar.barTintColor = self.navColor;
            [picker.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];

            [self.currentVC presentViewController:picker animated:YES completion:nil];//进入照相界面
            picker=nil;
            
        }
        
    }
}
-(void)imagePickerController:(UIImagePickerController *)picke didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.canEidit) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    if (self.block) {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        void (^chooseImage)(UIImage*image,NSDictionary *info1) = self.block;
        chooseImage(image,info);
    }
    [picke dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

    [picker dismissViewControllerAnimated:YES completion:nil];

}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    
//    viewController.navBarBgAlpha = 1;
//    viewController.navBarTintColor = [UIColor blackColor];
    static  NSString *puui = @"PUUIImageViewController";
    static NSString *cami = @"CAMImagePickerCameraViewController";
    static NSString *PLUICameraViewController = @"PLUICameraViewController";
    NSString *vcClass = NSStringFromClass([viewController class]);
    
    if ([puui isEqualToString:vcClass  ] || [cami isEqualToString:vcClass] || [PLUICameraViewController isEqualToString:vcClass])
        {
        [UIView animateWithDuration:0.1 animations:^{
            navigationController.navigationBarHidden = YES;
        }];
        
        }else{
            navigationController.navigationBarHidden = NO;
            
        }
}
@end

