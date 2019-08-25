//
//  CALayer+BorderColor.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/11/28.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "CALayer+BorderColor.h"

@implementation CALayer (BorderColor)

- (void)setBorderColorWithUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
    
}

@end
