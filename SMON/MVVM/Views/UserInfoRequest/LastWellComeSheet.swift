//
//  LastWellComeSheet.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/5/8.
//

import SwiftUI

struct LastWellComeSheet: View {
    @State private var show: Bool = false
    var body: some View {
        VStack(spacing: 12) {
            Text("每日大赛游戏规则！")
                .font(.XMFont.big3.bold())
            AutoLottieView(lottieFliesName: "okk", loopMode: .loop)
                .frame(height: 120)
                .scaleEffect(3)
                .transition(.movingParts.move(edge: .bottom).combined(with: .scale(scale: 2)).animation(.bouncy(duration: 3, extraBounce: 0.5)))
                .ifshow(show: show)
            XMTyperText(text: "每天都举行主题「排位赛」，例如「健身照大赛」、「泳装大赛」、「西装大赛」、「连衣裙大赛」等等😈\r\r用户按照po图参赛，收获点赞，可以提高热度值。全体用户按照「❤️‍🔥热度值」进行排名！\r\r祝你玩的愉快！\r\r别忘了领每天免费的火苗！")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.all, 12)
                .addBack()
            Spacer()
            XMDesgin.XMMainBtn(fColor: .XMColor.b1, backColor: .XMColor.f1, iconName: "", text: "我知道了！", enable: true) {
                Task {
                    UserManager.shared.userLoginInfo.isNeedInfo = false
                    await UserManager.shared.getUserInfo()
                    Apphelper.shared.closeSheet()
                }
            }
        }.padding(.all, 24).padding(.top, 24)
            .onAppear(perform: {
                withAnimation {
                    show = true
                }
            })
    }
}

#Preview {
    Color.red.onAppear(perform: {
        Apphelper.shared.presentPanSheet(
            LastWellComeSheet(),
            style: .hardSheet)
    })
}
