//
//  GradesTableViewCell.h
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/2/15.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GradesTableViewCell : UITableViewCell
//起点 角度
@property(nonatomic) CGFloat startAngle;
//终点 角度
@property(nonatomic)CGFloat endInnerAngle;
//线宽
@property(nonatomic)CGFloat lineWith;
//百分比数字
@property (nonatomic)CGFloat percentage1;
//百分比数字
@property (nonatomic)CGFloat percentage2;
//百分比数字
@property (nonatomic)CGFloat percentage3;
//百分比数字
@property (nonatomic)CGFloat percentage4;

//基准圆环颜色
@property(nonatomic,strong)UIColor *unfillColor;
//显示圆环颜色
@property(nonatomic,strong)UIColor *fill1Color;
@property(nonatomic,strong)UIColor *fill2Color;
@property(nonatomic,strong)UIColor *fill3Color;
@property(nonatomic,strong)UIColor *fill4Color;
//中心数据显示标签
@property (nonatomic ,strong)UILabel *centerLable;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong) UILabel *score1Label;
@property (nonatomic, strong) UILabel *score2Label;
@property (nonatomic, strong) UILabel *score3Label;
@property (nonatomic, strong) UILabel *score4Label;

@property (nonatomic, copy) NSString *titleN;
@end

NS_ASSUME_NONNULL_END
