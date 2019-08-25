//
//  NSString+Encrypt.m
//  CCNetwork
//
//  Created by Cole on 15/10/2.
//  Copyright © 2015年 Cole. All rights reserved.
//

#import "CCEncrypt.h"
#import "CommonCrypto/CommonDigest.h"
#import <CommonCrypto/CommonCryptor.h>

/** 加密Key */
static NSString *AESKey = @"CCCache.cole";
/** 加密向量 */
static const unsigned char AES_IV[] =
{ 0x6D, 0x4A, 0x11, 0x3B, 0x53, 0x85, 0x1E, 0x9A, 0x33, 0x53, 0x07, 0x74, 0x2B, 0x8F, 0x98, 0x58 };

@implementation NSString (Encrypt)

- (NSString *)md5 {
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}

- (NSString *)aesEncryptAndBase64Encode {
    return [NSString mfs_aesEncryptAndBase64Encode:self withKey:AESKey];
}

- (NSString *)aesDecryptAndBase64Decode {
    return [NSString mfs_aesDecryptAndBase64Decode:self withKey:AESKey];
}

+ (NSString *)mfs_aesEncryptAndBase64Encode:(NSString *)string withKey:(NSString *)key {
    if (!string.length || !key.length) return nil;
    
    NSString *secret = nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *iv = [NSData dataWithBytes:AES_IV length:sizeof(AES_IV)];
    NSData *encrypt = [data AES128EncryptWithKey:key initVector:iv];
    if (encrypt) secret = [encrypt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return [secret stringByReplacingOccurrencesOfString:@"\\" withString:@""];//斜杠曾引起过问题
}

+ (NSString *)mfs_aesDecryptAndBase64Decode:(NSString *)string withKey:(NSString *)key {
    if (!string.length || !key.length) return nil;
    
    NSString *secret = nil;
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *iv = [NSData dataWithBytes:AES_IV length:sizeof(AES_IV)];
    NSData *decrypt = [data AES128DecryptWithKey:key initVector:iv];
    if (decrypt) secret = [[NSString alloc] initWithData:decrypt encoding:NSUTF8StringEncoding];
    return secret;
}

@end

@implementation NSData (AES)

- (NSData*)AES128EncryptWithKey:(NSString*)key initVector:(NSData*)iv
{
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES128 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesEncrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128,
                                          [iv bytes] /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

- (NSData*)AES128DecryptWithKey:(NSString*)key initVector:(NSData*)iv
{
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES128 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesDecrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128,
                                          [iv bytes] /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

@end
