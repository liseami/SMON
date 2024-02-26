//
//  XMUIDesginSystemView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/26.
//

import SwiftUI
import SwiftUIX
import TipKit

struct XMUIDesginSystemView: View {
    var body: some View {
        List {
            Section("小按钮") {
                XMDesgin.SmallBtn {}
            }

            Section("图标") {
                XMDesgin.XMIcon(iconName: "setting_notification")
            }

            Section("SwiftUIX用例") {
                Text("View/statusItem(id:image:) - 添加一个状态栏项目，配置为在单击时显示弹出窗口")
            }
            Section("TipKit") {
                if #available(iOS 17.0, *) {
                    let favoriteLandmarkTip = FavoriteLandmarkTip()
                    TipView(favoriteLandmarkTip, arrowEdge: .bottom)
                } else {
                    EmptyView()
                }
            }
        }
        .task {
            // Configure and load your tips at app launch.
            if #available(iOS 17.0, *) {
                try? Tips.configure([
                    .displayFrequency(.immediate),
                    .datastoreLocation(.applicationDefault)
                ])
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

#Preview {
    XMUIDesginSystemView()
}

struct FavoriteLandmarkTip: Tip {
    var id: String {
        return "1"
    }

    var title: Text {
        Text("Save as a Favorite")
    }

    var message: Text? {
        Text("Your favorite landmarks always appear at the top of the list.")
    }

    var image: Image? {
        Image(systemName: "star")
    }
}
