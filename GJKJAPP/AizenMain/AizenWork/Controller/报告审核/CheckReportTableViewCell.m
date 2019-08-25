//
//  CheckReportTableViewCell.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/4/3.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "CheckReportTableViewCell.h"

@implementation CheckReportTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)select:(id)sender {
    if (self.block) {
        self.block(self, self.model);
    }
}
@end
