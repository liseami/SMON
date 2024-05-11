//
//  CoinshopView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/1.
//

import StoreKit
import SwiftUI
import SwiftUIX

struct HotExchangeView: View {
    @EnvironmentObject var vm: ProfileHomeViewModel
    @Environment(\.presentationMode) var presentationMode
    @MainActor
    func flameToHot() async {
        let t = UserAssetAPI.flamesToHot
        let r = await Networking.request_async(t)
        if r.is2000Ok {
            Apphelper.shared.pushNotification(type: .success(message: "兑换成功！"))
            Apphelper.shared.closeSheet()
            await vm.getSingleData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                Apphelper.shared.pushNotification(type: .success(message: "恭喜你！排名上升了！"))
                MainViewModel.shared.pushTo(MainViewModel.PagePath.myhotinfo)
            })
        } else {
            Apphelper.shared.closeSheet()
        }
    }

    var body: some View {
        VStack(alignment: .center, spacing: 24, content: {
            Spacer().frame(height: 1)
            HStack(content: {
                VStack(alignment: .leading, spacing: 12) {
                    Text("热度兑换").font(.title3.bold())
                    Text("热度可提升你在每日大赛中的排名，迎来人气大爆发。")
                        .fixedSize(horizontal: true, vertical: true)
                        .font(.XMFont.f2)
                        .fcolor(.XMColor.f2)
                }
                Spacer()
            })
            Spacer()
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .center, spacing: 12, content: {
                    Text("❤️‍🔥")
                        .font(.XMFont.big3)
                        .frame(width: 24, height: 24)
                    Text("\(vm.mod.flamesNums) 热度")
                        .font(.XMFont.f1b)
                })
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(Color.XMColor.b1)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                VStack(alignment: .center, spacing: 12, content: {
                    Text("🔥")
                        .font(.XMFont.big3)
                        .frame(width: 24, height: 24)
                    Text("\(vm.mod.flamesNums) 火苗")
                        .font(.XMFont.f1b)
                })
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(Color.XMColor.b1)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .overlay(alignment: .center) {
                AutoLottieView(lottieFliesName: "buyhot_arrow", loopMode: .loop, speed: 1.618)
                    .frame(width: 100, height: 100)
                    .scaleEffect(2)
                    .rotationEffect(.init(degrees: 90))
            }
            Spacer()
            XMDesgin.XMMainBtn(text: "立即兑换！") {
                await self.flameToHot()
            }
        })
        .padding(.all)
        .frame(maxWidth: .infinity, alignment: .top)
        .frame(height: UIScreen.main.bounds.height * 0.5, alignment: .top)
        .background(Color.black)
    }
}

#Preview {
    HotExchangeView()
        .environmentObject(ProfileHomeViewModel())
}
