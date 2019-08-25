//
//  UITextView+Placeholder.h
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/30.
//  Copyright © 2018 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//系统版本
#define HKVersion [[[UIDevice currentDevice] systemVersion] floatValue]
@interface UITextView (Placeholder)
-(void)setPlaceholder:(NSString *)placeholdStr placeholdColor:(UIColor *)placeholdColor;
@end

NS_ASSUME_NONNULL_END
