//
//  SignButton.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/3/15.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignButton : UIButton

typedef NS_ENUM(NSUInteger, JXLayoutButtonStyle) {
    JXLayoutButtonStyleLeftImageRightTitle,
    JXLayoutButtonStyleLeftTitleRightImage,
    JXLayoutButtonStyleUpImageDownTitle,
    JXLayoutButtonStyleUpTitleDownImage
};

/// 布局方式
@property (nonatomic, assign) JXLayoutButtonStyle layoutStyle;
/// 图片和文字的间距，默认值8
@property (nonatomic, assign) CGFloat midSpacing;

@end
