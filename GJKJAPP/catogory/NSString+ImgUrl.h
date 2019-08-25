//
//  NSString+ImgUrl.h
//  GJKJAPP
//
//  Created by git burning on 2018/9/13.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ImgUrl)

-(NSString *)fullImg;

- (NSString *)changeYYYYMMDDTime;

- (NSString *)changeYYYYMMDDSSTime;

- (NSString *)changeMMDDSSTime;

@end
