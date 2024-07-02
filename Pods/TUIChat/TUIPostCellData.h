//
//  TUIPostCellData.h
//  TUIChat
//
//  Created by mac xiao on 2024/6/24.
//

#import <TIMCommon/TUIBubbleMessageCellData.h>

NS_ASSUME_NONNULL_BEGIN

@interface TUIPostCellData : TUIMessageCellData

@property NSString *ImageUrl;
@property NSString *content;
@property NSString *postId;
@property NSString *postUserId;


@end

NS_ASSUME_NONNULL_END
