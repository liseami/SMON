//
//  MyCoinView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/4/24.
//

import SwiftUI

struct MyCoinView: View {
    var body: some View {
        List {
            XMSection(title: "总资产(赛币）") {
                HStack(alignment: .center, spacing: 12, content: {
                    Image("saicoin")
                        .resizable()
                        .frame(width: 44, height: 44)
                    Text("32")
                        .font(.XMFont.big1.bold())
                        .fcolor(.XMDesgin.f1)
                    Spacer()
                    XMDesgin.SmallBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.main, iconName: "", text: "充值") {
                        Apphelper.shared.presentPanSheet(CoinshopView(), style: .shop)
                    }
                })
            }

            XMDesgin.XMListRow(.init(name: "账单", icon: "", subline: "")) {
                MainViewModel.shared.pathPages.append(MainViewModel.PagePath.mybill)
            }
        }
        .navigationTitle("我的赛币资产")
    }
}

#Preview {
    MyCoinView()
}
