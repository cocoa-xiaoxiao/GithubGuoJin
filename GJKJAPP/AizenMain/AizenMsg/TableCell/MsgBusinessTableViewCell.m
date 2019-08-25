//
//  MsgBusinessTableViewCell.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/27.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MsgBusinessTableViewCell.h"

@implementation MsgBusinessTableViewCell

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
    
    
    self.imgView = [[UIImageView alloc]init];
    self.imgView.frame = CGRectMake(self.mainView.frame.size.width * 0.05, self.mainView.frame.size.height * 0.15, self.mainView.frame.size.height * 0.7, self.mainView.frame.size.height * 0.7);
    [self.mainView addSubview:self.imgView];
    
    
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.frame = CGRectMake(self.imgView.frame.size.width + self.imgView.frame.origin.x + self.mainView.frame.size.width * 0.03, self.imgView.frame.origin.y, self.mainView.frame.size.width * 0.4, self.imgView.frame.size.height * 0.5);
    [self.mainView addSubview:self.titleLab];
    
    
    self.dateLab = [[UILabel alloc]init];
    self.dateLab.frame = CGRectMake(self.mainView.frame.size.width - self.mainView.frame.size.width * 0.3 - self.mainView.frame.size.width * 0.05, self.titleLab.frame.origin.y, self.mainView.frame.size.width * 0.3, self.titleLab.frame.size.height);
    [self.mainView addSubview:self.dateLab];
    
    
    self.msgLab = [[UILabel alloc]init];
    self.msgLab.frame = CGRectMake(self.titleLab.frame.origin.x, self.titleLab.frame.origin.y + self.titleLab.frame.size.height + self.imgView.frame.size.height * 0.1, (self.mainView.frame.size.width - self.mainView.frame.size.width * 0.13 - self.mainView.frame.size.height * 0.8 - self.imgView.frame.size.height * 0.5), self.imgView.frame.size.height * 0.4);
    [self.mainView addSubview:self.msgLab];
    
    
    self.numLab = [[UILabel alloc]init];
    self.numLab.frame = CGRectMake(self.mainView.frame.size.width - self.imgView.frame.size.height * 0.4 - self.mainView.frame.size.width * 0.05, self.msgLab.frame.origin.y, self.imgView.frame.size.height * 0.4, self.imgView.frame.size.height * 0.4);
    self.numLab.layer.cornerRadius = self.imgView.frame.size.height * 0.4 / 2;
    self.numLab.layer.masksToBounds = YES;
    [self.mainView addSubview:self.numLab];
}


-(void) setMainImgStr:(NSString *)mainImgStr{
    self.imgView.image = [UIImage imageNamed:mainImgStr];
}


-(void) setMainTitleStr:(NSString *)mainTitleStr{
    self.titleLab.text = mainTitleStr;
    self.titleLab.textColor = [UIColor blackColor];
    self.titleLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
}


-(void) setMainMsgStr:(NSString *)mainMsgStr{
    self.msgLab.text = mainMsgStr;
    self.msgLab.textColor = [UIColor lightGrayColor];
    self.msgLab.font = [UIFont systemFontOfSize:16.0];
}


-(void) setMainNumStr:(NSString *)mainNumStr{
    if(mainNumStr.integerValue > 0){
        self.numLab.textColor = [UIColor whiteColor];
        self.numLab.backgroundColor = [UIColor redColor];
        self.numLab.text = mainNumStr;
        self.numLab.font = [UIFont systemFontOfSize:13.0];
        self.numLab.textAlignment = UITextAlignmentCenter;
        self.numLab.hidden = NO;

    }
    else{
        self.numLab.hidden = YES;
    }
}


-(void) setMainDateStr:(NSString *)mainDateStr{
    self.dateLab.text = mainDateStr;
    self.dateLab.textAlignment = UITextAlignmentRight;
    self.dateLab.font = [UIFont systemFontOfSize:14.0];
    self.dateLab.textColor = [UIColor lightGrayColor];
}



@end
