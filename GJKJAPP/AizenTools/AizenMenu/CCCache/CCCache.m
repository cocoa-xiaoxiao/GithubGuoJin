//
//  CCCache.m
//  CCNetwork
//
//  Created by Cole on 15/10/2.
//  Copyright © 2015年 Cole. All rights reserved.
//

#import "CCCache.h"
#import "CCJSONParse.h"
#import "CCEncrypt.h"
#import "CCCacheObject.h"

@interface CCCache ()
//磁盘储存
@property (nonatomic, strong) NSCache *cacheDisk;
//文件名
@property (nonatomic, strong) NSArray *finderNames;

@end

@implementation CCCache

+ (CCCache *)defaultManager {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ instance = self.new; });
    return instance;
}

- (NSCache *)cacheDisk{
    return _cacheDisk ?: ({ _cacheDisk = NSCache.new; });
}


- (void)setObject:(id)aObject forKey:(NSString *)aKey {
    [self setObject:aObject forKey:aKey duration:0];
}

- (void)setTempObject:(id)aObject forKey:(NSString *)aKey{
    [self setObject:aObject forKey:aKey duration:0 type:FileStorageMemory];
}

- (void)setObject:(id)aObject forKey:(NSString *)aKey duration:(NSTimeInterval)duration {
   [self setObject:aObject forKey:aKey duration:duration type:FileStorageDisk];
}

- (void)setObject:(id)aObject forKey:(NSString *)aKey duration:(NSTimeInterval)duration type:(FileStorageType)type{
    if (!aKey) return;
    if (!aObject) {[self removeObjectForKey:aKey];return;}
    
    CCCacheObject *object = [[CCCacheObject alloc] initWithObject:aObject];
    object.timeoutInterval = duration;
    if (object.cacheString){
        [self.cacheDisk setObject:object forKey:aKey];
        object.objectIdentifier = aKey;
        //        //归档序列化
        type == FileStorageMemory?:[self archiveObject:object];
    }
}



- (id)objectForKey:(NSString *)aKey{
    if (!aKey) return nil;
    CCCacheObject *object = [self.cacheDisk objectForKey:aKey];
    if (!object) {
        NSString *filePath = [self filePathWithKey:aKey];
        if (filePath) {
            // 反序列化，会检查定时的缓存对象，若过期则返回nil
            object = [self unarchiveObjectWithPath:filePath];
        }
    }
    return [object cacheObject];

}

- (void)removeObjectForKey:(NSString *)aKey{
    if (!aKey) return;
    [self.cacheDisk removeObjectForKey:aKey];
    NSArray *array = [self.finderNames copy];
    [array enumerateObjectsUsingBlock:^(NSString *finderName, NSUInteger idx, BOOL *stop) {
        NSString *filePath = [self filePathWithFileName:aKey finderName:finderName];
        if (filePath) [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }];
}


- (void)cleanObjectsWithCompletionBlock:(void (^)(long long folderSize))completionBlock{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [self cachePathWithFinderName:self.finderNames[FileStorageObjectIntervalDefault]];
        __block long long folderSize = 0;
        [CCCache enumerateFilesWithPath:path usingBlock:^(NSString *fileName) {
            NSString *filePath = [path stringByAppendingPathComponent:fileName];
            BOOL isDir;
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir] && !isDir) {
                long long size = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
                folderSize += size;
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            }
        }];
        if (completionBlock) completionBlock(folderSize);
    });

}

- (void)cleanExpireObjects{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [self cachePathWithFinderName:self.finderNames[FileStorageObjectIntervalTiming]];
        [CCCache enumerateFilesWithPath:path usingBlock:^(NSString *fileName) {
            NSString *filePath = [path stringByAppendingPathComponent:fileName];
            BOOL isDir;
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir] && !isDir) {
                [self unarchiveObjectWithPath:filePath];
            }
        }];
    });
}


#pragma mark - archive/unarchive
- (void)archiveObject:(CCCacheObject *)object {
    @synchronized(self) {
        NSString *filePath = [self filePathWithObject:object];
        [NSKeyedArchiver archiveRootObject:object toFile:filePath];
    }
}
- (CCCacheObject *)unarchiveObjectWithPath:(NSString *)path {
    if ([path hasSuffix:@".DS_Store"]) return nil;
    CCCacheObject *object = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    switch (object.cacheInterval) {
        case FileStorageObjectIntervalTiming: {
            //验证对象生命情况
            NSDictionary *arrtibutes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
            if (arrtibutes) {
                NSDate *createDate = arrtibutes[NSFileCreationDate];
                if (createDate) {
                    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:createDate];
                    BOOL valid = interval < object.timeoutInterval;
                    if (valid) return object;
                }
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                });
            }
        }
            break;
        case FileStorageObjectIntervalDefault:
            return object;
            break;
    }
    return nil;
}

#pragma mark - 文件名操作
- (NSArray *)finderNames {
    if (!_finderNames) {
        _finderNames = @[[@"storage0" md5], [@"storage1" md5]];
    }
    return _finderNames;
}
- (NSString *)filePathWithObject:(CCCacheObject *)object {
    NSString *finderName = self.finderNames[object.cacheInterval];
    return [self filePathWithFileName:object.objectIdentifier finderName:finderName];
}
- (NSString *)filePathWithKey:(NSString *)aKey {
    __block NSString *objectPath = nil;
    NSArray *array = [self.finderNames copy];
    [array enumerateObjectsUsingBlock:^(NSString *finderName, NSUInteger idx, BOOL *stop) {
        NSString *filePath = [self filePathWithFileName:aKey finderName:finderName];
        BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        if (exist) {
            objectPath = filePath;
            *stop = exist;
        }
    }];
    return objectPath;
}

#pragma mark - 目录操作
- (NSString *)filePathWithFileName:(NSString *)name finderName:(NSString *)finderName {
    if ([name length] <= 0) return nil;
    NSString *finderPath = [self cachePathWithFinderName:finderName];
    NSString *filePath = [NSString stringWithFormat:@"%@%@", finderPath, [name md5]];
    return filePath;
}
/** 根据目录名称获取缓存路径 */
- (NSString *)cachePathWithFinderName:(NSString *)finderName {
    static NSString *cacheDirectory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        cacheDirectory = [paths firstObject];
        cacheDirectory = [cacheDirectory stringByAppendingString:@"/"];
    });
    
    NSString *fileDirectory = [NSString stringWithFormat:@"%@%@/", cacheDirectory, [@"storagefile" md5]];
    if (finderName.length > 0) {
        fileDirectory = [NSString stringWithFormat:@"%@%@/", fileDirectory, finderName];
    }

    if(fileDirectory && [[NSFileManager defaultManager] fileExistsAtPath:fileDirectory] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return fileDirectory;
}

/** 遍历路径的目录，返回所有的文件名 */
+ (void)enumerateFilesWithPath:(NSString *)path usingBlock:(void (^)(NSString *fileName))block {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) return;
    NSEnumerator *filesEnumerator = [[manager subpathsAtPath:path] objectEnumerator];
    NSString *fileName;
    while ((fileName = [filesEnumerator nextObject]) != nil) {
        block(fileName);
    }
}


@end

