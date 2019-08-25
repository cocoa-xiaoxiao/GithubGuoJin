//
//  AizenStorage.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/1/24.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "AizenStorage.h"

@implementation AizenStorage


+ (void)writeUserDataWithKey:(id)data forKey:(NSString*)key{
    if (data == nil){
        return;
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)writeUserBoolWithKey:(BOOL)data forKey:(NSString *)key{
    
    [[NSUserDefaults standardUserDefaults] setBool:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


+ (id)readUserDataWithKey:(NSString*)key{
    id temp = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if(temp != nil){
        return temp;
    }
    return nil;
}


+ (void)removeUserDataWithkey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

@end
