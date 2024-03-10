//
//  LoginView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI

struct LoginView_PhoneNumberInput: View {
    @EnvironmentObject var vm: LoginViewModel

    var body: some View {
        InfoRequestView(title: "请输入您的手机号码", subline: "我们将向您的手机号发送验证码，以帮助你验证并完成登录。", btnEnable: vm.isPhoneNumberValid) {
            HStack(spacing: 20) {
                Text("+86")
                    .fcolor(.XMDesgin.f2)
                TextField("", text: $vm.phoneInput)
                    .tint(Color.XMDesgin.main)
                    .keyboardType(.numberPad)
                    .autoOpenKeyboard()
                    .fcolor(.XMDesgin.f1)
                XMDesgin.XMIcon(iconName: "system_xmark", size: 15, color: Color.XMDesgin.f3, withBackCricle: true)
                    .onTapGesture {
                        vm.phoneInput.removeAll()
                    }
                    .transition(.move(edge: .trailing).animation(.spring))
                    .ifshow(show: !vm.phoneInput.isEmpty)
            }
            .font(.XMFont.big2)
            .padding(.trailing, 16)
        } btnAction: {
            await vm.getSMSCode()
        }
        .onChange(of: vm.phoneInput) { input in
            if input.count > 11 {
                Apphelper.shared.nofimada(.error)
                vm.phoneInput = String(input.prefix(11))
            }
        }
    }
}

#Preview {
    LoginView_PhoneNumberInput()
        .environmentObject(LoginViewModel())
}
