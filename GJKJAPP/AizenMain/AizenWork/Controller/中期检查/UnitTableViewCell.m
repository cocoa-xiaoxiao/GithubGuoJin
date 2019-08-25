//
//  UnitTableViewCell.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/2/21.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "UnitTableViewCell.h"
#define   DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)
@interface UnitTableViewCell()
{
    CGFloat radius;
}
@property(nonatomic) CGPoint CGPoinCerter;
@property(nonatomic) CGFloat endAngle;
//起点 角度
@property(nonatomic) CGFloat startAngle;
//终点 角度
@property(nonatomic)CGFloat endInnerAngle;
@end

@implementation UnitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.endInnerAngle = DEGREES_TO_RADIANS(540);
    self.startAngle = DEGREES_TO_RADIANS(180);
    
    radius = (self.frame.size.height-5 - CGRectGetMaxY(self.sepLine.frame))/2 - 5.0/2;

    self.CGPoinCerter = CGPointMake(self.frame.size.width, self.sepLine.frame.origin.y+(self.frame.size.height-5 - CGRectGetMaxY(self.sepLine.frame))/2);
    
    self.shixilvLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, radius * 2, radius * 2)];
    self.shixilvLabel.numberOfLines = 2;
    self.shixilvLabel.font = [UIFont systemFontOfSize:radius/3];
    self.shixilvLabel.center = CGPointMake(self.xo_width, self.CGPoinCerter.y);
    self.shixilvLabel.textAlignment=NSTextAlignmentCenter;
    self.shixilvLabel.backgroundColor=[UIColor clearColor];
    self.shixilvLabel.adjustsFontSizeToFitWidth = YES;
//    self.shixilvLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.shixilvLabel];
    
    CAShapeLayer *layer2 = [[CAShapeLayer alloc]init];
    layer2.fillColor = [UIColor clearColor].CGColor;
    layer2.strokeColor = [UIColor lightGrayColor].CGColor;
    layer2.lineWidth = 5.0;
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:self.CGPoinCerter radius:radius startAngle:self.startAngle endAngle:self.endInnerAngle clockwise:YES];
    layer2.path = path2.CGPath;
    [self.contentView.layer addSublayer:layer2];
    
    
    self.layer1 = [[CAShapeLayer alloc]init];
    _layer1.fillColor = [UIColor clearColor].CGColor;
    _layer1.strokeColor = [UIColor redColor].CGColor;
    _layer1.lineWidth = 5.0;
    [self.contentView.layer addSublayer:_layer1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDegress:(CGFloat)degress
{
    _degress = degress;
    self.endAngle = degress*(self.endInnerAngle - self.startAngle) + self.startAngle;
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:self.CGPoinCerter radius:radius startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
    _layer1.path = path1.CGPath;
    
}
@end
