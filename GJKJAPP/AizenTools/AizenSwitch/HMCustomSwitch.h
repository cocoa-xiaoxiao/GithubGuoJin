//
//  HMCustomSwitch.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/3/2.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMCustomSwitch : UISlider {
    BOOL on;
    UIColor *tintColor;
    UIView *clippingView;
    UILabel *rightLabel;
    UILabel *leftLabel;
    
    // private member
    BOOL m_touchedSelf;
}

@property(nonatomic,getter=isOn) BOOL on;
@property (nonatomic,retain) UIColor *tintColor;
@property (nonatomic,retain) UIView *clippingView;
@property (nonatomic,retain) UILabel *rightLabel;
@property (nonatomic,retain) UILabel *leftLabel;

+ (HMCustomSwitch *) switchWithLeftText: (NSString *) tag1 andRight: (NSString *) tag2;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
