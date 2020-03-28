//
//  NewAuditingWeeklyTableViewCell.m
//  GJKJAPP
//
//  Created by 肖啸 on 2020/3/27.
//  Copyright © 2020 谭耀焯. All rights reserved.
//

#import "NewAuditingWeeklyTableViewCell.h"
#import "PhoneInfo.h"
@implementation NewAuditingWeeklyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.subview.layer.shadowOpacity =1;
    self.subview.layer.shadowColor = RGB_HEX(0xbebebe, 1).CGColor;
    self.subview.layer.shadowOffset = CGSizeMake(0, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)refreshAuditingWeeklyCellWithDict:(NSDictionary *)dataDic
{
    NSRange rang = {0,10};
    
    NSString *DateTime = [[[[dataDic objectForKey:@"CreateDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
    
    if (DateTime == nil) {
        DateTime = [[[[dataDic objectForKey:@"UpdateDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
    }
    NSString *DateStr = [PhoneInfo timestampSwitchTime:[DateTime integerValue] andFormatter:@"yyyy-MM-dd hh:mm:ss"];
    NSString *StateStr = @"";
    UIColor *showColor = nil;
    self.time.text =  [NSString stringWithFormat:@"审批时间：%@",DateStr];
    if([[dataDic objectForKey:@"CheckState"] integerValue] == 0){
        StateStr = @"待审核";
        self.time.text = [NSString stringWithFormat:@"提交时间：%@",DateStr];
        showColor = [UIColor colorWithRed:247/255.0 green:181/255.0 blue:94/255.0 alpha:1];
    }else if([[dataDic objectForKey:@"CheckState"] integerValue] == 1){
        StateStr = @"已通过";
        showColor = [UIColor colorWithRed:23/255.0 green:194/255.0 blue:149/255.0 alpha:1];
    }else if([[dataDic objectForKey:@"CheckState"] integerValue] == 2){
        StateStr = @"不通过";
        showColor = [UIColor colorWithRed:229/255.0 green:38/255.0 blue:38/255.0 alpha:1];
    }
    self.title.text = [dataDic objectForKey:@"WeeklyTitle"];
    self.state.text = StateStr;
    self.state.textColor = showColor;
    
}
@end
