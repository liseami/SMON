//
//  YtSDKKitFrameworkTool.h
//  YtSDKKitFrameworkTool
//
//  Created by sunnydu on 2022/10/12.
//  Copyright © 2022 Tecnet.Youtu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface YtSDKTool : NSObject
#define T_FRAMEWORK_VERSION "1.1.15.82.1"
/**
 获取YtSDKKitFrameworkTool*/
+(NSString*) getFrameworkVersion;

/**
    慧眼版本
 */
+(void) setHuiYanVersion:(NSString*)huiyanVersion;
/**
  远程下发模型场景，对算法模型做MD5校验
 */
+(int) md5ValidityByDir:(NSString*) path;

/**
 开启bugly
 */
+(void) openBuglyShared;

typedef enum {
    //验证完成。
       VALIDITY_OK=11000,
       //模型文件夹目录为空 或者找不到路径
       NOT_FOUND_MODEL_DIR=11001,
       //找不到md5效验文件
       NOT_FOUND_MODEL_MD5=11002,
       //读取md5文件异常
       READ_MD5_ERROR=11003,
       //效验失败
       VALIDITY_ERROR=11004,
       //目标MD5值没有找到
       TARGET_MD5_NOT_FOUND=11005,
       //生成md5 失败
       CREATE_MD5_ERROR=11006,
       //模型文件存在个别缺失
       MODEL_FILE_MISS=11007
}ModelValidityCode;

@end
NS_ASSUME_NONNULL_END
