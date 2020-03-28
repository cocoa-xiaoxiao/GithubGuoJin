//
//  SXTaskHeadVC.h
//  GJKJAPP
//
//  Created by 肖啸 on 2020/3/19.
//  Copyright © 2020 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXTaskHeadVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *detailtimeLb;
@property (weak, nonatomic) IBOutlet UILabel *detailReqLb;
@property (weak, nonatomic) IBOutlet UILabel *detailFujianLb;
@property (nonatomic, copy) NSString *taskID;

@property (nonatomic, copy) void (^bulidBlock)(CGFloat height , NSInteger cansub,NSString *jianfen);
@end

NS_ASSUME_NONNULL_END
