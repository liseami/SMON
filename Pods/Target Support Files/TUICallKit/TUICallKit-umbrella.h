#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "TUICallEngineHeader.h"
#import "TUICallKit.h"
#import "CallingLocalized.h"
#import "TUIAudioMessageRecordService.h"
#import "TUICallingExtensionObserver.h"
#import "TUICallingObjectFactory.h"
#import "TUICallingService.h"
#import "TUICallKitOfflinePushInfoConfig.h"
#import "TUICallKitConstants.h"
#import "TUICallingCommon.h"
#import "TUICallingGradientView.h"
#import "TUICallKitGCDTimer.h"
#import "UIButton+TUICalling.h"
#import "UIColor+TUICallingHex.h"
#import "UIImage+TUICallKitRTL.h"
#import "UIWindow+TUICalling.h"
#import "TUICallKitGroupMemberInfo.h"
#import "TUICallKitSelectGroupMemberCell.h"
#import "TUICallKitSelectGroupMemberViewController.h"
#import "TUICallKitAudioPlayer.h"
#import "TUICallingFloatingWindowManager.h"
#import "TUICallingUserManager.h"
#import "TUICallRecordCallsCell.h"
#import "TUICallRecordCallsCellViewModel.h"
#import "TUICallRecordCallsViewController.h"
#import "TUICallRecordCallsViewModel.h"
#import "TUICallingAction.h"
#import "TUICallingNavigationController.h"
#import "TUICallingStatusManager.h"
#import "TUICallingUserModel.h"
#import "TUICallingViewManager.h"
#import "TUICalleeGroupCell.h"
#import "TUICallingControlButton.h"
#import "TUICallingGroupCell.h"
#import "TUICallingVideoRenderView.h"
#import "TUICallingCalleeView.h"
#import "TUICallingSingleVideoUserView.h"
#import "TUICallingTimerView.h"
#import "TUICallingUserView.h"
#import "TUICallingFloatingWindow.h"
#import "TUICallingAudioFunctionView.h"
#import "TUICallingSwitchToAudioView.h"
#import "TUICallingVideoFunctionView.h"
#import "TUICallingVideoInviteFunctionView.h"
#import "TUICallingWaitFunctionView.h"
#import "BaseCallViewProtocol.h"
#import "BaseFunctionViewProtocol.h"
#import "BaseUserViewProtocol.h"
#import "TUICallingGroupDelegateManager.h"
#import "TUICallingGroupView.h"
#import "TUICallingSingleView.h"
#import "TUICallKitHeader.h"

FOUNDATION_EXPORT double TUICallKitVersionNumber;
FOUNDATION_EXPORT const unsigned char TUICallKitVersionString[];

