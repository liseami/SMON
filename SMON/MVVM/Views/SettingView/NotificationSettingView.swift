//
//  NotificationSettingView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/10.
//

import SwiftUI

struct NotificationSettingView: View {
    var body: some View {
        List {
            XMSection(title: "通知开关") {
                Group {
                    Toggle(isOn: .constant(true), label: {
                        Text("私信")
                    })
                    Toggle(isOn: .constant(true), label: {
                        Text("动态点赞、评论")
                    })
                    Toggle(isOn: .constant(true), label: {
                        Text("收获礼物")
                    })
                    Toggle(isOn: .constant(true), label: {
                        Text("收获火苗")
                    })
                    Toggle(isOn: .constant(true), label: {
                        Text("大赛")
                    })
                    Toggle(isOn: .constant(true), label: {
                        Text("全局开关")
                    })
                }
            }
        }
        .navigationTitle("通知")
        .listStyle(.plain)
    }
}

#Preview {
    NotificationSettingView()
}
