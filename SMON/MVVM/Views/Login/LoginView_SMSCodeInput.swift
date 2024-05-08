//
//  LoginView_VCode.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI

struct LoginView_SMSCodeInput: View {
    @EnvironmentObject var vm: LoginViewModel

    var body: some View {
        InfoRequestView(title: "请输入发送至您手机号的\r每日大赛验证码", subline: "我们将向您的手机号发送验证码，以帮助你验证并完成登录。", btnEnable: vm.vcodeInput.count == 6 && vm.autoLogin == false) {
            HStack(spacing: 12) {
                ForEach(0 ..< 6, id: \.self) { index in
                    if vm.vcodeInput.count >= index + 1 {
                        Text(String(vm.vcodeInput[index]))
                            .transition(.asymmetric(insertion: .movingParts.boing.animation(.spring).combined(with: .opacity), removal: .movingParts.boing).combined(with: .opacity).animation(.linear))
                    } else {
                        Circle().fill(Color.XMDesgin.f2)
                            .frame(width: 10, height: 10)
                    }
                }
                Spacer()
            }
            .onChange(of: vm.vcodeInput) { input in
                if input.count == 6 {
                    Task {
                        vm.autoLogin = true
                        await vm.loginBySms()
                    }
                }
            }
            .font(.XMFont.big2.bold())
            .padding(.trailing, 16)
            .frame(height: 44, alignment: .center)
        } btnAction: {
            await vm.loginBySms()
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                XMDesgin.XMButton.init {
                    vm.pageProgress = .Login_PhoneNumberInput
                    vm.phoneInput.removeAll()
                } label: {
                    Text("取消")
                        .font(.XMFont.f1)
                }
            }
        })
        .navigationBarTitleDisplayMode(.inline)
        .background {
            TextField("", text: $vm.vcodeInput)
                .keyboardType(.numberPad)
                .autoOpenKeyboard()
                .fcolor(.XMDesgin.f1)
                .opacity(0)
        }
        .onChange(of: vm.vcodeInput) { input in
            if input.count > 6 {
                Apphelper.shared.nofimada(.error)
                vm.vcodeInput = String(input.prefix(6))
            }
        }
    }
}

#Preview {
    LoginView_SMSCodeInput()
        .environmentObject(LoginViewModel())
}
