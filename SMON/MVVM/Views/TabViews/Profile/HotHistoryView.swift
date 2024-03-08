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
        HStack(spacing: 16) {
            WebImage(str: AppConfig.mokImage!.absoluteString)
                .frame(width: 56, height: 56)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 4, content: {
                Text("小玩具")
                    .font(.system(.subheadline, design: .rounded, weight: .regular))
                    .foregroundStyle(Color.XMDesgin.f1)
                Text("动态点赞")
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundStyle(Color.XMDesgin.f1)
                Text(Date.now.string(withFormat: "yyyy年MM月-dd日 HH:mm"))
                    .font(.caption)
                    .foregroundStyle(Color.XMDesgin.f2)

            })
            Spacer()
            Text("+392")
                .font(.system(.title2, design: .monospaced, weight: .bold))
                .foregroundStyle(Color.XMDesgin.f1)
        }
    }
}

#Preview {
    HotHistoryView()
}
