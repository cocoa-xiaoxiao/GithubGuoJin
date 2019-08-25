//
//  AttendanceCustomTableHeadView.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/2/21.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "AttendanceCustomTableHeadView.h"
#import "FL_Button.h"

@interface AttendanceCustomTableHeadView()
@property (nonatomic, strong) FL_Button *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIView *view2;
@end
@implementation AttendanceCustomTableHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews
{
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(5, 5, self.frame.size.width-10, 40)];
    view1.layer.borderWidth = 1;
    view1.layer.borderColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1].CGColor;
    
    self.view2 = [[UIView alloc]initWithFrame:CGRectMake(5, 50, self.frame.size.width - 10, 80)];
    _view2.layer.borderWidth = 1;
    _view2.layer.borderColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1].CGColor;
    [self addSubview:view1];
    [self addSubview:_view2];
    
    UILabel *lab = [[UILabel alloc]init];
    lab.font = [UIFont systemFontOfSize:15];
    lab.text = @"部门";
    [view1 addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view1);
        make.left.mas_offset(10);
    }];
    
    self.button1 = [[FL_Button alloc]initWithAlignmentStatus:FLAlignmentStatusLeft];
    [self.button1 setImage:[UIImage imageNamed:@"jiantouarrow486"] forState:UIControlStateNormal];
    self.button1.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.button1 setTitle:@"旅游英语" forState:UIControlStateNormal];
    [self.button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.button1.frame = CGRectMake(self.frame.size.width - 100, 10, 100, 20);
    [view1 addSubview:self.button1];
    
    UILabel *lab1 = [[UILabel alloc]init];
    lab1.font = [UIFont systemFontOfSize:15];
    lab1.text = @"开始时间";
    [_view2 addSubview:lab1];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_view2).mas_offset(20);
        make.left.mas_offset(10);
    }];
    UILabel *lab2 = [[UILabel alloc]init];
    lab2.font = [UIFont systemFontOfSize:15];
    lab2.text = @"结束时间";
    [_view2 addSubview:lab2];
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_view2).mas_offset(-20);
        make.left.mas_offset(10);
    }];
    UILabel *lab3 = [[UILabel alloc]init];
    lab3.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [_view2 addSubview:lab3];
    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_view2);
        make.left.right.equalTo(_view2);
        make.height.mas_offset(1);
    }];
    
    self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button2.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.button2 setTitle:@"2018-02-21 >" forState:UIControlStateNormal];
    [self.button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_view2 addSubview:self.button2];
    
    self.button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button3.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.button3 setTitle:@"2019-02-21 >" forState:UIControlStateNormal];
    [self.button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_view2 addSubview:self.button3];
    [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lab1);
        make.right.mas_offset(-10);
    }];
    [self.button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lab2);
        make.right.mas_offset(-10);
    }];
}

-(void)setHiddenView2:(BOOL)hiddenView2
{
    if (hiddenView2) {
        _view2.hidden = YES;
    }
}
@end
