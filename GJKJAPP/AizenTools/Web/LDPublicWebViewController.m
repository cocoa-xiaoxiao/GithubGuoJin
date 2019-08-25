//
//  LDPublicWebViewController.m
//  LingDiApp
//
//  Created by gitBurning on 2017/8/3.
//  Copyright © 2017年 BR. All rights reserved.
//

#import "LDPublicWebViewController.h"
#import <WebKit/WebKit.h>
//#import "LDBaseModel.h"
//#import "ThirdNativeLogInManager.h"
//#import "BRBannerModel.h"
//#import "BRHomeViewController.h"
//#import "WebChatPayH5VIew.h"
//#import "BRCaseViewModel.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
@interface LDPublicWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) WKUserContentController *configJs;

@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

@property (nonatomic,assign) BOOL isHiddenTabber;
@end

@implementation LDPublicWebViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.configJs addScriptMessageHandler:self name:@"native_fun"];
    
    if (self.isHiddenTabber == NO) {
        if (self.isApear) {
            self.isApear = NO;
            [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
            
        }
    }
 
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.configJs removeScriptMessageHandlerForName:@"native_fun"];
    if (self.isHiddenTabber == NO) {
        self.isApear = YES;
        [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    }
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    self.isApear = NO;
    self.isHiddenTabber = self.navigationController.childViewControllers.count > 2 ? YES:NO;
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *js = [[WKUserContentController alloc] init];
   // [js addScriptMessageHandler:self name:@"native_fun"];
    _configJs = js;
    config.userContentController = js;
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    webView.tag = 100;
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.mas_offset(0);
        make.top.mas_offset(64);
        make.bottom.mas_offset(0);
    }];
//    if (_webUrl == nil) {
//        _webUrl = @"https://www.baidu.com/";
//        [SVProgressHUDHelp showAlter:@"数据异常" isFailse:YES];
//        [BaseViewModel performBlock:^{
//            [self.navigationController popViewControllerAnimated:true];
//        } afterDelay:kDismissAlertTime];
//        return;
//    }
   // _webUrl = @"https://test-app.kzmen.cn/testnative.html";
    if (self.webUrl.length > 0) {
        [self br_loadingUrl];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.webUrl] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30];
//
//        NSString *sign = [BRUserHelp shareUserHelp].userModel.sign;
//        NSString *token = [BRUserHelp shareUserHelp].userModel.token;
//        if (sign == nil) {
//            sign = @"";
//        }
//
//        if (token == nil) {
//            token = @"";
//        }
//        [request setValue:sign forHTTPHeaderField:@"sign"];
//        [request setValue:token forHTTPHeaderField:@"token"];
//
//         [webView loadRequest:request];
    }
    //js
  
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    webView.allowsBackForwardNavigationGestures = YES;
    if (!self.shareInfo) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    //webView.backForwardList.backList.count
    // Do any additional setup after loading the view.
    WS(ws);
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[[MainViewController colorWithHexString:@"#0092ff"] copy]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [self.view addSubview:_activityIndicatorView];
    _activityIndicatorView.layer.zPosition = 1000;
   
}


- (void)br_loadingUrl {
    if (self.webUrl.length > 0) {
        WKWebView *webView = [self.view viewWithTag:100];
        NSMutableURLRequest *request;
        if ([self.webUrl rangeOfString:@"docx"].location == NSNotFound) {
          request =  [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.webUrl] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30];
        }
        else{
            request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self.webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//            [request addValue:@"application/vnd.openxmlformats-officedocument.wordprocessingml.document" forHTTPHeaderField:@"Content-Type"];
           
        }
        //content-type MIME
        
     
     
        
//        [fileViewDemo loadRequest:request];
        //[request setHTTPMethod:@"GET"];

        
        [webView loadRequest:request];
    }
}

-(void)br_addRightShareItemInfo:(id)shareInfo {
    
   
}

+(LDPublicWebViewController *)br_pushWebInVC:(UIViewController *)vc withUrl:(NSString *)url {
    
    LDPublicWebViewController *web = [[LDPublicWebViewController alloc] init];
    web.webUrl = url;
    if (vc) {
        [vc.navigationController pushViewController:web animated:YES];
        return nil;
    }
    else{
        return web;
    }
    
}
- (BOOL)needConfigBgView {
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_activityIndicatorView startAnimating];
    // [SVProgressHUDHelp showLoading:NO];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    //  [SVProgressHUDHelp dismiss];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [_activityIndicatorView stopAnimating];
    if (self.title.length == 0) {
        // self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable info, NSError * _Nullable error) {
            
            if (self.navigationItem.title == nil) {
                self.navigationItem.title = info;
            }
        }];
    }
    
    self.navigationItem.rightBarButtonItem.enabled = YES;

    //    [webView evaluateJavaScript:@"document.body.clientHeight" completionHandler:^(id _Nullable info, NSError * _Nullable error) {
    //
    //
    //    }];
    
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *reqUrl = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    navigationAction.request
    if ([reqUrl hasPrefix:@"alipays://"] || [reqUrl hasPrefix:@"alipay://"]) {
        // NOTE: 跳转支付宝App
        BOOL bSucc = [[UIApplication sharedApplication]openURL:navigationAction.request.URL];
        
        // NOTE: 如果跳转失败，则跳转itune下载支付宝App
        if (!bSucc) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"未检测到支付宝客户端，请安装后重试。"
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    else if ([reqUrl rangeOfString:@"https://wx.tenpay.com"].location != NSNotFound) {


        decisionHandler(WKNavigationActionPolicyAllow);
        
        return;
    }

    decisionHandler(WKNavigationActionPolicyAllow);
    
}



// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    
    
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [_activityIndicatorView stopAnimating];

    
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [_activityIndicatorView stopAnimating];

}

#pragma mark - WKUIDelegate

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if (!navigationAction.targetFrame.isMainFrame) {
        
        //        KINWebBrowserViewController *webBrowser = [KINWebBrowserViewController webBrowser];
        //        [webBrowser loadURL:navigationAction.request.URL];
        //        [self.navigationController pushViewController:webBrowser animated:NO];
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * actoin = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alter addAction:actoin];
    
    [self presentViewController:alter animated:YES completion:nil];
    
    //    let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
    //    let action = UIAlertAction(title: "好的", style: UIAlertActionStyle.Cancel) { (_) in
    //        completionHandler()
    //    }
    //    alert.addAction(action)
    //    presentViewController(alert, animated: true, completion: nil)
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    //  js 里面的alert实现，如果不实现，网页的alert函数无效  ,
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler(YES);
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action){
                                                          completionHandler(NO);
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
    
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
   
}

- (void)dealloc
{
    NSLog(@"内存释放--%@",NSStringFromClass([self class]) );
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [_activityIndicatorView stopAnimating];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
