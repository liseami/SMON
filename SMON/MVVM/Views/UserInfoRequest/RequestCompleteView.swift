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
                Text("每日大赛的游戏规则！")
                    .multilineTextAlignment(.leading)
                    .bold()
                Text("每天都举行主题「排位赛」，用户按照「🔥热度值」进行排名。\r\r在这里，你可以轻松找到「全国🔥最火热的用户」，「同城🔥最火热的用户」……\r\r最重要的是，目前获取「🔥」非常简单！")

                    .font(.body).foregroundStyle(Color.XMDesgin.f1)
                    .padding(.trailing, 30)
                    .transition(.movingParts.glare.animation(.easeInOut(duration: 0.66)))
                    .ifshow(show: showText)
                Text("祝你玩的愉快！")
                    .onAppear(perform: {
                        showText = true
                    })
                    .font(.body).foregroundStyle(Color.XMDesgin.f1)

            })
            Spacer()
            XMDesgin.XMMainBtn(fColor: .XMDesgin.b1, backColor: .XMDesgin.f1, iconName: "", text: "好的") {
                UserManager.shared.user.needInfo = false
                UserManager.shared.saveUserData()
            }
            .padding(.horizontal, 48)
        }
        .frame(maxWidth: .infinity)
        .statusBarHidden(false)
        .padding(.all)
        .font(.title)
        .padding(.top, 40)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    RequestCompleteView()
        .environmentObject(UserInfoRequestViewModel())
}
