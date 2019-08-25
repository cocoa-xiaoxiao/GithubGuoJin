//
//  NewMyProjectViewController.h
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/10.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewMyProjectViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *duli;
@property (weak, nonatomic) IBOutlet UIButton *team;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *tikuBtn;
- (IBAction)duli:(id)sender;
- (IBAction)team:(id)sender;
- (IBAction)newProject:(id)sender;
- (IBAction)selectFromTiku:(id)sender;
- (IBAction)submit:(id)sender;



@end

NS_ASSUME_NONNULL_END
