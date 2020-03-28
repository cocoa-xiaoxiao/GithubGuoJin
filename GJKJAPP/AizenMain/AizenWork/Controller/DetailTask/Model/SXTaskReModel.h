//
//  SXTaskReModel.h
//  GJKJAPP
//
//  Created by 肖啸 on 2020/3/23.
//  Copyright © 2020 谭耀焯. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXTaskReModel : NSObject

@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *CheckName;
@property (nonatomic, copy) NSString *UpdateDate;
@property (nonatomic, copy) NSString *SubmitAttachment;
@property (nonatomic, copy) NSString *CheckAttachment;
@property (nonatomic, copy) NSString *SubmitContent;
@property (nonatomic, copy) NSString *CheckContent;
@end

NS_ASSUME_NONNULL_END
