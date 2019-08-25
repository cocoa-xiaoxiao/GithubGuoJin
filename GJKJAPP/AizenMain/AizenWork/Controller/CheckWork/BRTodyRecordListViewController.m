//
//  BRTodyRecordListViewController.m
//  GJKJAPP
//
//  Created by git burning on 2018/9/15.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "BRTodyRecordListViewController.h"
#import "BRCheckWorkModel.h"
#import "BRTodyQianDaoTableViewCell.h"
#import "BaseTablewView.h"
@interface BRTodyRecordListViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation BRTodyRecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0, 0, WIDTH_SCREEN, 95*2 + 10*2);
    
    BaseTablewView *tabView = [[BaseTablewView alloc] init];
    [self.view addSubview:tabView];
    [tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    tabView.rowHeight = 95.0;
    tabView.delegate = self;
    tabView.dataSource =self;
    
    
    
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infoModel.signCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BRTodyQianDaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BRTodyQianDaoTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BRTodyQianDaoTableViewCell" owner:self options:nil] firstObject];
    }
    if (indexPath.row == 0) {
        cell.addressLabel.text = [NSString stringWithFormat:@"签到地址:%@",self.infoModel.CheckInPlace];
        cell.timeLabel.text = [NSString stringWithFormat:@"签到时间:%@",self.infoModel.CheckInDate];
    }
    else{
        cell.addressLabel.text = [NSString stringWithFormat:@"签退地址:%@",self.infoModel.CheckOutPlace];
        cell.timeLabel.text = [NSString stringWithFormat:@"签退时间:%@",self.infoModel.CheckOutDate];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
