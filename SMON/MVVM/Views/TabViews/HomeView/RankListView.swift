//
//  RankListView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/2.
//

import SwiftUI

struct RankListView: View {
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 16) {
                ForEach(0...99, id: \.self) { index in
                    XMDesgin.XMButton {} label: {
                        VStack {
                            WebImage(str: AppConfig.mokImage!.absoluteString)
                                .scaledToFit()
                                .frame(width: 100, height: 100) // Adjust the size as needed
                                .clipShape(Circle())
                            Text(String.randomChineseString(length: Int.random(in: 2...8)))
                                .font(.subheadline)
                                .bold()
                                .lineLimit(1)
                            Text("苏州")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .conditionalEffect(.smoke(layer: .local), condition: index < 3)
                }
            }
            .padding(.all)
        }.scrollIndicators(.hidden)
            .refreshable {}
    }
}

#Preview {
    MainView(vm: .init(currentTabbar: .home))
}
