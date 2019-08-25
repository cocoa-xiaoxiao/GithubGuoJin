//
//  ScoreTableView.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/2/16.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "ScoreTableView.h"
#import "Masonry.h"
@interface ScoreTableView ()<UIScrollViewDelegate>
{
    CGFloat currentPage;//当前页数
    CGFloat Xmargin;//X轴方向的偏移
    CGFloat Ymargin;//Y轴方向的偏移
    CGPoint lastPoint;//最后一个坐标点
    UIButton *firstBtn;
}
@property (nonatomic,strong)UIScrollView *chartScrollView;
@property (nonatomic,strong)UIView *bgView1;//背景图
@property (nonatomic,strong)UIView *scrollBgView1;
@property (nonatomic,strong)NSMutableArray *leftPointArr;//左边的数据源
@property (nonatomic,strong)NSMutableArray *leftBtnArr;//左边按钮
@property (nonatomic,strong)NSArray *leftScaleArr;
@property (nonatomic,strong)NSMutableArray *leftScaleViewArr;//左边的点击显示图
@property (nonatomic,strong)UILabel *lineLabel;
@end
@implementation ScoreTableView
-(UILabel *)lineLabel{
    
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:159/255.0 blue:106/255.0 alpha:1];
    }
    return _lineLabel;
}
-(UIView *)scrollBgView1{
    if (!_scrollBgView1) {
        _scrollBgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.chartScrollView.bounds.size.width-5, self.chartScrollView.bounds.size.height)];
        
    }
    return _scrollBgView1;
    
}
-(UIView *)bgView1{
    if (!_bgView1) {
        _bgView1 = [[UIView alloc]initWithFrame:CGRectMake(5, 0, self.chartScrollView.bounds.size.width-20, self.scrollBgView1.bounds.size.height-60)];
        _bgView1.layer.masksToBounds = YES;
        _bgView1.layer.cornerRadius = 5;
        _bgView1.layer.borderWidth = 1;
        _bgView1.layer.borderColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1].CGColor;
    }
    
    return _bgView1;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        currentPage = 0;
        self.leftPointArr = [NSMutableArray array];
        self.leftBtnArr = [NSMutableArray array];
        self.leftScaleArr = [NSArray array];
        self.leftScaleViewArr = [NSMutableArray array];
        [self addDetailViews];
    }
    return self;
}

//*******************数据源************************//

-(void)setLeftDataArr:(NSArray *)leftDataArr{
    
    [self addDataPointWith:self.scrollBgView1 andArr:leftDataArr];//添加点
    
    [self addLeftBezierPoint];//添加连线
    
    self.chartScrollView.scrollEnabled = NO;
}
//*******************分割线************************//
-(void)addDetailViews{
    
    self.chartScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(30, 0, self.bounds.size.width-30, self.bounds.size.height)];
    self.chartScrollView.contentOffset = CGPointMake(0, 0);
    self.chartScrollView.backgroundColor = [UIColor clearColor];
    self.chartScrollView.delegate = self;
    self.chartScrollView.showsHorizontalScrollIndicator = NO;
    self.chartScrollView.pagingEnabled = YES;
    self.chartScrollView.contentSize = CGSizeMake(self.bounds.size.width*1, 0);
    [self addSubview:self.chartScrollView];
    [self.chartScrollView addSubview:self.scrollBgView1];
    [self.scrollBgView1 addSubview:self.bgView1];
    [self addLines1With:self.bgView1];
    //添加左边数值
    [self addLeftViews];
    //添加底部月份
    [self addBottomViewsWith:self.scrollBgView1];
}

//添加左边的坐标线
-(void)addLeftBezierPoint{
    //取得起始点
    CGPoint p1 = [[self.leftPointArr objectAtIndex:0] CGPointValue];
    NSLog(@"%f %f",p1.x,p1.y);
    //直线的连线
    UIBezierPath *beizer = [UIBezierPath bezierPath];
    [beizer moveToPoint:p1];
    //遮罩层的形状
    UIBezierPath *bezier1 = [UIBezierPath bezierPath];
    bezier1.lineCapStyle = kCGLineCapRound;
    bezier1.lineJoinStyle = kCGLineJoinMiter;
    [bezier1 moveToPoint:p1];
    for (int i = 0;i<self.leftPointArr.count;i++ ) {
        if (i != 0) {
            CGPoint point = [[self.leftPointArr objectAtIndex:i] CGPointValue];
            [beizer addLineToPoint:point];
            [bezier1 addLineToPoint:point];
            if (i == self.leftPointArr.count-1) {
                [beizer moveToPoint:point];//添加连线
                lastPoint = point;
            }
        }
    }
    
    CGFloat bgViewHeight = self.bgView1.bounds.size.height;
    
    //获取最后一个点的X值
    CGFloat lastPointX = lastPoint.x;
    
    //最后一个点对应的X轴的值
    
    CGPoint lastPointX1 = CGPointMake(lastPointX, bgViewHeight);
    
    [bezier1 addLineToPoint:lastPointX1];
    
    //回到原点
    
    [bezier1 addLineToPoint:CGPointMake(p1.x, bgViewHeight)];
    
    [bezier1 addLineToPoint:p1];
    
    //遮罩层
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
    shadeLayer.path = bezier1.CGPath;
    shadeLayer.fillColor = [UIColor greenColor].CGColor;
    
    // [self.scrollBgView1.layer addSublayer:shadeLayer];
    
    //渐变图层
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(5, 0, 0, self.scrollBgView1.bounds.size.height-60);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.cornerRadius = 5;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:166/255.0 green:206/255.0 blue:247/255.0 alpha:0.7].CGColor,(__bridge id)[UIColor colorWithRed:237/255.0 green:246/255.0 blue:253/255.0 alpha:0.5].CGColor];
    gradientLayer.locations = @[@(0.5f)];
    
    CALayer *baseLayer = [CALayer layer];
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:shadeLayer];
    
    [self.scrollBgView1.layer addSublayer:baseLayer];
    
    CABasicAnimation *anmi1 = [CABasicAnimation animation];
    anmi1.keyPath = @"bounds";
    anmi1.duration = 5.2;
    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(5, 0, 2*lastPoint.x, self.scrollBgView1.bounds.size.height-60)];
    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi1.fillMode = kCAFillModeForwards;
    anmi1.autoreverses = NO;
    anmi1.removedOnCompletion = NO;
    
    [gradientLayer addAnimation:anmi1 forKey:@"bounds"];
    
    
    //*****************添加动画连线******************//
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = beizer.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor colorWithRed:0 green:120/255.0 blue:233/255.0 alpha:1].CGColor;
    shapeLayer.lineWidth = 2;
    [self.scrollBgView1.layer addSublayer:shapeLayer];
    
    
    CABasicAnimation *anmi = [CABasicAnimation animation];
    anmi.keyPath = @"strokeEnd";
    anmi.fromValue = [NSNumber numberWithFloat:0];
    anmi.toValue = [NSNumber numberWithFloat:1.0f];
    anmi.duration = 5;
    anmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi.autoreverses = NO;
    
    [shapeLayer addAnimation:anmi forKey:@"stroke"];
    
    for (UIButton *btn in self.leftBtnArr) {
        [self.scrollBgView1 addSubview:btn];
    }
    
    
}

-(void)addDataPointWith:(UIView *)view andArr:(NSArray *)leftData{
    
    self.leftScaleArr = leftData;
    
    CGFloat height = self.bgView1.bounds.size.height;
    
    //初始点
    NSMutableArray *arr = [NSMutableArray arrayWithArray:leftData];
    [arr insertObject:@"0" atIndex:0];
    
    CGFloat lineHeight = 0.5*height;//线的高度
    
    
    for (int i = 0; i<arr.count; i++) {
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((Xmargin)*i,(1- [arr[i] floatValue])* height - 6, 12, 12)];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.borderColor = [UIColor colorWithRed:0 green:122/255.0 blue:233/255.0 alpha:1].CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 6;
        btn.layer.masksToBounds = YES;
        btn.tag = i;
        if (i == 0) {
            firstBtn = btn;
        }
        [self.leftBtnArr addObject:btn];
        NSValue *point = [NSValue valueWithCGPoint:btn.center];
        [self.leftPointArr addObject:point];
    }
}


-(void)addLeftViews{
    NSArray *leftArr = @[@"100%",@"80%",@"60%",@"40%",@"20%"];
    for (int i = 0;i<5 ;i++ ) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, i*(Ymargin)-8, 30, 30)];
        leftLabel.textColor = [UIColor grayColor];
        leftLabel.font = [UIFont systemFontOfSize:12];
        leftLabel.text = leftArr[i];
        [leftLabel sizeToFit];
        [self addSubview:leftLabel];
    }
}


-(void)addBottomViewsWith:(UIView *)UIView{
    NSArray *bottomArr;
    if (UIView == self.scrollBgView1) {
        bottomArr = @[@"优秀",@"良好",@"中等",@"合格",@"不合格"];
        
    }
    for (int i = 0;i<5 ;i++ ) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(Xmargin+i*Xmargin-12, 5*Ymargin, 50, 30)];
        leftLabel.textColor = [UIColor blackColor];
        leftLabel.font = [UIFont systemFontOfSize:10];
        leftLabel.text = bottomArr[i];
        leftLabel.textAlignment = 0;
        [UIView addSubview:leftLabel];
    }
}
-(void)addLines1With:(UIView *)view{
    CGFloat magrginHeight = (view.bounds.size.height)/5;
    CGFloat labelWith = view.bounds.size.width;
    Ymargin = magrginHeight;
    for (int i = 0;i<5 ;i++ ) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, magrginHeight+magrginHeight*i, labelWith, 1)];
        label.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
        [view addSubview:label];
    }
    CGFloat marginWidth = view.bounds.size.width/5;
    Xmargin = marginWidth;
    CGFloat labelHeight = view.bounds.size.height;
    for (int i = 0;i<5 ;i++ ) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(marginWidth*i, 0, 1, labelHeight)];
        label.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
        if (i != 0) {
            [view addSubview:label];
        }
    }
}


@end
