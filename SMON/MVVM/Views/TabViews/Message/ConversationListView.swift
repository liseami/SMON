//
//  MessageView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI

struct ConversationListView: View {
    var body: some View {
        ConversationListContainer()
            .navigationTitle("消息")
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea()
    }
}

#Preview {
    ConversationListView()
}
