//
//  HTTPOpration.m
//  GJKJAPP
//
//  Created by git burning on 2018/9/13.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "HTTPOpration.h"

@implementation HTTPOpration
+(instancetype)sharedHTTPOpration
{
    static HTTPOpration * manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager=[[HTTPOpration alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/",kCacheHttpRoot]]];
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        //        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        manager.requestSerializer.timeoutInterval=60;
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [securityPolicy setValidatesDomainName:NO];
        [securityPolicy setAllowInvalidCertificates:YES];
        manager.securityPolicy = securityPolicy;
        //manager.operationQueue.maxConcurrentOperationCount = 10;
        //                [[HTTPOpration sharedHTTPOpration].requestSerializer setValue:infoModel.token ? :@" " forHTTPHeaderField:@"X-Auth-Token"];
        NSString *versionShort = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        NSString *version = [NSString stringWithFormat:@"%@",versionShort];
        [manager.requestSerializer setValue:version forHTTPHeaderField:@"publicDeviceVersion"];
        [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"publicDeviceType"];
//        NSString *OpenUDID1 = [OpenUDID value];
//        if (OpenUDID1.length == 0) {
//            OpenUDID1 = @"mmmmm";
//        }
//        NSString *sign = [LDUserDefaultHelp yy_getUserSign];//[BRUserHelp shareUserHelp].userModel.sign;//[LDUserDefaultHelp yy_getUserSign];
//        NSString *token = [LDUserDefaultHelp yy_getUserToken];;
//        if (sign) {
//            [manager.requestSerializer setValue:sign forHTTPHeaderField:@"sign"];
//
//        }
//        if (token) {
//            [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
//        }
//        [manager.requestSerializer setValue:OpenUDID1 forHTTPHeaderField:@"publicdeviceid"];
//        [manager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request) {
//            return  nil;
//        }];
        
    });
    return manager;
}
-(NSURLSessionDataTask *)NetRequestGETWithRequestURL:(NSString *)requestURLString WithParameter:(NSDictionary *)parameter  WithReturnValeuBlock:(ReturnValueBlock)block WithFailureBlock:(FailureBlock)failureBlock
{
    __weak HTTPOpration * weakSelf=self;
    NSMutableDictionary *temp = (id)parameter;
    if (![parameter isKindOfClass:[NSMutableDictionary class]]) {
        temp = [NSMutableDictionary dictionaryWithDictionary:parameter];
    }
        
   
    NSLog(@"提交的参数:%@--url:%@",temp,requestURLString);
    
    __block NSString *url = requestURLString ;
    
    
    NSURLSessionDataTask *opp = [self GET:url parameters:temp success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
       
        HTTPData * object=[weakSelf dataFormatWithObject:responseObject withViewModel:nil];
        
        if (object.code == 0) {
            block(object);
            
        }else{
            failureBlock(object.msg);
            
        }
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            responseObject = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        }
        NSString * dataString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"responseObject 参数%@",dataString);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error.localizedDescription);
            
        }
       
    }];
    
    
    return opp;
    
}


-(NSURLSessionDataTask *)NetRequestPOSTFileWithRequestURL:(NSString *)requestURLString WithParameter:(NSDictionary *)parameter WithFiles:(NSDictionary *)files WithReturnValeuBlock:(ReturnValueBlock)block WithFailureBlock:(FailureBlock)failureBlock
{
    
    if ([requestURLString rangeOfString:@"http"].location == NSNotFound || [requestURLString rangeOfString:@"https"].location == NSNotFound) {
        requestURLString = [NSString stringWithFormat:@"%@/%@",kCacheHttpRoot,requestURLString];
    }
    if (files.allKeys.count <= 0) {
        
//        return [self NetRequestPOSTWithRequestURL:requestURLString WithParameter:parameter viewModel:viewModel WithReturnValeuBlock:^(HTTPData *data) {
//            block(data);
//
//        } WithFailureBlock:^(id error) {
//            failureBlock(error);
//        }];
        return nil;
    }
    else
    {
        
//        kUploadFileType fileType = viewModel.fileType;
//        NSString *fileLastName = viewModel.fileLastName;
//        if (fileLastName.length == 0) {
//            fileLastName = @".mp3";
//        }
//        else{
//            if ([fileLastName componentsSeparatedByString:@"."].count < 2) {
//                fileLastName = [NSString stringWithFormat:@".%@",fileLastName];
//            }
//        }
        NSMutableDictionary *temp = (id)parameter;
        if (![parameter isKindOfClass:[NSMutableDictionary class]]) {
            temp = [NSMutableDictionary dictionaryWithDictionary:parameter];
        }
       // [temp addEntriesFromDictionary:[self getPublicPamar]];
        //        if (viewModel.paramRootKey.length > 0) {
        //            temp = (id)@{viewModel.paramRootKey:temp};
        //        }
        __weak HTTPOpration * weakSelf=self;
        
        NSURLSessionDataTask *op = [self POST:requestURLString parameters:temp constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [files enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {

                [formData appendPartWithFileData:obj name:key fileName:[key stringByAppendingString:@".png"] mimeType:@"image/png"];
                
                
            }];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            
            
            id object=[weakSelf dataFormatWithObject:responseObject withViewModel:nil];
            block(object);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock(error.localizedDescription);
//            if (viewModel.getHttpEndBlock) {
//                viewModel.getHttpEndBlock(nil);
//            }
        }];
        
        return op;
        
    }
}

-(HTTPData*)dataFormatWithObject:(id)dict withViewModel:(id )viewModel
{
   
    HTTPData *data = [[HTTPData alloc] init];
    NSDictionary *newDict = dict;
    
    if ([dict isKindOfClass:[NSDictionary class]]) {
        
        newDict = dict;
        
    }
    else if ([dict isKindOfClass:[NSData class]])
    {
        
        NSString *responseString = [[NSString alloc] initWithData:dict encoding:NSUTF8StringEncoding];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        dict = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"返回数据字符串 %@",responseString);
        NSError *errot ;
        NSDictionary *newDict1 = [NSJSONSerialization JSONObjectWithData:dict options:NSJSONReadingMutableContainers error:&errot];
        newDict = newDict1;
        //retcode
        //msg
        //data
        
    }
    
    
    
    data.beforeData = newDict;
    /*!
     *  @brief 
     {"ResultType":0,"Message":"上传成功！","LogMessage":null,"AppendData":"/Upload/Internship/2018/09/13003042387171.png"}
     */
    if ([newDict isKindOfClass:[NSDictionary class]]) {
        
        NSInteger status = [newDict[@"ResultType"] integerValue];
        NSString *msg = @"获取失败";
//        NSString *rootKey = @"data";
        //        if (viewModel.paramRootKey.length > 0) {
        //            rootKey = viewModel.paramRootKey;
        //        }
        id returnData1 = newDict;
        data.code = status;
        
        //        data.returnData = returnData1;
        
        NSString *message = newDict[@"Message"];//文字说明
        if ([message isKindOfClass:[NSString class]]) {
            msg = message;
        }
        data.msg = msg;
        
        if (status == 0) {
           
            data.returnData = returnData1;
            
        }
        
        
    }else{
        data.msg = @"数据异常";
    }
    
    
    return data;
}

@end

@implementation HTTPData
@end


