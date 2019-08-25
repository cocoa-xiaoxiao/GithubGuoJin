//
//  MailPeopleTableViewCell.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/29.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MailPeopleTableViewCell : UITableViewCell

@property(nonatomic,strong) UIView *mainView;
@property(nonatomic,strong) UIImageView *ImgView;
@property(nonatomic,strong) UILabel *nameLab;

@property(nonatomic,strong) NSString *ImgStr;
@property(nonatomic,strong) NSString *nameStr;

@end
