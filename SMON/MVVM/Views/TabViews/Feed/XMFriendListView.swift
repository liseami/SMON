//
//  XMFriendListView.swift
//  SMON
//
//  Created by mac xiao on 2024/6/24.
//

import SwiftUI
import TIMCommon

class ShareFriendListViewModel: ObservableObject {
    @Published var post: XMPost
    init(post: XMPost) {
        self.post = post
    }
}

struct XMFriendListView: View {
    @StateObject var um: MessageViewModel = .shared
    
    @StateObject var vm: ShareFriendListViewModel
    init(_ post: XMPost) {
        self._vm = StateObject(wrappedValue: .init(post: post))
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: 0, pinnedViews: [], content: {
                ForEach(Array(um.conversations.enumerated()), id: \.offset) { indx, model in
                    HStack{
                        WebImage(str: model.faceUrl)
                            .scaledToFill()
                            .frame(width: 34, height: 34, alignment: .leading)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        
                        
                        Text("\(model.showName)")
                            .frame(width: 300, height: 20, alignment: .leading)
                            .font(.XMFont.f2)
                            .foregroundColor(.XMColor.b2)
                            
                    }
                    .frame(width: UIScreen.main.bounds.width-40, height: 64, alignment: .leading)
                    .onTapGesture {
                        let name: String = model.showName != nil ? model.showName:""
                        Apphelper.shared.pushAlert(title: "确认", message: "确认分享给\(name)吗?", actions: [UIAlertAction(title: "取消", style: .default),UIAlertAction(title: "确定", style: .destructive, handler: { _ in
                            print("分享给\(name)")
                            
                            um.sendMessage(post: vm.post, userid: model.userID)
                            
                            Apphelper.shared.closeSheet()
                            
                            
                            
                        })])
                        
                    }
                    
                }
                
        })
        
        
        
        }
        .navigationTitle("选择分享好友")
                       
    }
                
}

//#Preview {
//    XMFriendListView()
//}
