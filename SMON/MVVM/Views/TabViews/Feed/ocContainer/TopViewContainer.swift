//
//  TopViewContainer.swift
//  SMON
//
//  Created by mac xiao on 2024/6/20.
//

import SwiftUI
import UIKit

struct TopViewContainer: UIViewRepresentable{
    
//    let view: XMTopView
    
    @Binding var themeList: [XMTheme]
    
    
   
    func makeUIView(context: Context) -> XMTopView {
        // 创建并返回一个UIView子类的实例
        let theView = XMTopView()
        theView.listArr = themeList
        return theView
    }
    
    func updateUIView(_ uiView: XMTopView, context: Context){
        // 在需要更新UIView时进行操作，例如更新属性或内容
        uiView.listArr = themeList
        print("刷新>>\(uiView)")
    }
    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(parent: self)
//    }
//    
//    class Coordinator: NSObject {
//        var parent: TopViewContainer
// 
//        init(parent: TopViewContainer) {
//            self.parent = parent
//        }
// 
//        // 这里可以实现从OC视图回传值到SwiftUI的方法
//    }
    
}

// 使用CustomViewRepresentable作为视图
struct ContentView: View {
    var body: some View {
        EmptyView()
    }
}
