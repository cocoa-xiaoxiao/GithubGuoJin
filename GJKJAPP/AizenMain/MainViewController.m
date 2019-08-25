//
//  MainViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/1/12.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MainViewController.h"
#import "MsgViewController.h"
#import "WorkViewController.h"
#import "ServiceViewController.h"
#import "MeViewController.h"
#import "MyViewController.h"
#import "AizenStorage.h"
#import "NewMeViewController.h"
#import "NewWorkViewController.h"
#import "NewMsgViewController.h"
#import "BaseNavigationController.h"
#import "UIImage+NFExten.h"
#import "RDVTabBarItem.h"
@interface MainViewController ()

@property(nonatomic,assign) UIViewController *MsgCtl;
@property(nonatomic,assign)UIViewController *WorkCtl;
@property(nonatomic,assign)UIViewController *ServiceCtl;
@property(nonatomic,assign)UIViewController *MeCtl;
@property(nonatomic) UIViewController *MyCtl;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@",[AizenStorage readUserDataWithKey:@"batch"]);
    
    _MsgCtl = [[NewMsgViewController alloc]init];
    _MsgCtl.title = @"消息";
    UIViewController *MsgNavigationCtl = [[UINavigationController alloc]initWithRootViewController:_MsgCtl];

    _WorkCtl = [[NewWorkViewController alloc]init];
    _WorkCtl.title = @"工作台";
    UINavigationController *WorkNavigationCtl = [[UINavigationController alloc]initWithRootViewController:_WorkCtl];
    WorkNavigationCtl.navigationBar.tintColor = [UIColor whiteColor];
    _ServiceCtl = [[ServiceViewController alloc]init];
    _ServiceCtl.title = @"服务";
    UIViewController *ServiceNavigationCtl = [[UINavigationController alloc]initWithRootViewController:_ServiceCtl];

//    _MeCtl = [[MeViewController alloc]init];
//    _MeCtl.title = @"我的";
//    UIViewController *MeNavigationCtl = [[UINavigationController alloc]initWithRootViewController:_MeCtl];
    
    _MyCtl = [[NewMeViewController alloc]init];
    _MyCtl.title = @"我的";
    UIViewController *MyNavigationCtl = [[BaseNavigationController alloc]initWithRootViewController:_MyCtl];

//    [self setViewControllers:@[MsgNavigationCtl, WorkNavigationCtl,                                       ServiceNavigationCtl,MyNavigationCtl]];
//    WorkNavigationCtl.tabBarItem.image = [UIImage imageNamed:@"tabber_work"];
//    WorkNavigationCtl.tabBarItem.image = [UIImage imageNamed:@"tabber_me"];

    [self setViewControllers:@[MsgNavigationCtl,WorkNavigationCtl,MyNavigationCtl]];

    [self setSelectedIndex:0];
    [self customizeTabBarForController:self];
   // [self customizeInterface];
}

-(void) customizeTabBarForController:(RDVTabBarController *)tabBarController{
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_normal1"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal1"];
    NSArray *tabBarItemImages = @[@"tabber_msg",@"tabber_work", @"tabber_me"];

    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
    
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        //kAppMainColor
        UIImage *selectedimage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@",
                                                       [tabBarItemImages objectAtIndex:index]]] br_imageWithColor:kAppMainColor];
        
        UIGraphicsBeginImageContext(CGSizeMake(35, 35));
        [selectedimage drawInRect:CGRectMake(0, 0, 35, 35)];
        UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",
                                                        [tabBarItemImages objectAtIndex:index]]];
        
        UIGraphicsBeginImageContext(CGSizeMake(35, 35));
        [unselectedimage drawInRect:CGRectMake(0, 0, 35, 35)];
        UIImage *unreSizeImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [item setFinishedSelectedImage:reSizeImage withFinishedUnselectedImage:unreSizeImage];
        
        index++;
        
        NSDictionary *textAttributes = nil;
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:15],
                           UITextAttributeTextColor: [UIColor blackColor],
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
        
        NSDictionary *textSelectedAttributes = nil;
        textSelectedAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:15],
                           UITextAttributeTextColor: kAppMainColor,
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
        item.unselectedTitleAttributes = textAttributes;
        item.selectedTitleAttributes = textSelectedAttributes;
//        item.unselectedTitleAttributes = textAttributes;
        
    }
}


- (void)customizeInterface {

    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        backgroundImage = [UIImage imageNamed:@"navigationbar_background_tall"];
        
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                           NSForegroundColorAttributeName: [UIColor blackColor],
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        backgroundImage = [UIImage imageNamed:@"navigationbar_background"];
        
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:18],
                           UITextAttributeTextColor: [UIColor blackColor],
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
        
        
#endif
    }
    
    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}



+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor *) colorWithHexString: (NSString *) hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            return nil;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
