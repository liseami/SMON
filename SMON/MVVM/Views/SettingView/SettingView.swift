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
                                    shareApp()
//                                    MainViewModel.shared.pathPages.append(SettingViewModel.PagePath.inviteFriends)
                                case "App信息":
                                    MainViewModel.shared.pathPages.append(SettingViewModel.PagePath.appInfo)
                                case "分享App": shareApp()
                                case "去AppStore评分": rateApp()
                                case "第三方SDK信息共享清单":
                                    MainViewModel.shared.pathPages.append(SettingViewModel.PagePath.thirdPartySDKInfo)
                                case "账户注销":
                                    UserManager.shared.goodBye()
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

    /*
     分享App
     */
    func shareApp() {
        // 要分享的内容
        let shareText = "我正在使用每日大赛APP官方版本，现邀请你加入。 " // 分享时附带的介绍语
        let appURL = AppConfig.AppStoreURL // 你应用在App Store的链接
        // 创建分享项目数组
        let objectsToShare = [shareText, appURL] as [Any]
        // 创建分享视图控制器
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        // 设置可以在分享视图中显示的活动类型(例如邮件、Twitter等)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        // 显示分享视图
        Apphelper.shared.topMostViewController()?.present(activityVC, animated: true, completion: nil)
    }

    /*
     评价APP
      */
    func rateApp() {
        guard let writeReviewURL = URL(string: AppConfig.AppStoreURL.absoluteString + "?action=write-review") else {
            return
        }

        if UIApplication.shared.canOpenURL(writeReviewURL) {
            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
        } else {
            // 在这里处理无法打开App Store的情况
        }
    }
}

#Preview {
    NavigationStack(path: .constant(NavigationPath())) {
        SettingView()
    }
}
