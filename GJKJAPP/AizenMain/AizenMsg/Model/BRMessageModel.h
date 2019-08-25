//
//  BRMessageModel.h
//  GJKJAPP
//
//  Created by git burning on 2018/9/25.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "BRBaseModel.h"

@interface BRMessageModel : BRBaseModel
@property  (nonatomic , copy)  NSString   * CreateDate;
/*!
 *  @brief <#Description#> 
 */
@property  (nonatomic , copy)  NSString   * FactUrl;
/*!
 *  @brief <#Description#>
 */
@property  (nonatomic , copy)  NSString   * Creater;
/*!
 *  @brief <#Description#>
 */
@property  (nonatomic , copy)  NSString   * Num;
/*!
 *  @brief <#Description#>
 */
@property  (nonatomic , copy)  NSString   * MessageContent;
/*!
 *  @brief <#Description#>
 */
@property  (nonatomic , copy)  NSString   * UserName;
@end
