//
//  BRUserInfoModifyView.m
//  GJKJAPP
//
//  Created by git burning on 2018/9/12.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "BRUserInfoModifyView.h"

@implementation BRUserInfoModifyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib {
    [super awakeFromNib];
    _headerBtn.superview.backgroundColor = [UIColor whiteColor];
    [_headerBtn setTitle:nil forState:UIControlStateNormal];
    _headerBtn.layer.cornerRadius = 10.0;
    _headerBtn.clipsToBounds = YES;
}
+ (BRUserInfoModifyView *)br_getBRUserInfoModifyView {
    BRUserInfoModifyView *view = [[[NSBundle mainBundle] loadNibNamed:@"BRUserInfoModifyView" owner:self options:nil] firstObject];
    view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, view.frame.size.height);
    return view;
}
- (void)dealloc {

}
@end
