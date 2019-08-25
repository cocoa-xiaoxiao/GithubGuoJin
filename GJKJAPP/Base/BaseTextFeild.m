//
//  BaseTextFeild.m
//  GJKJAPP
//
//  Created by git burning on 2018/9/9.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "BaseTextFeild.h"

@implementation BaseTextFeild
-(instancetype)init{
    self = [super init];
    if (self) {
        [self br_config];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self br_config];
    }
    return self;
}
- (void)br_config{
    self.returnKeyType = UIReturnKeyDone;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
