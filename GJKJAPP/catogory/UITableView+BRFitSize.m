//
//  UITableView+BRFitSize.m
//  ZhangXinApp
//
//  Created by gitBurning on 2017/10/14.
//  Copyright © 2017年 BR. All rights reserved.
//

#import "UITableView+BRFitSize.h"

@implementation UITableView (BRFitSize)
-(void)br_fitios11 {
    self.estimatedSectionFooterHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
   // self.estimatedRowHeight = 0;

}
-(void)br_configFitIos11AdjustNo {
    self.estimatedSectionFooterHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
   // self.estimatedRowHeight = 0;

    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }

}
@end
