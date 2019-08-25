//
//  GJSOSRemarkTableViewCell.m
//  GJKJAPP
//
//  Created by git burning on 2018/10/13.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "GJSOSRemarkTableViewCell.h"

@implementation GJSOSRemarkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        self.remarkTitle = [UILabel new];
        [self.contentView addSubview:self.remarkTitle];
        [self.remarkTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.equalTo(self.contentView);
        }];
        self.remarkTitle.text = @"预警信息";
        
        self.statusTitle = [UILabel new];
        [self.contentView addSubview:self.statusTitle];
        [self.statusTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.equalTo(self.contentView);
        }];
        self.statusTitle.textAlignment = NSTextAlignmentRight;
        self.statusTitle.textColor = [UIColor lightGrayColor];
        self.statusTitle.text = @"SOS信息: 已发送";
    }
    return self;
}

+(CGFloat)br_getUITableViewCellHeight{
    return 44.0;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
