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
        InfoRequestView(title: "填写微信号，方便真实优质的会员联系你", subline: "平台会定期清除虚假的联系信息并执行封号处理，真实用户将被平台优先展示。", icon: "inforequest_wechat", btnEnable: true) {
            VStack(alignment: .leading, spacing: 12, content: {
                Text("微信号")
                    .font(.caption)
                    .foregroundStyle(Color.XMDesgin.f3)
                TextField("请输入微信号", text: $vm.name)
                    .autoOpenKeyboard()
                    .foregroundStyle(Color.XMDesgin.f1)
                    .tint(Color.XMDesgin.main)
                Capsule()
                    .frame(height: 1)
                    .foregroundColor(Color.XMDesgin.f3)
            })
            Text("🚪 后续支持自定义解锁价格")
                .font(.body)
                .foregroundStyle(Color.XMDesgin.f1)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Capsule().fill(Color.XMDesgin.b1))
        } btnAction: {
            vm.presentedSteps.append(.bio)
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
