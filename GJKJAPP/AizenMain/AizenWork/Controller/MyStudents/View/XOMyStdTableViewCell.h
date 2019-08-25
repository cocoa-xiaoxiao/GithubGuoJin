//
//  XOMyStdTableViewCell.h
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/6/4.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XOMyStdTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgv;
@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *sxlb;
@property (weak, nonatomic) IBOutlet UILabel *telLb;

@end

NS_ASSUME_NONNULL_END
