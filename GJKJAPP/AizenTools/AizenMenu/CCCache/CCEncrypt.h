/*---------------------------------------------------------------------
 文件名称 : CCEncrypt
 创建作者 : Cole
 创建时间 : 2015-10-04
 文件描述 : 加密类，支持md5，AES128，base64加解密
 ---------------------------------------------------------------------*/

#import <Foundation/Foundation.h>

@interface NSString (Encrypt)

/** MD5 */
- (NSString *)md5;

/** aes128加密后转换base64，使用默认Key&默认Iv */
- (NSString *)aesEncryptAndBase64Encode;
/** 转换base64并解密aes128，使用默认Key&默认Iv */
- (NSString *)aesDecryptAndBase64Decode;

@end

@interface NSData (AES)
/**
 *  根据内部定义的key和向量加密AES
 *
 *  @param key 自定义key
 *  @param iv  自定义向量
 */
- (NSData*)AES128EncryptWithKey:(NSString*)key initVector:(NSData*)iv;

/**
 *  根据内部定义的key和向量解密AES
 *
 *  @param key 自定义key
 *  @param iv  自定义向量
 */
- (NSData*)AES128DecryptWithKey:(NSString*)key initVector:(NSData*)iv;

@end
