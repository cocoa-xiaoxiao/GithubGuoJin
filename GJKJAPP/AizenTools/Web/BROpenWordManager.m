//
//  BROpenWordManager.m
//  GJKJAPP
//
//  Created by git burning on 2018/9/21.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "BROpenWordManager.h"
#import "HTTPOpration.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"

#import <QuickLook/QuickLook.h>
@interface BROpenWordManager()<UIDocumentInteractionControllerDelegate,QLPreviewControllerDelegate,QLPreviewControllerDataSource>
@property (nonatomic, weak) UIViewController *openInVC;
@property (nonatomic, strong) DGActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong) UIDocumentInteractionController *wordVC;
@end
@implementation BROpenWordManager
+(instancetype)share {
    static BROpenWordManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BROpenWordManager alloc] init];
    });
    return manager;
}
- (void)br_configHUDInView:(UIView *)inView{
    if (_activityIndicatorView) {
        [_activityIndicatorView removeFromSuperview];
        _activityIndicatorView = nil;
    }
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((inView.frame.size.width - 100)/2, (inView.frame.size.height - 200)/2, 100, 100);
    [inView addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
}
- (void)br_openAWordWithUrl:(NSString *)url fileId:(NSString *)fileId vc:(BaseViewController *)vc
{
    fileId = [NSString stringWithFormat:@"%@|%@",fileId,[[url componentsSeparatedByString:@"/"] lastObject]];
    NSString *cacheName = [self br_saveCacheFiles:fileId fileData:nil];
    if (cacheName.length > 0) {
//        UIDocumentInteractionController *doc= [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:cacheName]];
//        doc.delegate = self;
//        self.openInVC = vc;
//        self.wordVC = doc;
//        [doc presentPreviewAnimated:YES];
        
        QLPreviewController *qlController = [[QLPreviewController alloc]init];
        qlController.delegate = self;
        qlController.dataSource = self;
        qlController.accessibilityLabel = cacheName;
        [qlController setCurrentPreviewItemIndex:0];
        [vc presentViewController:qlController animated:YES completion:nil];
    
    }
    else{
        NSString *fullStr = [url fullImg];
        NSURL *url1 = [NSURL URLWithString:[fullStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url1];
        [self br_configHUDInView:vc.view];
       NSURLSessionDataTask *task = [[HTTPOpration sharedHTTPOpration] dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            
        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                [_activityIndicatorView stopAnimating];
                [BaseViewController br_showAlterMsg:@"下载错误。请重试"];
            }
            else{
                [self br_saveCacheFiles:fileId fileData:responseObject];
                [_activityIndicatorView stopAnimating];

            }
        }];
        [task resume];
    }
    
   
   
}
-(NSString *)br_saveCacheFiles:(NSString*)fileName fileData:(NSData*)fileData{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    NSLog(@"app_home_doc: %@",documentsDirectory);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",fileName]]; //docPath为文件名
    if (![fileManager fileExistsAtPath:filePath]) { //文件已经存在,直接打开
       BOOL success = [fileData writeToFile:filePath atomically:YES];
        return nil;
    }
    return filePath;

}
#pragma mark - UIDocumentInteractionControllerDelegate //必须实现的代理方法 预览窗口以模式窗口的形式显示，因此需要在该方法中返回一个view controller ，作为预览窗口的父窗口。如果你不实现该方法，或者在该方法中返回 nil，或者你返回的 view controller 无法呈现模式窗口，则该预览窗口不会显示。
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self.openInVC;
    
}
- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller {
    return self.openInVC.view;
    
}
- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller {
    return CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 30);
    
}
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

/*!
 * @abstract Returns the item that the preview controller should preview.
 * @param controller The Preview Controller.
 * @param index The index of the item to preview.
 * @result An item conforming to the QLPreviewItem protocol.
 */
- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    NSString *path = controller.accessibilityLabel;//[[NSBundle mainBundle] pathForResource:@"测试" ofType:@"docx"];
    NSURL *url = [NSURL fileURLWithPath:path];
    return url;
}



@end
