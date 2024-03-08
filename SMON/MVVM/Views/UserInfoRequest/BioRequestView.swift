//
//  SmokeRequestView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import SwiftUI

struct BioRequestView: View {
    @EnvironmentObject var vm: UserInfoRequestViewModel
    var body: some View {
        InfoRequestView(title: "最后，关于我，我还想说...", subline: "认真地编辑自我介绍，更容易变得万众瞩目哦。", btnEnable: !vm.bio.isEmpty) {
            TextEditor(text: $vm.bio)
                .tint(Color.XMDesgin.main)
                .scrollContentBackground(.hidden)
                .background(Color.XMDesgin.b1)
                .font(.XMFont.f1).fcolor(.XMDesgin.f1)
                .padding(.all, 12)
                .frame(height: 160)
                .background(Color.XMDesgin.b1)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .autoOpenKeyboard()
        } btnAction: {
            let result = await UserManager.shared.updateUserInfo(updateReqMod: .init(signature: vm.bio))
            if result.is2000Ok {
                vm.showCompleteView = true
            }
        }
        .canSkip {
            vm.showCompleteView = true
        }
    }
}

#Preview {
    BioRequestView()
        .environmentObject(UserInfoRequestViewModel())
}
