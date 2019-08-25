//
//  ScoreSCLView.h
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/2/16.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ScoreSCLView : UIView
//起点 角度
@property(nonatomic) CGFloat startAngle;
//终点 角度
@property(nonatomic)CGFloat endInnerAngle;
//线宽
@property(nonatomic)CGFloat lineWith;
//百分比数字
@property (nonatomic)CGFloat percentage;
//基准圆环颜色
@property(nonatomic,strong)UIColor *unfillColor;
//显示圆环颜色
@property(nonatomic,strong)UIColor *fillColor;
//中心数据显示标签
@property (nonatomic ,strong)UILabel *centerLable;

@property (nonatomic, strong) resultScoreModel *scoreDetail;

@end

NS_ASSUME_NONNULL_END
