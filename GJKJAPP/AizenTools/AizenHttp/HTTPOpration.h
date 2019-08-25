//
//  HTTPOpration.h
//  GJKJAPP
//
//  Created by git burning on 2018/9/13.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "AFHTTPSessionManager.h"
@class HTTPData;
typedef void (^AddFooderFreshBlcok) (id info);
typedef void (^NotDataShowBlcok) (id info);
typedef void (^ReturnValueBlock) (HTTPData *data);
typedef void (^ErrorCodeBlock) (id errorCode);
typedef void (^FailureBlock)(id error);
typedef void (^NetWorkBlock)(BOOL netConnetState);
@interface HTTPOpration : AFHTTPSessionManager
+ (instancetype)sharedHTTPOpration;

-(NSURLSessionDataTask *)NetRequestGETWithRequestURL:(NSString *)requestURLString WithParameter:(NSDictionary *)parameter  WithReturnValeuBlock:(ReturnValueBlock)block WithFailureBlock:(FailureBlock)failureBlock;


/**
 *  POST请求 带图片
 *
 *  @param requestURLString <#requestURLString description#>
 *  @param parameter        <#parameter description#>
 *  @param files            <#files description#>
 *  @param block            <#block description#>
 *  @param errorBlock       <#errorBlock description#>
 *  @param failureBlock     <#failureBlock description#>
 *
 *  @return <#return value description#>
 */
- (NSURLSessionDataTask*) NetRequestPOSTFileWithRequestURL: (NSString *) requestURLString
                                             WithParameter: (NSDictionary *) parameter
                                                 WithFiles:(NSDictionary*)files
                                      WithReturnValeuBlock: (ReturnValueBlock) block
                                          WithFailureBlock: (FailureBlock) failureBlock;
@end

@interface HTTPData : NSObject
@property (nonatomic,strong) id returnData;
@property (nonatomic,copy)   NSString *msg;
@property(nonatomic,assign) NSInteger code;
@property(nonatomic,strong) id beforeData;
@property (nonatomic,strong) id tempData;


@end
