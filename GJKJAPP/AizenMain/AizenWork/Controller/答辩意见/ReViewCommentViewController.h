//
//  ReViewCommentViewController.h
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/1/7.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReViewCommentViewController : UIViewController

@property (nonatomic, copy) NSString *reviewID;
@property (nonatomic, assign) int editReview; //1编辑 2查看
@end

@interface myReViewCommentModel : NSObject

@property (nonatomic,copy) NSString *score;
@property (nonatomic,copy) NSString *comment;

@end

NS_ASSUME_NONNULL_END
