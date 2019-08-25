//
//  ProReviewTableViewCell.h
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/1/7.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProReviewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *projectLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentLabel;
@property (weak, nonatomic) IBOutlet UILabel *chachongLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

NS_ASSUME_NONNULL_END
