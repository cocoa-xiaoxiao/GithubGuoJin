//
//  MsgBusinessTableViewCell.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/27.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgBusinessTableViewCell : UITableViewCell

@property(nonatomic,strong) NSString *mainImgStr;
@property(nonatomic,strong) NSString *mainTitleStr;
@property(nonatomic,strong) NSString *mainMsgStr;
@property(nonatomic,strong) NSString *mainNumStr;
@property(nonatomic,strong) NSString *mainDateStr;


@property(nonatomic,strong) UIView *mainView;
@property(nonatomic,strong) UIImageView *imgView;
@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) UILabel *msgLab;
@property(nonatomic,strong) UILabel *numLab;
@property(nonatomic,strong) UILabel *dateLab;

@end
