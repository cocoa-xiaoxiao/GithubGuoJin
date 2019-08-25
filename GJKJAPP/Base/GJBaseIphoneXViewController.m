//
//  GJBaseIphoneXViewController.m
//  GJKJAPP
//
//  Created by git burning on 2018/10/9.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "GJBaseIphoneXViewController.h"

@interface GJBaseIphoneXViewController ()

@end

@implementation GJBaseIphoneXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentView = [[UIView alloc] init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.nav_offset);
        make.bottom.mas_equalTo(kIphonexButtomHeight());
    }];
    // Do any additional setup after loading the view.
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
