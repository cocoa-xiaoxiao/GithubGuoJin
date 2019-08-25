//
//  MyTaskBookCustom2TableViewCell.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/11.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "MyTaskBookCustom2TableViewCell.h"
#import "UITextView+Placeholder.h"
@implementation MyTaskBookCustom2TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_detailTextView setPlaceholder:@"请输入..." placeholdColor:[UIColor lightGrayColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(textViewEditEndAndTextString:andIndex:)]) {
        [self.delegate textViewEditEndAndTextString:textView.text andIndex:self.indexPath];
    }
}
@end
