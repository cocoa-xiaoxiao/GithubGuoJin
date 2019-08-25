//
//  MyProposalDetailViewController.h
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/11.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface myProposalModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, assign) BOOL isteam;
@property (nonatomic, assign) int cellType;

@end

@interface MyProposalDetailViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
