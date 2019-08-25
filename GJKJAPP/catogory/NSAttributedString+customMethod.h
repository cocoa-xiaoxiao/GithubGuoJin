//
//  NSAttributedString+customMethod.h
//  XiangSuProject
//
//  Created by PC_xiaoxiao on 2019/4/8.
//  Copyright © 2019 xiaoxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (customMethod)

+(NSAttributedString *)xo_changeFontWithFont:(UIFont *)font totalStr:(NSString *)totalStr andChangeStingArray:(NSArray*)ChangeArray andColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
