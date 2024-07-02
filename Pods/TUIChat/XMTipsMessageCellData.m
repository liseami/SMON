//
//  XMTipsMessageCellData.m
//  TUIChat
//
//  Created by mac xiao on 2024/6/28.
//

#import "XMTipsMessageCellData.h"

@implementation XMTipsMessageCellData
+ (XMTipsMessageCellData *)getCellData:(V2TIMMessage *)message {
        NSDictionary *param = [NSJSONSerialization JSONObjectWithData:message.customElem.data options:NSJSONReadingAllowFragments error:nil];
    XMTipsMessageCellData *cellData = [[XMTipsMessageCellData alloc] initWithDirection:message.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
        cellData.innerMessage = message;
        cellData.msgID = message.msgID;
        cellData.messageContent = param[@"businessInfo"][@"content"];
        cellData.avatarUrl = [NSURL URLWithString:message.faceURL];
        return cellData;
 }

+ (NSString *)getDisplayString:(V2TIMMessage *)message {
    NSDictionary *param = [NSJSONSerialization JSONObjectWithData:message.customElem.data options:NSJSONReadingAllowFragments error:nil];
    return param[@"text"];
}
@end
