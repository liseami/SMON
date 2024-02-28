//
//  SettingView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/25.
//

import SwiftUI

struct SettingView: View {
    @StateObject var vm: SettingViewModel = .init()
    var body: some View {
        List {
            #if DEBUG

            NavigationLink {
                XMUIDesginSystemView()
            } label: {
                Text("XMUI组件")
            }

            #endif

            ForEach(vm.settingGroup, id: \.self.name) { group in
                Section {
                    if let child = group.children {
                        ForEach(child, id: \.name) { child in
                            Label {
                                Text(child.name)
                            } icon: {
                                XMDesgin.XMIcon(iconName: child.iconName ?? "", color: .white)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, -2)
                        }
                    }
                } header: {
                    Text(group.name)
                        .font(.body)
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.vertical)
                }
            }

            XMDesgin.XMMainBtn(fColor: Color.red, text: "退出登陆") {
                UserManager.shared.logout()
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(.insetGrouped)
        .navigationTitle("设置")
    }
}

#Preview {
    NavigationView(content: {
        SettingView()
    })
//    ProfileView()
}
