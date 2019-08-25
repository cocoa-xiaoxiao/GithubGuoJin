//
//  CCCacheObject.m
//  QQTravel
//
//  Created by Cole on 15/10/22.
//  Copyright © 2015年 Cole. All rights reserved.
//

#import "CCCacheObject.h"
#import "CCJSONParse.h"
#import "CCEncrypt.h"

@interface CCCacheObject ()

@property (nonatomic, copy, readwrite) NSString *cacheString;

@end

@implementation CCCacheObject

- (instancetype)initWithObject:(id)object {
    if (self = [self init]) {
        NSDictionary *dictionary = [self dictionaryWithObject:object];
        NSData *JSONData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSString *JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
        
        self.cacheString = [JSONString aesEncryptAndBase64Encode];
    }
    return self;
}

- (id)cacheObject {
    //AES解密
    NSString *objectString = [self.cacheString aesDecryptAndBase64Decode];
    
    NSData *JSONData = [objectString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    return [self storageObjectWithDictionary:dictionary];
}

- (id)storageObjectWithDictionary:(NSDictionary *)dictionary {
    __block id returnObject = nil;
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *className, id obj, BOOL *stop) {
        Class cls = NSClassFromString(className);
        if ([cls isSubclassOfClass:[NSString class]]) {
            returnObject = [NSMutableString stringWithString:obj];
        }
        else if ([cls isSubclassOfClass:[NSURL class]]) {
            returnObject = [NSURL URLWithString:obj];
        }
        else if ([cls isSubclassOfClass:[NSNumber class]]) {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            returnObject = [numberFormatter numberFromString:obj];
        }
        else if ([cls isSubclassOfClass:[NSData class]]) {
            returnObject = [obj dataUsingEncoding:NSUTF8StringEncoding];
        }
        else if ([cls isSubclassOfClass:[NSDictionary class]]) {
            __block NSMutableDictionary *mutDictionary = [NSMutableDictionary dictionary];
            [((NSDictionary *)obj) enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                id tmpObject = [self storageObjectWithDictionary:obj];
                if (tmpObject) [mutDictionary setObject:tmpObject forKey:key];
            }];
            returnObject = [NSMutableDictionary dictionaryWithDictionary:mutDictionary];
        }
        else if ([cls isSubclassOfClass:[NSArray class]]) {
            __block NSMutableArray *mutArray = [NSMutableArray array];
            [((NSArray *)obj) enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                id tmpObject = [self storageObjectWithDictionary:obj];
                if (tmpObject) [mutArray addObject:tmpObject];
            }];
            returnObject = [NSMutableArray arrayWithArray:mutArray];
        }
        else if ([cls isSubclassOfClass:[NSNull class]]) {
            returnObject = [NSNull null];
        }
        else if ([cls isSubclassOfClass:[NSObject class]]) {
            NSData *JSONData = [obj dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
            returnObject = [cls objectWithDictionary:dictionary];
        }
        else {
            //TODO:更多的类型
        }
    }];
    return returnObject;
}

- (NSDictionary *)dictionaryWithObject:(id)object {
    //把object转成字符串dictionary，保存方便
    NSString *objectKey = NSStringFromClass([object class]);
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if ([object isKindOfClass:[NSString class]]) {
        [dictionary setValue:object forKey:objectKey];
    }
    else if ([object isKindOfClass:[NSURL class]]) {
        [dictionary setValue:((NSURL *)object).absoluteString forKey:objectKey];
    }
    else if ([object isKindOfClass:[NSNumber class]]) {
        [dictionary setValue:((NSNumber *)object).stringValue forKey:objectKey];
    }
    else if ([object isKindOfClass:[NSData class]]) {
        NSString *dataString = [[NSString alloc] initWithData:object encoding:NSUTF8StringEncoding];
        [dictionary setValue:dataString forKey:objectKey];
    }
    else if ([object isKindOfClass:[NSDictionary class]]) {
        __block NSMutableDictionary *objectDictionary = [NSMutableDictionary dictionary];
        [((NSDictionary *)object) enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSDictionary *objDictionary = [self dictionaryWithObject:obj];
            [objectDictionary setValue:objDictionary forKey:key];
        }];
        [dictionary setValue:objectDictionary forKey:objectKey];
    }
    else if ([object isKindOfClass:[NSArray class]]) {
        __block NSMutableArray *objectArray = [NSMutableArray array];
        [((NSArray *)object) enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *objDictionary = [self dictionaryWithObject:obj];
            [objectArray addObject:objDictionary];
        }];
        [dictionary setValue:objectArray forKey:objectKey];
    }
    else if ([object isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[NSNull null] forKey:objectKey];
    }
    else if ([object isKindOfClass:[NSObject class]]) {
        NSDictionary *dict = [object propertyDictionary];
        NSData *JSONData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *objectString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
        [dictionary setValue:objectString forKey:objectKey];
    }
    else {
        //TODO:更多的类型
    }
    return dictionary;
}

#pragma mark -

- (NSString *)objectIdentifier {
    return _objectIdentifier ?: ({ _objectIdentifier = [self.cacheString md5]; });
}

- (FileStorageObjectTimeOutInterval)cacheInterval{
    if (self.timeoutInterval > 0) {
        return FileStorageObjectIntervalTiming;
    }
    return FileStorageObjectIntervalDefault;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.cacheString forKey:@"storageString"];
    [aCoder encodeObject:self.objectIdentifier forKey:@"objectIdentifier"];
    [aCoder encodeObject:@(self.timeoutInterval) forKey:@"timeoutInterval"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        self.cacheString = [aDecoder decodeObjectForKey:@"storageString"];
        self.objectIdentifier = [aDecoder decodeObjectForKey:@"objectIdentifier"];
        self.timeoutInterval = (NSTimeInterval)[[aDecoder decodeObjectForKey:@"timeoutInterval"] doubleValue];
    }
    return self;
}

@end
