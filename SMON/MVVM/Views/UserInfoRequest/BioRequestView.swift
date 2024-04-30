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
                Apphelper.shared.presentPanSheet(VStack(spacing: 12) {
                    Text("每日大赛游戏规则！")
                        .font(.XMFont.big3.bold())
                    XMLoginVideo()
                        .ignoresSafeArea()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .frame(height: 120)
                    XMTyperText(text: "每天都举行主题「排位赛」，例如「健身照大赛」、「泳装大赛」、「西装大赛」、「连衣裙大赛」等等😈\r\r用户按照po图参赛，收获点赞，可以提高热度值。全体用户按照「❤️‍🔥热度值」进行排名！\r\r祝你玩的愉快！\r\r别忘了领每天免费的火苗！")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.all, 12)
                        .addBack()
                    Spacer()
                    XMDesgin.XMMainBtn(fColor: .XMDesgin.b1, backColor: .XMDesgin.f1, iconName: "", text: "我知道了！", enable: true) {
                        Task {
                            UserManager.shared.userLoginInfo.isNeedInfo = false
                            await UserManager.shared.getUserInfo()
                            Apphelper.shared.closeSheet()
                        }
                    }
                }.padding(.all, 24)
                    .padding(.top, 24),
                style: .hardSheet)
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
