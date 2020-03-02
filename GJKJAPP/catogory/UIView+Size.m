//
//  UIView+Size.m
//  京东商品详情
//
//  Created by caoyl on 17-2-15.
//  Copyright (c) 2017年 @八点钟学院. All rights reserved.
//

#import "UIView+Size.h"

@implementation UIView (Size)

-(void)setXo_x:(CGFloat)xo_x
{
    CGRect frame = self.frame;
    frame.origin.x = xo_x;
    self.frame = frame;
}
-(CGFloat)xo_x
{
    return self.frame.origin.x;
}
-(void)setXo_y:(CGFloat)xo_y
{
    CGRect frame = self.frame;
    frame.origin.y = xo_y;
    self.frame = frame;
}

-(CGFloat)xo_centerY
{
    return self.center.y;
}
-(void)setXo_centerY:(CGFloat)xo_centerY
{
    CGPoint point = self.center;
    point.y = xo_centerY;
    self.center = point;
}


-(CGFloat)xo_y
{
    return self.frame.origin.y;
}
-(void)setXo_width:(CGFloat)xo_width
{
    CGRect frame = self.frame;
    frame.size.width = xo_width;
    self.frame = frame;
}
-(CGFloat)xo_width
{
    return self.frame.size.width;
}
-(void)setXo_height:(CGFloat)xo_height
{
    CGRect frame = self.frame;
    frame.size.height = xo_height;
    self.frame = frame;
}
-(CGFloat)xo_height
{
    return self.frame.size.height;
}
-(void)setXo_origin:(CGPoint)xo_origin
{
    CGRect frame = self.frame;
    frame.origin = xo_origin;
    self.frame = frame;
}
-(CGPoint)xo_origin
{
    return self.frame.origin;
}

-(void)setXo_size:(CGSize)xo_size
{
    CGRect frame = self.frame;
    frame.size = xo_size;
    self.frame = frame;
}
-(CGSize)xo_size
{
    return self.frame.size;
}

-(CGFloat)xo_bottomY
{
    return self.xo_y+self.xo_height;
}
-(void)setXo_bottomY:(CGFloat)xo_bottomY
{
    
}

@end
