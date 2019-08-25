//
//  ScoreSCLView.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/2/16.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "ScoreSCLView.h"
#define cirlDistance 10
#define   DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)
@interface ScoreSCLView()
{
    CGFloat radius;
}
@property(nonatomic) CGPoint CGPoinCerter;
@property(nonatomic) CGFloat endAngle;
@property(nonatomic) BOOL clockwise;

@end

@implementation ScoreSCLView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.lineWith = 10.0;
        self.fillColor = RGB_HEX(0xFF2400, 1);
        self.unfillColor = [UIColor lightGrayColor];
        self.clockwise = YES;
        self.backgroundColor = [UIColor clearColor];
        self.percentage = 0.5;
        self.startAngle = 180;
        self.endInnerAngle = 360 + 180;
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [self initData];
    [self drawMiddlecircle];
    [self drawOutCCircle];
    
}

-(void)initData
{
    self.percentage = self.scoreDetail.ccscl;
    if(self.percentage>1){
        self.percentage = 1.0;
    }
    else if(self.percentage < 0){
        self.percentage = 0;
    }
    self.CGPoinCerter = CGPointMake(self.bounds.size.width/2, 5+(self.frame.size.height - 45)/2);
    radius = (self.frame.size.height - 45)/2 - self.lineWith/2;
    self.endInnerAngle = DEGREES_TO_RADIANS(self.endInnerAngle);
    self.startAngle = DEGREES_TO_RADIANS(self.startAngle);
    self.endAngle = self.percentage*(self.endInnerAngle - self.startAngle) + self.startAngle;
    
    self.centerLable = [[UILabel alloc]init];
    self.centerLable.font = [UIFont systemFontOfSize:radius/3];
    self.centerLable.numberOfLines = 2;
    self.centerLable.text = [NSString stringWithFormat:@"%.0lf%%\n成绩生成率",_percentage*100];
    self.centerLable.frame =CGRectMake(self.frame.size.width/2 - radius, 5, 2 * radius, 2*radius);
    self.centerLable.textAlignment=NSTextAlignmentCenter;
    self.centerLable.backgroundColor=[UIColor clearColor];
    self.centerLable.adjustsFontSizeToFitWidth = YES;
    self.centerLable.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.centerLable];
    
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/2- 50, self.frame.size.height - 30, 100, 20)];
    lab1.text = [NSString stringWithFormat:@"有成绩:%d",self.scoreDetail.sccj];
    lab1.font = [UIFont systemFontOfSize:14];
    lab1.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lab1];
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/2- 150, self.frame.size.height - 30, 100, 20)];
    lab2.text = [NSString stringWithFormat:@"学生总数:%d",self.scoreDetail.sxrs];
    lab2.font = [UIFont systemFontOfSize:14];
    lab2.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lab2];
    
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/2+50, self.frame.size.height - 30, 100, 20)];
    lab3.text = [NSString stringWithFormat:@"无成绩:%d",self.scoreDetail.wcc];
    lab3.font = [UIFont systemFontOfSize:14];
    lab3.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lab3];
}
/**
 *  显示圆环
 */
-(void )drawOutCCircle{
    UIBezierPath *bPath1 = [UIBezierPath bezierPathWithArcCenter:self.CGPoinCerter radius:radius startAngle:self.startAngle endAngle:self.endAngle clockwise:self.clockwise];
    bPath1.lineWidth=self.lineWith;
    bPath1.lineCapStyle = kCGLineCapRound;
    bPath1.lineJoinStyle = kCGLineJoinRound;
    [self.fillColor setStroke];
    [bPath1 stroke];
}
-(void)drawMiddlecircle
{
    UIBezierPath *cPath1 = [UIBezierPath bezierPathWithArcCenter:self.CGPoinCerter radius:radius startAngle:self.startAngle endAngle:self.endInnerAngle clockwise:self.clockwise];
    cPath1.lineWidth=self.lineWith;
    cPath1.lineCapStyle = kCGLineCapRound;
    cPath1.lineJoinStyle = kCGLineJoinRound;
    UIColor *color1 = self.unfillColor;
    [color1 setStroke];
    [cPath1 stroke];
}

@end
