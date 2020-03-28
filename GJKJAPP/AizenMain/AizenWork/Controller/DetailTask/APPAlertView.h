//
//  APPAlertView.h
//  GJKJAPP
//
//  Created by 肖啸 on 2020/3/23.
//  Copyright © 2020 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol APPAlertViewDelegate <NSObject>

@end

@interface APPAlertView : UIView

-(instancetype)AlertFactoryInitPracticeTaskSubmitViewfromController:(UIViewController *)viewcontroller taskID:(NSString *)taskid successblock:(SuccessResponseBlock)block;
-(void)show;
@end

@interface APPShenheView : UIView

-(instancetype)AlertFactoryshenheStudentID:(NSString *)ID successblock:(SuccessResponseBlock)block;
-(void)show;

@end


@interface APPStationChenckAlertView : UIView
-(instancetype)initWithStringArray:(NSArray *)strings applyID:(NSString *)applyID andIsOppose:(BOOL)oppose isWeeklyCheck:(BOOL)isweekly successblock:(SuccessResponseBlock)block;
-(void)show;
@end


@interface APPTaskCheckAlertView : UIView
-(instancetype)initWithTaskCheckAlertStringArray:(NSArray *)strings applyID:(NSString *)applyID  successblock:(SuccessResponseBlock)block Controller:(UIViewController *)viewcontroller koufen:(NSString *)jian;
-(void)show;
@end

NS_ASSUME_NONNULL_END
