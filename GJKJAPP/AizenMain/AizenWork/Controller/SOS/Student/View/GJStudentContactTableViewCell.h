//
//  GJStudentContactTableViewCell.h
//  GJKJAPP
//
//  Created by git burning on 2018/10/11.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GJStudentContactTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teacherNameLabelLeftConstraint;

@end
