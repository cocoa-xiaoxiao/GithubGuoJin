//
//  MsgTableViewCell.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/1/17.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MsgTableViewCell.h"

@implementation MsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Info:(NSDictionary *)InfoObj{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        CGFloat width = WIDTH_SCREEN;
        CGFloat height = HEIGHT_ROW;
        
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[InfoObj objectForKey:@"imgUrl"]]];
        imgView.frame = CGRectMake(height * 0.1 * 1.5, height * 0.1, height * 0.8, height * 0.8);
        [self addSubview:imgView];
        
        
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(imgView.frame.size.width + imgView.frame.origin.x + 10, height * 0.1, width - imgView.frame.size.width - height * 0.2 - 10 - 5 - width * 0.2, imgView.frame.size.height * 0.5)];
        titleLab.text = [InfoObj objectForKey:@"title"];
        titleLab.textColor = [UIColor blackColor];
        titleLab.font = [UIFont fontWithName:@"AmericanTypewriter" size:18.0];
        [self addSubview:titleLab];
        
        UILabel *messageLab = [[UILabel alloc]initWithFrame:CGRectMake(imgView.frame.size.width + imgView.frame.origin.x + 10, titleLab.frame.origin.y + titleLab.frame.size.height, width - imgView.frame.size.width - height * 0.2 - 10 - 5, imgView.frame.size.height * 0.5)];
        messageLab.text = [InfoObj objectForKey:@"message"];
        messageLab.textColor = [UIColor grayColor];
        messageLab.font = [UIFont fontWithName:@"AmericanTypewriter" size:13.0];
        [self addSubview:messageLab];
        
        
        UILabel *dateLab = [[UILabel alloc]initWithFrame:CGRectMake(titleLab.frame.size.width + titleLab.frame.origin.x, height * 0.1, width * 0.2, imgView.frame.size.height * 0.5)];
        dateLab.textColor = [UIColor grayColor];
        dateLab.text = [InfoObj objectForKey:@"date"];
        dateLab.font = [UIFont fontWithName:@"AmericanTypewriter" size:12.0];
        dateLab.textAlignment = UITextAlignmentRight;
        [self addSubview:dateLab];
    }
    return self;

}


@end
