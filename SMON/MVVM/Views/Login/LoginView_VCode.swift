//
//  LoginView_VCode.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI

struct LoginView_VCode: View {
    @EnvironmentObject var vm: LoginViewModel
    @FocusState var input

    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            Text("请输入发送至您短信的\r每日大赛验证码")
                .multilineTextAlignment(.leading)
                .bold()
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

            Spacer()
            XMDesgin.CircleBtn(backColor: Color.XMDesgin.f1, fColor: Color.XMDesgin.b1, iconName: "system_down") {}
                .rotationEffect(.degrees(-90))
                .isShakeBtn(enable: vm.isPhoneNumberValid, action: {})
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .statusBarHidden(false)
        .padding(.all)
        .font(.title)
        .padding(.top, 40)
        .frame(maxHeight: .infinity, alignment: .top)
        .background {
            TextField("", text: $vm.vcodeInput)
                .keyboardType(.numberPad)
                .focused($input)
                .onAppear(perform: {
                    input = true
                })
                .foregroundStyle(Color.XMDesgin.f1)
                .opacity(0)
        }
    }
}

#Preview {
    LoginView_VCode()
        .environmentObject(LoginViewModel())
}
