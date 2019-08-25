//
//  MsgCacheTableViewCell.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/29.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgCacheTableViewCell : UITableViewCell

@property(nonatomic,strong) NSString *cacheImgStr;
@property(nonatomic,strong) NSString *cacheTitleStr;
@property(nonatomic,strong) NSString *cacheMsgStr;

@property(nonatomic,strong) UIView *cacheMainView;
@property(nonatomic,strong) UIImageView *cacheImgView;
@property(nonatomic,strong) UILabel *cacheTitleLab;
@property(nonatomic,strong) UILabel *cacheMsgLab;

@end
