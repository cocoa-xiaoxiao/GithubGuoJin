//
//  MyTaskBookCustom2TableViewCell.h
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/11.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyStudentTaskBookDetailViewController.h"
NS_ASSUME_NONNULL_BEGIN

@protocol MyCustom2TableCellDelegate <NSObject>

-(void)textViewEditEndAndTextString:(NSString *)text andIndex:(NSIndexPath *)index;

@end
@interface MyTaskBookCustom2TableViewCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<MyCustom2TableCellDelegate>delegate;
//@property (nonatomic, strong) mystudentTaskModel *model;
@end

NS_ASSUME_NONNULL_END
