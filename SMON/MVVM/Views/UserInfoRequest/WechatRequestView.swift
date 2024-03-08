//
//  WechatRequestView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/29.
//

import SwiftUI

struct WechatRequestView: View {
    @EnvironmentObject var vm: UserInfoRequestViewModel
    var body: some View {
        InfoRequestView(title: "填写微信号", subline: "方便真实优质的会员联系你。平台会定期清除虚假的联系信息并执行封号处理，真实用户将被平台优先展示。", icon: "inforequest_wechat", btnEnable: !vm.wechat.isEmpty) {
            VStack(alignment: .leading, spacing: 12, content: {
                Text("微信号")
                    .font(.XMFont.f3)
                    .fcolor(.XMDesgin.f3)
                   
                HStack {
                    TextField("请输入微信号", text: $vm.wechat)
                        .autoOpenKeyboard()
                        .font(.XMFont.f1)
                        .fcolor(.XMDesgin.f1)
                        .tint(Color.XMDesgin.main)
                    Text("🚪 未来支持自定义解锁价格")
                        .font(.XMFont.f3).bold()
                        .fcolor(.XMDesgin.f1)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(Color.XMDesgin.b1))
                }
                Capsule()
                    .frame(height: 1)
                    .fcolor(.XMDesgin.f3)
            })
        } btnAction: {
            let result = await UserManager.shared.updateUserInfo(updateReqMod: .init(wechat: vm.wechat))
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
