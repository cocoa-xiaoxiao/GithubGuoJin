//
//  WorkTableViewCell.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/26.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView *workImgView;

@property(nonatomic,strong) UILabel *workName;

@property(nonatomic,strong) UIImageView *goDetailView;


@property(nonatomic,strong) NSString *workImgStr;
@property(nonatomic,strong) NSString *workNameStr;
@property(nonatomic,strong) NSString *workGoStr;


@end
