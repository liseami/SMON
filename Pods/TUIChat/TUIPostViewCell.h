//
//  TUIPostViewCell.h
//  TUIChat
//
//  Created by mac xiao on 2024/6/24.
//

#import <TIMCommon/TUIBubbleMessageCell.h>
#import "TUIPostCellData.h"

NS_ASSUME_NONNULL_BEGIN

@interface TUIPostViewCell : TUIMessageCell
@property UILabel *titleLable;

@property UILabel *myTitleLabel;  // 展示文本
@property UIImageView *myImageView;  // 链接跳转文本
- (void)fillWithData:(TUIPostCellData *)data; // 绘制 UI


@end

NS_ASSUME_NONNULL_END
