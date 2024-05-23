//
//  WBFaceVerifySDKConfig.h
//  Pods
//
//  Created by pp on 2017/8/2.
//
//

#import <Foundation/Foundation.h>
#import "WBFaceVerifyConst.h"
NS_ASSUME_NONNULL_BEGIN

/**
 人脸识别SDK 基础配置类
 */
@interface WBFaceVerifySDKConfig : NSObject

/// 是否使用非标模式, 默认为NO（具体含义请咨询技术支持）
/// - IMPORTANT: 一般不需要开启, 开启前请咨询技术支持
/// - IMPORTANT: 使用原WBCloudFaceVerifySimpleSDK升级过来的，务必打开此项
@property (nonatomic, assign) BOOL useSimpleMode;

#pragma mark - common
/**
 sdk中拉起人脸活体识别界面中使用UIWindow时的windowLevel配置,默认配置是1 + UIWindowLevelNormal

 如果接入放app中有其他自定义UIWindow, 为了防止界面覆盖,可以酌情设置该参数
 */
@property (nonatomic, assign) NSUInteger windowLevel;

/**
 人脸识别服务结果页是否展示配置项 - 是否展示人脸对比成功界面 -> 建议关闭

 default: NO
 */
@property (nonatomic, assign) BOOL showSuccessPage DEPRECATED_MSG_ATTRIBUTE("SDK 已移除结果页, 若有需要可参考 Demo 实现");

/**
 人脸识别服务结果页是否展示配置项 - 是否展示人脸对比失败界面 -> 建议关闭

 default: NO
 */
@property (nonatomic, assign) BOOL showFailurePage DEPRECATED_MSG_ATTRIBUTE("SDK 已移除结果页, 若有需要可参考 Demo 实现");

/**
 人脸识别服务是否进行通过录像, 从而进行视频存证

 default: NO
 */
@property (nonatomic, assign) BOOL recordVideo;

/**
 人脸识别服务是否强制校验视频，当视频为空时报错
 可能会出现在部分性能差的机型

 default: NO
 */
@property (nonatomic, assign) BOOL checkVideo;

/**
 是否由SDK内部处理sdk网络请求的cookie

 默认值: YES
 */
@property (nonatomic, assign) BOOL manualCookie;

/**
 多语言配置
 默认中文，当使用其他语言时，强制静音
 */
@property (nonatomic, assign) WBFaceVerifyLanguage language;
/**
 人脸识别页面中的主题风格, 需要配合不同资源包使用:
 WBFaceVerifyThemeDarkness - 暗灰主题
 WBFaceVerifyThemeLightness - 明亮主题
 - 当前意愿性表达只支持明亮主题, 若使用了意愿性表达功能则强制设定为明亮主题
 */
@property (nonatomic, assign) WBFaceVerifyTheme theme;

/**
 是否静音
 默认值：YES
 */
@property (nonatomic, assign) BOOL mute;

/**
 刷脸服务走iPv6协议栈
 默认：YES
 */
@property (nonatomic, assign) BOOL isIpv6;

/**
 是否海外用户
 默认：NO
 */
@property (nonatomic, assign) BOOL isAbroad;

/**
 是否打开日志上报
 1打开 0关闭 -1由SDK内部决定
 默认：-1
 */
@property (nonatomic, assign) NSInteger enableTrackLog DEPRECATED_ATTRIBUTE;
/*
 送入自定义提示文案的位置
 默认：WBFaceCustomTipsLoc_Bottom
 */
@property (nonatomic, assign) WBFaceCustomTipsLoc tipsLoc;

/*
 检测过程中展示的文案
 默认为空
 */
@property (nonatomic, copy) NSString *customTipsInDetect;

/*
 上传过程中展示的文案
 默认为空
 */
@property (nonatomic, copy) NSString *customTipsInUpload;

/*
 底部提示文案，长度不超过70字
 */
@property (nonatomic, copy) NSString *bottomCustomTips;

/*
 退出二次确认UI配置
 */
@property (nonatomic, copy) NSString *exitAlertTitle; //标题
@property (nonatomic, copy) NSString *exitAlertMessage; //内容
@property (nonatomic, copy) NSString *exitAlertYES; //确认按钮
@property (nonatomic, copy) NSString *exitAlertNO; //取消按钮

/*
 如果有使用苹果分屏模式（UIWindowScene），打开此开关
 Xcode11新建工程有使用Scene，可以参考资料自行调整
 默认为NO
 */
@property (nonatomic, assign) BOOL useWindowSecene;

/// 使用 hostVC 以实现基于 Modal 的 transition, **一般不需要配置, 仅建议 native 开发者使用**
/// - IMPORTANT: **一般不需要配置, 仅建议 native 开发者使用**
@property (nonatomic, weak, nullable) UIViewController *hostVC;

/**
 TencentCloudHuiyanSDKFace.bundle 的目录路径，不包含bundle本身（仅当需要自己下发资源时配置，本地资源无需配置）
 ！！！重要：此目录下必须包含TencentCloudHuiyanSDKFace.bundle 文件，否则无法拉起SDK
 */
@property (nonatomic, copy) NSString *bundlePath;

/**
 face-tracker-v001.bundle 的目录路径
 
 ！！！重要：若有值，此目录下必须包含 face-tracker-v001.bundle 文件，否则无法拉起SDK
 */
@property (nonatomic, copy, nullable) NSString *faceTrackerBundleDirPath;

/**
 face-tracker-v001.bundle 是否经过重新打包, 默认值为 NO, **一般不需要配置**
 */
@property (nonatomic) BOOL faceTrackerBundleRepackaged;

/**
 是否采用增强比对服务，仅增强接口生效，仅活体服务设置为NO
 默认为 NO
 */
@property (nonatomic, assign) BOOL useAdvanceCompare;

/**
 APP是否只允许横屏，非强制横屏的不用设置，否则可能会出现旋转问题
 @default NO
 */
@property (nonatomic, assign) BOOL forceOrientation;

#pragma mark - simple //非标特有字段，标准模式无需设置
/**
 是否返回录制的视频
 
 default: NO
 */
@property (nonatomic, assign) BOOL returnVideo;

/**
 返回视频加密的公钥，如果不配置则不加密
 
 需要recordVideo returnVideo同时为YES，才返回加密的视频内容
 */
@property (nonatomic, copy) NSString *publicKey;

/**
 AES加密需要用到的IV
 */
@property (nonatomic, copy) NSString *aesIV;

#pragma mark - will //意愿性特有字段，标准模式无需设置
@property (nonatomic, assign) BOOL recordWillVideo;

@property (nonatomic, assign) BOOL checkWillVideo;

/// 播报音量，值范围（0.1,1]
@property (nonatomic, assign) float willVolume;

/// 当录制意愿视频时，是否同时返回sdk+服务端视频
@property (nonatomic, assign) BOOL uploadAndReturnWillVideo;
/// 是否允许意愿阶段使用有线耳机, 默认不允许
@property (nonatomic, assign) BOOL allowWillHeadset;
#pragma mark -
/**
 默认sdk配置
 */
+(instancetype)sdkConfig;

@end
NS_ASSUME_NONNULL_END
