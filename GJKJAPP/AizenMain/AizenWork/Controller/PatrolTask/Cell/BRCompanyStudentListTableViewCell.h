//
//  BRCompanyStudentListTableViewCell.h
//  GJKJAPP
//
//  Created by git burning on 2018/9/17.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRCompanyStudentListTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *studentLabel;
@property (retain, nonatomic) IBOutlet UILabel *teacheLabel;
@property (retain, nonatomic) IBOutlet UILabel *roleLabel;
@property (retain, nonatomic) IBOutlet UILabel *studentTelLabel;
@property (retain, nonatomic) IBOutlet UILabel *teacherTelLabel;

@property (nonatomic, strong) UIImageView *headerImg;
@end
