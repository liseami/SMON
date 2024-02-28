//
//  RequestCompleteView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import SwiftUI

struct RequestCompleteView: View {
    @EnvironmentObject var vm: UserInfoRequestViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            VStack(alignment: .leading, spacing: 24, content: {
                XMDesgin.XMIcon(iconName: "inforequest_fire", size: 45, color: Color.white)
                    .padding(.all, 24)
                    .background(Circle().fill(Color.XMDesgin.b1))
                Text("每日大赛的游戏规则！")
                    .multilineTextAlignment(.leading)
                    .bold()
                Text("「每日大赛」每天都有排位赛，用户按照🔥热度值进行排名。\r\r在这里，你可以轻松找到每天「全国🔥最火热的用户」，「同城🔥最火热的用户」……\r\r最重要的是，目前获取🔥非常简单！几乎是免费的！")
                    .font(.body).foregroundStyle(Color.XMDesgin.f1)
                    .padding(.trailing, 30)
                Text("祝你玩的愉快！")
                    .font(.body).foregroundStyle(Color.XMDesgin.f1)
                
            })
            Spacer()
            XMDesgin.XMMainBtn(fColor: .XMDesgin.b1, backColor: .XMDesgin.f1, iconName: "", text: "好的") {
                UserManager.shared.user.needInfo = false
            }
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
