//
//  LoginView_VCode.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI

struct LoginView_VCode: View {
    var body: some View {
        VStack {
            Text("请输入短信中的验证码")
            TextField("", text: .constant("152"))
        }
        .font(.largeTitle)
    }
}

#Preview {
    LoginView_VCode()
}
