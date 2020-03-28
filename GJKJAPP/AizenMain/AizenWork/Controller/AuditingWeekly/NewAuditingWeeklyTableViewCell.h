//
//  NewAuditingWeeklyTableViewCell.h
//  GJKJAPP
//
//  Created by 肖啸 on 2020/3/27.
//  Copyright © 2020 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewAuditingWeeklyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *subview;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *title;
-(void)refreshAuditingWeeklyCellWithDict:(NSDictionary *)dataDic;
@end

NS_ASSUME_NONNULL_END
