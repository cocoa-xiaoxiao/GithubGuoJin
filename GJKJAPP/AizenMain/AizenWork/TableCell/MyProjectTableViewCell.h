//
//  MyProjectTableViewCell.h
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/10.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyProjectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *pnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ptimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pteacherLabel;

- (IBAction)chooseCommand:(id)sender;

@end

NS_ASSUME_NONNULL_END
