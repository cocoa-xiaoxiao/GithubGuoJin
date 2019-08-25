//
//  MyFinalizationTableViewCell.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/11.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MyFinalizationTableViewCell.h"

@implementation MyFinalizationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)chachong:(id)sender {
    if ([self.delegate respondsToSelector:@selector(chachongWithIndexPath:)]) {
        [self.delegate chachongWithIndexPath:self.cellIndex];
    }
}

@end
