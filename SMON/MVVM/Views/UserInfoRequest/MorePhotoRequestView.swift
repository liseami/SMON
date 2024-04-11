//
//  MorePhotoRequestView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import SwiftUI

struct MorePhotoRequestView: View {
    @EnvironmentObject var vm: UserInfoRequestViewModel

    let w = (UIScreen.main.bounds.width - (14 * 2) - 8 - 8) / 3

    var body: some View {
        InfoRequestView(title: "添加更多的照片\r人气大爆发的开始", subline: "据我们的统计显示，个人档案中超过三张照片的用户，其收获喜欢的几率会高出43%。您可以随后对这些照片进行更改。", btnEnable: !vm.morePhoto.isEmpty) {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), alignment: .center, spacing: 8) {
                avatar
                ForEach(0 ... 4, id: \.self) { index in
                    XMDesgin.XMButton(action: {
                        Apphelper.shared.present(PhotoSelector(maxSelection: 5 - vm.morePhoto.count, completionHandler: { uiimages in
                            vm.morePhoto = uiimages
                        }))
                    }, label: {
                        Group {
                            if vm.morePhoto.count >= index + 1 {
                                let avatar = vm.morePhoto[index]
                                Image(uiImage: avatar)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                XMDesgin.XMIcon(iconName: "system_add")
                            }
                        }
                        .frame(width: w, height: w, alignment: .center)
                        .background(Color.XMDesgin.b1)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    })
                }
            }

        } btnAction: {
            LoadingTask(loadingMessage: "上传照片") {
                if let urls = await AliyunOSSManager.shared.upLoadImages_async(images: vm.morePhoto, type: .userAlbum) {
                    let target = UserAPI.updateAlbum(p: urls)
                    let result = await Networking.request_async(target)
                    if result.is2000Ok {
                        vm.presentedSteps.append(.brithday)
                    } else {
                        Apphelper.shared.pushNotification(type: .error(message: "上传失败，请稍后再试。"))
                    }
                }
            }
        }
        .canSkip {
            vm.presentedSteps.append(.brithday)
        }
    }

    @ViewBuilder
    var avatar: some View {
        if let avatar = vm.avatar {
            Image(uiImage: avatar)
                .resizable()
                .scaledToFill()
                .frame(width: w, height: w, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 24))
        }
    }
}

#Preview {
    MorePhotoRequestView()
        .environmentObject(UserInfoRequestViewModel())
}
