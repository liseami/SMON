//
//  CollagePostView.swift
//  SMON
//
//  Created by mac xiao on 2024/6/25.
//

import SwiftUI
class CollagePostModel: XMListViewModel<XMPost>{
    init() {
        super.init(target: CollagePostAPI.list(page: 1, userId: UserManager.shared.user.userId))
    }
}



struct CollagePostView: View {
    @StateObject var vm: CollagePostModel = .init()
    
    func reqData() async {
        await vm.getListData()
    }
    
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: 0, pinnedViews: [], content: {
                postList
            })
        }
        .task{
            await reqData()
        }
    }
    
    
    
    var postList: some View {
        XMStateView(vm.list, reqStatus: vm.reqStatus, loadmoreStatus: vm.loadingMoreStatus, pagesize: 20) { post in
            PostView(post)
        } loadingView: {
            PostListLoadingView()
        } emptyView: {
            VStack(spacing: 24) {
                Text("他很忙，什么也没留下～")
                    .font(.XMFont.f1)
                    .fcolor(.XMColor.f2)
                LoadingPostView()
            }
            .padding(.top, 12)
        } loadMore: {
            await vm.loadMore()
        } getListData: {
            await reqData()
        }
        .padding(.all, 16)
    }
        
}



#Preview {
    CollagePostView()
}
