//
//  ChartsBaseViewController.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/6/1.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJKJAPP-Bridging-Header.h"

@interface ChartsBaseViewController : UIViewController{
    @protected NSArray *parties;
}

@property (nonatomic, strong) UIButton *optionsButton;
@property (nonatomic, strong) NSArray *options;

@property (nonatomic, assign) BOOL shouldHideData;

- (void)handleOption:(NSString *)key forChartView:(ChartViewBase *)chartView;

- (void)updateChartData;

- (void)setupPieChartView:(PieChartView *)chartView getTitle:(NSString *)title;
- (void)setupRadarChartView:(RadarChartView *)chartView;
- (void)setupBarLineChartView:(BarLineChartViewBase *)chartView;

@end
