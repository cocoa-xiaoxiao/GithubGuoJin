//
//  UITableViewCell+GetIdentifier.m
//  CompanyCircle
//
//  Created by gitBurning on 16/4/26.
//  Copyright © 2016年 ZZ. All rights reserved.
//

#import "UITableViewCell+GetIdentifier.h"

@implementation UITableViewCell (GetIdentifier)
+(NSString *)getCellIdentifier
{
    return NSStringFromClass([self class]);
}

+(CGFloat)br_getUITableViewCellHeight
{
    NSString *cellName = NSStringFromClass([self class]);
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:cellName owner:self options:nil] lastObject];
    return view.frame.size.height;
    
}
@end
