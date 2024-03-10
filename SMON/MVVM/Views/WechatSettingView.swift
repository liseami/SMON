//
//  WechatSettingView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/7.
//

import SwiftUI

struct WechatSettingView: View {
    @EnvironmentObject var vm: ProfileEditViewModel
    var body: some View {
        List {
            XMSection(title: "微信号") {
                TextField("微信号", text: $vm.updateModel.wechat)
                    .autoOpenKeyboard()
            }
            
            XMSection(title: "他人如何解锁你的微信？",footer: "* 当其他用户向你赠送的礼物总价值超过上述设置价格时，对方可以解锁你的微信号。") {
                Picker(selection: .constant(1)) {
                    ForEach((6 ... 4000).filter { number in
                        if number < 300 {
                            return number % 10 == 0
                        } else if number < 500 {
                            return number % 50 == 0
                        } else {
                            return number % 200 == 0
                        }
                    }, id: \.self) { index in
                        Text("礼物价值 >= \(index)元").font(.headline).bold()
                    }
                }
                .pickerStyle(.wheel)
            }

        }.listStyle(.plain)
    }
}

#Preview {
    WechatSettingView()
        .environmentObject(ProfileEditViewModel())
}
