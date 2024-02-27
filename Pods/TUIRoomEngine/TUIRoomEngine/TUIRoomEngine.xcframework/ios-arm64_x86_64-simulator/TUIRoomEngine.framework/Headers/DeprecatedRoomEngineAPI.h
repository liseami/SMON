/**
 * Copyright (c) 2022 Tencent. All rights reserved.
 */
#import "TUIRoomEngine.h"

@class TRTCCloud;
@class TXDeviceManager;
@class TXAudioEffectManager;
@class TXBeautyManager;

NS_ASSUME_NONNULL_BEGIN
@interface TUIRoomEngine (deprecated)

/////////////////////////////////////////////////////////////////////////////////
//
//                    弃用接口（建议使用对应的新接口）
//
/////////////////////////////////////////////////////////////////////////////////

/**
 * 开始推送本地音频
 *
 * @deprecated v1.5.0 版本开始不推荐使用,建议使用{@link unmuteLocalAudio}代替。
 */
- (void)startPushLocalAudio NS_SWIFT_NAME(startPushLocalAudio())__attribute__((deprecated("use muteLocalAudio instead")));

/**
 * 停止推送本地音频
 *
 * @deprecated v1.5.0 版本开始不推荐使用,建议使用{@link muteLocalAudio}代替。
 */
- (void)stopPushLocalAudio NS_SWIFT_NAME(stopPushLocalAudio())__attribute__((deprecated("use muteLocalAudio instead")));

/**
 * 获得TRTC实例对象
 *
 * @deprecated v1.5.0 版本开始不推荐使用
 */
- (TRTCCloud *)getTRTCCloud NS_SWIFT_NAME(getTRTCCloud())__attribute__((deprecated("Deprecated from v1.5.0")));
;

/**
 * 获得设备管理对象
 *
 * @deprecated v1.5.0 版本开始不推荐使用
 */
- (TXDeviceManager *)getDeviceManager NS_SWIFT_NAME(getDeviceManager())__attribute__((deprecated("Deprecated from v1.5.0")));
;

/**
 * 获得音效管理对象
 *
 * @deprecated v1.5.0 版本开始不推荐使用
 */
- (TXAudioEffectManager *)getAudioEffectManager NS_SWIFT_NAME(getAudioEffectManager())__attribute__((deprecated("Deprecated from v1.5.0")));
;

/**
 * 获得美颜管理对象
 *
 * @deprecated v1.5.0 版本开始不推荐使用
 */
- (TXBeautyManager *)getBeautyManager NS_SWIFT_NAME(getBeautyManager())__attribute__((deprecated("Deprecated from v1.5.0")));
;

/**
 * 设置本地用户视频渲染的视图控件
 *
 * @deprecated v1.6.1 版本开始不推荐使用
 */
- (void)setLocalVideoView:(TUIVideoStreamType)streamType view:(TUIVideoView *__nullable)view NS_SWIFT_NAME(setLocalVideoView(streamType:view:))__attribute__((deprecated("Deprecated from v1.6.1")));
;

NS_ASSUME_NONNULL_END
@end
