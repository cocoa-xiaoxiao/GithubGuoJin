//
//  BaseNavigationController.m
//  GJKJAPP
//
//  Created by git burning on 2018/9/12.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "BaseNavigationController.h"
@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = [UIColor colorWithRed:1/255.0 green:137/255.0 blue:255/255.0 alpha:1];
    self.navigationBar.backgroundColor = self.navigationBar.barTintColor;
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationBar setShadowImage:[UIImage new]];
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000,0) forBarMetrics:UIBarMetricsDefault];
    
    // Do any additional setup after loading the view.
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


@end
