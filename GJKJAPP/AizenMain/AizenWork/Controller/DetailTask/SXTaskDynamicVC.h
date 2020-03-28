//
//  SXTaskDynamicVC.h
//  GJKJAPP
//
//  Created by 肖啸 on 2020/3/19.
//  Copyright © 2020 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QQtableView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXTaskDynamicVC : UIViewController
@property (nonatomic , strong) QQtableView * tableView;
@property (nonatomic, copy) NSString *taskId;
@end

NS_ASSUME_NONNULL_END
