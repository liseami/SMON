//
//  LoginView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var vm: LoginViewModel
    @State var showCodeView: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            Text("请输入您的手机号码")
                .bold()
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

            Spacer()
            XMDesgin.CircleBtn(backColor: Color.XMDesgin.f1, fColor: Color.XMDesgin.b1, iconName: "system_down") {}
                .rotationEffect(.degrees(-90))
                .isShakeBtn(enable: vm.isPhoneNumberValid, action: {
                    withAnimation {
                        showCodeView = true
                    }
                })
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .navigationDestination(isPresented: $showCodeView, destination: {
            LoginView_VCode()
        })
        .statusBarHidden(false)
        .padding(.all)
        .font(.title)
        .padding(.top, 80)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    LoginView()
        .environmentObject(LoginViewModel())
}
