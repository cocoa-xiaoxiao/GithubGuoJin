//
//  BRTaskDetailModel.h
//  GJKJAPP
//
//  Created by git burning on 2018/9/15.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "BRBaseModel.h"

@interface BRTaskDetailModel : BRBaseModel
/*!
 *  @brief <#Description#> 
 */
@property  (nonatomic , copy)  NSString   * SubmitContent;
/*!
 *  @brief <#Description#>
 */
@property  (nonatomic , copy)  NSString   * ID;
/*!
 *  @brief <#Description#>
 */
@property  (nonatomic , copy)  NSString   * State;
/*!
 *  @brief <#Description#>
 */
@property  (nonatomic , copy)  NSString   * SubmitAttachment;
/*!
 *  @brief <#Description#>
 */
@property  (nonatomic , copy)  NSString   * UserName;
/*!
 *  @brief <#Description#>
 */
@property  (nonatomic , copy)  NSString   * CreateDate;
/*!
 *  @brief <#Description#>
 */
@property  (nonatomic , copy)  NSString   * CheckContent;
/*!
 *  @brief <#Description#>
 */
@property  (nonatomic , copy)  NSString   * CheckName;
/*!
 *  @brief <#Description#>
 */
@property  (nonatomic , copy)  NSString   * ActivityTaskDetailID;
/*!
 *  @brief <#Description#>
 */
@property  (nonatomic , copy)  NSString   * CheckAttachment;
/*!
 *  @brief <#Description#>
 */
@property  (nonatomic , copy)  NSString   * UpdateDate;
/*!
 *  @brief <#Description#>
 */
@property  (nonatomic , copy)  NSString   * UserNo;
@end
