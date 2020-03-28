//
//  NewAuditingTaskCell.m
//  GJKJAPP
//
//  Created by 肖啸 on 2020/3/26.
//  Copyright © 2020 谭耀焯. All rights reserved.
//

#import "NewAuditingTaskCell.h"
#import "PhoneInfo.h"

@implementation NewAuditingTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.taskSubviews.layer.shadowOpacity =1;
    self.taskSubviews.layer.shadowColor = RGB_HEX(0xbebebe, 1).CGColor;
    self.taskSubviews.layer.shadowOffset = CGSizeMake(0, 1);
    self.taskResponsible.textColor = DEFAULT_APPTHEME_COLOR;
    self.taskChecker.textColor = DEFAULT_APPTHEME_COLOR;
    self.taskUploadTime.textColor = DEFAULT_APPTHEME_COLOR;
    self.taskGrade.textColor = [UIColor systemPinkColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshAuditingTaskCellWithDict:(NSDictionary *)dataDic
{
    
    NSRange rang = {0,10};
    NSString *DateTime = [[[[dataDic objectForKey:@"EndDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
    NSString *DateStr = [PhoneInfo timestampSwitchTime:[DateTime integerValue] andFormatter:@"yyyy-MM-dd"];
    NSString *currTime = [PhoneInfo getNowTimeTimestamp3];
    int timeCount =  ([DateTime integerValue] + (24 * 60 * 60) - 1) - [currTime integerValue] / 1000;
    NSString *yuqi = [NSString stringWithFormat:@"%d天",abs(timeCount / (24 * 60 * 60) - 1)];
    NSString *createDateTime = [[[[dataDic objectForKey:@"CreateDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
    NSString *createDateStr = [PhoneInfo timestampSwitchTime:[createDateTime integerValue] andFormatter:@"yyyy-MM-dd"];
    NSString *statusStr = @"";
    UIColor *statusColor = nil;
    if([[dataDic objectForKey:@"State"] integerValue] == -1){
        statusStr = @"未提交";
        statusColor = [UIColor colorWithRed:232/255.0 green:79/255.0 blue:32/255.0 alpha:1];
    }else if([[dataDic objectForKey:@"State"] integerValue] == 0){
        statusStr = @"未审核";
        statusColor = [UIColor colorWithRed:234/255.0 green:218/255.0 blue:35/255.0 alpha:1];

    }else if([[dataDic objectForKey:@"State"] integerValue] == 1){
        statusStr = @"审核通过";
        statusColor = [UIColor colorWithRed:47/255.0 green:222/255.0 blue:51/255.0 alpha:1];
    }else if([[dataDic objectForKey:@"State"] integerValue] == 2){
        statusStr = @"审核不通过";
        statusColor = [UIColor colorWithRed:231/255.0 green:144/255.0 blue:41/255.0 alpha:1];
    }else if([[dataDic objectForKey:@"State"] integerValue] == 3){
        statusStr = @"反审";
        statusColor = [UIColor colorWithRed:231/255.0 green:144/255.0 blue:41/255.0 alpha:1];
    }else if([[dataDic objectForKey:@"State"] integerValue] == 4){
        statusStr = @"转审";
        statusColor = [UIColor colorWithRed:231/255.0 green:144/255.0 blue:41/255.0 alpha:1];
    }else if([[dataDic objectForKey:@"State"] integerValue] == 5){
        statusStr = @"过期";
        statusColor = [UIColor colorWithRed:231/255.0 green:144/255.0 blue:41/255.0 alpha:1];
    }
    NSString *score = @"无";
       if ([[dataDic objectForKey:@"State"] integerValue] > 0) {
           score = [NSString stringWithFormat:@"%.2f",[[dataDic objectForKey:@"FinalScore"] floatValue]];
       }
    self.taskName.text = [dataDic objectForKey:@"TaskTitle"];
    self.taskResponsible.text = [dataDic objectForKey:@"StudentName"];
    if (timeCount < 0) {
        self.taskOverTime.text = yuqi;
        self.taskOverTime.textColor = [UIColor systemPinkColor];
    }else{
        self.taskOverTime.text = @"否";
        self.taskOverTime.textColor = DEFAULT_APPTHEME_COLOR;
    }
    self.taskUploadTime.text = createDateStr;
    self.taskChecker.text = [NSString checkNull:[dataDic objectForKey:@"CheckName"]];
    self.taskState.text = statusStr;
    self.taskState.textColor = statusColor;
    self.taskGrade.text = score;
}
@end
