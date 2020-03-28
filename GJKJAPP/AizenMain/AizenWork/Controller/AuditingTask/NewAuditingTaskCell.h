//
//  NewAuditingTaskCell.h
//  GJKJAPP
//
//  Created by 肖啸 on 2020/3/26.
//  Copyright © 2020 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewAuditingTaskCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *taskSubviews;
@property (weak, nonatomic) IBOutlet UILabel *taskName;
@property (weak, nonatomic) IBOutlet UILabel *taskResponsible;
@property (weak, nonatomic) IBOutlet UILabel *taskState;
@property (weak, nonatomic) IBOutlet UILabel *taskChecker;
@property (weak, nonatomic) IBOutlet UILabel *taskUploadTime;
@property (weak, nonatomic) IBOutlet UILabel *taskOverTime;
@property (weak, nonatomic) IBOutlet UILabel *taskGrade;



-(void)refreshAuditingTaskCellWithDict:(NSDictionary *)dataDic;
@end

NS_ASSUME_NONNULL_END
