//
//  SXTaskDynamicCell.h
//  GJKJAPP
//
//  Created by 肖啸 on 2020/3/23.
//  Copyright © 2020 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXTaskDynamicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *submitLb;
@property (weak, nonatomic) IBOutlet UILabel *submitContentLb;
@property (weak, nonatomic) IBOutlet UILabel *checkLb;
@property (weak, nonatomic) IBOutlet UILabel *checkContentLb;
@property (weak, nonatomic) IBOutlet UILabel *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *overBtn;
@property (weak, nonatomic) IBOutlet UILabel *finalBtn;

@end

NS_ASSUME_NONNULL_END
