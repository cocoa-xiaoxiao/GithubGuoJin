//
//  GJStudentSOSHistoryViewController.m
//  GJKJAPP
//
//  Created by git burning on 2018/10/13.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "GJStudentSOSHistoryViewController.h"
#import "GJSOSRecordListTableViewCell.h"
#import "GJASOSDetailViewController.h"
@interface GJStudentSOSHistoryViewController ()

@end

@implementation GJStudentSOSHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的预警";
    [self addNomolTablewDelegate:self];
    self.categoryTablew.rowHeight = [GJSOSRecordListTableViewCell br_getUITableViewCellHeight];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GJSOSRecordListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GJSOSRecordListTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GJSOSRecordListTableViewCell" owner:self options:nil] firstObject];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GJASOSDetailViewController *vc = [[GJASOSDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
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
