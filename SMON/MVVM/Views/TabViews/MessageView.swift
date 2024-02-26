//
//  MessageView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI

struct MessageView: View {
    var exampleConversation: BIMConversation {
        return BIMConversation()
    }

    var body: some View {
        VStack {
            ConversationListContainer()
                .frame(maxWidth: .infinity)
                .ignoresSafeArea(.keyboard)
        }
    }
}

#Preview {
    MessageView()
}
