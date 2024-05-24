//
//  MyCoinView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/4/24.
//

import SwiftUI

struct MyCoinView: View {
    
    // 体现按钮
    @MainActor
    func cashOutMyCoin() async {
        let target = UserAPI.cashOut
        let result = await Networking.request_async(target)
        if result.is2000Ok {
            
        }
    }
    
    
    @StateObject var vm: StoreManager = .init()
//    @EnvironmentObject var vm: ProfileHomeViewModel
    var body: some View {
        List {
            XMSection(title: "总资产(赛币）") {
                HStack(alignment: .center, spacing: 12, content: {
                    Image("saicoin")
                        .resizable()
                        .frame(width: 44, height: 44)
                    Text("\(vm.wallet.coinNum)")
                        .font(.XMFont.big1.bold())
                        .fcolor(.XMColor.f1)
                    Spacer()
                    XMDesgin.SmallBtn(fColor: .XMColor.f1, backColor: .XMColor.main, iconName: "", text: "充值") {
                        Apphelper.shared.presentPanSheet(CoinshopView(), style: .shop)
                    }
                })
            }

            XMSection(title: "我的收入") {
                HStack(alignment: .center, spacing: 12, content: {
                    Image("profile_wallet")
                        .resizable()
                        .renderingMode(.template)
                        .fcolor(.XMColor.f1)
                        .frame(width: 44, height: 44)
                    Text("\(vm.wallet.coinGiftMoney)")
                        .font(.XMFont.big1.bold())
                        .fcolor(.XMColor.f1)
                    Spacer()
                    XMDesgin.SmallBtn(fColor: .XMColor.f1, backColor: .XMColor.b1, iconName: "", text: "提现") {
                        Task{
                            await cashOutMyCoin()
                        }
                        
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
        .environmentObject(ProfileHomeViewModel())
}
