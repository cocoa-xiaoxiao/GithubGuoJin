//
//  MineFeedbackViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/11/28.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MineFeedbackViewController.h"

@interface MineFeedbackViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation MineFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
@end
