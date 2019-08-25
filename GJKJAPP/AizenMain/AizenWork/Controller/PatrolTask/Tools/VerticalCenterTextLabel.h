//
//  VerticalCenterTextLabel.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/15.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    myVerticalAlignmentNone = 0,
    myVerticalAlignmentCenter,
    myVerticalAlignmentTop,
    myVerticalAlignmentBottom
} myVerticalAlignment;

@interface VerticalCenterTextLabel : UILabel
@property (nonatomic) UIEdgeInsets edgeInsets;

/**
 *  对齐方式
 */
@property (nonatomic) myVerticalAlignment verticalAlignment;

@end
