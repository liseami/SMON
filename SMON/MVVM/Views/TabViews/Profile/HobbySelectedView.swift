//
//  HobbySelectedView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/7.
//

import SwiftUI
import Tagly

struct HobbySelectedView: View {
    @EnvironmentObject var viewModel: ProfileEditViewModel
    @State private var tagGroups: [XMTagGroup] = []
    @State private var expandedGroupIds: Set<String> = []

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 36) {
                headerSection
                tagGroupsSection
            }
            .padding(.top, 60)
            .padding(.horizontal)
            Spacer().frame(height: 120)
        }
        .edgesIgnoringSafeArea(.bottom)
        .font(.title)
        .statusBarHidden(false)
        .task {
            tagGroups = loadTagGroups()
        }
    }

    // MARK: - View Components

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            XMDesgin.XMIcon(iconName: "inforequest_hobby", size: 32)
                .frame(maxWidth: .infinity, alignment: .leading)

            XMTyperText(text: "兴趣爱好")
                .multilineTextAlignment(.leading)
                .bold()

            XMTyperText(text: "最多选择5样您喜欢的标签。")
                .font(.XMFont.f1)
                .fcolor(.XMColor.f2)
        }
    }

    private var tagGroupsSection: some View {
        ForEach(tagGroups, id: \.self) { group in
            VStack(alignment: .leading, spacing: 12) {
                Text(group.title)
                    .font(.title3.bold())

                // 将每组的兴趣标签转换为 XMTag 实例
                let children = group.children.map { XMTag(text: $0) }

                VStack(alignment: .center, spacing: 24) {
                    let isExpanded = expandedGroupIds.contains(group.id)
                    let displayedTags = isExpanded ? children : Array(children.prefix(10))

                    TagCloudView(data: displayedTags, spacing: 12) { tag in
                        tagView(for: tag)
                    }
                    .padding(.horizontal, 2)

                    if children.count > 10 {
                        XMDesgin.SmallBtn(text: isExpanded ? "收起" : "更多") {
                            toggleGroupExpansion(for: group.id)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Helper Functions

    private func tagView(for tag: XMTag) -> some View {
        let isSelected = viewModel.updateModel.interestsTagList.contains(tag.text)

        return XMDesgin.XMTag(text: tag.text)
            .onTapGesture {
                toggleTag(tag)
            }
            .overlay(alignment: .topTrailing) {
                Capsule()
                    .stroke(lineWidth: 3)
                
                    .fcolor(.XMColor.main)
                    .ifshow(show: isSelected)
            }
    }

    private func toggleTag(_ tag: XMTag) {
        let isSelected = viewModel.updateModel.interestsTagList.contains(tag.text)

        if isSelected {
            viewModel.updateModel.interestsTagList.removeFirst(where: { $0 == tag.text })
        } else {
            guard viewModel.updateModel.interestsTagList.count < 5 else {
                Apphelper.shared.pushNotification(type: .info(message: "最多选择5个标签。"))
                return
            }
            viewModel.updateModel.interestsTagList.append(tag.text)
        }
    }

    private func toggleGroupExpansion(for groupId: String) {
        if expandedGroupIds.contains(groupId) {
            expandedGroupIds.remove(groupId)
        } else {
            expandedGroupIds.insert(groupId)
        }
    }

    private func loadTagGroups() -> [XMTagGroup] {
        // 从本地或网络加载 XMTagGroup 数据
        // let target = CommonAPI.interests
        // let tagGroups = await Networking.request_async(target).mapArray(XMTagGroup.self)
        // return tagGroups ?? []
        return MockTool.readArray(XMTagGroup.self, fileName: "兴趣标签", atKeyPath: "data") ?? []
    }

    private func saveInterestsTag() {
        Task {
            let result = await UserManager.shared.updateUserInfo(updateReqMod: .init(interestsTag: viewModel.updateModel.interestsTagList.joined(separator: "&")))
            if result.is2000Ok {}
        }
    }
}

#Preview {
    HobbySelectedView()
        .environmentObject(ProfileEditViewModel())
}
