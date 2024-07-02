//
//  TUIC2CChatViewController.h
//  TXIMSDK_TUIKit_iOS
//
//  Created by kayev on 2021/6/17.
//  Copyright © 2023 Tencent. All rights reserved.
//

#import "TUIBaseChatViewController.h"

NS_ASSUME_NONNULL_BEGIN


@protocol TUIMessageTapDelegate <NSObject>
-(void)tapMessageCell:(TUIMessageCell *)cell postId:(NSString *)postId;
@end

@interface TUIC2CChatViewController : TUIBaseChatViewController

@property(nonatomic, weak) id<TUIMessageTapDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
