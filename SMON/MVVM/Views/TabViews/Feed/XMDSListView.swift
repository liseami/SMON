//
//  XMDSListView.swift
//  SMON
//
//  Created by mac xiao on 2024/6/21.
//

import SwiftUI

class XMDSThemeListModel: XMListViewModel<XMTheme>{
    init(){
        super.init(target: PostsOperationAPI.themeList(page: 1, sex: 0))
    }
}

struct XMDSListView: View {
    @StateObject var vm: XMDSThemeListModel = .init()
    
    func getList() async{
        await vm.getListData()
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: 0, pinnedViews: [], content: {
                XMStateView(vm.list, reqStatus: vm.reqStatus, loadmoreStatus: vm.loadingMoreStatus, pagesize: 20) { post in
                    
                    HStack{
                        WebImage(str: post.coverUrl)
                            .scaledToFill()
                            .frame(width: 34, height: 34, alignment: .leading)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        
                        VStack{
                            Text("\(post.title)")
                                .frame(width: 300, height: 20, alignment: .leading)
                                .font(.XMFont.f2)
                                .foregroundColor(.XMColor.b2)
                            Text("\(post.postsNumsStr)人参与")
                                .frame(width: 300, alignment: .leading)
                                .font(.XMFont.f3)
                                .foregroundColor(.XMColor.b2)
                        }
                            
                    }
                    .frame(width: UIScreen.main.bounds.width-40, height: 64, alignment: .leading)
                    .onTapGesture {
                        print("\(post.id)")
                    }
                    
                    
                    
                } loadingView: {
//                    PostListLoadingView()
                } emptyView: {
                    XMEmptyView()
                } loadMore: {
                    await vm.loadMore()
                } getListData: {
                    await vm.getListData()
                }

            })
            .padding(.all, 16)
        }
        .task {
            Task{
                await getList()
            }
        }
        .refreshable { await vm.getListData() }
        .navigationTitle("热门大赛")
    }
     
    
}



//#Preview {
//    MainView(vm: .init(currentTabbar: .rank))
//        .environmentObject(RankViewModel())
//    XMDSListView()
//}
