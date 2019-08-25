//
//  BaseTablewView.m
//  GJKJAPP
//
//  Created by git burning on 2018/9/8.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "BaseTablewView.h"

@implementation BaseTablewView
-(instancetype)init{
    self = [super init];
    if (self) {
        [self br_configFooder];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self br_configFooder];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
    }
    return self;
}
- (void)br_configFooder{
    self.tableFooterView = [[UIView alloc] init];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
