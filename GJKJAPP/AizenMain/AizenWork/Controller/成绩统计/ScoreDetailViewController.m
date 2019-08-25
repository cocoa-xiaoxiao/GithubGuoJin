//
//  ScoreDetailViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/2/16.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "ScoreDetailViewController.h"
#import "ScoreSCLView.h"
#import "ScoreTableView.h"
@interface ScoreDetailViewController ()
@property (nonatomic, strong) ScoreSCLView *sclView;
@property (nonatomic, strong) ScoreTableView *tbView;
@end

@implementation ScoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"成绩详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.sclView];
    [self.view addSubview:self.tbView];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.sclView.frame = CGRectMake(5, 5, self.view.frame.size.width - 10, 200);
    self.tbView.frame = CGRectMake(5, 210, self.view.frame.size.width-10, 250);
}

-(ScoreSCLView *)sclView
{
    if (!_sclView) {
        _sclView = [[ScoreSCLView alloc]init];
        _sclView.scoreDetail = self.scoreDetail;
    }
    return _sclView;
}

-(ScoreTableView *)tbView
{
    if (!_tbView) {
        _tbView = [[ScoreTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-10, 250)];
        _tbView.backgroundColor = [UIColor clearColor];
        NSString *youxiu = [NSString stringWithFormat:@"%.2f",self.scoreDetail.yxl*0.01];
        NSString *lianghao = [NSString stringWithFormat:@"%.2f",self.scoreDetail.lhl*0.01];
        NSString *zhongdeng = [NSString stringWithFormat:@"%.2f",self.scoreDetail.zdl*0.01];
        NSString *hege = [NSString stringWithFormat:@"%.2f",self.scoreDetail.hgl*0.01];
        NSString *buhege = [NSString stringWithFormat:@"%.2f",self.scoreDetail.bhgl*0.01];
        _tbView.leftDataArr =  @[youxiu,lianghao,zhongdeng,hege,buhege];
    }
    return _tbView;
}
@end
