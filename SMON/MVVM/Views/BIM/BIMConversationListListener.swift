//
//  BIMConversationListListener.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/26.
//

import Foundation

class BIMConversationListener: NSObject, BIMConversationListListener {
    func onNewConversation(_ conversationList: [BIMConversation]) {
        conversationList.forEach { conversation in
            let userId = conversation.oppositeUserID
           
        }
    }
}
