//
//  VerticalCenterTextLabel.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/15.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "VerticalCenterTextLabel.h"

@implementation VerticalCenterTextLabel

- (void)setVerticalAlignment:(myVerticalAlignment)verticalAlignment
{
    _verticalAlignment= verticalAlignment;
    [self setNeedsDisplay];
}

- (void)drawTextInRect:(CGRect)rect
{
    if (_verticalAlignment == myVerticalAlignmentNone)
    {
        [super drawTextInRect:UIEdgeInsetsInsetRect(self.bounds, self.edgeInsets)];
    }
    else
    {
        CGRect textRect = [self textRectForBounds:UIEdgeInsetsInsetRect(rect, self.edgeInsets) limitedToNumberOfLines:self.numberOfLines];
        [super drawTextInRect:textRect];
    }
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (_verticalAlignment) {
        case myVerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
            
        case myVerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
            
        case myVerticalAlignmentCenter:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
            break;
            
        default:
            break;
    }
    return textRect;
}
@end  
