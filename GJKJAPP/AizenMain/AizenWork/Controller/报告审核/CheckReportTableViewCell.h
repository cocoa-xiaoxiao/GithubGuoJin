//
//  CheckReportTableViewCell.h
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/4/3.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^selectCellBlock)(UITableViewCell *cell,checkReportModel *model);
@interface CheckReportTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *xunchaLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *danweiLb;
@property (weak, nonatomic) IBOutlet UILabel *dizhiLb;
@property (weak, nonatomic) IBOutlet UILabel *zhuangtaiLb;
@property (weak, nonatomic) IBOutlet UILabel *pianquLb;
@property (weak, nonatomic) IBOutlet UILabel *biaotiLb;
@property (weak, nonatomic) IBOutlet UIButton *xuanzeBtn;
@property (nonatomic, copy) checkReportModel *model;
@property (copy, nonatomic) selectCellBlock block;

@end

NS_ASSUME_NONNULL_END
