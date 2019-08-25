//
//  MyReviewListViewCell.h
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/13.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyReviewListViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rsourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rstateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rscoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *rteacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *rplaceLabel;
@end

NS_ASSUME_NONNULL_END
