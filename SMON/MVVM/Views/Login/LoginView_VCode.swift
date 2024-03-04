//
//  LoginView_VCode.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI

struct LoginView_VCode: View {
    @EnvironmentObject var vm: LoginViewModel

    var body: some View {
        InfoRequestView(title: "请输入发送至您短信的\r每日大赛验证码", subline: "我们将向您的手机号发送验证码，以帮助你验证并完成登录。", btnEnable: true) {
            HStack(spacing: 12) {
                ForEach(0 ..< 6, id: \.self) { index in
                    if vm.vcodeInput.count >= index + 1 {
                        Text(String(vm.vcodeInput[index]))
                            .font(.title3.bold())
                    } else {
                        Circle().fill(Color.XMDesgin.f2)
                            .frame(width: 10, height: 10)
                    }
                }
                Spacer()
            }
            .font(.title)
            .padding(.trailing, 16)
            .frame(height: 44, alignment: .center)
        } btnAction: {
            await vm.loginBySms()
        }
        .navigationBarTitleDisplayMode(.inline)
        .background {
            TextField("", text: $vm.vcodeInput)
                .keyboardType(.numberPad)
                .autoOpenKeyboard()
                .foregroundStyle(Color.XMDesgin.f1)
                .opacity(0)
        }
    }
}

#Preview {
    LoginView_VCode()
        .environmentObject(LoginViewModel())
}
