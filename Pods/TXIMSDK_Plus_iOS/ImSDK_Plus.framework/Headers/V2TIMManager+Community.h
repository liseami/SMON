/////////////////////////////////////////////////////////////////////
//
//  腾讯云通信服务 IMSDK
//
//  模块名称：V2TIMManager+Community
//
//  社群接口，里面包含了创建话题、删除话题、修改话题、获取话题列表等逻辑
//
/////////////////////////////////////////////////////////////////////
#import "V2TIMManager.h"
#import "V2TIMManager+Group.h"

V2TIM_EXPORT @protocol V2TIMCommunityListener;
@class V2TIMTopicInfo;
@class V2TIMTopicInfoResult;
@class V2TIMTopicOperationResult;
@class V2TIMPermissionGroupInfo;
@class V2TIMPermissionGroupOperationResult;
@class V2TIMPermissionGroupInfoResult;
@class V2TIMPermissionGroupMemberOperationResult;
@class V2TIMPermissionGroupMemberInfoResult;
@class V2TIMTopicPermissionOperationResult;
@class V2TIMTopicPermissionResult;

V2TIM_EXPORT @interface V2TIMManager (Community)

/// 操作话题列表结果
typedef void(^V2TIMTopicOperationResultSucc)(NSMutableArray<V2TIMTopicOperationResult *> *resultList);
/// 获取话题列表结果
typedef void(^V2TIMTopicInfoResultListSucc)(NSMutableArray<V2TIMTopicInfoResult *> *resultList);
/// 创建话题成功回调
typedef void (^V2TIMCreateTopicSucc)(NSString * topicID);
/// 创建权限组成功回调
typedef void (^V2TIMCreatePermissionGroupSucc)(NSString * permissionGroupID);
/// 操作权限组结果
typedef void (^V2TIMPermissionGroupOperationResultSucc)(NSMutableArray<V2TIMPermissionGroupOperationResult *> *resultList);
/// 获取权限组列表结果
typedef void (^V2TIMPermissionGroupInfoResultListSucc)(NSMutableArray<V2TIMPermissionGroupInfoResult *> *resultList);
/// 操作权限组成员结果
typedef void (^V2TIMPermissionGroupMemberOperationResultListSucc)(NSMutableArray<V2TIMPermissionGroupMemberOperationResult *> *resultList);
/// 获取权限组成员结果
typedef void (^V2TIMPermissionGroupMemberInfoResultListSucc)(NSString *nextCursor, NSMutableArray<V2TIMGroupMemberFullInfo *> *resultList);
/// 获取话题权限结果
typedef void (^V2TIMTopicPermissionResultSucc)(NSMutableArray<V2TIMTopicPermissionResult *> *resultList);

/// 社群权限值
typedef NS_ENUM(NSInteger, V2TIMCommunityPermissionValue) {
    V2TIM_COMMUNITY_PERMISSION_MANAGE_GROUP_INFO               = 0x1,       ///< 修改群资料权限。该位设置为0，表示没有该权限；设置为1，表示有该权限。
    V2TIM_COMMUNITY_PERMISSION_MANAGE_GROUP_MEMBER             = 0x1 << 1,  ///< 群成员管理权限，包含踢人，进群审核、修改成员资料等。该位设置为0，表示没有该权限；设置为1，表示有该权限。
    V2TIM_COMMUNITY_PERMISSION_MANAGE_PERMISSION_GROUP_INFO    = 0x1 << 2,  ///< 管理权限组资料权限。该位设置为0，表示没有该权限；设置为1，表示有该权限。权限包含创建、修改、删除权限组；在权限组中添加、修改、删除话题权限。
    V2TIM_COMMUNITY_PERMISSION_MANAGE_PERMISSION_GROUP_MEMBER  = 0x1 << 3,  ///< 权限组成员管理权限，包含邀请成员进权限组和把成员从权限组踢出等。该位设置为0，表示没有该权限；设置为1，表示有该权限。
    V2TIM_COMMUNITY_PERMISSION_MANAGE_TOPIC_IN_COMMUNITY       = 0x1 << 4,  ///< 话题管理权限，包含创建、修改、删除话题等。该位设置为0，表示没有该权限；设置为1，表示有该权限。
    V2TIM_COMMUNITY_PERMISSION_MUTE_MEMBER                     = 0x1 << 5,  ///< 对某群成员在社群下所有话题的禁言权限。该位设置为0，表示没有该权限；设置为1，表示有该权限。
    V2TIM_COMMUNITY_PERMISSION_SEND_MESSAGE                    = 0x1 << 6,  ///< 群成员在社群下所有话题的发消息权限。该位设置为0，表示没有该权限；设置为1，表示有该权限。
    V2TIM_COMMUNITY_PERMISSION_AT_ALL                          = 0x1 << 7,  ///< 在社群下所有话题发 at all 消息权限。该位设置为0，表示没有该权限；设置为1，表示有该权限。
    V2TIM_COMMUNITY_PERMISSION_GET_HISTORY_MESSAGE             = 0x1 << 8,  ///< 在社群下所有话题拉取入群前的历史消息权限。该位设置为0，表示没有该权限；设置为1，表示有该权限。
    V2TIM_COMMUNITY_PERMISSION_REVOKE_OTHER_MEMBER_MESSAGE     = 0x1 << 9,  ///< 在社群下所有话题撤回他人消息权限。该位设置为0，表示没有该权限；设置为1，表示有该权限。
    V2TIM_COMMUNITY_PERMISSION_BAN_MEMBER                      = 0x1 << 10, ///< 封禁社群成员权限。该位设置为0，表示没有该权限；设置为1，表示有该权限。
};

/// 话题权限值
typedef NS_ENUM(NSInteger, V2TIMTopicPermissionValue) {
    V2TIM_TOPIC_PERMISSION_MANAGE_TOPIC                        = 0x1,       ///< 管理当前话题的权限，包括修改当前话题的资料、删除当前话题。该位设置为0，表示没有该权限；设置为1，表示有该权限
    V2TIM_TOPIC_PERMISSION_MANAGE_TOPIC_PERMISSION             = 0x1 << 1,  ///< 在当前话题中管理话题权限，包括添加、修改、移除话题权限。该位设置为0，表示没有该权限；设置为1，表示有该权限
    V2TIM_TOPIC_PERMISSION_MUTE_MEMBER                         = 0x1 << 2,  ///< 在当前话题中禁言成员权限。该位设置为0，表示没有该权限；设置为1，表示有该权限
    V2TIM_TOPIC_PERMISSION_SEND_MESSAGE                        = 0x1 << 3,  ///< 在当前话题中发消息权限。该位设置为0，表示没有该权限；设置为1，表示有该权限
    V2TIM_TOPIC_PERMISSION_GET_HISTORY_MESSAGE                 = 0x1 << 4,  ///< 在当前话题中拉取入群前的历史消息权限。该位设置为0，表示没有该权限；设置为1，表示有该权限
    V2TIM_TOPIC_PERMISSION_REVOKE_OTHER_MEMBER_MESSAGE         = 0x1 << 5,  ///< 在当前话题中撤回他人消息权限。该位设置为0，表示没有该权限；设置为1，表示有该权限
    V2TIM_TOPIC_PERMISSION_AT_ALL                              = 0x1 << 6,  ///< 在当前话题中发消息时有 at all 权限。该位设置为0，表示没有该权限；设置为1，表示有该权限
};

/////////////////////////////////////////////////////////////////////////////////
//
// 社群监听器
//
/////////////////////////////////////////////////////////////////////////////////

/**
 *  1.1 添加社群监听器
 */
- (void)addCommunityListener:(id<V2TIMCommunityListener>)listener NS_SWIFT_NAME(addCommunityListener(listener:));

/**
 *  1.2 移除社群监听器
 */
- (void)removeCommunityListener:(id<V2TIMCommunityListener>)listener NS_SWIFT_NAME(removeCommunityListener(listener:));

/////////////////////////////////////////////////////////////////////////////////
//
// 社群接口
//
/////////////////////////////////////////////////////////////////////////////////
/**
 * 2.1 创建支持话题的社群
 */
- (void)createCommunity:(V2TIMGroupInfo*)info memberList:(NSArray<V2TIMCreateGroupMemberInfo *>*) memberList succ:(V2TIMCreateGroupSucc)succ fail:(V2TIMFail)fail;

/**
 * 2.1 获取当前用户已经加入的支持话题的社群列表
 */
- (void)getJoinedCommunityList:(V2TIMGroupInfoListSucc)succ fail:(V2TIMFail)fail;

/**
 * 2.2 创建话题
 *
 * @param groupID 社群 ID，必须以 @TGS#_ 开头。
 */
- (void)createTopicInCommunity:(NSString *)groupID topicInfo:(V2TIMTopicInfo *)topicInfo succ:(V2TIMCreateTopicSucc)succ fail:(V2TIMFail)fail;

/**
 * 2.3 删除话题
 */
- (void)deleteTopicFromCommunity:(NSString *)groupID topicIDList:(NSArray<NSString *>*)topicIDList succ:(V2TIMTopicOperationResultSucc)succ fail:(V2TIMFail)fail;

/**
 * 2.4 修改话题信息
 */
- (void)setTopicInfo:(V2TIMTopicInfo *)topicInfo succ:(V2TIMSucc)succ fail:(V2TIMFail)fail;

/**
 * 2.5 获取话题列表。
 * @note: topicIDList 传空时，获取此社群下的所有话题列表
 */
- (void)getTopicInfoList:(NSString *)groupID topicIDList:(NSArray<NSString *>*)topicIDList succ:(V2TIMTopicInfoResultListSucc)succ fail:(V2TIMFail)fail;

/////////////////////////////////////////////////////////////////////////////////
//
// 权限组接口
//
/////////////////////////////////////////////////////////////////////////////////
/**
 * 3.1 创建社群权限组（7.8 及其以上版本支持）
 * @note
 * - 该功能为旗舰版功能，需要您购买旗舰版套餐。
 */
- (void)createPermissionGroupInCommunity:(V2TIMPermissionGroupInfo *)permissionGroupInfo succ:(V2TIMCreatePermissionGroupSucc)succ fail:(V2TIMFail)fail;

/**
 * 3.2 删除社群权限组（7.8 及其以上版本支持）
 * @note
 * - 该功能为旗舰版功能，需要您购买旗舰版套餐。
 */
- (void)deletePermissionGroupFromCommunity:(NSString *)groupID permissionGroupIDList:(NSArray<NSString *>*)permissionGroupIDList succ:(V2TIMPermissionGroupOperationResultSucc)succ fail:(V2TIMFail)fail;

/**
 * 3.3 修改社群权限组（7.8 及其以上版本支持）
 * @note
 * - 该功能为旗舰版功能，需要您购买旗舰版套餐。
 */
- (void)modifyPermissionGroupInfoInCommunity:(V2TIMPermissionGroupInfo *)permissionGroupInfo succ:(V2TIMSucc)succ fail:(V2TIMFail)fail;

/**
 * 3.4 获取已加入的社群权限组列表（7.8 及其以上版本支持）
 * @note
 * - 该功能为旗舰版功能，需要您购买旗舰版套餐。
 */
- (void)getJoinedPermissionGroupListInCommunity:(NSString *)groupID succ:(V2TIMPermissionGroupInfoResultListSucc)succ fail:(V2TIMFail)fail;

/**
 * 3.5 获取社群权限组列表（7.8 及其以上版本支持）
 * @note
 * - 该功能为旗舰版功能，需要您购买旗舰版套餐。
 * - permissionGroupIDList 为空时，获取所有的权限组列表；不为空时，获取指定的权限组列表
 */
- (void)getPermissionGroupListInCommunity:(NSString *)groupID permissionGroupIDList:(NSArray<NSString *>*)permissionGroupIDList succ:(V2TIMPermissionGroupInfoResultListSucc)succ fail:(V2TIMFail)fail;

/**
 * 3.6 向社群权限组添加成员（7.7 及其以上版本支持）
 * @note
 * - 该功能为旗舰版功能，需要您购买旗舰版套餐。
 */
- (void)addCommunityMembersToPermissionGroup:(NSString *)groupID permissionGroupID:(NSString *)permissionGroupID memberList:(NSArray<NSString *>*)memberList succ:(V2TIMPermissionGroupMemberOperationResultListSucc)succ fail:(V2TIMFail)fail;

/**
 * 3.7 从社群权限组删除成员（7.8 及其以上版本支持）
 */
- (void)removeCommunityMembersFromPermissionGroup:(NSString *)groupID permissionGroupID:(NSString *)permissionGroupID memberList:(NSArray<NSString *>*)memberList succ:(V2TIMPermissionGroupMemberOperationResultListSucc)succ fail:(V2TIMFail)fail;

/**
 * 3.8 获取社群权限组成员列表（7.8 及其以上版本支持）
 * @note
 * - 该功能为旗舰版功能，需要您购买旗舰版套餐。
 */
- (void)getCommunityMemberListInPermissionGroup:(NSString *)groupID permissionGroupID:(NSString *)permissionGroupID nextCursor:(NSString *)nextCursor succ:(V2TIMPermissionGroupMemberInfoResultListSucc)succ fail:(V2TIMFail)fail;

/**
 * 3.9 向权限组添加话题权限（7.8 及其以上版本支持）
 * @note
 * - 该功能为旗舰版功能，需要您购买旗舰版套餐。
 */
- (void)addTopicPermissionToPermissionGroup:(NSString *)groupID permissionGroupID:(NSString *)permissionGroupID topicPermissionMap:(NSDictionary<NSString *, NSNumber *>*)topicPermissionMap succ:(V2TIMTopicOperationResultSucc)succ fail:(V2TIMFail)fail;

/**
 * 3.10 从权限组中删除话题权限（7.8 及其以上版本支持）
 * @note
 * - 该功能为旗舰版功能，需要您购买旗舰版套餐。
 */
- (void)deleteTopicPermissionFromPermissionGroup:(NSString *)groupID permissionGroupID:(NSString *)permissionGroupID topicIDList:(NSArray<NSString *>*)topicIDList succ:(V2TIMTopicOperationResultSucc)succ fail:(V2TIMFail)fail;

/**
 * 3.11 修改权限组中的话题权限（7.8 及其以上版本支持）
 * @note
 * - 该功能为旗舰版功能，需要您购买旗舰版套餐。
 */
- (void)modifyTopicPermissionInPermissionGroup:(NSString *)groupID permissionGroupID:(NSString *)permissionGroupID topicPermissionMap:(NSDictionary<NSString *, NSNumber *>*)topicPermissionMap succ:(V2TIMTopicOperationResultSucc)succ fail:(V2TIMFail)fail;

/**
 * 3.12 获取权限组中的话题权限（7.8 及其以上版本支持）
 * @note
 * - 该功能为旗舰版功能，需要您购买旗舰版套餐。
 */
- (void)getTopicPermissionInPermissionGroup:(NSString *)groupID permissionGroupID:(NSString *)permissionGroupID topicIDList:(NSArray<NSString *>*)topicIDList succ:(V2TIMTopicPermissionResultSucc)succ fail:(V2TIMFail)fail;

@end

/////////////////////////////////////////////////////////////////////////////////
//
// 社群回调
//
/////////////////////////////////////////////////////////////////////////////////
/// 资料关系链回调
V2TIM_EXPORT @protocol V2TIMCommunityListener <NSObject>
@optional

/// 话题创建回调
- (void)onCreateTopic:(NSString *)groupID topicID:(NSString *)topicID;

/// 话题被删除回调
- (void)onDeleteTopic:(NSString *)groupID topicIDList:(NSArray<NSString *> *)topicIDList;

/// 话题更新回调
- (void)onChangeTopicInfo:(NSString *)groupID topicInfo:(V2TIMTopicInfo *)topicInfo;

/// 收到 RESTAPI 下发的话题自定义系统消息
- (void)onReceiveTopicRESTCustomData:(NSString *)topicID data:(NSData *)data;

/// 权限组创建通知
- (void)onCreatePermissionGroup:(NSString *)groupID permissionGroupInfo:(V2TIMPermissionGroupInfo *)permissionGroupInfo;

/// 权限组删除通知
- (void)onDeletePermissionGroup:(NSString *)groupID permissionGroupIDList:(NSArray<NSString *> *)permissionGroupIDList;

/// 权限组更新通知
- (void)onChangePermissionGroupInfo:(NSString *)groupID permissionGroupInfo:(V2TIMPermissionGroupInfo *)permissionGroupInfo;

/// 添加成员到权限组通知
- (void)onAddMembersToPermissionGroup:(NSString *)groupID permissionGroupID:(NSString *)permissionGroupID memberIDList:(NSArray<NSString *> *)memberIDList;

/// 从权限组中删除成员通知
- (void)onRemoveMembersFromPermissionGroup:(NSString *)groupID permissionGroupID:(NSString *)permissionGroupID memberIDList:(NSArray<NSString *> *)memberIDList;

/// 话题权限添加通知
- (void)onAddTopicPermission:(NSString *)groupID permissionGroupID:(NSString *)permissionGroupID topicPermissionMap:(NSDictionary<NSString *, NSNumber *>*)topicPermissionMap;

/// 话题权限删除通知
- (void)onDeleteTopicPermission:(NSString *)groupID permissionGroupID:(NSString *)permissionGroupID topicIDList:(NSArray<NSString *>*)topicIDList;

/// 话题权限修改通知
- (void)onModifyTopicPermission:(NSString *)groupID permissionGroupID:(NSString *)permissionGroupID topicPermissionMap:(NSDictionary<NSString *, NSNumber *>*)topicPermissionMap;

@end

/////////////////////////////////////////////////////////////////////////////////
//
// 话题基本资料
//
/////////////////////////////////////////////////////////////////////////////////
V2TIM_EXPORT @interface V2TIMTopicInfo : NSObject

/// 话题 ID，只能在创建话题或者修改话题信息的时候设置。组成方式为：社群 ID + @TOPIC#_xxx，例如社群 ID 为 @TGS#_123，则话题 ID 为 @TGS#_123@TOPIC#_xxx
@property(nonatomic, strong) NSString *topicID;

/// 话题名称，最长 150 字节，使用 UTF-8 编码
@property(nonatomic, strong) NSString *topicName;

/// 话题头像，最长 500 字节，使用 UTF-8 编码
@property(nonatomic, strong) NSString *topicFaceURL;

/// 话题介绍，最长 400 字节，使用 UTF-8 编码
@property(nonatomic, strong) NSString *introduction;

/// 话题公告，最长 400 字节，使用 UTF-8 编码
@property(nonatomic, strong) NSString *notification;

/// 话题全员禁言
@property(nonatomic, assign) BOOL isAllMuted;

/// 当前用户在话题中的禁言时间，单位：秒
@property(nonatomic, assign, readonly) uint32_t selfMuteTime;

/// 话题自定义字段
@property(nonatomic, strong) NSString *customString;

/// 话题消息接收选项，修改话题消息接收选项请调用 setGroupReceiveMessageOpt 接口
@property(nonatomic, assign, readonly) V2TIMReceiveMessageOpt recvOpt;

/// 话题草稿
@property(nonatomic, strong) NSString *draftText;

/// 话题消息未读数量
@property(nonatomic, assign, readonly) uint64_t unreadCount;

/// 话题 lastMessage
@property(nonatomic,strong,readonly) V2TIMMessage *lastMessage;

/// 话题已读消息的 sequence，从 7.8 版本开始支持
@property(nonatomic, assign, readonly) uint64_t readSequence;

/// 话题 at 信息列表
@property(nonatomic, strong, readonly) NSArray<V2TIMGroupAtInfo *> *groupAtInfolist;

/// 话题创建时间，单位：秒
@property(nonatomic, assign, readonly) uint32_t createTime;

/// 话题默认权限，7.8 版本开始支持
/// 
@property(nonatomic, assign) uint64_t defaultPermissions;
@end

/////////////////////////////////////////////////////////////////////////////////
//
// 话题处理结果
//
/////////////////////////////////////////////////////////////////////////////////
V2TIM_EXPORT @interface V2TIMTopicOperationResult : NSObject

/// 结果 0：成功；非0：失败
@property(nonatomic, assign)  int errorCode;

/// 错误信息
@property(nonatomic, strong)  NSString *errorMsg;

/// 话题 ID
@property(nonatomic, strong)  NSString *topicID;
@end

/////////////////////////////////////////////////////////////////////////////////
//
// 话题资料获取结果
//
/////////////////////////////////////////////////////////////////////////////////
V2TIM_EXPORT @interface V2TIMTopicInfoResult : NSObject

/// 结果 0：成功；非0：失败
@property(nonatomic, assign)  int errorCode;

/// 错误信息
@property(nonatomic, strong)  NSString *errorMsg;

/// 话题资料
@property(nonatomic, strong)  V2TIMTopicInfo *topicInfo;
@end

/////////////////////////////////////////////////////////////////////////////////
//
// 权限组信息
//
/////////////////////////////////////////////////////////////////////////////////
V2TIM_EXPORT @interface V2TIMPermissionGroupInfo : NSObject

/// 群 ID
@property(nonatomic, strong) NSString *groupID;

/// 权限组 ID
@property(nonatomic, strong) NSString *permissionGroupID;

/// 权限组名称
@property(nonatomic, strong) NSString *permissionGroupName;

/// 群权限
@property(nonatomic, assign) uint64_t groupPermission;

/// 自定义数据
@property(nonatomic, strong) NSString *customData;

/// 成员人数
@property(nonatomic, assign, readonly) uint64_t memberCount;

@end

/////////////////////////////////////////////////////////////////////////////////
//
// 权限组信息获取结果
//
/////////////////////////////////////////////////////////////////////////////////
V2TIM_EXPORT @interface V2TIMPermissionGroupInfoResult : NSObject

/// 结果 0：成功；非0：失败
@property(nonatomic,assign) int resultCode;

/// 如果获取失败，会返回错误信息
@property(nonatomic,strong) NSString *resultMsg;

/// 如果获取成功，会返回对应的 info
@property(nonatomic,strong) V2TIMPermissionGroupInfo *info;

@end

/////////////////////////////////////////////////////////////////////////////////
//
// 权限组处理结果
//
/////////////////////////////////////////////////////////////////////////////////
V2TIM_EXPORT @interface V2TIMPermissionGroupOperationResult : NSObject

/// 结果 0：成功；非0：失败
@property(nonatomic,assign) int resultCode;

/// 如果获取失败，会返回错误信息
@property(nonatomic,strong) NSString *resultMsg;

/// 如果获取成功，会返回对应的 info
@property(nonatomic,strong) NSString *permissionGroupID;

@end

/////////////////////////////////////////////////////////////////////////////////
//
// 权限组成员处理结果
//
/////////////////////////////////////////////////////////////////////////////////
V2TIM_EXPORT @interface V2TIMPermissionGroupMemberOperationResult : NSObject

/// 成员 userID
@property(nonatomic,strong) NSString *memberID;

/// 结果 0：成功；非0：失败
@property(nonatomic,assign) int resultCode;

@end

/////////////////////////////////////////////////////////////////////////////////
//
// 话题权限获取结果
//
/////////////////////////////////////////////////////////////////////////////////
V2TIM_EXPORT @interface V2TIMTopicPermissionResult : NSObject

/// 话题
@property(nonatomic,strong) NSString *topicID;

/// 结果 0：成功；非0：失败
@property(nonatomic,assign) int resultCode;

/// 如果获取失败，会返回错误信息
@property(nonatomic,strong) NSString *resultMsg;

/// 话题权限
@property(nonatomic, assign) uint64_t topicPermission;

/// 社群 ID
@property(nonatomic, strong) NSString *groupID;

/// 权限组 ID
@property(nonatomic, strong) NSString *permissionGroupID;

@end
