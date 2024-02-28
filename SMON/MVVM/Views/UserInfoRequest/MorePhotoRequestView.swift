//
//  MorePhotoRequestView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import SwiftUI

struct MorePhotoRequestView: View {
    @EnvironmentObject var vm: UserInfoRequestViewModel
    @State var showImagePicker: Bool = false
    var body: some View {
        InfoRequestView(title: "添加更多的照片\r人气大爆发的开始", subline: "据我们的统计显示，个人档案中超过三张照片的用户，其收获喜欢的几率会高出43%。您可以随后对这些照片进行更改。", btnEnable: true) {
            let w = (UIScreen.main.bounds.width - (14 * 2) - 8 - 8) / 3

            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), alignment: .center, spacing: 8) {
                if let avatar = vm.avatar {
                    Image(uiImage: avatar)
                        .resizable()
                        .scaledToFill()
                        .frame(width: w, height: w, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                }
                ForEach(0 ... 4, id: \.self) { index in
                    XMDesgin.XMButton(action: {
                        showImagePicker = true
                    }, label: {
                        Group {
                            if vm.morePhoto.count >= index + 1 {
                                let avatar = vm.morePhoto[index]
                                Image(uiImage: avatar)
                                    .resizable()
                                    .fill()
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
            vm.presentedSteps.append(.brithday)
        }
        .fullScreenCover(isPresented: $showImagePicker, content: {
            PhotoSelector(maxSelection: 5 - vm.morePhoto.count, completionHandler: { uiimages in
                vm.morePhoto = uiimages
            })
            .ignoresSafeArea()
            .environment(\.colorScheme, .dark)
        })
    }
}

#Preview {
    MorePhotoRequestView()
        .environmentObject(UserInfoRequestViewModel())
}
