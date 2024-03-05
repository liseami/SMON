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
        InfoRequestView(title: "兴趣爱好", subline: "最多选择5样您喜欢的标签。", icon: "inforequest_hobby", btnEnable: true) {
            VStack(alignment: .leading, spacing: 12) {
                Text("自我疗愈")
                    .font(.title3.bold())
                ForEach(taggroups,id:\.self){ group in
                    let children = group.children.map { str in
                        XMTag(text:str)
                    }
                    TagCloudView(data: children, spacing: 12) { tag in
                        XMDesgin.XMTag(text: tag.text)
                    }
                }
             
            }
        } btnAction: {
            let result = await UserManager.shared.updateUserInfo(updateReqMod: .init(emotionalNeeds: vm.emotionalNeeds))
            if result.is2000Ok {
                vm.presentedSteps.append(.height)
            }
        }
        .canSkip {
            vm.presentedSteps.append(.height)
        }
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
