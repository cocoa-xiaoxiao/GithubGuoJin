//
//  TaskBookListTableViewCell.h
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/13.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskBookListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bsourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *btimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bstateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bteamLabel;
@end

NS_ASSUME_NONNULL_END
