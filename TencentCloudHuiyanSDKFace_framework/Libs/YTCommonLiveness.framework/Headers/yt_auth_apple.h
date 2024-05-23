#import <Foundation/Foundation.h>

 __attribute__((visibility("default"))) @interface YTLivenessAuthManager : NSObject

+ (int)initAuthByFilePath:(NSString*) license_path withSecretKey:(NSString*) secret_key;

+ (int)initAuthByString:(NSString*) license_string withSecretKey:(NSString*) secret_key;

+ (int)initAuthForQQ;

+ (NSString*)getVersion;

+ (int64_t)getEndTime;

+ (NSArray*)getSDKList;

+ (NSString*)getSDKNameByID:(int)sdk_id;

+ (void)setEnableLog:(int)enable;

@end
