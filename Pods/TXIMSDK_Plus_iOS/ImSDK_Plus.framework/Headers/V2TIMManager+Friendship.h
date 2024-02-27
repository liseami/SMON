/////////////////////////////////////////////////////////////////////
//
//                     腾讯云通信服务 IMSDK
//
//  模块名称：V2TIMManager+Friendship
//
//  关系链接口，里面包含了好友的添加、删除，黑名单的添加、删除等逻辑
//
/////////////////////////////////////////////////////////////////////
#import "V2TIMManager.h"

V2TIM_EXPORT @protocol V2TIMFriendshipListener;
@class V2TIMFriendOperationResult;
@class V2TIMFriendInfoResult;
@class V2TIMFriendInfo;
@class V2TIMFriendCheckResult;
@class V2TIMFriendApplicationResult;
@class V2TIMFriendAddApplication;
@class V2TIMFriendApplication;
@class V2TIMFriendGroup;
@class V2TIMFriendSearchParam;
@class V2TIMOfficialAccountInfo;
@class V2TIMOfficialAccountInfoResult;
@class V2TIMFollowOperationResult;
@class V2TIMFollowInfo;
@class V2TIMFollowTypeCheckResult;

V2TIM_EXPORT @interface V2TIMManager (Friendship)

/// 获取好友列表成功回调
typedef void (^V2TIMFriendInfoListSucc)(NSArray<V2TIMFriendInfo *> *infoList);
/// 获取指定好友信息成功回调
typedef void (^V2TIMFriendInfoResultListSucc)(NSArray<V2TIMFriendInfoResult *> *resultList);
/// 好友操作成功回调
typedef void (^V2TIMFriendOperationResultSucc)(V2TIMFriendOperationResult *result);
/// 好友列表操作成功回调
typedef void (^V2TIMFriendOperationResultListSucc)(NSArray<V2TIMFriendOperationResult *> *resultList);
/// 好友检查成功回调
typedef void (^V2TIMFriendCheckResultListSucc)(NSArray<V2TIMFriendCheckResult *> *resultList);
/// 获取群分组列表成功回调
typedef void (^V2TIMFriendGroupListSucc)(NSArray<V2TIMFriendGroup *> *groups);
/// 获取好友申请列表成功回调
typedef void (^V2TIMFriendApplicationResultSucc)(V2TIMFriendApplicationResult *result);
/// 获取公众号列表成功回调
typedef void (^V2TIMOfficialAccountInfoResultListSucc)(NSArray<V2TIMOfficialAccountInfoResult *> *resultList);
/// 关注/取关用户操作成功的回调
typedef void (^V2TIMFollowOperationResultListSucc)(NSArray<V2TIMFollowOperationResult *> *resultList);
/// 获取自己 关注/粉丝/互关 列表成功的回调
typedef void (^V2TIMUserInfoResultSucc)(NSString *nextCursor, NSArray<V2TIMUserFullInfo *> *userInfoList);
/// 获取用户关注数量信息成功的回调
typedef void (^V2TIMFollowInfoResultListSucc)(NSArray<V2TIMFollowInfo *> *resultList);
/// 用户关注类型检查成功回调
typedef void (^V2TIMFollowTypeCheckResultListSucc)(NSArray<V2TIMFollowTypeCheckResult *> *resultList);

/// 好友申请类型
typedef NS_ENUM(NSInteger, V2TIMFriendApplicationType) {
    V2TIM_FRIEND_APPLICATION_COME_IN        = 1,  ///< 别人发给我的
    V2TIM_FRIEND_APPLICATION_SEND_OUT       = 2,  ///< 我发给别人的
    V2TIM_FRIEND_APPLICATION_BOTH           = 3,  ///< 别人发给我的 和 我发给别人的。仅拉取时有效
};

/// 好友类型
typedef NS_ENUM(NSInteger, V2TIMFriendType) {
    V2TIM_FRIEND_TYPE_SINGLE                = 1,  ///< 单向好友
    V2TIM_FRIEND_TYPE_BOTH                  = 2,  ///< 双向好友
};

/// 好友关系类型
typedef NS_ENUM(NSInteger, V2TIMFriendRelationType) {
    V2TIM_FRIEND_RELATION_TYPE_NONE                   = 0x0,  ///< 不是好友
    V2TIM_FRIEND_RELATION_TYPE_IN_MY_FRIEND_LIST      = 0x1,  ///< 对方在我的好友列表中
    V2TIM_FRIEND_RELATION_TYPE_IN_OTHER_FRIEND_LIST   = 0x2,  ///< 我在对方的好友列表中
    V2TIM_FRIEND_RELATION_TYPE_BOTH_WAY               = 0x3,  ///< 互为好友
};

/// 好友申请接受类型
typedef NS_ENUM(NSInteger, V2TIMFriendAcceptType) {
    V2TIM_FRIEND_ACCEPT_AGREE             = 0,  ///< 接受加好友（建立单向好友）
    V2TIM_FRIEND_ACCEPT_AGREE_AND_ADD     = 1,  ///< 接受加好友并加对方为好友（建立双向好友）
};

/// 关注类型
typedef NS_ENUM(NSInteger, V2TIMFollowType) {
    V2TIM_FOLLOW_TYPE_NONE                     = 0x0,  ///< 无任何关注关系
    V2TIM_FOLLOW_TYPE_IN_MY_FOLLOWING_LIST     = 0x1,  ///< 对方在我的关注列表中
    V2TIM_FOLLOW_TYPE_IN_MY_FOLLOWERS_LIST     = 0x2,  ///< 对方在我的粉丝列表中
    V2TIM_FOLLOW_TYPE_IN_BOTH_FOLLOWERS_LIST   = 0x3,  ///< 对方与我互相关注
};

/////////////////////////////////////////////////////////////////////////////////
//
//                         关系链和用户资料监听器
//
/////////////////////////////////////////////////////////////////////////////////

/**
 *  1.1 添加关系链监听器
 */
- (void)addFriendListener:(id<V2TIMFriendshipListener>)listener NS_SWIFT_NAME(addFriendListener(listener:));

/**
 *  1.2 移除关系链监听器
 */
- (void)removeFriendListener:(id<V2TIMFriendshipListener>)listener NS_SWIFT_NAME(removeFriendListener(listener:));

/**
 *  设置关系链监听器（待废弃接口，请使用 addFriendListener 和 removeFriendListener 接口）
 */
- (void)setFriendListener:(id<V2TIMFriendshipListener>)listener __attribute__((deprecated("use addFriendListener: instead")));

/////////////////////////////////////////////////////////////////////////////////
//
//                       好友添加、删除、列表获取、资料设置相关接口
//
/////////////////////////////////////////////////////////////////////////////////

/**
 *  2.1 获取好友列表
 */
- (void)getFriendList:(V2TIMFriendInfoListSucc)succ fail:(V2TIMFail)fail;

/**
 *  2.2 获取指定好友资料
 *  @param userIDList 好友 userID 列表
 *                   - ID 建议一次最大 100 个，因为数量过多可能会导致数据包太大被后台拒绝，后台限制数据包最大为 1M。
 */
- (void)getFriendsInfo:(NSArray<NSString *> *)userIDList succ:(V2TIMFriendInfoResultListSucc)succ fail:(V2TIMFail)fail;

/**
 *  2.3 设置指定好友资料
 */
- (void)setFriendInfo:(V2TIMFriendInfo *)info succ:(V2TIMSucc)succ fail:(V2TIMFail)fail;


/**
 * 2.4 搜索好友（5.4.666 及以上版本支持）
 * @note
 *  - 接口返回本地存储的用户资料，可以根据 V2TIMFriendInfoResult 中的 getRelation 来判断是否为好友。
 *  - 该功能为 IM 旗舰版功能，[购买旗舰版套餐包](https://buy.cloud.tencent.com/avc?from=17474)后可使用，详见[价格说明](https://cloud.tencent.com/document/product/269/11673?from=17176#.E5.9F.BA.E7.A1.80.E6.9C.8D.E5.8A.A1.E8.AF.A6.E6.83.85)
 */
- (void)searchFriends:(V2TIMFriendSearchParam *)searchParam succ:(V2TIMFriendInfoResultListSucc)succ fail:(V2TIMFail)fail;

/**
 *  2.5 添加好友
 */
- (void)addFriend:(V2TIMFriendAddApplication *)application succ:(V2TIMFriendOperationResultSucc)succ fail:(V2TIMFail)fail;

/**
 *  2.6 删除好友
 *  @param userIDList 要删除的好友 userID 列表
 *                   - ID 建议一次最大 100 个，因为数量过多可能会导致数据包太大被后台拒绝，后台限制数据包最大为 1M。
 *  @param deleteType 删除类型（单向好友、双向好友）
 */
- (void)deleteFromFriendList:(NSArray *)userIDList deleteType:(V2TIMFriendType)deleteType succ:(V2TIMFriendOperationResultListSucc)succ fail:(V2TIMFail)fail;

/**
 *  2.7 检查指定用户的好友关系
 *  @param userIDList 要检查的 userID 列表
 *  @param checkType 检查类型 （单向好友检查、双向好友检查）
 *  @param succ 成功后的回调
 *  @param fail 失败后的回调
 *
 *  @note checkType 的使用需要注意：
 *  - checkType 如果传入 V2TIM_FRIEND_TYPE_SINGLE，结果返回：V2TIM_FRIEND_RELATION_TYPE_NONE、V2TIM_FRIEND_RELATION_TYPE_IN_MY_FRIEND_LIST 两种情况
 *  - checkType 如果传入 V2TIM_FRIEND_TYPE_BOTH，结果返回：V2TIM_FRIEND_RELATION_TYPE_NONE、V2TIM_FRIEND_RELATION_TYPE_IN_MY_FRIEND_LIST、
 *                                                 V2TIM_FRIEND_RELATION_TYPE_IN_OTHER_FRIEND_LIST、V2TIM_FRIEND_RELATION_TYPE_BOTH_WAY 四种情况
 */
- (void)checkFriend:(NSArray<NSString *> *)userIDList checkType:(V2TIMFriendType)checkType succ:(V2TIMFriendCheckResultListSucc)succ fail:(V2TIMFail)fail;

/////////////////////////////////////////////////////////////////////////////////
//
//                          好友申请、删除相关逻辑
//
/////////////////////////////////////////////////////////////////////////////////

/**
 *  3.1 获取好友申请列表
 *
 *  @note
 *   - 好友申请列表包括发起的好友申请和收到的好友申请。
 *   - 最多支持100个。
 */
- (void)getFriendApplicationList:(V2TIMFriendApplicationResultSucc)succ fail:(V2TIMFail)fail;

/**
 *  3.2 同意好友申请
 *
 *  @param application 好友申请信息，getFriendApplicationList 成功后会返回
 *  @param acceptType 建立单向/双向好友关系
 */
- (void)acceptFriendApplication:(V2TIMFriendApplication *)application type:(V2TIMFriendAcceptType)acceptType succ:(V2TIMFriendOperationResultSucc)succ fail:(V2TIMFail)fail;

/**
 *  3.3 拒绝好友申请
 *
 *  @param application 好友申请信息，getFriendApplicationList 成功后会返回
 */
- (void)refuseFriendApplication:(V2TIMFriendApplication *)application succ:(V2TIMFriendOperationResultSucc)succ fail:(V2TIMFail)fail;

/**
 *  3.4 删除好友申请
 *
 *  @param application 好友申请信息，getFriendApplicationList 成功后会返回
 */
- (void)deleteFriendApplication:(V2TIMFriendApplication *)application succ:(V2TIMSucc)succ fail:(V2TIMFail)fail;

/**
 *  3.5 设置好友申请已读
 */
- (void)setFriendApplicationRead:(V2TIMSucc)succ fail:(V2TIMFail)fail;


/////////////////////////////////////////////////////////////////////////////////
//
//                          黑名单
//
/////////////////////////////////////////////////////////////////////////////////

/**
 *  4.1 添加用户到黑名单
 */
- (void)addToBlackList:(NSArray *)userIDList succ:(V2TIMFriendOperationResultListSucc)succ fail:(V2TIMFail)fail;

/**
 *  4.2 把用户从黑名单中删除
 */
- (void)deleteFromBlackList:(NSArray *)userIDList succ:(V2TIMFriendOperationResultListSucc)succ fail:(V2TIMFail)fail;

/**
 *  4.3 获取黑名单列表
 */
- (void)getBlackList:(V2TIMFriendInfoListSucc)succ fail:(V2TIMFail)fail;


/////////////////////////////////////////////////////////////////////////////////
//
//                          好友分组
//
/////////////////////////////////////////////////////////////////////////////////

/**
 *  5.1 新建好友分组
 *
 *  @param groupName  分组名称
 *  @param userIDList 要添加到分组中的好友
 */
- (void)createFriendGroup:(NSString *)groupName userIDList:(NSArray *)userIDList succ:(V2TIMFriendOperationResultListSucc)succ fail:(V2TIMFail)fail;

/**
 *  5.2 获取分组信息
 *
 *  @param groupNameList  要获取信息的好友分组名称列表,传入 nil 获得所有分组信息
 */
- (void)getFriendGroupList:(NSArray *)groupNameList succ:(V2TIMFriendGroupListSucc)succ fail:(V2TIMFail)fail;

/**
 *  5.3 删除好友分组
 */
- (void)deleteFriendGroup:(NSArray *)groupNameList succ:(V2TIMSucc)succ fail:(V2TIMFail)fail;

/**
 *  5.4 修改好友分组的名称
 */
- (void)renameFriendGroup:(NSString*)oldName newName:(NSString*)newName succ:(V2TIMSucc)succ fail:(V2TIMFail)fail;

/**
 *  5.5 添加好友到一个好友分组
 */
- (void)addFriendsToFriendGroup:(NSString *)groupName userIDList:(NSArray *)userIDList succ:(V2TIMFriendOperationResultListSucc)succ fail:(V2TIMFail)fail;

/**
 *  5.6 从好友分组中删除好友
 */
- (void)deleteFriendsFromFriendGroup:(NSString *)groupName userIDList:(NSArray *)userIDList succ:(V2TIMFriendOperationResultListSucc)succ fail:(V2TIMFail)fail;

/////////////////////////////////////////////////////////////////////////////////
//
//                          公众号订阅、取消订阅、获取公众号列表接口
//
/////////////////////////////////////////////////////////////////////////////////

/**
 *  6.1 订阅公众号（7.6 及其以上版本支持）
 */
- (void)subscribeOfficialAccount:(NSString *)officialAccountID succ:(V2TIMSucc)succ fail:(V2TIMFail)fail;

/**
 *  6.2 取消订阅公众号（7.6 及其以上版本支持）
 */
- (void)unsubscribeOfficialAccount:(NSString *)officialAccountID succ:(V2TIMSucc)succ fail:(V2TIMFail)fail;

/**
 *  6.3 获取公众号列表（7.6 及其以上版本支持）
 *  @note officialAccountIDList 传空时，获取订阅的公众号列表
 */
- (void)getOfficialAccountsInfo:(NSArray<NSString *> *)officialAccountIDList succ:(V2TIMOfficialAccountInfoResultListSucc)succ fail:(V2TIMFail)fail;

/////////////////////////////////////////////////////////////////////////////////
//
//                          关注/粉丝 相关接口
//
/////////////////////////////////////////////////////////////////////////////////
/**
 *  7.1 关注用户（从 7.8 版本开始支持）
 * 
 *  @note
 *   - 该功能为 IM 旗舰版功能，[购买旗舰版套餐包](https://buy.cloud.tencent.com/avc?from=17491)后可使用，详见[价格说明](https://cloud.tencent.com/document/product/269/11673?from=17472#.E5.9F.BA.E7.A1.80.E6.9C.8D.E5.8A.A1.E8.AF.A6.E6.83.85)。
 */
- (void)followUser:(NSArray<NSString *> *)userIDList succ:(V2TIMFollowOperationResultListSucc)succ fail:(V2TIMFail)fail;

/**
 *  7.2 取消关注用户（从 7.8 版本开始支持）
 * 
 *  @note
 *   - 该功能为 IM 旗舰版功能，[购买旗舰版套餐包](https://buy.cloud.tencent.com/avc?from=17491)后可使用，详见[价格说明](https://cloud.tencent.com/document/product/269/11673?from=17472#.E5.9F.BA.E7.A1.80.E6.9C.8D.E5.8A.A1.E8.AF.A6.E6.83.85)。
 */
- (void)unfollowUser:(NSArray<NSString *> *)userIDList succ:(V2TIMFollowOperationResultListSucc)succ fail:(V2TIMFail)fail;

/**
 *  7.3 获取我的关注列表（从 7.8 版本开始支持）
 * 
 *  @note
 *   - 该功能为 IM 旗舰版功能，[购买旗舰版套餐包](https://buy.cloud.tencent.com/avc?from=17491)后可使用，详见[价格说明](https://cloud.tencent.com/document/product/269/11673?from=17472#.E5.9F.BA.E7.A1.80.E6.9C.8D.E5.8A.A1.E8.AF.A6.E6.83.85)。
 * 
 *  @param nextCursor  分页拉取标志，第一次拉取填 nil 或 @""，回调成功如果 nextCursor 不为 @""，需要分页，可以传入该值再次拉取，直至 nextCursor 返回为 @""
 * 
 *  @note
 *   - 该功能为 IM 旗舰版功能，[购买旗舰版套餐包](https://buy.cloud.tencent.com/avc?from=17491)后可使用，详见[价格说明](https://cloud.tencent.com/document/product/269/11673?from=17472#.E5.9F.BA.E7.A1.80.E6.9C.8D.E5.8A.A1.E8.AF.A6.E6.83.85)。
 */
- (void)getMyFollowingList:(NSString *)nextCursor succ:(V2TIMUserInfoResultSucc)succ fail:(V2TIMFail)fail;

/**
 *  7.4 获取我的粉丝列表（从 7.8 版本开始支持）
 * 
 *  @param nextCursor  分页拉取标志，第一次拉取填 nil 或 @""，回调成功如果 nextCursor 不为 @""，需要分页，可以传入该值再次拉取，直至 nextCursor 返回为 @""
 * 
 *  @note
 *   - 该功能为 IM 旗舰版功能，[购买旗舰版套餐包](https://buy.cloud.tencent.com/avc?from=17491)后可使用，详见[价格说明](https://cloud.tencent.com/document/product/269/11673?from=17472#.E5.9F.BA.E7.A1.80.E6.9C.8D.E5.8A.A1.E8.AF.A6.E6.83.85)。
 */
- (void)getMyFollowersList:(NSString *)nextCursor succ:(V2TIMUserInfoResultSucc)succ fail:(V2TIMFail)fail;

/**
 *  7.5 获取我的互关列表（从 7.8 版本开始支持）
 * 
 *  @param nextCursor  分页拉取标志，第一次拉取填 nil 或 @""，回调成功如果 nextCursor 不为 @""，需要分页，可以传入该值再次拉取，直至 nextCursor 返回为 @""
 * 
 *  @note
 *   - 该功能为 IM 旗舰版功能，[购买旗舰版套餐包](https://buy.cloud.tencent.com/avc?from=17491)后可使用，详见[价格说明](https://cloud.tencent.com/document/product/269/11673?from=17472#.E5.9F.BA.E7.A1.80.E6.9C.8D.E5.8A.A1.E8.AF.A6.E6.83.85)。
 */
- (void)getMutualFollowersList:(NSString *)nextCursor succ:(V2TIMUserInfoResultSucc)succ fail:(V2TIMFail)fail;

/**
 *  7.6 获取指定用户的 关注/粉丝/互关 数量信息（从 7.8 版本开始支持）
 * 
 *  @note
 *   - 该功能为 IM 旗舰版功能，[购买旗舰版套餐包](https://buy.cloud.tencent.com/avc?from=17491)后可使用，详见[价格说明](https://cloud.tencent.com/document/product/269/11673?from=17472#.E5.9F.BA.E7.A1.80.E6.9C.8D.E5.8A.A1.E8.AF.A6.E6.83.85)。
 */
- (void)getUserFollowInfo:(NSArray *)userIDList succ:(V2TIMFollowInfoResultListSucc)succ fail:(V2TIMFail)fail;

/**
 *  7.7 检查指定用户的关注类型（从 7.8 版本开始支持）
 * 
 *  @note
 *   - 该功能为 IM 旗舰版功能，[购买旗舰版套餐包](https://buy.cloud.tencent.com/avc?from=17491)后可使用，详见[价格说明](https://cloud.tencent.com/document/product/269/11673?from=17472#.E5.9F.BA.E7.A1.80.E6.9C.8D.E5.8A.A1.E8.AF.A6.E6.83.85)。
 */
- (void)checkFollowType:(NSArray<NSString *> *)userIDList succ:(V2TIMFollowTypeCheckResultListSucc)succ fail:(V2TIMFail)fail;

@end

/////////////////////////////////////////////////////////////////////////////////
//
//                      资料关系链回调
//
/////////////////////////////////////////////////////////////////////////////////
/// 资料关系链回调
V2TIM_EXPORT @protocol V2TIMFriendshipListener <NSObject>
@optional
/**
 *  好友申请新增通知,两种情况会收到这个回调：
 *  1. 自己申请加别人好友
 *  2. 别人申请加自己好友
 */
- (void)onFriendApplicationListAdded:(NSArray<V2TIMFriendApplication *> *)applicationList;

/**
 *  好友申请删除通知，四种情况会收到这个回调：
 *  1. 调用 deleteFriendApplication 主动删除好友申请
 *  2. 调用 refuseFriendApplication 拒绝好友申请
 *  3. 调用 acceptFriendApplication 同意好友申请
 *  4. 申请加别人好友被拒绝
 */
- (void)onFriendApplicationListDeleted:(NSArray *)userIDList;

/**
 *  好友申请已读通知，如果调用 setFriendApplicationRead 设置好友申请列表已读，会收到这个回调（主要用于多端同步）
 */
- (void)onFriendApplicationListRead;

/**
 *  好友新增通知
 */
- (void)onFriendListAdded:(NSArray<V2TIMFriendInfo *>*)infoList;

/**
 *  好友删除通知，两种情况会收到这个回调：
 *  1. 自己删除好友（单向和双向删除都会收到回调）
 *  2. 好友把自己删除（双向删除会收到）
 */
- (void)onFriendListDeleted:(NSArray*)userIDList;

/**
 *  黑名单新增通知
 */
- (void)onBlackListAdded:(NSArray<V2TIMFriendInfo *>*)infoList;

/**
 *  黑名单删除通知
 */
- (void)onBlackListDeleted:(NSArray*)userIDList;

/**
 *  好友资料变更通知
 */
- (void)onFriendProfileChanged:(NSArray<V2TIMFriendInfo *> *)infoList;

/**
 *  订阅公众号通知
 */
- (void)onOfficialAccountSubscribed:(V2TIMOfficialAccountInfo *)officialAccountInfo;

/**
 *  取消订阅公众号通知
 */
- (void)onOfficialAccountUnsubscribed:(NSString *)officialAccountID;

/**
 *  订阅的公众号被删除通知
 */
- (void)onOfficialAccountDeleted:(NSString *)officialAccountID;

/**
 *  订阅的公众号资料更新通知
 */
- (void)onOfficialAccountInfoChanged:(V2TIMOfficialAccountInfo *)officialAccountInfo;

/**
 *  关注列表变更通知
 */
- (void)onMyFollowingListChanged:(NSArray<V2TIMUserFullInfo *> *)userInfoList isAdd:(BOOL)isAdd NS_SWIFT_NAME(onMyFollowingListChanged(userInfoList:isAdd:));

/**
 *  粉丝列表变更通知
 */
- (void)onMyFollowersListChanged:(NSArray<V2TIMUserFullInfo *> *)userInfoList isAdd:(BOOL)isAdd;

/**
 *  互关列表变更通知
 */
- (void)onMutualFollowersListChanged:(NSArray<V2TIMUserFullInfo *> *)userInfoList isAdd:(BOOL)isAdd;

@end

/////////////////////////////////////////////////////////////////////////////////
//
//                      好友资料获取结果
//
/////////////////////////////////////////////////////////////////////////////////
/// 好友资料获取结果
V2TIM_EXPORT @interface V2TIMFriendInfoResult : NSObject

/// 返回码
@property(nonatomic,assign) int resultCode;

/// 返结果表述
@property(nonatomic,strong) NSString *resultInfo;

/// 好友类型
@property(nonatomic,assign) V2TIMFriendRelationType relation;

/// 好友个人资料，如果不是好友，除了 userID 字段，其他字段都为空
@property(nonatomic,strong) V2TIMFriendInfo *friendInfo;
@end

/////////////////////////////////////////////////////////////////////////////////
//
//                      好友资料
//
/////////////////////////////////////////////////////////////////////////////////
/// 好友资料
V2TIM_EXPORT @interface V2TIMFriendInfo : NSObject

/// 好友 ID
@property(nonatomic,strong) NSString *userID;

/**
 * 好友备注
 *
 * @note
 * - 备注长度最长不得超过 96 个字节;
 * - 字段描述详见 [控制台](https://cloud.tencent.com/document/product/269/1501#.E6.A0.87.E9.85.8D.E5.A5.BD.E5.8F.8B.E5.AD.97.E6.AE.B5)。
*/
@property(nonatomic,strong) NSString *friendRemark;

/// 添加好友的 UTC 时间戳
@property(nonatomic,assign,readonly) uint64_t friendAddTime;

/// 好友自定义字段
/// 首先要在 [控制台](https://console.cloud.tencent.com/im) (功能配置 -> 好友自定义字段) 配置好友自定义字段，然后再调用该接口进行设置，key 值不需要加 Tag_SNS_Custom_ 前缀。
@property(nonatomic,strong) NSDictionary<NSString *,NSData *> *friendCustomInfo;

/**
 * 好友所在分组列表
 *
 * @note
 * - 最多支持 32 个分组；
 * - 不允许分组名为空；
 * - 分组名长度不得超过 30 个字节；
 * - 同一个好友可以有多个不同的分组。
 * - 字段描述详见 [控制台](https://cloud.tencent.com/document/product/269/1501#.E6.A0.87.E9.85.8D.E5.A5.BD.E5.8F.8B.E5.AD.97.E6.AE.B5)。
*/
@property(nonatomic,strong,readonly) NSArray *friendGroups;

/// 好友个人资料
@property(nonatomic,strong,readonly) V2TIMUserFullInfo *userFullInfo;

@end

/////////////////////////////////////////////////////////////////////////////////
//
//                      好友申请相关对象
//
/////////////////////////////////////////////////////////////////////////////////

/// 加好友
V2TIM_EXPORT @interface V2TIMFriendAddApplication : NSObject

/// 用户 userID（必填）
@property (nonatomic,strong) NSString* userID;

/// 备注（备注最大96字节）
@property (nonatomic,strong) NSString* friendRemark;

/// 预分组名（最大96字节）
@property (nonatomic,strong) NSString* friendGroup;

/// 请求说明（最大120字节）
@property (nonatomic,strong) NSString* addWording;

/// 添加来源
@property (nonatomic,strong) NSString* addSource;

/// 加好友方式
@property (nonatomic,assign) V2TIMFriendType addType;

@end

/// 好友申请列表
V2TIM_EXPORT @interface V2TIMFriendApplicationResult : NSObject

/// 好友申请未读数量
@property(nonatomic,assign) uint64_t unreadCount;

/// 好友申请列表
@property(nonatomic,strong) NSMutableArray<V2TIMFriendApplication *> * applicationList;

@end

/// 好友申请
V2TIM_EXPORT @interface V2TIMFriendApplication : NSObject

/// 用户标识
@property(nonatomic,strong,readonly) NSString* userID;

/// 用户昵称
@property(nonatomic,strong,readonly) NSString* nickName;

/// 用户头像
@property(nonatomic,strong,readonly) NSString* faceUrl;

/// 添加好友的 UTC 时间戳
@property(nonatomic,assign,readonly) uint64_t addTime;

/// 来源
@property(nonatomic,strong,readonly) NSString* addSource;

/// 加好友附言
@property(nonatomic,strong,readonly) NSString* addWording;

/// 好友申请类型
@property(nonatomic,assign,readonly) V2TIMFriendApplicationType type;

@end

/////////////////////////////////////////////////////////////////////////////////
//
//                    好友关系链检查结果
//
/////////////////////////////////////////////////////////////////////////////////
/// 好友关系链检查结果
V2TIM_EXPORT @interface V2TIMFriendCheckResult : NSObject

/// 用户id
@property(nonatomic,strong) NSString* userID;

/// 返回码
@property(nonatomic,assign) NSInteger resultCode;

/// 返回信息
@property(nonatomic,strong) NSString *resultInfo;

/// 检查结果
@property(nonatomic,assign) V2TIMFriendRelationType relationType;

@end

/////////////////////////////////////////////////////////////////////////////////
//
//                 好友操作结果（添加、删除、加黑名单、添加分组等）
//
/////////////////////////////////////////////////////////////////////////////////
/// 好友操作结果（添加、删除、加黑名单、添加分组等）
V2TIM_EXPORT @interface V2TIMFriendOperationResult : NSObject

/// 用户Id
@property(nonatomic,strong) NSString* userID;

/// 返回码
@property(nonatomic,assign) NSInteger resultCode;

/// 返回信息
@property(nonatomic,strong) NSString *resultInfo;

@end

/////////////////////////////////////////////////////////////////////////////////
//
//                    好友分组
//
/////////////////////////////////////////////////////////////////////////////////
/// 好友分组
V2TIM_EXPORT @interface V2TIMFriendGroup : NSObject
/// 好友分组名称
@property(nonatomic,strong) NSString* groupName;

/// 分组成员数量
@property(nonatomic,assign) uint64_t userCount;

/// 分组成员列表
@property(nonatomic,strong) NSMutableArray* friendList;

@end

/////////////////////////////////////////////////////////////////////////////////
//
//                    好友搜索
//
/////////////////////////////////////////////////////////////////////////////////

V2TIM_EXPORT @interface V2TIMFriendSearchParam : NSObject

/// 搜索的关键字列表，关键字列表最多支持 5 个
@property(nonatomic, strong) NSArray<NSString *> *keywordList;

/// 设置是否搜索 userID
@property(nonatomic, assign) BOOL isSearchUserID;

/// 是否设置搜索昵称
@property(nonatomic, assign) BOOL isSearchNickName;

/// 是否设置搜索备注
@property(nonatomic, assign) BOOL isSearchRemark;;

@end

/////////////////////////////////////////////////////////////////////////////////
//
//                    公众号资料
//
/////////////////////////////////////////////////////////////////////////////////
V2TIM_EXPORT @interface V2TIMOfficialAccountInfo : NSObject

/// 公众号 ID
@property(nonatomic,strong,readonly) NSString* officialAccountID;

/// 公众号名称
@property(nonatomic,strong,readonly) NSString* officialAccountName;

/// 公众号头像
@property(nonatomic,strong,readonly) NSString* faceUrl;

/// 公众号所有者
@property(nonatomic,strong,readonly) NSString* ownerUserID;

/// 公众号组织
@property(nonatomic,strong,readonly) NSString* organization;

/// 公众号简介
@property(nonatomic,strong,readonly) NSString* introduction;

/// 公众号自定义数据
@property(nonatomic,strong,readonly) NSString* customData;

/// 公众号创建时间，单位：秒
@property(nonatomic,assign,readonly) uint64_t createTime;

/// 公众号订阅者数量
@property(nonatomic,assign,readonly) uint64_t subscriberCount;

/// 订阅公众号的时间，单位：秒
@property(nonatomic,assign,readonly) uint64_t subscribeTime;

@end

/////////////////////////////////////////////////////////////////////////////////
//
//                      公众号资料获取结果
//
/////////////////////////////////////////////////////////////////////////////////
/// 公众号资料获取结果
V2TIM_EXPORT @interface V2TIMOfficialAccountInfoResult : NSObject

/// 返回码
@property(nonatomic,assign) int resultCode;

/// 返回结果表述
@property(nonatomic,strong) NSString *resultInfo;

/// 公众号资料
@property(nonatomic,strong) V2TIMOfficialAccountInfo *officialAccountInfo;

@end

/////////////////////////////////////////////////////////////////////////////////
//
//                  关注/取关用户的操作结果
//
/////////////////////////////////////////////////////////////////////////////////
/// 关注/取关用户的操作结果
V2TIM_EXPORT @interface V2TIMFollowOperationResult : NSObject

/// 用户 ID
@property(nonatomic,strong) NSString* userID;

/// 返回码
@property(nonatomic,assign) NSInteger resultCode;

/// 返回信息
@property(nonatomic,strong) NSString *resultInfo;

@end

/////////////////////////////////////////////////////////////////////////////////
//
//                      用户关注数量信息获取结果
//
/////////////////////////////////////////////////////////////////////////////////
/// 用户关注数量信息获取结果
V2TIM_EXPORT @interface V2TIMFollowInfo : NSObject

/// 返回码
@property(nonatomic,assign) NSInteger resultCode;

/// 返回结果表述
@property(nonatomic,strong) NSString *resultInfo;

/// 用户 ID
@property(nonatomic,strong) NSString *userID;

/// 用户的关注数量
@property(nonatomic,assign)	uint64_t followingCount;

/// 用户的粉丝数量
@property(nonatomic,assign)	uint64_t followersCount;

/// 用户的互关数量
@property(nonatomic,assign)	uint64_t mutualFollowersCount;

@end

/////////////////////////////////////////////////////////////////////////////////
//
//                     指定用户的关注类型检查结果
//
/////////////////////////////////////////////////////////////////////////////////
/// 指定用户的关注类型检查结果
V2TIM_EXPORT @interface V2TIMFollowTypeCheckResult : NSObject

/// 用户 ID
@property(nonatomic,strong) NSString* userID;

/// 返回码
@property(nonatomic,assign) NSInteger resultCode;

/// 返回信息
@property(nonatomic,strong) NSString *resultInfo;

/// 关注类型
@property(nonatomic,assign) V2TIMFollowType followType;

@end
