//
//  CCCacheObject.h
//  QQTravel
//
//  Created by Cole on 15/10/22.
//  Copyright © 2015年 Cole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCCache.h"

@interface CCCacheObject : NSObject <NSCoding>

/** 数据String */
@property (nonatomic, copy, readonly) NSString *cacheString;
/** 数据对象 */
@property (nonatomic, strong, readonly) id cacheObject;
/** 数据的存储时效性 */
@property (nonatomic, assign, readonly) FileStorageObjectTimeOutInterval cacheInterval;

/** 当前对象的标识符（KEY），默认会自动生成，可自定义*/
@property (nonatomic, copy) NSString *objectIdentifier;

/** 存储文件的过期时间 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/** 根据（String,URL,Data,Number,Dictionary,Array,Null,实体）初始化对象 */
- (instancetype)initWithObject:(id)object;

@end
