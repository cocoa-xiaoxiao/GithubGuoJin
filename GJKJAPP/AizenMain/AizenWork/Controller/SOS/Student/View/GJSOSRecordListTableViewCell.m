//
//  GJSOSRecordListTableViewCell.m
//  GJKJAPP
//
//  Created by git burning on 2018/10/11.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "GJSOSRecordListTableViewCell.h"

@implementation GJSOSRecordListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshUIWithModel:(SOSListModel *)model
{
    self.nameLabel.text = model.sosName;
    self.timeLabel.text = model.time;
    self.placeLabel.text = model.sosPlace;
    self.reasonLabel.text = model.warnReason;
    self.typeLabel.text = model.ishandle?@"预警处理:已处理":@"预警处理:待处理";
    self.typeLabel.textColor = model.ishandle?RGB_HEX(0x238E23, 1):RGB_HEX(0xDC143C, 1);
}
@end
