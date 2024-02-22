//
//  LoginView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI

struct LoginView_PhoneNumber: View {
    var body: some View {
        VStack{
            Text("请输入您的手机号码")
            TextField("", text: .constant("152"))
            
            NavigationLink {
                LoginView_VCode()
            } label: {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }

        }
        .font(.largeTitle)
        
    }
}

#Preview {
    LoginView_PhoneNumber()
}
