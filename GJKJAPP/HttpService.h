//
//  HttpService.h
//  ubiaMainView
//
//  Created by PC_xiaoxiao on 2018/10/30.
//  Copyright © 2018年 youchuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, HTTPMethodType) {
    HTTPMethodTypeGET,
    HTTPMethodTypePOST
};
typedef void (^FailureResponseBlock)(NSError *error);       // 错误信息回调
typedef void (^SuccessResponseBlock)(id responseObject);    // 原始数据回调＋
typedef void(^ProgressResponseBlock)(NSProgress *uploadProgress); //进度
@interface HttpService : NSObject
+ (HttpService *)sharedAPI;
/**
 *  程序启动,第一次网络请求前需配置
 */
+ (void)configeWithUserInfo:(id)userInfo;

/**
 *  统一数据请求
 *  @param methodType 请求的方法
 *  @param api 请求地址
 *  @param parameters 请求的参数
 *  @param success    成功的回调
 *  @param failure    失败的回调
 */
+ (NSURLSessionDataTask *)dataTaskWithMethodType:(HTTPMethodType)methodType
                                             api:(NSString *)api
                                      parameters:(NSDictionary *)parameters
                                         success:(SuccessResponseBlock)success
                                         failure:(FailureResponseBlock)failure;

@end

NS_ASSUME_NONNULL_END
