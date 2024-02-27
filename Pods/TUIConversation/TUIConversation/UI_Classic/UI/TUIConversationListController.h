
//  Created by Tencent on 2023/06/09.
//  Copyright © 2023 Tencent. All rights reserved.
/**
 *
 * 腾讯云通讯服务界面组件 TUIKIT - 会话列表组件。
 *
 * 本文件声明了话列表的视图组件。
 * 会话列表组件能够按照新消息发来时间顺序（越新的消息排序越靠前），展示各个会话的简要信息。
 * 会话列表所展示的会话信息包括：
 * 1、头像信息（用户头像/群头像）
 * 2、会话标题（用户昵称/群名称）
 * 3、会话消息概览（展示最新的一条的消息内容）
 * 4、未读消息数（若有未读消息的话）
 * 5、会话时间（最新消息的收到/发出时间）
 * 会话列表中展示的会话信息，由 TUIConversationCell 具体实现。详细信息请参考 TUIConversation\Cell\CellUI\TUIConversationCell.h
 *
 *
 * Tencent Cloud Communication Service Interface Component TUIKIT - Conversation List Component.
 *
 * This file declares the view component of the conversation list.
 * The conversation list component can display brief information of each conversation in the order of the time when new messages are sent (newer messages are
 * sorted earlier). The conversation information displayed in the conversation list includes:
 * 1. Avatar information (user avatar/group avatar)
 * 2. Conversation title (user nickname/group name)
 * 3. Conversation message overview (display the latest message content)
 * 4. The number of unread messages (if there are unread messages)
 * 5. Conversation time (receive/send time of the latest message)
 * The conversation information displayed in the conversation list is implemented by TUIConversationCell. For details, please refer to
 * TUIConversation\Cell\CellUI\TUIConversationCell.h
 */

#import <TIMCommon/TIMDefine.h>
#import <UIKit/UIKit.h>
#import "TUIConversationCellData.h"
#import "TUIConversationListControllerListener.h"
#import "TUIConversationTableView.h"

@class TUISearchBar;

NS_ASSUME_NONNULL_BEGIN

/**
 * 【模块名称】会话列表界面组件（TUIConversationListController）
 *
 * 【功能说明】负责按消息的接收顺序展示各个会话，同时响应用户的操作，为用户提供多会话的管理功能。
 *  会话列表所展示的会话信息包括：
 *  1、头像信息（用户头像/群头像）
 *  2、会话标题（用户昵称/群名称）
 *  3、会话消息概览（展示最新的一条的消息内容）
 *  4、未读消息数（若有未读消息的话）
 *  5、会话时间（最新消息的收到/发出时间）
 *
 *
 * 【Module name】 message list interface component (TUIConversationListController)
 *
 * 【Function description】 It is responsible for displaying each conversation in the order in which the messages are received, and responding to the user's
 * operation, providing users with multi-session management functions. The conversation information displayed in the conversation list includes:
 *  1. Avatar information (user avatar/group avatar)
 *  2. Conversation title (user nickname/group name)
 *  3. Conversation message overview (display the latest message content)
 *  4. The number of unread messages (if there are unread messages)
 *  5. Conversation time (receive/send time of the latest message)
 */
@interface TUIConversationListController : UIViewController
@property(nonatomic, strong) TUIConversationTableView *tableViewForAll;

@property(nonatomic, weak) id<TUIConversationListControllerListener> delegate;

@property(nonatomic, strong) TUIConversationListBaseDataProvider *dataProvider;

@property(nonatomic) BOOL isShowBanner;

/**
 *  是否展示会话分组，如果集成了 TUIConversationGroup 组件，默认会展示
 *  An identifier that identifies whether to display the conversation group, If the TUIConversationGroup component is integrated, it will be displayed by
 * default
 */
@property(nonatomic) BOOL isShowConversationGroup;

- (void)startConversation:(V2TIMConversationType)type;
@end

NS_ASSUME_NONNULL_END
