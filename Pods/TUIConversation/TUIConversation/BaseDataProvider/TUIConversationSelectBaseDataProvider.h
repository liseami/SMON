//
//  TUIConversationSelectModel.h
//  TXIMSDK_TUIKit_iOS
//
//  Created by xiangzhang on 2021/6/25.
//  Copyright © 2023 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TIMCommon/TIMCommonModel.h>
#import "TUIConversationCellData.h"

NS_ASSUME_NONNULL_BEGIN

@interface TUIConversationSelectBaseDataProvider : NSObject
@property(nonatomic, strong) NSArray<TUIConversationCellData *> *dataList;

- (void)loadConversations;

// subclass override
- (Class)getConversationCellClass;
@end

NS_ASSUME_NONNULL_END
