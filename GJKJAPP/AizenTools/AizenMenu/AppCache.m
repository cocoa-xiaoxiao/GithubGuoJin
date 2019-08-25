//
//  AppCache.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/2/7.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "AppCache.h"

@implementation AppCache

+(NSMutableArray *)handleTopModuleArr:(NSArray *)arr{
    if ([arr isKindOfClass:[NSDictionary class]]) {
        arr = [NSArray arrayWithObjects:arr, nil];
    }
    NSMutableArray *result = [[NSMutableArray alloc]init];
    
    for(int i = 0;i<[arr count];i++){
        NSDictionary *dic = [arr objectAtIndex:i];
        NSArray *keys = [dic allKeys];
        NSMutableDictionary *muDic = [[NSMutableDictionary alloc]init];
        for(int x = 0;x<[keys count];x++){
            if([[arr[i] objectForKey:keys[x]] isKindOfClass:[NSNull class]]){
                [muDic setObject:@"" forKey:keys[x]];
            }else{
                [muDic setObject:[arr[i] objectForKey:keys[x]] forKey:keys[x]];
            }
        }
        [result addObject:muDic];
        //result[i] = muDic;
    }
    return result;
}


+(NSMutableArray *)handleSubModuleArr:(NSMutableArray *)arr{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for(int i = 0;i<[arr count];i++){
        NSDictionary *secondModule = arr[i];
        NSArray *secondKeys = [secondModule allKeys];
        NSMutableDictionary *newSecondModule = [[NSMutableDictionary alloc]init];
        for(int x = 0;x<[secondKeys count];x++){
            if([secondKeys[x] isEqualToString:@"SysModuleVMs"]){
                NSMutableArray *newThirdArr = [[NSMutableArray alloc]init];
                NSArray *thirdArr = secondModule[@"SysModuleVMs"];
                for(int y = 0;y<[thirdArr count];y++){
                    NSMutableDictionary *newThirdModule = [[NSMutableDictionary alloc]init];
                    NSDictionary *thirdModule = thirdArr[y];
                    NSArray *thirdKeys = [thirdModule allKeys];
                    for(int z = 0;z<[thirdKeys count];z++){
                        if([thirdModule[thirdKeys[z]] isKindOfClass:[NSNull class]]){
                            [newThirdModule setObject:@"" forKey:thirdKeys[z]];
                        }else{
                            [newThirdModule setObject:thirdModule[thirdKeys[z]] forKey:thirdKeys[z]];
                        }
                    }
                    [newThirdArr addObject:newThirdModule];
                }
                [newSecondModule setObject:newThirdArr forKey:secondKeys[x]];
            }else{
                if([secondModule[secondKeys[x]] isKindOfClass:[NSNull class]]){
                    [newSecondModule setObject:@"" forKey:secondKeys[x]];
                }else{
                    [newSecondModule setObject:secondModule[secondKeys[x]] forKey:secondKeys[x]];
                }
            }
        }
        [result addObject:newSecondModule];
    }
    return result;
}

@end
