//
//  NSString+Extension.h
//  golo
//
//  Created by launch06 on 13-11-6.
//  Copyright (c) 2013年 LAUNCH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

+ (NSString *)md5:(NSString *)str;

- (NSString *)md5;

+ (NSString *)base64StringFromText:(NSString *)text;

+ (NSString *)textFromBase64String:(NSString *)base64;

+ (NSString *)generateUDID;
/**
 *  去除字符串左右两端空格
 *
 *  @param string 输入字符串
 *
 *  @return 返回字符串
 */
+ (NSString *)trimString:(NSString *)string;

+ (id)checkNull:(id)source;

+ (NSString *)stringWithDate:(NSDate *)date dateFormat:(NSString *)dateFormat;

// 字符串编码
- (NSString *)stringURLEncoding;

- (NSString *)filterHTML;

@end
