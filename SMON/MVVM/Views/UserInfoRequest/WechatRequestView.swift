//
//  WechatRequestView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/29.
//

import SwiftUI

struct WechatRequestView: View {
    @StateObject var wechatSettingVM: WechatSettingViewModel = .init(wechat: "", threshold: "")
    @EnvironmentObject var vm: UserInfoRequestViewModel
    var body: some View {
        InfoRequestView(title: "填写微信号", subline: "💰 应用内可设置解锁您的微信所需要的礼物价格。凭口令码加你。保护你的安全。", icon: "inforequest_wechat", btnEnable: !vm.wechat.isEmpty) {
            VStack(alignment: .leading, spacing: 12, content: {
                XMSection(title: "微信号", footer: "") {
                    VStack(alignment: .leading, spacing: 12, content: {
                        TextField("微信号", text: $wechatSettingVM.wechat)
                            
                        Divider()
                    })
                }
                XMSection(title: "设置他人如何解锁你的微信(当前为\(wechatSettingVM.threshold)赛币)", footer: "") {
                    Picker(selection: $wechatSettingVM.pikcerIndex) {
                        ForEach(wechatSettingVM.settingPrice, id: \.self) { index in
                            Text("送出礼物价值 >= \(index)赛币")
                                .font(.headline)
                                .bold()
                                .tag(index)
                        }
                    }
                    .pickerStyle(.wheel)
                }
            })

        } btnAction: {
            let result = await UserManager.shared.updateUserWechatSetting(contactValue: vm.wechat, threshold: wechatSettingVM.threshold)
            if result.is2000Ok {
                vm.presentedSteps.append(.bio)
            }
        }
        .canSkip {
            vm.presentedSteps.append(.bio)
        }
    }
}

#Preview {
    WechatRequestView()
        .environmentObject(UserInfoRequestViewModel())
}
