//
//  RequestCompleteView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import SwiftUI

struct RequestCompleteView: View {
    @EnvironmentObject var vm: UserInfoRequestViewModel
    @State var showText: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            VStack(alignment: .leading, spacing: 24, content: {
                Image("inforequest_complete")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .conditionalEffect(.smoke, condition: true)
                XMTyperText(text: "每日大赛的游戏规则！")
                    .multilineTextAlignment(.leading)
                    .bold()
                XMTyperText(text: "每天都举行主题「排位赛」，例如「健身照大赛」、「泳装大赛」、「西装大赛」、「连衣裙大赛」等等😈\r\r用户按照po图参赛，收获点赞，可以提高热度值。全体用户按照「❤️‍🔥热度值」进行排名！\r\r在这里，你可以轻松找到「全国❤️‍🔥最火热的用户」，「同城❤️‍🔥最火热的用户」……\r\r最重要的是，目前获取「❤️‍🔥」非常简单!\r\r祝你玩的愉快！\r\r别忘了领每天免费的火苗！")

                    .font(.XMFont.f1).fcolor(.XMDesgin.f1)
                    .padding(.trailing, 30)
                    .transition(.movingParts.glare.animation(.easeInOut(duration: 0.66)))
                    .ifshow(show: showText)

            })

            Spacer()
            XMDesgin.XMMainBtn(fColor: .XMDesgin.b1, backColor: .XMDesgin.f1, iconName: "", text: "好的") {
                Task {
                    UserManager.shared.userLoginInfo.isNeedInfo = false
                    await UserManager.shared.getUserInfo()
                }
            }
            .transition(.movingParts.anvil)
            .ifshow(show: showText)
            .padding(.horizontal, 48)
        }
        .frame(maxWidth: .infinity)
        .statusBarHidden(false)
        .padding(.all)
        .font(.title)
        .padding(.top, 40)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(XMLoginVideo()
            .ignoresSafeArea()
            .opacity(0.6)
            .transition(.movingParts.blur.animation(.easeIn(duration: 1.5))).ignoresSafeArea()
            .ifshow(show: showText)
        )
        .onAppear(perform: {
            showText = true
        })
    }
}

#Preview {
    RequestCompleteView()
        .environmentObject(UserInfoRequestViewModel())
}
