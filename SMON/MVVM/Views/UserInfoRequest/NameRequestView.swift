//
//  NameRequestView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import SwiftUI

struct InfoRequestView<Content>: View where Content: View {
    var title: String = ""
    var subline: String = ""
    var icon: String?
    var btnEnable: Bool = true
    var btnAction: () async -> Void
    var content: () -> Content

    init(title: String, subline: String, icon: String? = nil, btnEnable: Bool = true, @ViewBuilder content: @escaping () -> Content, btnAction: @escaping () async -> Void) {
        self.title = title
        self.subline = subline
        self.icon = icon
        self.content = content
        self.btnEnable = btnEnable
        self.btnAction = btnAction
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            VStack(alignment: .leading, spacing: 12, content: {
                if let icon {
                    XMDesgin.XMIcon(iconName: icon, size: 32)
                }
                XMTyperText(text: title)
                    .multilineTextAlignment(.leading)
                    .font(.XMFont.big2.bold())
                Text(subline)
                    .font(.XMFont.f1)
                    .fcolor(.XMDesgin.f2)
            })
            content()

            XMDesgin.CircleBtn(backColor: Color.XMDesgin.f1, fColor: Color.XMDesgin.b1, iconName: "system_right", enable: self.btnEnable) {
                await self.btnAction()
            }
            .moveTo(alignment: .bottomTrailing)
        }
        .statusBarHidden(false)
        .padding(.horizontal)
        .padding(.top, 60)
        .padding(.bottom, 16)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct NameRequestView: View {
    @EnvironmentObject var vm: UserInfoRequestViewModel
    var body: some View {
        InfoRequestView(title: "从一个昵称开始\r向会员们介绍你自己", subline: "昵称日后也可以修改。", btnEnable: !vm.name.isEmpty) {
            VStack(alignment: .leading, spacing: 12, content: {
                Text("昵称")
                    .font(.XMFont.f2)
                    .fcolor(.XMDesgin.f3)
                TextField("请输入昵称", text: $vm.name)
                    .font(.XMFont.big2.bold())
                    .autoOpenKeyboard()
                    .fcolor(.XMDesgin.f1)
                    .tint(Color.XMDesgin.main)
                Capsule()
                    .frame(height: 1)
                    .fcolor(.XMDesgin.f3)
            })
        } btnAction: {
            await updateName()
        }
    }

    @MainActor
    func updateName() async {
        let result = await UserManager.shared.updateUserInfo(updateReqMod: .init(nickname: vm.name))
        if result.is2000Ok {
            vm.presentedSteps.append(.photo)
        }
    }
}

#Preview {
    NameRequestView()
        .environmentObject(UserInfoRequestViewModel())
}
