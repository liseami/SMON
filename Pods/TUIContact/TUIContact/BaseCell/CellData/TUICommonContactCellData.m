//
//  TCommonFriendCellData.m
//  TXIMSDK_TUIKit_iOS
//
//  Created by annidyfeng on 2019/5/7.
//  Copyright © 2023 Tencent. All rights reserved.
//

#import "TUICommonContactCellData.h"
#import <TIMCommon/TIMCommonModel.h>
#import <TIMCommon/TIMDefine.h>

@implementation TUICommonContactCellData {
    V2TIMFriendInfo *_friendProfile;
}

- (instancetype)initWithFriend:(V2TIMFriendInfo *)args {
    self = [super init];

    if (args.friendRemark.length) {
        _title = args.friendRemark;
    } else {
        _title = [args.userFullInfo showName];
    }

    _identifier = args.userID;
    _avatarUrl = [NSURL URLWithString:args.userFullInfo.faceURL];
    _friendProfile = args;

    return self;
}

- (instancetype)initWithGroupInfo:(V2TIMGroupInfo *)args {
    self = [super init];

    _title = args.groupName;
    _avatarImage = DefaultGroupAvatarImageByGroupType(args.groupType);
    _avatarUrl = [NSURL URLWithString:args.faceURL];
    _identifier = args.groupID;

    return self;
}

- (NSComparisonResult)compare:(TUICommonContactCellData *)data {
    return [self.title localizedCompare:data.title];
}

- (CGFloat)heightOfWidth:(CGFloat)width {
    return 56;
}
@end
