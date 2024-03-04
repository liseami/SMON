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

//            NavigationLink {
//                XMUIDesginSystemView()
//            } label: {
//                Text("XMUI组件")
//            }

            #endif

            ForEach(vm.settingGroup, id: \.self.name) { group in
                Section {
                    if let children = group.children {
                        ForEach(children, id: \.name) { child in
                            XMDesgin.XMListRow(.init(name: child.name, icon: child.iconName ?? "", subline: "")) {
                                switch child.name {
                                case "退出登录":
                                    UserManager.shared.user = .init()
                                default: break
                                }
                            }
                            .listRowInsets(.init(top: 32, leading: 018, bottom: 24, trailing: 24))

                            .listRowSeparator(.hidden, edges: .all)
                        }
                    }
                } header: {
                    Text(group.name)
                        .font(.body)
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.vertical, 6)
                }
            }

            VStack(alignment: .center, spacing: 12) {
                Text("Made with peace & love in Suzhou ♥️")
                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                    .foregroundColor(Color.XMDesgin.f1)
                Text("SMON Version" + AppConfig.AppVersion)
                    .font(.system(.body, design: .rounded, weight: .bold))
                    .foregroundColor(Color.XMDesgin.f2)
            }
            .padding(.top, 32)
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .scrollIndicators(.hidden)
        .listStyle(.plain)
        .navigationTitle("设置")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    SettingView()
}
