/*---------------------------------------------------------------------
 文件名称 : CCCache
 创建作者 : Cole
 创建时间 : 2015-10-03
 文件描述 : 缓存管理，线程安全，放心使用
 ---------------------------------------------------------------------*/
#import <Foundation/Foundation.h>

/** 缓存实效类型 */
typedef NS_ENUM(NSUInteger, FileStorageObjectTimeOutInterval) {
    FileStorageObjectIntervalDefault,       //默认永久
    FileStorageObjectIntervalTiming         //定时
};

typedef NS_ENUM(NSUInteger, FileStorageType) {
    FileStorageMemory,          //内存
    FileStorageDisk             //磁盘
};

#pragma mark - CacheManager
@interface CCCache : NSObject

/** 默认缓存管理器 */
+ (CCCache *)defaultManager;


#pragma mark Set

/**
 *  根据Key缓存对象，默认存储在磁盘中,如只需在内存则调用setTempObject
 *
 *  @param aObject 存储对象，支持String,URL,Data,Number,Dictionary,Array,Null,自定义实体类
 *  @param aKey    唯一key，相同的key覆盖原来的对象
 *
 *  <!注1  如果aobject为nil，程序不会crash，如果该key对应的对象有值，则置为nil>
 *  <!注2  如果永久和定时两种类型存在相同的key，获取的时候优先会得到永久那个，所以key的定义尽量不同，建议加前缀>
 */
- (void)setObject:(id)aObject forKey:(NSString *)aKey;

/**
 *  存储在内存，本次程序有效
 *
 */
- (void)setTempObject:(id)aObject forKey:(NSString *)aKey;

/**
 *  缓存的存在时间，duration默认为0
 *
 *  @param duration 存储时间，单位:秒
 */
- (void)setObject:(id)aObject forKey:(NSString *)aKey duration:(NSTimeInterval)duration;


#pragma  mark Get
/** 根据Key获取对象(数据相同内存值不同),会优先查找内存，再找磁盘 */
- (id)objectForKey:(NSString *)aKey;


#pragma mark Remove
/** 根据Key移除缓存对象 */
- (void)removeObjectForKey:(NSString *)aKey;

#pragma mark Clean
/** 异步移除所有duration为0的缓存 folderSize单位是字节，转换M需要folderSize/(1024.0*1024.0) */
- (void)cleanObjectsWithCompletionBlock:(void (^)(long long folderSize))completionBlock;

/** 异步检查缓存(duration大于0)的生命，删除过期缓存，建议App启动使用 */
- (void)cleanExpireObjects;

@end

