//
//  HotHistoryView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/8.
//

import SwiftUI

struct HotHistoryView: View {
    var body: some View {
        List {
            ForEach(0 ... 100, id: \.self) { _ in
                row
            }
        }
        .listStyle(.plain)
        .toolbarRole(.editor)
        .navigationTitle("🔥热度历史")
    }

    var row: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4, content: {
                Text("+ 392")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(Color.green)
                Text("动态点赞")
                    .font(.subheadline)
                    .foregroundStyle(Color.XMDesgin.f2)
                Text(Date.now.string(withFormat: "yyyy-MM-dd HH:mm"))
                    .font(.subheadline)
                    .foregroundStyle(Color.XMDesgin.f2)

            })
            Spacer()

            WebImage(str: AppConfig.mokImage!.absoluteString)
                .frame(width: 44, height: 44)
                .clipShape(Circle())
        }
    }
}

#Preview {
    HotHistoryView()
}
