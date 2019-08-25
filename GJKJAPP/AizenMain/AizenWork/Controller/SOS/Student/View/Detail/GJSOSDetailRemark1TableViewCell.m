//
//  GJSOSDetailRemark1TableViewCell.m
//  GJKJAPP
//
//  Created by git burning on 2018/10/13.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "GJSOSDetailRemark1TableViewCell.h"

@implementation GJSOSDetailRemark1TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;

        self.contentLabel = [UILabel new];
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textColor = [UIColor lightGrayColor];
        self.contentLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
