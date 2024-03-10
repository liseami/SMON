//
//  LoginMainView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI

struct LoginMainView: View {
    @StateObject var vm: LoginViewModel = .init()

    var body: some View {
        
            ZStack(content: {
                XMLoginVideo()
                    .ignoresSafeArea()
                    .opacity(vm.pageProgress == .AppFeatures ? 1 : 0.4)
                    .animation(.easeInOut(duration: 1.5), value: vm.pageProgress)
                    .transition(.opacity.animation(.easeIn(duration: 1.5)))
                    .ifshow(show: vm.pageProgress != .Login_PhoneNumberInput && vm.pageProgress != .Login_SMSCodeInput)
                background
                Group {
                    switch vm.pageProgress {
                    case .AppFeatures:
                        AppFeaturesView()
                    case .Warning:
                        AppWarningView()
                    case .Login_PhoneNumberInput:
                        LoginView_PhoneNumberInput()
                            .transition(.asymmetric(insertion: .movingParts.boing(edge: .top).combined(with: .opacity), removal: .movingParts.move(edge: .bottom)).animation(.easeInOut(duration: 0.6)))
                    case .Login_SMSCodeInput:
                        LoginView_SMSCodeInput()
                            .transition(.asymmetric(insertion: .movingParts.boing(edge: .top).combined(with: .opacity), removal: .movingParts.move(edge: .bottom)).animation(.easeInOut(duration: 0.6)))
                    }
                }
            })
        
        .environmentObject(vm)
    }

    var background: some View {
        LinearGradient(colors: [Color.black, Color.black.opacity(0)], startPoint: .bottom, endPoint: .top)
            .frame(height: UIScreen.main.bounds.height * 0.4)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
    }
}

#Preview {
    LoginMainView()
}
