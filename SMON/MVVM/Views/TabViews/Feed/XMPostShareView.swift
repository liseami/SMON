//
//  XMPostShareView.swift
//  SMON
//
//  Created by mac xiao on 2024/6/24.
//

import SwiftUI
class PostShareViewModel: ObservableObject {
    @Published var post: XMPost
    init(post: XMPost) {
        self.post = post
    }
}


struct XMPostShareView: View {
    @StateObject var vm: PostViewModel
    init(_ post: XMPost) {
        self._vm = StateObject(wrappedValue: .init(post: post))
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 24, content: {
            Spacer().frame(height: 1)
            HStack(content: {
                Text("分享到").font(.XMFont.f1b)
            })
        })
        Spacer()
        
        HStack{
            VStack{
                Button(action: {
                    print("好友 \(vm.post.postContent)")
                    Apphelper.shared.closeSheet()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // 延迟
                        // 在这里执行你的操作
                        print("弹出来了")
                        Apphelper.shared.presentPanSheet(XMFriendListView(vm.post), style: .cloud)
                    }
                    
                    
                    
                }, label: {
                    Image("xm_postShare_friend")
                })
                .frame(width: 74, height: 74, alignment: .center)
                
                Text("好友")
                    .font(.XMFont.f2)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.3)
//            VStack{
//                Button(action: {
//                    print("链接")
//                    Apphelper.shared.closeSheet()
//                }, label: {
//                    Image("xm_postShare_lj")
//                })
//                .frame(width: 74, height: 74, alignment: .center)
//                
//                Text("复制链接")
//                    .font(.XMFont.f2)
//            }
//            .frame(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height * 0.3)
        }
        
            
    }
}

//#Preview {
//    XMPostShareView()
//}
