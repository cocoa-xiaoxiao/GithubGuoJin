//
//  StandingPointViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/31.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "StandingPointViewController.h"
#import "GJKJAPP-Bridging-Header.h"

@interface StandingPointViewController ()<ChartViewDelegate>

@property (nonatomic, strong) PieChartView *chartView;
@property (nonatomic, strong) UISlider *sliderX;
@property (nonatomic, strong) UISlider *sliderY;
@property (nonatomic, strong) UITextField *sliderTextX;
@property (nonatomic, strong) UITextField *sliderTextY;

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *chartsView;
@property(nonatomic,strong) UIView *dataView;

@end

@implementation StandingPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self startLayout];
}


-(void) startLayout{
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - (HEIGHT_NAVBAR + HEIGHT_STATUSBAR + 44.0f));
    _contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contentView];
    
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    [_contentView addSubview:_scrollView];
    
    
    [self detailLayout];
}


-(void) detailLayout{
    _chartsView = [[UIView alloc]init];
    _chartsView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height * 0.6);
    [_scrollView addSubview:_chartsView];
    
    [self handleChartsView:_chartsView];
    
    _dataView = [[UIView alloc]init];
    _dataView.frame = CGRectMake(0, _chartsView.frame.size.height + _chartsView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height * 0.4);
    _dataView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_dataView];
    
    
    UIView *view1 = [[UIView alloc]init];
    view1.frame = CGRectMake(0, 0, _dataView.frame.size.width, _dataView.frame.size.height * 0.2);
    [_dataView addSubview:view1];
    
    CALayer *bottomLayer1 = [[CALayer alloc]init];
    bottomLayer1.frame = CGRectMake(view1.frame.size.width * 0.05, view1.frame.size.height - 1, view1.frame.size.width * 0.95, 1);
    bottomLayer1.backgroundColor = [UIColor lightGrayColor].CGColor;
    [view1.layer addSublayer:bottomLayer1];
    
    UILabel *view1Lab1 = [[UILabel alloc]init];
    view1Lab1.frame = CGRectMake(view1.frame.size.width * 0.05, view1.frame.size.height * 0.1, view1.frame.size.width * 0.45, view1.frame.size.height * 0.8);
    view1Lab1.text = @"需巡察企业数";
    view1Lab1.font = [UIFont systemFontOfSize:18.0];
    [view1 addSubview:view1Lab1];
    
    
    UILabel *view1Lab2 = [[UILabel alloc]init];
    view1Lab2.frame = CGRectMake(view1.frame.size.width * 0.5, view1.frame.size.height * 0.1, view1.frame.size.width * 0.45, view1.frame.size.height * 0.8);
    view1Lab2.text = @"100";
    view1Lab2.font = [UIFont systemFontOfSize:18.0];
    view1Lab2.textAlignment = UITextAlignmentRight;
    [view1 addSubview:view1Lab2];
    
    
    UIView *view2 = [[UIView alloc]init];
    view2.frame = CGRectMake(0, view1.frame.size.height + view1.frame.origin.y, _dataView.frame.size.width, _dataView.frame.size.height * 0.2);
    [_dataView addSubview:view2];
    
    CALayer *bottomLayer2 = [[CALayer alloc]init];
    bottomLayer2.frame = CGRectMake(view2.frame.size.width * 0.05, view2.frame.size.height - 1, view2.frame.size.width * 0.95, 1);
    bottomLayer2.backgroundColor = [UIColor lightGrayColor].CGColor;
    [view2.layer addSublayer:bottomLayer2];
    
    UILabel *view2Lab1 = [[UILabel alloc]init];
    view2Lab1.frame = CGRectMake(view2.frame.size.width * 0.05, view2.frame.size.height * 0.1, view2.frame.size.width * 0.45, view2.frame.size.height * 0.8);
    view2Lab1.text = @"已收报告";
    view2Lab1.font = [UIFont systemFontOfSize:18.0];
    [view2 addSubview:view2Lab1];
    
    
    UILabel *view2Lab2 = [[UILabel alloc]init];
    view2Lab2.frame = CGRectMake(view2.frame.size.width * 0.5, view2.frame.size.height * 0.1, view2.frame.size.width * 0.45, view2.frame.size.height * 0.8);
    view2Lab2.text = @"1000";
    view2Lab2.font = [UIFont systemFontOfSize:18.0];
    view2Lab2.textAlignment = UITextAlignmentRight;
    [view2 addSubview:view2Lab2];
    
    
    
    UIView *view3 = [[UIView alloc]init];
    view3.frame = CGRectMake(0, view2.frame.size.height + view2.frame.origin.y, _dataView.frame.size.width, _dataView.frame.size.height * 0.2);
    [_dataView addSubview:view3];
    
    CALayer *bottomLayer3 = [[CALayer alloc]init];
    bottomLayer3.frame = CGRectMake(view3.frame.size.width * 0.05, view3.frame.size.height - 1, view3.frame.size.width * 0.95, 1);
    bottomLayer3.backgroundColor = [UIColor lightGrayColor].CGColor;
    [view3.layer addSublayer:bottomLayer3];
    
    UILabel *view3Lab1 = [[UILabel alloc]init];
    view3Lab1.frame = CGRectMake(view3.frame.size.width * 0.05, view3.frame.size.height * 0.1, view3.frame.size.width * 0.45, view3.frame.size.height * 0.8);
    view3Lab1.text = @"待巡察企业数";
    view3Lab1.font = [UIFont systemFontOfSize:18.0];
    [view3 addSubview:view3Lab1];
    
    
    UILabel *view3Lab2 = [[UILabel alloc]init];
    view3Lab2.frame = CGRectMake(view3.frame.size.width * 0.5, view3.frame.size.height * 0.1, view3.frame.size.width * 0.45, view3.frame.size.height * 0.8);
    view3Lab2.text = @"20";
    view3Lab2.font = [UIFont systemFontOfSize:18.0];
    view3Lab2.textAlignment = UITextAlignmentRight;
    [view3 addSubview:view3Lab2];
    
    
    
    
    UIView *view4 = [[UIView alloc]init];
    view4.frame = CGRectMake(0, view3.frame.size.height + view3.frame.origin.y, _dataView.frame.size.width, _dataView.frame.size.height * 0.2);
    [_dataView addSubview:view4];
    
    CALayer *bottomLayer4 = [[CALayer alloc]init];
    bottomLayer4.frame = CGRectMake(view4.frame.size.width * 0.05, view4.frame.size.height - 1, view4.frame.size.width * 0.95, 1);
    bottomLayer4.backgroundColor = [UIColor lightGrayColor].CGColor;
    [view4.layer addSublayer:bottomLayer4];
    
    UILabel *view4Lab1 = [[UILabel alloc]init];
    view4Lab1.frame = CGRectMake(view4.frame.size.width * 0.05, view4.frame.size.height * 0.1, view4.frame.size.width * 0.45, view4.frame.size.height * 0.8);
    view4Lab1.text = @"已巡察企业数";
    view4Lab1.font = [UIFont systemFontOfSize:18.0];
    [view4 addSubview:view4Lab1];
    
    
    UILabel *view4Lab2 = [[UILabel alloc]init];
    view4Lab2.frame = CGRectMake(view4.frame.size.width * 0.5, view4.frame.size.height * 0.1, view4.frame.size.width * 0.45, view4.frame.size.height * 0.8);
    view4Lab2.text = @"80";
    view4Lab2.font = [UIFont systemFontOfSize:18.0];
    view4Lab2.textAlignment = UITextAlignmentRight;
    [view4 addSubview:view4Lab2];
    
    
    
    UIView *view5 = [[UIView alloc]init];
    view5.frame = CGRectMake(0, view4.frame.size.height + view4.frame.origin.y, _dataView.frame.size.width, _dataView.frame.size.height * 0.2);
    [_dataView addSubview:view5];
    
    CALayer *bottomLayer5 = [[CALayer alloc]init];
    bottomLayer5.frame = CGRectMake(view5.frame.size.width * 0.05, view5.frame.size.height - 1, view5.frame.size.width * 0.95, 1);
    bottomLayer5.backgroundColor = [UIColor lightGrayColor].CGColor;
    [view5.layer addSublayer:bottomLayer5];
    
    UILabel *view5Lab1 = [[UILabel alloc]init];
    view5Lab1.frame = CGRectMake(view5.frame.size.width * 0.05, view5.frame.size.height * 0.1, view5.frame.size.width * 0.45, view5.frame.size.height * 0.8);
    view5Lab1.text = @"巡察覆盖率";
    view5Lab1.font = [UIFont systemFontOfSize:18.0];
    [view5 addSubview:view5Lab1];
    
    
    UILabel *view5Lab2 = [[UILabel alloc]init];
    view5Lab2.frame = CGRectMake(view5.frame.size.width * 0.5, view5.frame.size.height * 0.1, view5.frame.size.width * 0.45, view5.frame.size.height * 0.8);
    view5Lab2.text = @"20%";
    view5Lab2.font = [UIFont systemFontOfSize:18.0];
    view5Lab2.textAlignment = UITextAlignmentRight;
    [view5 addSubview:view5Lab2];

}






-(void) handleChartsView:(UIView *)sender{
    _chartView = [[PieChartView alloc]init];
    _chartView.frame = CGRectMake(0, 0, sender.frame.size.width, sender.frame.size.height);
    [sender addSubview:_chartView];
    
    _sliderX = [[UISlider alloc]init];
    _sliderY = [[UISlider alloc]init];
    //    _sliderTextX = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    //    _sliderTextY = [[UITextField alloc]initWithFrame:CGRectMake(0, 100, 100, 50)];
    
    [self.view addSubview:_sliderTextX];
    [self.view addSubview:_sliderTextY];
    
    //    self.options = @[
    //                     @{@"key": @"toggleValues", @"label": @"Toggle Y-Values"},
    //                     @{@"key": @"toggleXValues", @"label": @"Toggle X-Values"},
    //                     @{@"key": @"togglePercent", @"label": @"Toggle Percent"},
    //                     @{@"key": @"toggleHole", @"label": @"Toggle Hole"},
    //                     @{@"key": @"toggleIcons", @"label": @"Toggle Icons"},
    //                     @{@"key": @"animateX", @"label": @"Animate X"},
    //                     @{@"key": @"animateY", @"label": @"Animate Y"},
    //                     @{@"key": @"animateXY", @"label": @"Animate XY"},
    //                     @{@"key": @"spin", @"label": @"Spin"},
    //                     @{@"key": @"drawCenter", @"label": @"Draw CenterText"},
    //                     @{@"key": @"saveToGallery", @"label": @"Save to Camera Roll"},
    //                     @{@"key": @"toggleData", @"label": @"Toggle Data"},
    //                     ];
    
    [self setupPieChartView:_chartView getTitle:@"驻点巡察"];
    
    _chartView.delegate = self;
    
    ChartLegend *l = _chartView.legend;
    //    l.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentCenter;
    l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;
    
    // entry label styling
    _chartView.entryLabelColor = UIColor.whiteColor;
    _chartView.entryLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
    
    _sliderX.value = 4.0;
    _sliderY.value = 100.0;
    [self slidersValueChanged:nil];
    
    [_chartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
    
}


- (void)updateChartData{
    if (self.shouldHideData){
        _chartView.data = nil;
        return;
    }
    
    [self setDataCount:_sliderX.value range:_sliderY.value];
}

- (void)setDataCount:(int)count range:(double)range{
    double mult = range;
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    //    for (int i = 0; i < 10; i++)
    //    {
    //        [values addObject:[[PieChartDataEntry alloc] initWithValue:(arc4random_uniform(mult) + mult / 5) label:parties[i % parties.count] icon: [UIImage imageNamed:@"icon"]]];
    //    }
    [values addObject:[[PieChartDataEntry alloc] initWithValue:80 label:@"已巡察" icon: [UIImage imageNamed:@"icon"]]];
    
    [values addObject:[[PieChartDataEntry alloc] initWithValue:20 label:@"待巡察" icon: [UIImage imageNamed:@"icon"]]];
    
    
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@""];
    
    dataSet.drawIconsEnabled = NO;
    
    dataSet.sliceSpace = 2.0;
    dataSet.iconsOffset = CGPointMake(0, 40);
    
    // add a lot of colors
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 0.9;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.f]];
    [data setValueTextColor:UIColor.lightGrayColor];
    
    _chartView.data = data;
    [_chartView highlightValues:nil];
}

- (void)optionTapped:(NSString *)key{
    if ([key isEqualToString:@"toggleXValues"]){
        _chartView.drawEntryLabelsEnabled = !_chartView.drawEntryLabelsEnabled;
        
        [_chartView setNeedsDisplay];
        return;
    }
    
    if ([key isEqualToString:@"togglePercent"]){
        _chartView.usePercentValuesEnabled = !_chartView.isUsePercentValuesEnabled;
        
        [_chartView setNeedsDisplay];
        return;
    }
    
    if ([key isEqualToString:@"toggleHole"]){
        _chartView.drawHoleEnabled = !_chartView.isDrawHoleEnabled;
        
        [_chartView setNeedsDisplay];
        return;
    }
    
    if ([key isEqualToString:@"drawCenter"]){
        _chartView.drawCenterTextEnabled = !_chartView.isDrawCenterTextEnabled;
        
        [_chartView setNeedsDisplay];
        return;
    }
    
    if ([key isEqualToString:@"animateX"]){
        [_chartView animateWithXAxisDuration:1.4];
        return;
    }
    
    if ([key isEqualToString:@"animateY"]){
        [_chartView animateWithYAxisDuration:1.4];
        return;
    }
    
    if ([key isEqualToString:@"animateXY"]){
        [_chartView animateWithXAxisDuration:1.4 yAxisDuration:1.4];
        return;
    }
    
    if ([key isEqualToString:@"spin"]){
        [_chartView spinWithDuration:2.0 fromAngle:_chartView.rotationAngle toAngle:_chartView.rotationAngle + 360.f easingOption:ChartEasingOptionEaseInCubic];
        return;
    }
    
    [super handleOption:key forChartView:_chartView];
}

#pragma mark - Actions

- (void)slidersValueChanged:(id)sender{
    _sliderTextX.text = [@((int)_sliderX.value) stringValue];
    _sliderTextY.text = [@((int)_sliderY.value) stringValue];
    
    [self updateChartData];
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView{
    NSLog(@"chartValueNothingSelected");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
