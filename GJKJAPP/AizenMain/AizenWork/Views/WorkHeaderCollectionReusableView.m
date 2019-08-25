//
//  WorkHeaderCollectionReusableView.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/1/23.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "WorkHeaderCollectionReusableView.h"

@interface WorkHeaderCollectionReusableView()
@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic , strong) UIView *showView;
@property (nonatomic , strong) UIView *leftView;
@end

@implementation WorkHeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _showView = [[UIView alloc]initWithFrame:CGRectZero];
        _showView.backgroundColor = [UIColor clearColor];
        [self addSubview:_showView];
        
        _leftView = [[UIView alloc]initWithFrame:CGRectZero];
        _leftView.backgroundColor = [UIColor colorWithRed:29/255.0 green:143/255.0 blue:225/255.0 alpha:1];
        [_showView addSubview:_leftView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_showView addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews{
    _showView.frame = self.bounds;
    
    _leftView.frame = CGRectMake(_showView.frame.size.width * 0.03, _showView.frame.size.height * 0.15, 7, _showView.frame.size.height * 0.7);
    
    _titleLabel.frame = CGRectMake(_leftView.frame.size.width + _leftView.frame.origin.x + _showView.frame.size.width * 0.02, _leftView.frame.origin.y, _showView.frame.size.width * 0.5, _showView.frame.size.height * 0.7);
}

- (void)setTitle:(NSString *)title{
    _titleLabel.text = title;
}

@end
