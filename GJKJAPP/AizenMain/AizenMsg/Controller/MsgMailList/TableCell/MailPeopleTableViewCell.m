//
//  MailPeopleTableViewCell.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/29.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MailPeopleTableViewCell.h"

@implementation MailPeopleTableViewCell

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
    self.mainView = [[UIView alloc]init];
    self.mainView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 70.0f);
    self.mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.mainView];
    
    
    self.ImgView = [[UIImageView alloc]init];
    self.ImgView.frame = CGRectMake(self.mainView.frame.size.width * 0.05, self.mainView.frame.size.height * 0.15, self.mainView.frame.size.height * 0.7, self.mainView.frame.size.height * 0.7);
    [self.mainView addSubview:self.ImgView];
    
    
    self.nameLab = [[UILabel alloc]init];
    self.nameLab.frame = CGRectMake(self.ImgView.frame.size.width + self.ImgView.frame.origin.x + self.ImgView.frame.size.width * 0.1,self.ImgView.frame.origin.y +(self.ImgView.frame.size.height - self.ImgView.frame.size.height * 0.5) / 2, self.mainView.frame.size.width * 0.4, self.ImgView.frame.size.height * 0.5);
    [self.mainView addSubview:self.nameLab];
}


-(void) setImgStr:(NSString *)cacheImgStr{
    self.ImgView.image = [UIImage imageNamed:cacheImgStr];
}

-(void) setNameStr:(NSString *)cacheTitleStr{
    self.nameLab.text = cacheTitleStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
