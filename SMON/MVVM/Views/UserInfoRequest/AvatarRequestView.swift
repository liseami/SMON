//
//  AvatarRequestView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import JDStatusBarNotification
import SwiftUI
import SwiftUIX

struct AvatarRequestView: View {
    @EnvironmentObject var vm: UserInfoRequestViewModel

    var body: some View {
        InfoRequestView(title: "至少需要一张照片\r作为头像", subline: "头像日后也可以修改。", btnEnable: vm.avatar != nil) {
            XMDesgin.XMButton(action: {
                Apphelper.shared.present(SinglePhotoSelector(completionHandler: { avatar in
                    vm.avatar = avatar
                }))
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
                .background(Color.XMColor.b1)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            })
            .moveTo(alignment: .center)
            .frame(height: 140)
        } btnAction: {
            await updateAvatar()
        }
    }

    @MainActor
    func updateAvatar() async {
        guard let avatar = vm.avatar,
              let urls = await AliyunOSSManager.shared.upLoadImages_async(images: [avatar], type: .avatar),
              let url = urls.first else { vm.avatar = nil; return }
        let result = await UserManager.shared.updateUserInfo(updateReqMod: .init(avatar: url))
        if result.is2000Ok {
            vm.presentedSteps.append(.morephoto)
        } else {
            vm.avatar = nil
        }
    }
}

#Preview {
    AvatarRequestView()
        .environmentObject(UserInfoRequestViewModel())
}
