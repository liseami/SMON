//
//  WechatSettingView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/7.
//

import SwiftUI

class WechatSettingViewModel: ObservableObject {
    @Published var wechat: String
    @Published var threshold: String
    @Published var pikcerIndex: Int = 0
    init(wechat: String, threshold: String) {
        self.wechat = wechat
        self.threshold = threshold
        self.pikcerIndex = Int(threshold) ?? 0
    }

    var settingPrice: [Int] {
        (6 ... 4000).filter { number in
            if number < 300 {
                return number % 10 == 0
            } else if number < 500 {
                return number % 50 == 0
            } else {
                return number % 200 == 0
            }
        }
    }

    /*
     设置
     */
    @MainActor
    func set() async {
        let t = UserRelationAPI.updateUserContact(contactType: "wechat", contactValue: wechat, threshold: String(pikcerIndex))
        let r = await Networking.request_async(t)
        if r.is2000Ok {
            Apphelper.shared.closeSheet()
            Apphelper.shared.pushNotification(type: .info(message: "设置成功。"))
        }
    }
}

struct WechatSettingView: View {
    @StateObject var vm: WechatSettingViewModel

    init(wechat: String, threshold: String) {
        _vm = StateObject(wrappedValue: .init(wechat: wechat, threshold: threshold))
    }

    var body: some View {
        List {
            XMSection(title: "微信号") {
                TextField("微信号", text: $vm.wechat)
                    .autoOpenKeyboard()
            }
            XMSection(title: "他人如何解锁你的微信？", footer: "* 当其他用户向你赠送的礼物总价值超过上述设置价格时，对方可以解锁你的微信号。") {
                Picker(selection: $vm.pikcerIndex) {
                    ForEach(vm.settingPrice, id: \.self) { index in
                        Text("送出礼物价值 >= \(index)赛币")
                            .font(.headline)
                            .bold()
                            .tag(index)
                    }
                }
                .pickerStyle(.wheel)
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                XMDesgin.XMButton {
                    await vm.set()
                } label: {
                    Text("完成")
                        .fcolor(.XMDesgin.f1)
                        .font(.XMFont.f1b)
                }
            }
        })
        .listStyle(.grouped)
        .scrollDismissesKeyboard(.immediately)
    }
}

#Preview {
    WechatSettingView(wechat: "123123", threshold: "2400")
}
