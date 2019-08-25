//
//  AizenStorage.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/1/24.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AizenStorage : NSObject

+ (void)writeUserDataWithKey:(id)data forKey:(NSString*)key;

+ (void)writeUserBoolWithKey:(BOOL)data forKey:(NSString *)key;

+ (id)readUserDataWithKey:(NSString*)key;

+ (void)removeUserDataWithkey:(NSString*)key;

@end
