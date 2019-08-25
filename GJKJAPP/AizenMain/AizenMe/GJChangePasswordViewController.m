//
//  GJChangePasswordViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/1/17.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "GJChangePasswordViewController.h"
#import "BRMoifyUserInfoViewController.h"
@interface GJChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldF;
@property (weak, nonatomic) IBOutlet UITextField *Fnew;
@property (weak, nonatomic) IBOutlet UITextField *AgainF;
@end

@implementation GJChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (IBAction)tijiao:(id)sender {
    if (self.oldF.text.length == 0) {
        [BRMoifyUserInfoViewController br_showAlterMsg:self.oldF.placeholder];
        return;
    }
    if (self.Fnew.text.length == 0) {
        [BRMoifyUserInfoViewController br_showAlterMsg:self.Fnew.placeholder];
        return;
    }
    if (self.AgainF.text.length == 0) {
        [BRMoifyUserInfoViewController br_showAlterMsg:self.AgainF.placeholder];
        return;
    }
    if (![self.Fnew.text isEqualToString:self.AgainF.text]) {
        [BRMoifyUserInfoViewController br_showAlterMsg:@"密码不一致"];
        return;
    }
}

@end
