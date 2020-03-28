//
//  SXTaskRecordCell.h
//  GJKJAPP
//
//  Created by 肖啸 on 2020/3/23.
//  Copyright © 2020 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXTaskRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dtcontentLb;
@property (weak, nonatomic) IBOutlet UILabel *dtnameLb;
@property (weak, nonatomic) IBOutlet UILabel *dttimeLb;
@property (weak, nonatomic) IBOutlet UIButton *dtAttachBtn;
@property (weak, nonatomic) IBOutlet UILabel *thcontentLb;
@property (weak, nonatomic) IBOutlet UILabel *thnameLb;
@property (weak, nonatomic) IBOutlet UILabel *thtimeLb;
@property (weak, nonatomic) IBOutlet UIButton *thAttachBtn;

@end

NS_ASSUME_NONNULL_END
