//
//  LDPublicWebViewController.h
//  LingDiApp
//
//  Created by gitBurning on 2017/8/3.
//  Copyright © 2017年 BR. All rights reserved.
//

#import "BaseViewController.h"
@class LDShareBaseModel;
@interface LDPublicWebViewController : BaseViewController

@property (nonatomic,copy) NSString *referer_domain;
@property (nonatomic, copy)  NSString *webUrl;
@property (nonatomic, strong) LDShareBaseModel *shareInfo;
+ (LDPublicWebViewController *)br_pushWebInVC:(UIViewController *)vc withUrl:(NSString *)url;


- (void)br_loadingUrl ;

/**
 公共分享方法

 @param shareInfo <#shareInfo description#>
 */
+ (void)br_publicSelectedShareInfo:(id)shareInfo inVC:(UIViewController *)vc;
@end
