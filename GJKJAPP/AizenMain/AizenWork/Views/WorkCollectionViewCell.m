//
//  WorkCollectionViewCell.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/1/23.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "WorkCollectionViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface WorkCollectionViewCell()

@property (nonatomic , strong) UIImageView *imageShow;
@property (nonatomic , strong) UILabel *titleLab;

@end

@implementation WorkCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        _imageShow = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _titleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _imageShow = [[UIImageView alloc]init];
        _titleLab = [[UILabel alloc]init];
        [self.contentView addSubview:_imageShow];
        [self.contentView addSubview:_titleLab];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _imageShow.frame = CGRectMake(self.contentView.frame.size.width * 0.25, self.contentView.frame.size.width * 0.1, self.contentView.frame.size.width * 0.5, self.contentView.frame.size.width * 0.5);
    
    _titleLab.frame = CGRectMake(self.contentView.frame.size.width * 0.1, _imageShow.frame.size.height + _imageShow.frame.origin.y + 5, self.contentView.frame.size.width * 0.8, 15);
}

-(void)setTitleName:(NSString *)titleName{
    _titleLab.textColor = [UIColor blackColor];
    _titleLab.font = [UIFont systemFontOfSize:13.0];
    _titleLab.textAlignment = UITextAlignmentCenter;
    _titleLab.text = titleName;
}

-(void)setImageName:(NSString *)imageName{
    NSLog(@"%@",imageName);
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kCacheHttpRoot,imageName];
    [_imageShow sd_setImageWithURL:[NSURL URLWithString:urlStr]
                 placeholderImage:[UIImage imageNamed:@"gj_unicon.png"]];
}



@end
