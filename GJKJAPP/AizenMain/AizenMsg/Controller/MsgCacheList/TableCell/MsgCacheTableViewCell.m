//
//  MsgCacheTableViewCell.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/29.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MsgCacheTableViewCell.h"

@implementation MsgCacheTableViewCell

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
    self.cacheMainView = [[UIView alloc]init];
    self.cacheMainView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 70.0f);
    self.cacheMainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.cacheMainView];
    
    
    self.cacheImgView = [[UIImageView alloc]init];
    self.cacheImgView.frame = CGRectMake(self.cacheMainView.frame.size.width * 0.05, self.cacheMainView.frame.size.height * 0.15, self.cacheMainView.frame.size.height * 0.7, self.cacheMainView.frame.size.height * 0.7);
    [self.cacheMainView addSubview:self.cacheImgView];
    
    
    self.cacheTitleLab = [[UILabel alloc]init];
    self.cacheTitleLab.frame = CGRectMake(self.cacheImgView.frame.size.width + self.cacheImgView.frame.origin.x + self.cacheImgView.frame.size.width * 0.1, self.cacheImgView.frame.origin.y, self.cacheMainView.frame.size.width * 0.4, self.cacheImgView.frame.size.height * 0.5);
    [self.cacheMainView addSubview:self.cacheTitleLab];
    
    self.cacheMsgLab = [[UILabel alloc]init];
    self.cacheMsgLab.frame = CGRectMake(self.cacheTitleLab.frame.origin.x, self.cacheTitleLab.frame.origin.y + self.cacheTitleLab.frame.size.height + self.cacheImgView.frame.size.height * 0.1, (self.cacheMainView.frame.size.width - self.cacheMainView.frame.size.width * 0.13 - self.cacheMainView.frame.size.height * 0.8 - self.cacheImgView.frame.size.height * 0.5), self.cacheImgView.frame.size.height * 0.4);
    [self.cacheMainView addSubview:self.cacheMsgLab];
}



-(void) setCacheImgStr:(NSString *)cacheImgStr{
    self.cacheImgView.image = [UIImage imageNamed:cacheImgStr];
}

-(void) setCacheTitleStr:(NSString *)cacheTitleStr{
    self.cacheTitleLab.text = cacheTitleStr;
}

-(void) setCacheMsgStr:(NSString *)cacheMsgStr{
    self.cacheMsgLab.text = cacheMsgStr;
    self.cacheMsgLab.textColor = [UIColor lightGrayColor];
    self.cacheMsgLab.font = [UIFont systemFontOfSize:14.0];
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
