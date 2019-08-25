//
//  UnitStatisticsDetailViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/2/21.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "UnitStatisticsDetailViewController.h"
#import "UnitDetailTopView.h"
#import "UnitDetailMiddleView.h"
@interface UnitStatisticsDetailViewController ()
@property (nonatomic, strong) UnitDetailTopView *top;
@property (nonatomic, strong) UnitDetailMiddleView *middle;
@end

@implementation UnitStatisticsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"单位统计详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.top];
    [self.view addSubview:self.middle];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.top.frame = CGRectMake(5, 5, self.view.frame.size.width - 10, 200);
    self.middle.frame = CGRectMake(5, 210, self.view.frame.size.width-10, 250);
}

-(UnitDetailTopView *)top
{
    if (!_top) {
        _top = [[UnitDetailTopView alloc]init];
        _top.detailModel = self.detailModel;
    }
    return _top;
}

-(UnitDetailMiddleView *)middle
{
    if (!_middle) {
        _middle = [[UnitDetailMiddleView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-10, 250)];
        _middle.backgroundColor = [UIColor clearColor];
        NSString *youxiu = [NSString stringWithFormat:@"%.2f",self.detailModel.unit_sxl*0.01];
        NSString *lianghao = [NSString stringWithFormat:@"%.2f",self.detailModel.unit_jdsxl*0.01];
        NSString *zhongdeng = [NSString stringWithFormat:@"%.2f",self.detailModel.unit_dgl];
        _middle.leftDataArr =  @[youxiu,lianghao,zhongdeng];
    }
    return _middle;
}
@end
