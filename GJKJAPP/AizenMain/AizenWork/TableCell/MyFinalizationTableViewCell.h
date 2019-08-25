//
//  MyFinalizationTableViewCell.h
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/11.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MyFinalizationTableViewCellDelegate <NSObject>

-(void)chachongWithIndexPath:(NSIndexPath *)index;

@end
@interface MyFinalizationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *fTeachLabel;
@property (weak, nonatomic) IBOutlet UILabel *fScoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *chachongButton;
@property (nonatomic, strong) NSIndexPath *cellIndex;
@property (weak, nonatomic) id <MyFinalizationTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
