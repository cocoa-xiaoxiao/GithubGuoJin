//
//  MyteacherTableViewCell.h
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/2/22.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyteacherTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;

@end

NS_ASSUME_NONNULL_END
