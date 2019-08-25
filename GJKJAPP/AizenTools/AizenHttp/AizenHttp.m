//
//  AizenHttp.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/1/6.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "AizenHttp.h"
#import "AFNetworking.h"

@implementation AizenHttp

+(void) asynRequest:(NSString *)URLString httpMethod:(NSString *)method params:(NSDictionary *)params success:(void(^)(id result))block failue:(void(^)(NSError *error))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    if([method isEqualToString:@"GET"]){
        [manager GET:URLString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"asynGET");
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            block(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
    }else if([method isEqualToString:@"POST"]){
        [manager POST:URLString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"asynPOST");
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            block(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
    }
}


+(void) synRequest:(NSString *)URLString httpMethod:(NSString *)method params:(NSDictionary *)params success:(void(^)(id result))block failue:(void(^)(NSError *error))failure{
    
}

@end
