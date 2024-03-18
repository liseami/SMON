//
//  CompetitionPostListView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/18.
//

import SwiftUI
class CompletionPostListViewModel: XMListViewModel<XMPost> {
    let type: Int
    let themeId: Int
    init(type: Int, themeId: Int) {
        self.type = type
        self.themeId = themeId
        super.init(pageName: "") { pageindex in
            PostAPI.themeList(p: .init(page: pageindex, type: type, themeId: themeId))
        }
  
    }
}

struct CompetitionPostListView: View {
    @StateObject var vm: CompletionPostListViewModel

    init(type: Int, themeId: Int) {
        self._vm = StateObject(wrappedValue: .init(type: type, themeId: themeId))
    }

    var body: some View {
        ForEach(vm.list, id: \.self.id) { post in
            PostView(post)
        }
    }
}

#Preview {
    CompetitionPostListView(type: 1, themeId: 2)
}