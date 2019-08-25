//
//  FinalizationListTableViewCell.h
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/13.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FinalizationListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fsourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ftimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fstateLabel;
@property (weak, nonatomic) IBOutlet UILabel *fscoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *fteamLabel;
@property (weak, nonatomic) IBOutlet UILabel *fcheckLabel;
@end

NS_ASSUME_NONNULL_END
