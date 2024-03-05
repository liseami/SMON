//
//  HobbyRequestView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import SwiftUI
import Tagly

struct HobbyRequestView: View {
    @EnvironmentObject var vm: UserInfoRequestViewModel
    @State private var taggroups: [XMTagGroup] = []
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            VStack(alignment: .leading, spacing: 36) {
                VStack(alignment: .leading, spacing: 12, content: {
                    XMDesgin.XMIcon(iconName: "inforequest_hobby", size: 32)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    XMTyperText(text: "兴趣爱好")
                        .multilineTextAlignment(.leading)
                        .bold()
                    Text("最多选择5样您喜欢的标签。")
                        .font(.body).foregroundStyle(Color.XMDesgin.f2)
                })

                ForEach(taggroups, id: \.self) { group in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(group.title)
                            .font(.title3.bold())
                        let children = group.children.map { str in
                            XMTag(text: str)
                        }
                        TagCloudView(data: children, spacing: 12) { tag in
                            let selected = vm.interestsTag.contains(where: { $0 == tag.text })

                            XMDesgin.XMTag(text: tag.text)
                                .onTapGesture(perform: {
                                    if selected {
                                        vm.interestsTag.removeFirst(where: { $0 == tag.text })
                                    } else {
                                        guard vm.interestsTag.count < 5 else {
                                            Apphelper.shared.pushNotification(type: .info(message: "最多选择5个标签。"))
                                            return
                                        }
                                        vm.interestsTag.append(tag.text)
                                    }
                                })
                                .overlay(alignment: .topTrailing) {
                                    Capsule()
                                        .stroke(lineWidth: 3)
                                        .foregroundStyle(Color.XMDesgin.main)
                                        .ifshow(show: selected)
                                }
                        }
                        .padding(.horizontal, 2)
                    }
                }
            }
            .padding(.top, 60)
        })
        .edgesIgnoringSafeArea(.bottom)
        .overlay {
            XMDesgin.CircleBtn(backColor: Color.XMDesgin.f1, fColor: Color.XMDesgin.b1, iconName: "system_right", enable: !vm.interestsTag.isEmpty) {
                let result = await UserManager.shared.updateUserInfo(updateReqMod: .init(interestsTag: vm.interestsTag.joined(separator: "&")))
                if result.is2000Ok {
                    vm.presentedSteps.append(.height)
                }
            }
            .padding(.bottom, 16)
            .moveTo(alignment: .bottomTrailing)
        }
        .statusBarHidden(false)
        .padding(.horizontal)
        .font(.title)
        .task {
            let target = CommonAPI.interests
            let taggroups = await Networking.request_async(target).mapArray(XMTagGroup.self)
            if let taggroups {
                self.taggroups = taggroups
            }
        }
    }
}

#Preview {
    HobbyRequestView()
        .environmentObject(UserInfoRequestViewModel())
}
