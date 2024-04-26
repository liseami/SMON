//
//  SocialAccountView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/4/24.
//

import SwiftUI

struct WechatSettingInfo: Convertible {
    var contactType: String = "" // ": "wechat",
    var maskValue: String = "" // ": "zh*******85",
    var threshold: String = "" // ": 10
}

class SocialAccountViewModel: XMModRequestViewModel<WechatSettingInfo> {
    init() {
        super.init(pageName: "") {
            UserRelationAPI.contactSettingView(contactType: "wechat")
        }
    }
}

struct SocialAccountView: View {
    @StateObject var vm: SocialAccountViewModel = .init()
    var body: some View {
        NavigationView(content: {
            List {
                XMSection(title: "礼物门槛设置", footer: "* 每日大赛系统会生成一个口令码，防止乱加。每个解锁你微信的用户都会得到唯一的口令码。") {
                    NavigationLink {
                        WechatSettingView(wechat: vm.mod.maskValue, threshold: vm.mod.threshold)
                            .navigationTitle("礼物门槛设置")
                            .toolbarRole(.editor)
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        XMDesgin.XMListRow(.init(name: vm.mod.maskValue, icon: "inforequest_wechat", subline: vm.mod.threshold), showRightArrow: false) {}
                            .disabled(true)
                    }
                }

                XMSection(title: "解锁信息") {
                    
                    NavigationLink {
                        UnlockedMeView()
                            .navigationTitle("解锁了我的")
                            .toolbarRole(.editor)
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        XMDesgin.XMListRow(.init(name: "解锁了我的", icon: "", subline: ""),showRightArrow: false) {}.disabled(true)
                    }
                    
                    NavigationLink {
                        MyUnlockView()
                            .navigationTitle("我解锁的")
                            .toolbarRole(.editor)
                            .navigationBarTitleDisplayMode(.inline)
                 
                    } label: {
                        XMDesgin.XMListRow(.init(name: "我解锁的", icon: "", subline: ""),showRightArrow: false) {}.disabled(true)
                    }

                   
                }
            }
            .listStyle(.grouped)
            .navigationTitle("微信号解锁管理")
            .navigationBarTitleDisplayMode(.inline)

        })
        .navigationViewStyle(.stack)
        .tint(Color.XMDesgin.f1)
    }
}

#Preview {
    SocialAccountView()
}
