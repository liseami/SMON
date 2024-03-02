//
//  WebImage.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/2.
//

import Kingfisher
import SwiftUI

struct WebImage: View {
    let str: String

    var body: some View {
        KFImage(URL(string: str))
            .resizable()
            .placeholder { _ in
                Color.XMDesgin.b1
                    .conditionalEffect(.repeat(.shine, every: 1), condition: true)
            }
            .fade(duration: 0.3)
            .loadDiskFileSynchronously()
            .cancelOnDisappear(false)
    }
}

#Preview {
    VStack {
        WebImage(str: AppConfig.mokImage!.absoluteString)
        WebImage(str: "AppConfig.mokImage!.absoluteString")
    }
}
