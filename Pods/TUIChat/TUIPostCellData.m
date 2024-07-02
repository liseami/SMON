//
//  TUIPostCellData.m
//  TUIChat
//
//  Created by mac xiao on 2024/6/24.
//

#import "TUIPostCellData.h"

@implementation TUIPostCellData

+ (TUIPostCellData *)getCellData:(V2TIMMessage *)message {
        NSDictionary *param = [NSJSONSerialization JSONObjectWithData:message.customElem.data options:NSJSONReadingAllowFragments error:nil];
    TUIPostCellData *cellData = [[TUIPostCellData alloc] initWithDirection:message.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
        cellData.innerMessage = message;
        cellData.msgID = message.msgID;
        cellData.ImageUrl = param[@"ImageUrl"];
        cellData.content = param[@"content"];
        cellData.postId = param[@"postId"];
        cellData.postUserId = param[@"postUserId"];
        cellData.avatarUrl = [NSURL URLWithString:message.faceURL];
        return cellData;
 }

+ (NSString *)getDisplayString:(V2TIMMessage *)message {
    return @"分享了你一个帖子";
}



@end
