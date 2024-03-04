//
//  LoginView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var vm: LoginViewModel

    var body: some View {
        InfoRequestView(title: "请输入您的手机号码", subline: "我们将向您的手机号发送验证码，以帮助你验证并完成登录。", btnEnable: true) {
            HStack(spacing: 20) {
                Text("+86")
                    .foregroundStyle(Color.XMDesgin.f2)
                TextField("", text: $vm.phoneInput)
                    .tint(Color.XMDesgin.main)
                    .keyboardType(.numberPad)
                    .autoOpenKeyboard()
                    .foregroundStyle(Color.XMDesgin.f1)
                XMDesgin.XMIcon(iconName: "system_xmark", color: Color.XMDesgin.f3)
                    .onTapGesture {
                        vm.phoneInput.removeAll()
                    }
                    .transition(.move(edge: .trailing).animation(.spring))
                    .ifshow(show: !vm.phoneInput.isEmpty)
            }
            .font(.title)
            .padding(.trailing, 16)
        } btnAction: {
            await vm.getSMSCode()
        }
        .navigationDestination(isPresented: $vm.showCodeInputView, destination: {
            LoginView_VCode()
                .toolbarRole(.editor)
                .environmentObject(vm)
        })
    }
}

#Preview {
    LoginView()
        .environmentObject(LoginViewModel())
}
