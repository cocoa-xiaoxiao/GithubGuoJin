//
//  SXTaskDyModel.h
//  GJKJAPP
//
//  Created by 肖啸 on 2020/3/23.
//  Copyright © 2020 谭耀焯. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXTaskDyModel : NSObject

@property (nonatomic, copy) NSString *SubmitAttachment; //提交附件
@property (nonatomic, copy) NSString *SubmitContent; //提交内容
@property (nonatomic, copy) NSString *CheckAttachment; //提交附件
@property (nonatomic, copy) NSString *CheckContent; //提交内容
@property (nonatomic, copy) NSString *OverdueScore; //超期
@property (nonatomic, copy) NSString *TeacherScore; //审核
@property (nonatomic, copy) NSString *FinalScore; //最终
@property (nonatomic, copy) NSString *CheckAttachmentAll; //提交附件
@property (nonatomic, copy) NSString *SubmitAttachmentAll; //提交附件
@end

NS_ASSUME_NONNULL_END
