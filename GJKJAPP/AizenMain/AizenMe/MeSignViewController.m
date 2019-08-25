//
//  MeSignViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/11/29.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MeSignViewController.h"
@interface MeSignViewController ()
@property (weak, nonatomic) IBOutlet UIView *CalendarsubView;

@end

@implementation MeSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
}
- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
