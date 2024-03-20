//
//  XMUserLine.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/9.
//

import SwiftUI

struct XMUserLine: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            WebImage(str: AppConfig.mokImage!.absoluteString)
                .scaledToFill()
                .frame(width: 44, height: 44, alignment: .center)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 12, content: {
                HStack {
                    VStack(alignment: .leading, spacing: 6, content: {
                        Text("Placeholder")
                            .font(.XMFont.f1b)
                        Text("天蝎 · S")
                            .font(.XMFont.f2)
                            .fcolor(.XMDesgin.f2)
                    })
                    Spacer()
                    XMDesgin.SmallBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.b1, iconName: "", text: "正在关注") {}
                }
                Text(String.randomChineseString(length: 40))
                    .font(.XMFont.f2)

            })
        }
        .onTapGesture {
            MainViewModel.shared.pathPages.append(MainViewModel.PagePath.profile(userId: "0"))
        }
    }
}


#Preview {
    XMUserLine()
}
