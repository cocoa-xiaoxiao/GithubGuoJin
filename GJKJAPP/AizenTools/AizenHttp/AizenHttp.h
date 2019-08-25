//
//  AizenHttp.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/1/6.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AizenHttp : NSObject

+(void) asynRequest:(NSString *)URLString httpMethod:(NSString *)method params:(NSDictionary *)params success:(void(^)(id result))block failue:(void(^)(NSError *error))failure;

+(void) synRequest:(NSString *)URLString httpMethod:(NSString *)method params:(NSDictionary *)params success:(void(^)(id result))block failue:(void(^)(NSError *error))failure;

@end
