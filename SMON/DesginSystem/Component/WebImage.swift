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
            }
            .fade(duration: 0.3)
            .loadDiskFileSynchronously()
            .cancelOnDisappear(false)
    }
}

struct XMUserAvatar: View {
    let str: String
    let userId: String
    let size: CGFloat
    init(str: String, userId: String, size: CGFloat = 56.0) {
        self.str = str
        self.userId = userId
        self.size = size
    }

    var body: some View {
        XMDesgin.XMButton {
            MainViewModel.shared.pathPages.append(MainViewModel.PagePath.profile(userId: self.userId))
        } label: {
            WebImage(str: str)
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
        }
    }
}

#Preview {
    VStack {
        XMUserAvatar(str: AppConfig.mokImage!.absoluteString, userId: "32", size: 56)
        WebImage(str: AppConfig.mokImage!.absoluteString)
        WebImage(str: "AppConfig.mokImage!.absoluteString")
    }
}
