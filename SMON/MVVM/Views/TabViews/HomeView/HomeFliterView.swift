//
//  HomeFliterView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/26.
//

import SwiftUI

struct HomeFliterView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var age: Float = 12
    var body: some View {
        NavigationView(content: {
            List {
                VStack(alignment: .leading, spacing: 12, content: {
                    Text("年龄")
                    Slider(value: $age)
                        .tint(Color(hex: "AA7E1F"))
                })
                VStack(alignment: .leading, spacing: 12, content: {
                    Text("距离")
                    Slider(value: $age)
                        .tint(Color(hex: "AA7E1F"))
                })
                HStack(alignment: .center, spacing: 12, content: {
                    Text("向我显示")
                    Spacer()
                    Text("女性")
                })
            }
            .listStyle(.sidebar)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    XMDesgin.XMIcon(iconName: "system_checkmark")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    XMDesgin.XMIcon(iconName: "system_xmark")
                        .onTapGesture {
                            presentationMode.dismiss()
                        }
                }
            })
            .navigationTitle("用户筛选")
            .navigationBarTitleDisplayMode(.inline)
        })
    }
}

#Preview {
    HomeFliterView()
}
