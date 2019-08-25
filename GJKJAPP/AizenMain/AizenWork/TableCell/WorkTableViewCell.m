//
//  WorkTableViewCell.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/26.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "WorkTableViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"

@implementation WorkTableViewCell


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
    self.workImgView = [[UIImageView alloc]init];
    self.workImgView.frame = CGRectMake(20, 5, 30, 30);
    [self addSubview:self.workImgView];
    
    
    self.workName = [[UILabel alloc]init];
    self.workName.frame = CGRectMake(self.workImgView.frame.size.width + self.workImgView.frame.origin.x + 20, self.workImgView.frame.origin.y, self.contentView.frame.size.width * 0.5, 30);
    self.workName.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:16];
    [self addSubview:self.workName];


    self.goDetailView = [[UIImageView alloc]init];
    self.goDetailView.frame = CGRectMake([UIScreen mainScreen].applicationFrame.size.width - 30 -10, 5, 30, 30);
    self.goDetailView.image = [UIImage imageNamed:@"gj_memore"];
    [self addSubview:self.goDetailView];
    
}

-(void) setWorkNameStr:(NSString *)workNameStr{
    self.workName.text = workNameStr;
}


-(void)setWorkImgStr:(NSString *)workImgStr{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kCacheHttpRoot,workImgStr];
    [self.workImgView sd_setImageWithURL:[NSURL URLWithString:urlStr]
                  placeholderImage:[UIImage imageNamed:@"gj_unicon.png"]];
}


@end
