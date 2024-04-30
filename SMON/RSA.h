//
//  RSA.h
//  SHUMEIApp
//
//  Created by mac on 2023/4/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RSA : NSObject

//使用'.der'公钥文件加密
+ (NSString *)encryptString:(NSString *)str publicKeyWithContentsOfFile:(NSString *)path;

//使用'.12'私钥文件解密
+ (NSString *)decryptString:(NSString *)str privateKeyWithContentsOfFile:(NSString *)path password:(NSString *)password;


//使用公钥字符串加密
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;

//使用私钥字符串解密
//+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;
+ (NSDictionary *)decryptString:(NSString *)str privateKey:(NSString *)privKey;


@end

NS_ASSUME_NONNULL_END
