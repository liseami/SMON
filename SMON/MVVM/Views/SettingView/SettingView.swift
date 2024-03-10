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
                                case "黑名单":
                                    MainViewModel.shared.pathPages.append(SettingViewModel.PagePath.blackList)
                                case "通知":
                                    MainViewModel.shared.pathPages.append(SettingViewModel.PagePath.notificationSetting)
                                case "邀请好友":
                                    MainViewModel.shared.pathPages.append(SettingViewModel.PagePath.inviteFriends)
                                case "App信息":
                                    MainViewModel.shared.pathPages.append(SettingViewModel.PagePath.appInfo)
                                case "分享App": break
                                case "去AppleStore评分": goAppStoreToRateApp()
                                case "第三方SDK信息共享清单":
                                    MainViewModel.shared.pathPages.append(SettingViewModel.PagePath.thirdPartySDKInfo)
                                case "账户注销":
                                    UserManager.shared.logOut()
                                case "退出登录":
                                    UserManager.shared.logOut()
                                default:
                                    break
                                }
                            }
                            .listRowInsets(.init(top: 32, leading: 018, bottom: 24, trailing: 24))
                            .listRowSeparator(.hidden, edges: .all)
                        }
                    }
                } header: {
                    Text(group.name)
                        .font(.XMFont.f1b)
                        .fcolor(.XMDesgin.f1)
                        .padding(.vertical, 6)
                }
            }

            VStack(alignment: .center, spacing: 12) {
                Text("Made with peace & love in Suzhou ♥️")
                    .font(.XMFont.f2b)
                    .fcolor(.XMDesgin.f1)
                Text("SMON Version" + AppConfig.AppVersion)
                    .font(.XMFont.f1b)
                    .fcolor(.XMDesgin.f2)
            }
            .padding(.top, 32)
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }

        .navigationDestination(for: SettingViewModel.PagePath.self, destination: { page in
            Group {
                switch page {
                case .blackList:
                    BlackListView()
                case .notificationSetting:
                    NotificationSettingView()
                case .inviteFriends:
                    InviteFriendsView()
                case .appInfo:
                    AppInfoView()
                case .thirdPartySDKInfo:
                    ThirdPartySDKInfoView()
                case .accountCancellation:
                    AccountCancellationView()
                }
            }
            .navigationBarTransparent(false)
            .toolbarRole(.editor)
        })

        .scrollIndicators(.hidden)
        .listStyle(.plain)
        .navigationTitle("设置")
        .navigationBarTitleDisplayMode(.large)
    }

    func goAppStoreToRateApp() {
        guard let writeReviewURL = URL(string: "\(AppConfig.AppStoreURL)?action=write-review")
        else { fatalError("Expected a valid URL") }
        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
    }
}

#Preview {
    NavigationStack(path: .constant(NavigationPath.init())) {
        SettingView()
    }
}
