//
//  GradesTableViewCell.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/2/15.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "GradesTableViewCell.h"
#define cirlDistance 10
#define   DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)
@interface GradesTableViewCell()
{
    CGFloat radius;
}
@property(nonatomic) CGPoint CGPoinCerter1;
@property(nonatomic) CGPoint CGPoinCerter2;
@property(nonatomic) CGPoint CGPoinCerter3;
@property(nonatomic) CGPoint CGPoinCerter4;
@property(nonatomic) CGFloat endAngle1;
@property(nonatomic) CGFloat endAngle2;
@property(nonatomic) CGFloat endAngle3;
@property(nonatomic) CGFloat endAngle4;
@property(nonatomic) BOOL clockwise;
@end

@implementation GradesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.lineWith = 5.0;
        self.fill1Color = RGB_HEX(0xff7f00, 1);
        self.fill2Color = RGB_HEX(0xff0000, 1);
        self.fill3Color = RGB_HEX(0x3299cc, 1);
        self.fill4Color = RGB_HEX(0x32cd32, 1);
        self.unfillColor = [UIColor lightGrayColor];
        self.clockwise = YES;
        self.backgroundColor = [UIColor clearColor];
        self.percentage1 = 0.5;
        self.percentage2 = 0.1;
        self.percentage3 = 0.8;
        self.percentage4 = 0.3;
        self.startAngle = 180;
        self.endInnerAngle = 360;
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{
    [self addSubviews];
    [self drawMiddlecircle];
    [self drawOutCCircle];
}
-(void)addSubviews
{
    if(self.percentage1>1){
        self.percentage1 = 1.0;
    }
    else if(self.percentage1 < 0){
        self.percentage1 = 0;
    }
    if(self.percentage2>1){
        self.percentage2 = 1.0;
    }
    else if(self.percentage2 < 0){
        self.percentage2 = 0;
    }
    if(self.percentage3>1){
        self.percentage3 = 1.0;
    }
    else if(self.percentage3 < 0){
        self.percentage3 = 0;
    }
    if(self.percentage4>1){
        self.percentage4 = 1.0;
    }
    else if(self.percentage4 < 0){
        self.percentage4 = 0;
    }
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.frame = CGRectMake(10, 10, 200, 21);
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.text = self.titleN;
    [self.contentView addSubview:self.titleLabel];
    
    CGFloat width = (self.frame.size.width - 5 * cirlDistance)/4;
    CGFloat centery = 41+(self.frame.size.height - 41)/2;
    self.CGPoinCerter1 = CGPointMake(cirlDistance + width/2, centery);
    self.CGPoinCerter2 = CGPointMake(2*cirlDistance + 3*width/2, centery);
    self.CGPoinCerter3 = CGPointMake(3*cirlDistance + 5*width/2, centery);
    self.CGPoinCerter4 = CGPointMake(4*cirlDistance + 7*width/2, centery);
    radius = MIN(width/2-self.lineWith/2, (self.frame.size.height - 41)/2-self.lineWith/2);
    self.endInnerAngle = DEGREES_TO_RADIANS(self.endInnerAngle);
    self.startAngle = DEGREES_TO_RADIANS(self.startAngle);
    self.endAngle1 = self.percentage1*(self.endInnerAngle - self.startAngle) + self.startAngle;
    self.endAngle2 = self.percentage2*(self.endInnerAngle - self.startAngle) + self.startAngle;
    self.endAngle3 = self.percentage3*(self.endInnerAngle - self.startAngle) + self.startAngle;
    self.endAngle4 = self.percentage4*(self.endInnerAngle - self.startAngle) + self.startAngle;
    
    self.score1Label = [[UILabel alloc]init];
    self.score1Label.font = [UIFont systemFontOfSize:radius/3];
    self.score1Label.numberOfLines = 2;
    self.score1Label.text = [NSString stringWithFormat:@"%.0lf%%\n优秀",self.percentage1*100];
    self.score1Label.frame =CGRectMake(cirlDistance, 41, width, 2*radius);
    self.score1Label.textAlignment=NSTextAlignmentCenter;
    self.score1Label.backgroundColor=[UIColor clearColor];
    self.score1Label.adjustsFontSizeToFitWidth = YES;
    self.score1Label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.score2Label = [[UILabel alloc]init];
    self.score2Label.font = [UIFont systemFontOfSize:radius/3];
    self.score2Label.text = [NSString stringWithFormat:@"%.0lf%%\n良好",self.percentage2*100];
    self.score2Label.numberOfLines = 2;
    self.score2Label.frame =CGRectMake(2*cirlDistance + width, 41, width, 2*radius);
    self.score2Label.textAlignment=NSTextAlignmentCenter;
    self.score2Label.backgroundColor=[UIColor clearColor];
    self.score2Label.adjustsFontSizeToFitWidth = YES;
    self.score2Label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.score3Label = [[UILabel alloc]init];
    self.score3Label.font = [UIFont systemFontOfSize:radius/3];
    self.score3Label.text = [NSString stringWithFormat:@"%.0lf%%\n中等",self.percentage3*100];
    self.score3Label.numberOfLines = 2;
    self.score3Label.frame =CGRectMake(3*cirlDistance + 2*width, 41, width, 2*radius);
    self.score3Label.textAlignment=NSTextAlignmentCenter;
    self.score3Label.backgroundColor=[UIColor clearColor];
    self.score3Label.adjustsFontSizeToFitWidth = YES;
    self.score3Label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.score4Label = [[UILabel alloc]init];
    self.score4Label.font = [UIFont systemFontOfSize:radius/3];
    self.score4Label.text = [NSString stringWithFormat:@"%.0lf%%\n合格",self.percentage4*100];
    self.score4Label.numberOfLines = 2;
    self.score4Label.frame =CGRectMake(4*cirlDistance + 3*width, 41, width, 2*radius);
    self.score4Label.textAlignment=NSTextAlignmentCenter;
    self.score4Label.backgroundColor=[UIColor clearColor];
    self.score4Label.adjustsFontSizeToFitWidth = YES;
    self.score4Label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.contentMode = UIViewContentModeRedraw;
    [self.contentView addSubview:self.score1Label];
    [self.contentView addSubview:self.score2Label];
    [self.contentView addSubview:self.score3Label];
    [self.contentView addSubview:self.score4Label];
}
/**
 *  显示圆环
 */
-(void )drawOutCCircle{
    UIBezierPath *bPath1 = [UIBezierPath bezierPathWithArcCenter:self.CGPoinCerter1 radius:radius startAngle:self.startAngle endAngle:self.endAngle1 clockwise:self.clockwise];
    bPath1.lineWidth=self.lineWith;
    bPath1.lineCapStyle = kCGLineCapRound;
    bPath1.lineJoinStyle = kCGLineJoinRound;
    [self.fill1Color setStroke];
    [bPath1 stroke];
    
    UIBezierPath *bPath2 = [UIBezierPath bezierPathWithArcCenter:self.CGPoinCerter2 radius:radius startAngle:self.startAngle endAngle:self.endAngle2 clockwise:self.clockwise];
    bPath2.lineWidth=self.lineWith;
    bPath2.lineCapStyle = kCGLineCapRound;
    bPath2.lineJoinStyle = kCGLineJoinRound;
    [self.fill2Color setStroke];
    [bPath2 stroke];
    
    UIBezierPath *bPath3 = [UIBezierPath bezierPathWithArcCenter:self.CGPoinCerter3 radius:radius startAngle:self.startAngle endAngle:self.endAngle3 clockwise:self.clockwise];
    bPath3.lineWidth=self.lineWith;
    bPath3.lineCapStyle = kCGLineCapRound;
    bPath3.lineJoinStyle = kCGLineJoinRound;
    [self.fill3Color setStroke];
    [bPath3 stroke];
    
    UIBezierPath *bPath4 = [UIBezierPath bezierPathWithArcCenter:self.CGPoinCerter4 radius:radius startAngle:self.startAngle endAngle:self.endAngle4 clockwise:self.clockwise];
    bPath4.lineWidth=self.lineWith;
    bPath4.lineCapStyle = kCGLineCapRound;
    bPath4.lineJoinStyle = kCGLineJoinRound;
    [self.fill4Color setStroke];
    [bPath4 stroke];
}
/**
 *  辅助圆环
 */
-(void)drawMiddlecircle{
    UIBezierPath *cPath1 = [UIBezierPath bezierPathWithArcCenter:self.CGPoinCerter1 radius:radius startAngle:self.startAngle endAngle:self.endInnerAngle clockwise:self.clockwise];
    cPath1.lineWidth=self.lineWith;
    cPath1.lineCapStyle = kCGLineCapRound;
    cPath1.lineJoinStyle = kCGLineJoinRound;
    UIColor *color1 = self.unfillColor;
    [color1 setStroke];
    [cPath1 stroke];
    
    UIBezierPath *cPath2 = [UIBezierPath bezierPathWithArcCenter:self.CGPoinCerter2 radius:radius startAngle:self.startAngle endAngle:self.endInnerAngle clockwise:self.clockwise];
    cPath2.lineWidth=self.lineWith;
    cPath2.lineCapStyle = kCGLineCapRound;
    cPath2.lineJoinStyle = kCGLineJoinRound;
    UIColor *color2 = self.unfillColor;
    [color2 setStroke];
    [cPath2 stroke];
    
    UIBezierPath *cPath3 = [UIBezierPath bezierPathWithArcCenter:self.CGPoinCerter3 radius:radius startAngle:self.startAngle endAngle:self.endInnerAngle clockwise:self.clockwise];
    cPath3.lineWidth=self.lineWith;
    cPath3.lineCapStyle = kCGLineCapRound;
    cPath3.lineJoinStyle = kCGLineJoinRound;
    UIColor *color3 = self.unfillColor;
    [color3 setStroke];
    [cPath3 stroke];
    
    UIBezierPath *cPath4 = [UIBezierPath bezierPathWithArcCenter:self.CGPoinCerter4 radius:radius startAngle:self.startAngle endAngle:self.endInnerAngle clockwise:self.clockwise];
    cPath4.lineWidth=self.lineWith;
    cPath4.lineCapStyle = kCGLineCapRound;
    cPath4.lineJoinStyle = kCGLineJoinRound;
    UIColor *color4 = self.unfillColor;
    [color4 setStroke];
    [cPath4 stroke];
}
@end
