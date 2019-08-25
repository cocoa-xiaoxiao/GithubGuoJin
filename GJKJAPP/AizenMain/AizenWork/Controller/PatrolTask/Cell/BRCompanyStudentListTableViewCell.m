//
//  BRCompanyStudentListTableViewCell.m
//  GJKJAPP
//
//  Created by git burning on 2018/9/17.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "BRCompanyStudentListTableViewCell.h"

@implementation BRCompanyStudentListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _nameLabel.layer.cornerRadius = 20.0;
    _nameLabel.clipsToBounds = YES;
    _headerImg = [UIImageView new];
    [_nameLabel addSubview:_headerImg];
    [_headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
    }];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
   
}
@end
