//
//  TUITipViewCell.h
//  TUIChat
//
//  Created by mac xiao on 2024/6/28.
//

#import <TIMCommon/TUIBubbleMessageCell.h>
#import "XMTipsMessageCellData.h"

NS_ASSUME_NONNULL_BEGIN

@interface TUITipViewCell : TUIMessageCell
@property UILabel *titleLable;
- (void)fillWithData:(XMTipsMessageCellData *)data; // 绘制 UI

@end

NS_ASSUME_NONNULL_END
