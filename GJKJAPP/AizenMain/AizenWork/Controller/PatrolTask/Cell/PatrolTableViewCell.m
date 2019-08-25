//
//  PatrolTableViewCell.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/6/7.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "PatrolTableViewCell.h"

@implementation PatrolTableViewCell{
    UIView *contentView;
    UIImageView *imgView;
    UILabel *titleLab;
    UILabel *phoneLab;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化子视图
        [self initLayout];
    }
    return self;
}


-(void) initLayout{
    contentView = [[UIView alloc]init];
    contentView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 28.0f);
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    
    
    imgView = [[UIImageView alloc]init];
    imgView.frame = CGRectMake(contentView.frame.size.width * 0.08, contentView.frame.size.height * 0.1, contentView.frame.size.height * 0.8, contentView.frame.size.height * 0.8);
    [contentView addSubview:imgView];
    
    titleLab = [[UILabel alloc]init];
    titleLab.frame = CGRectMake(imgView.frame.size.width + imgView.frame.origin.x + contentView.frame.size.width * 0.02, contentView.frame.size.height * 0.1, contentView.frame.size.width * 0.4, contentView.frame.size.height * 0.8);
    titleLab.font = [UIFont systemFontOfSize:14.0];
    [contentView addSubview:titleLab];
    
    
    
    phoneLab = [[UILabel alloc]init];
    phoneLab.frame = CGRectMake(contentView.frame.size.width - contentView.frame.size.width * 0.4 - contentView.frame.size.width * 0.03, contentView.frame.size.height * 0.1, contentView.frame.size.width * 0.4, contentView.frame.size.height * 0.8);
    phoneLab.textAlignment = UITextAlignmentRight;
    phoneLab.font = [UIFont systemFontOfSize:14.0];
    phoneLab.textColor = [UIColor lightGrayColor];
    [contentView addSubview:phoneLab];
    
}


-(void)setDetailDic:(NSDictionary *)detailDic{
    if([[detailDic objectForKey:@"type"] isEqualToString:@"people"]){
        imgView.image = [UIImage imageNamed:@"xuncha_2"];
        titleLab.text = [detailDic objectForKey:@"UserName"];
        phoneLab.text = [detailDic objectForKey:@"Mobile"];
    }else if([[detailDic objectForKey:@"type"] isEqualToString:@"company"]){
        imgView.image = [UIImage imageNamed:@"gj_patrolcompany"];
        titleLab.text = [detailDic objectForKey:@"EnterpriseName"];
        CGRect titleRect = titleLab.frame;
        titleRect.size.width = contentView.frame.size.width * 0.8;
        titleLab.frame = titleRect;
        [phoneLab removeFromSuperview];
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
