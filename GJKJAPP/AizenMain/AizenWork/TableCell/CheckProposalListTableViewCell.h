//
//  CheckProposalListTableViewCell.h
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/13.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckProposalListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *pnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *psourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ptimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pstateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pteamLabel;
@end

NS_ASSUME_NONNULL_END
