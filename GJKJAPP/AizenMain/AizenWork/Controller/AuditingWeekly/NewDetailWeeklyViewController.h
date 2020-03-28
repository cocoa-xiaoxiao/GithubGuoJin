//
//  NewDetailWeeklyViewController.h
//  GJKJAPP
//
//  Created by 肖啸 on 2020/3/27.
//  Copyright © 2020 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewDetailWeeklyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UILabel *uploaderLb;
@property (weak, nonatomic) IBOutlet UILabel *uploadTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *modifiTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLb;
@property (weak, nonatomic) IBOutlet UIView *endTimeLayerV;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *role;
@end

NS_ASSUME_NONNULL_END
