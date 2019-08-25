//
//  GJSOSRecordListTableViewCell.h
//  GJKJAPP
//
//  Created by git burning on 2018/10/11.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkBaseModel.h"
@interface GJSOSRecordListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

-(void)refreshUIWithModel:(SOSListModel *)model;

@end
