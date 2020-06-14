//
//  SXTaskHeadVC.m
//  GJKJAPP
//
//  Created by 肖啸 on 2020/3/19.
//  Copyright © 2020 谭耀焯. All rights reserved.
//

#import "SXTaskHeadVC.h"
#import "PhoneInfo.h"
@interface SXTaskHeadVC ()
@property (nonatomic, strong) NSDictionary *headDic;
@end

@implementation SXTaskHeadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self request];
}

-(void)request
{
    [HttpService sxtaskDetail:self.taskID success:^(id  _Nonnull responseObject) {
        self.headDic = [[responseObject objectForKey:@"AppendData"] firstObject];
        [self taskHeadRefresh];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


-(void)taskHeadRefresh
{
    self.detailTitleLb.text = [self.headDic objectForKey:@"TaskTitle"];
    NSRange rang = {0,10};
    NSString *StartTime =[PhoneInfo timestampSwitchTime:[[[[[self.headDic objectForKey:@"BeginDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang]integerValue] andFormatter:@"YYYY-MM-dd"];
    NSString *endTime =  [PhoneInfo timestampSwitchTime:[[[[[self.headDic objectForKey:@"EndDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang]integerValue] andFormatter:@"YYYY-MM-dd"];
    self.detailtimeLb.text = [NSString stringWithFormat:@"%@ ~ %@",StartTime,endTime];
    NSString *requeststr = [NSString checkNull:[self.headDic objectForKey:@"ContentReq"]];
    CGSize size =  [self mh_stringSizeWithFont:[UIFont systemFontOfSize:15.0] str:requeststr maxWidth:(self.view.xo_width-107) maxHeight:MAXFLOAT];
    
    self.detailReqLb.text =  requeststr;
    NSInteger can = [[self.headDic objectForKey:@"State"] integerValue];
    NSMutableString *submitstr = [NSString checkNull:[self.headDic objectForKey:@"Attachment"]];
    NSArray *ar = [submitstr componentsSeparatedByString:@"/"];
    self.detailFujianLb.text = ar.lastObject;
    self.detailFujianLb.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fujianAction:)];
    tap.accessibilityValue = [self.headDic objectForKey:@"Attachment"];
    [self.detailFujianLb addGestureRecognizer:tap];
    NSString *jianfenstr = [NSString checkNull:[self.headDic objectForKey:@"OverdueScore"]];
    if (self.bulidBlock) {
        self.bulidBlock(164 + ceilf(size.height),can,jianfenstr);
    }
    
}

-(void)fujianAction:(UITapGestureRecognizer *)tap
{
    if (self.lookDetailFuj) {
        self.lookDetailFuj(tap.accessibilityValue);
    }
}

- (CGSize)mh_stringSizeWithFont:(UIFont *)font str:(NSString*)str maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight
{
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    CGSize maxSize = CGSizeMake(maxWidth, maxHeight);
    attr[NSFontAttributeName] = font;
    return [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attr context:nil].size;
    
}
@end
