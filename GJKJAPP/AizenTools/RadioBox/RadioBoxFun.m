//
//  RadioBoxFun.m
//  RadioBoxDemo
//
//  Created by 李晓璐 on 2017/12/28.
//  Copyright © 2017年 onmmc. All rights reserved.
//

#import "RadioBoxFun.h"
#import "UIButton+TTButton.h"
@interface RadioBoxFun()

@property(nonatomic, strong)NSMutableArray *buttonArray;
@property(nonatomic, strong)UIView *superView;

@end

@implementation RadioBoxFun

-(void)radioBoxButtons:(NSArray *)buttonArray superView:(UIView *)superView defultSelectedInde:(NSInteger)index callBack:(void (^)(NSInteger selectIndex ,NSString *title))callBack{
    _superView = superView;
    _buttonArray = [NSMutableArray new];
    for (int i=0; i<buttonArray.count; i++) {
        UIButton *button = buttonArray[i];
        button.tag = i;
        if (index==i) {
            [button setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        }
        [button addTapBlock:^(UIButton *btn) {
            [self clickedBtnWith:btn];
 
            callBack(btn.tag,btn.currentTitle);
        }];
        [superView addSubview:button];
        [_buttonArray addObject:button];
    }
}

-(void)clickedBtnWith:(UIButton *)btn{
    [btn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    for (int i=0; i<_buttonArray.count; i++) {
        UIButton *button = _buttonArray[i];
        if (button.tag!=btn.tag) {
            [button setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        }
    }
}

-(UIButton *)creatButton:(CGRect)fram title:(NSString *)title{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];

    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, ([UIScreen mainScreen].bounds.size.width-50-32)/3-5-22);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.frame = fram;

    return btn;
}
@end
