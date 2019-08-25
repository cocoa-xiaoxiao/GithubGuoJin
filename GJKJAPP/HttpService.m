//
//  HttpService.m
//  ubiaMainView
//
//  Created by PC_xiaoxiao on 2018/10/30.
//  Copyright © 2018年 youchuan. All rights reserved.
//

#import "HttpService.h"
#import "AFNetworking.h"

/**
 *  @brief json调试开关
 */
#define JSONDEBUG NO
#define MM_BaseUrl    @"http://120.78.148.58"

@interface HttpService ()

@property (nonatomic, strong) id userInfo;

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation HttpService
#pragma mark - Init && Setup 初始化和设置
+ (HttpService *)sharedAPI {
    
    static HttpService *_sharedRequestAPI = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedRequestAPI = [[HttpService alloc] init];
    });
    
    return _sharedRequestAPI;
}

+ (void) configeWithUserInfo:(id)userInfo {
    
    // 设置超时等待的时间
    HttpService *requestService = [HttpService sharedAPI];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    requestService.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kCacheHttpRoot]
                                                      sessionConfiguration:configuration];
    requestService.userInfo = userInfo;
    //包括初始化
    requestService.manager.requestSerializer.timeoutInterval = 8;
    
    // 配置请求头信息
    [requestService configureHTTPHeaderField];
    
    //    requestService.manager.responseSerializer =  [AFHTTPResponseSerializer serializer];
    
    // 设置客户端可接受内容的类型
    NSMutableSet *acceptableContentTypes = [NSMutableSet setWithSet:requestService.manager.responseSerializer.acceptableContentTypes];
    [acceptableContentTypes addObject:@"text/plain"];
    [acceptableContentTypes addObject:@"text/html"];
    [acceptableContentTypes addObject:@"multipart/form-data"];
    
    requestService.manager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
}


/**
 * 登录成功配置请求头
 */
- (void)configureHTTPHeaderField {
    //---------------------------------------------- 配置网络层Header信息 for app 信息 --------------------------------------------
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [_manager.requestSerializer setValue:appCurVersion forHTTPHeaderField:@"version"];
    
    //设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    [_manager.requestSerializer setValue:deviceName forHTTPHeaderField:@"deviceName"];
    
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    [_manager.requestSerializer setValue:phoneVersion forHTTPHeaderField:@"phoneVersion"];
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] model];
    [_manager.requestSerializer setValue:phoneModel forHTTPHeaderField:@"phoneModel"];
    
    //地方型号  （国际化区域名称）
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    [_manager.requestSerializer setValue:localPhoneModel forHTTPHeaderField:@"localPhoneModel"];
    
    [_manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
}


#pragma mark - 通用请求 && GET请求 && POST请求 && 上传请求 && 下载请求
+ (NSURLSessionDataTask *)dataTaskWithMethodType:(HTTPMethodType)methodType
                                             api:(NSString *)api
                                      parameters:(NSDictionary *)parameters
                                         success:(SuccessResponseBlock)success
                                         failure:(FailureResponseBlock)failure
{
    NSURLSessionDataTask *task = [self goRequestWithMethodType:methodType
                                                           api:api
                                                    parameters:parameters
                                                       success:success
                                                       failure:failure];
    return task;
}

/**
 *  前往发起HTTP请求
 */
+ (NSURLSessionDataTask *)goRequestWithMethodType:(HTTPMethodType)methodType
                                              api:(NSString *)api
                                       parameters:(NSDictionary *)parameters
                                          success:(SuccessResponseBlock)success
                                          failure:(FailureResponseBlock)failure
{
    NSURLSessionDataTask *task = nil;
    switch (methodType) {
        case HTTPMethodTypeGET:
            task = [self getRequestWithAPI:api parameters:parameters success:success failure:failure];
            break;
        case HTTPMethodTypePOST:
            
            task = [self postRequestWithAPI:api parameters:parameters success:success failure:failure];
            break;
        default:
            break;
    }
    return task;
}

/**
 *  GET请求
 *  @param api  请求的地址
 *  @param parameters 请求的参数
 *  @param success    成功的回调
 *  @param failure    失败的回调
 */
+ (NSURLSessionDataTask *)getRequestWithAPI:(NSString *)api
                                 parameters:(NSDictionary *)parameters
                                    success:(SuccessResponseBlock)success
                                    failure:(FailureResponseBlock)failure
{
    return [[HttpService sharedAPI] getRequestWithAPI:api
                                           parameters:parameters
                                              success:success
                                              failure:failure];
}
/**
 *  POST请求
 *
 *  @param api  请求的地址
 *  @param parameters 请求的参数
 *  @param success    成功的回调
 *  @param failure    失败的回调
 */
+ (NSURLSessionDataTask *)postRequestWithAPI:(NSString *)api
                                  parameters:(NSDictionary *)parameters
                                     success:(SuccessResponseBlock)success
                                     failure:(FailureResponseBlock)failure
{
    return [[HttpService sharedAPI] postRequestWithAPI:api
                                            parameters:parameters
                                               success:success
                                               failure:failure];
}
#pragma mark - Private Instance Method 私有实例方法
/*!
 *  AFNetworking get请求发起
 *  注:progress并未实现返回 今后可以实现
 */
- (NSURLSessionDataTask *)getRequestWithAPI:(NSString *)api
                                 parameters:(NSDictionary *)parameters
                                    success:(SuccessResponseBlock)success
                                    failure:(FailureResponseBlock)failure
{
    // 添加Token 或者 用户账号信息
    NSLog(@"发起get请求:%@\n请求参数:%@",api,parameters);
    
    NSURLSessionDataTask *dataTask = [_manager GET:api parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        /**
         *  @brief 异常状态 代码 情况判断
         */
        if (![[responseObject objectForKey:@"ResultType"] boolValue]) {
            
            [self requestSuccessOperationWithAPI:api
                                      parameters:parameters
                                        response:responseObject
                                            task:task
                                         success:success
                                         failure:failure];
            
        } else {
            
            NSError * failureError = [NSError errorWithDomain:@"InvalidCode"
                                                         code:[[responseObject objectForKey:@"ResultType"] intValue]
                                                     userInfo:@{@"message":responseObject[@"Message"]}];
            
            // get失败处理
            [self requestFailOperationWithAPI:api
                                   parameters:parameters
                                        error:failureError
                                      success:success
                                      failure:failure];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // get失败处理
        [self requestFailOperationWithAPI:api
                               parameters:parameters
                                    error:error
                                  success:success
                                  failure:failure];
    }];
    
    
    return dataTask;
}

/*!
 *  AFNetworking post请求发起
 *  注:progress并未实现返回 今后可以实现
 */
- (NSURLSessionDataTask *)postRequestWithAPI:(NSString *)api
                                  parameters:(NSDictionary *)parameters
                                     success:(SuccessResponseBlock)success
                                     failure:(FailureResponseBlock)failure
{
    // 添加Token 或者 用户账号信息
    NSLog(@"发起post请求:%@\n请求参数:%@",api,parameters);
    
    NSURLSessionDataTask *dataTask = [_manager POST:api parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // post成功处理
        [self requestSuccessOperationWithAPI:api
                                  parameters:parameters
                                    response:responseObject
                                        task:task
                                     success:success
                                     failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // post失败处理
        [self requestFailOperationWithAPI:api
                               parameters:parameters
                                    error:error
                                  success:success
                                  failure:failure];
        
    }];
    return dataTask;
}

/*!
 *  @brief C函数 调用类方法 - 成功回调
 *
 *  为解决对象对类函数调用不方便的问题
 *  统一将常用类方法做了C函数构建
 */
void handleSuccess (SuccessResponseBlock success , id result ) {
    
    if (success)
        success(result);
    else
        print(@"该api没有Success block");
}
/*!
 *  @brief C函数 调用类方法 - 失败回调
 */
void handleFailure (FailureResponseBlock failure , NSError *error ) {
    
    if (failure)
        failure(error);
    else
        print(@"该api没有Fail block");
}

void handleProgress (ProgressResponseBlock progressblock, NSProgress *progress)
{
    if (progressblock) {
        progressblock(progress);
    }else{
        print(@"该api没有progressblock");
    }
}
void print (NSString * pStr) {
    printf("%s\n",pStr.UTF8String);
}

//get,post统一成功处理
-(void)requestSuccessOperationWithAPI:(NSString *)api
                           parameters:(NSDictionary *)parameters
                             response:(id  _Nullable)responseObject
                                 task:(NSURLSessionDataTask * _Nonnull)task
                              success:(SuccessResponseBlock)success
                              failure:(FailureResponseBlock)failure
{
    /**
     *  @brief 调试阶段返回参数打印
     */
    
    if (JSONDEBUG) {
        NSLog(@"----------返回内容----------\n%@",responseObject);
    }
    
    //返回请求成功结果
    handleSuccess(success, responseObject);
}
- (void)requestuploadOperationWithProgress:(ProgressResponseBlock)progress
                               andprogress:(NSProgress *)prog
{
    /**
     *  @brief 调试阶段返回参数打印
     */
    
    if (JSONDEBUG) {
        NSLog(@"----------返回内容----------\n%@",prog);
    }
    //返回请求成功结果
    handleProgress(progress, prog);
}

//get,post统一错误处理
- (void)requestFailOperationWithAPI:(NSString *)api
                         parameters:(NSDictionary *)parameters
                              error:(NSError * _Nonnull)error
                            success:(SuccessResponseBlock)success
                            failure:(FailureResponseBlock)failure
{
    handleFailure(failure, error);
}

@end
