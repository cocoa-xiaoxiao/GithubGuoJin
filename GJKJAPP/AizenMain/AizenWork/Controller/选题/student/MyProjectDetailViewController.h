//
//  MyProjectDetailViewController.h
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/10.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^deleteblock)();
@interface MyProjectDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *lookwordBtn;
@property (nonatomic, copy) NSString *pID;
@property (nonatomic, assign) BOOL laoshi;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shenbaotishiTop;
@property (weak, nonatomic) IBOutlet UIView *fubiaotiView;
@property (nonatomic, copy)deleteblock deleteblock;
- (IBAction)submit:(id)sender;

@end

NS_ASSUME_NONNULL_END
