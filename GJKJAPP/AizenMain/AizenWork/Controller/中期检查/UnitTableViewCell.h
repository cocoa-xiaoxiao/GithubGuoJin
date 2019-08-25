//
//  UnitTableViewCell.h
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/2/21.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UnitTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name1;
@property (weak, nonatomic) IBOutlet UILabel *name2;
@property (weak, nonatomic) IBOutlet UILabel *name3;
@property (weak, nonatomic) IBOutlet UILabel *name4;
@property (weak, nonatomic) IBOutlet UILabel *sepLine;
@property (nonatomic, assign) CGFloat degress;
@property (nonatomic, strong) CAShapeLayer *layer1;
@property (nonatomic, strong) UILabel *shixilvLabel;
@end

NS_ASSUME_NONNULL_END
