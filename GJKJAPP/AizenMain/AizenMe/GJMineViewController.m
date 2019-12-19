//
//  GJMineViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/11/28.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "GJMineViewController.h"
#import "LoginViewController.h"
#import "People.h"
@interface GJMineViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *myPhotoImg;
@property (weak, nonatomic) IBOutlet UILabel *realNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;
@property (weak, nonatomic) IBOutlet UILabel *majorLab;

@property LoginViewController *loginCtl;

@end

@implementation GJMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *header_url = getObj.FactUrl.fullImg;
    [self.myPhotoImg br_SDWebSetImageWithURLString:header_url placeholderImage:nil];
    self.realNameLab.text = [NSString stringWithFormat:@"%@",getObj.USERNAME];
    self.sexImg.image = [getObj.SEX isEqualToString:@"男"]?[UIImage imageNamed:@"gj_sexmale"]:[UIImage imageNamed:@"gj_sexfemale"];
    if (getObj.CLASSNAME==nil) {
        self.majorLab.text = [NSString stringWithFormat:@"%@ | %@",getObj.COLLEGENAME,getObj.PHONE];
    }else{
        self.majorLab.text = [NSString stringWithFormat:@"%@ | %@",getObj.CLASSNAME,getObj.PHONE];
    }
    
}
- (IBAction)logout:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定退出系统吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1;
    [alert show];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 1:
            if(buttonIndex == 1){
                [AizenStorage removeUserDataWithkey:@"TopModule"];
                [AizenStorage removeUserDataWithkey:@"SubModule"];
                [AizenStorage removeUserDataWithkey:@"isLogin"];
                [AizenStorage removeUserDataWithkey:@"batch"];
                [AizenStorage removeUserDataWithkey:@"batchID"];
//                _loginCtl = [[LoginViewController alloc]init];
//                _loginCtl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                _loginCtl = getControllerFromStoryBoard(@"Mine", @"myloginStoryID");
                _loginCtl.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:_loginCtl animated:YES completion:nil];
            }
            break;
        case 2:
            NSLog(@"设置按钮");
            break;
        default:
            break;
    }
    
}
@end
