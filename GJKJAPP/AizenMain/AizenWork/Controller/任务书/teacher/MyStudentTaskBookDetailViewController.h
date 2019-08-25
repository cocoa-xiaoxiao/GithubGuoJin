//
//  MyStudentTaskBookDetailViewController.h
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/1/4.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyStudentTaskBookDetailViewController : UIViewController

@property (nonatomic, weak)taskBookListModel *topModel;

@end
@interface mystudentTaskModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, assign) BOOL isteam;
@property (nonatomic, assign) int cellType;

@end
NS_ASSUME_NONNULL_END
