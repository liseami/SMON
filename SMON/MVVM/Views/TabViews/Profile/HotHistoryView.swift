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
            XMDesgin.XMIcon(iconName: "system_toggle")
                .frame(width: 56, height: 56, alignment: .center)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 4, content: {
//                Text("我")
//                    .font(.XMFont.f2)
//                    .fcolor(.XMDesgin.f1)
                Text(Bool.random() ? "购买热度" : Bool.random() ? "火苗兑换" : "冷却buff降温")
                    .font(.XMFont.f1b)
                    .fcolor(.XMDesgin.f1)
                Text(Date.now.string(withFormat: "yyyy年MM月-dd日 HH:mm"))
                    .font(.XMFont.f3)
                    .fcolor(.XMDesgin.f2)

            })
            Spacer()
            Text(Bool.random() ? "+392" : "-131")
                .font(.XMFont.big3.bold())
                .fcolor(.XMDesgin.f1)
        }
        
    }
}

#Preview {
    HotHistoryView()
}
