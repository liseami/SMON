//
//  AvatarRequestView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import SwiftUI
import SwiftUIX

struct AvatarRequestView: View {
    @EnvironmentObject var vm: UserInfoRequestViewModel
    @State private var showImagePicker = false
    var body: some View {
        InfoRequestView(title: "至少需要一张照片\r作为头像", subline: "头像日后也可以修改。", btnEnable: true) {
            XMDesgin.XMButton(action: {
                showImagePicker = true
            }, label: {
                Group {
                    if let avatar = vm.avatar {
                        Image(uiImage: avatar)
                            .resizable()
                            .fill()
                    } else {
                        XMDesgin.XMIcon(iconName: "system_camera")
                    }
                }
                .frame(width: 120, height: 120, alignment: .center)
                .background(Color.XMDesgin.b1)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            })
            .moveTo(alignment: .center)
            .frame(height: 140)
        } btnAction: {
            vm.presentedSteps.append(.morephoto)
        }
        .fullScreenCover(isPresented: $showImagePicker, content: {
            SinglePhotoSelector(completionHandler: { avatar in
                vm.avatar = avatar
                AliyunOSSManager.shared.uploadImageToOSS(image: avatar)
            })
            .ignoresSafeArea()
            .environment(\.colorScheme, .dark)
        })
    }
}

#Preview {
    AvatarRequestView()
        .environmentObject(UserInfoRequestViewModel())
}
