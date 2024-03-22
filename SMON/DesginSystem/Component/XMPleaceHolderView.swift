//
//  XMPleaceHolderView.swift
//  StomachBook
//
//  Created by 赵翔宇 on 2024/3/21.
//

import SwiftUI

struct XMPleaceHolderView: View {
    let imageName : String?
    let text : String
    let btnText : String
    let btnaction : () async -> ()
    var body: some View {
        VStack(spacing: 24) {
            if let imageName{
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .scaleEffect(2)
            }
            Text(text)
                .font(.XMFont.f1)
            XMDesgin.XMMainBtn(text: btnText) {
                await btnaction()
            }
            .padding(.horizontal, 120)
        }
        .frame(height: UIScreen.main.bounds.width, alignment: .top)
        .frame(maxWidth: .infinity)
        .padding(.top, UIScreen.main.bounds.width * 0.3)
        .listRowInsets(.init(top: 0, leading: 24, bottom: 0, trailing: 24))
        .listRowSeparator(.hidden, edges: .all)
        .listRowBackground(Color.clear)
    }
}

#Preview {
    XMPleaceHolderView.init(imageName: "pear", text: "请重试。",btnText: "重试") {
        
    }
}
