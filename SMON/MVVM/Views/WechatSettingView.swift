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
            Section {
                TextField("微信号", text: $vm.updateModel.wechat)
            } header: {
                Text("微信号").font(.title3.bold())
                    .foregroundStyle(Color.XMDesgin.f1)
            }
            Section {
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
            } header: {
                Text("他人如何解锁你的微信？").font(.title3.bold())
            } footer: {
                Text("礼物价值不低于上述设置价格时，对方可以看到你的微信号。")
            }
        }
    }
}

#Preview {
    WechatSettingView()
        .environmentObject(ProfileEditViewModel())
}
