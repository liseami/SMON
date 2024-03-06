//
//  ProfileEditView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/2.
//

import SwiftUI

struct XMPhoto : Hashable{
    var id : String
    var url : String
}


struct ProfileEditView: View {
    var w: CGFloat {
        (UIScreen.main.bounds.size.width - 16 - 16 - 8 - 8 - 8) / 3
    }

    @State private var photos : [XMPhoto] = []
    
    var body: some View {
        List {
            
            Section(Text("照片墙")) {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 8) {
                    ForEach(photos, id: \.self) { _ in
                        XMDesgin.XMButton {
                            Apphelper.shared.presentPanSheet(
                                PhotoSelector(maxSelection: 6, completionHandler: { uiimages in
                                    AliyunOSSManager.shared.upLoadImages(images: uiimages) { _ in
                                    }
                                }), style: .cloud)

                        } label: {
                            WebImage(str: AppConfig.mokImage!.absoluteString)
                                .scaledToFill()
                                .frame(width: w, height: w / 3 * 4)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            Section(Text("个人简介")) {
                TextEditor(text: .constant("Placeholder"))
                    .frame(height: 80)
                    .scrollContentBackground(.hidden)
                    .listRowBackground(Color.XMDesgin.b1)
            }
            Section(Text("自我认同")) {
                Menu {
                    Button(action: {}) {
                        Label {
                            Text("Dom")
                        } icon: {}
                    }
                } label: {
                    XMDesgin.XMListRow(.init(name: "S", icon: "inforequest_bdsm", subline: "")) {}
                        .contentShape(Rectangle())
                }
            }
            Section(Text("交往目标")) {
                XMDesgin.XMListRow(.init(name: "长期关系", icon: "inforequest_drink", subline: "")) {}
            }
            Section(Text("兴趣标签")) {
                XMDesgin.XMListRow(.init(name: "🏑曲棍球、🏀篮球、🍺聚会", icon: "", subline: "选择标签")) {}
            }
            Section(Text("身高")) {
                XMDesgin.XMListRow(.init(name: "180cm", icon: "inforequest_ruler", subline: "")) {}
            }

            Section(Text("微信号")) {
                XMDesgin.XMListRow(.init(name: "chunxiangjifei123", icon: "inforequest_wechat", subline: "")) {}
            }
            Section(Text("更多信息")) {
                XMDesgin.XMListRow(.init(name: "教育信息", icon: "inforequest_drink", subline: "")) {}
                XMDesgin.XMListRow(.init(name: "公司", icon: "inforequest_drink", subline: "")) {}
                XMDesgin.XMListRow(.init(name: "职位", icon: "inforequest_drink", subline: "")) {}
            }
        }
        .scrollIndicators(.hidden)
        .font(.body.bold()).foregroundColor(.XMDesgin.f1)
        .listStyle(.grouped)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                XMDesgin.SmallBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.main, iconName: "", text: "完成") {}
            }
        }
    }
}

#Preview {
    ProfileEditView()
}




//
//struct DropViewDelegate: DropDelegate {
//    @Binding var photos: [Int]
//    let current: Int
//    
//    func performDrop(info: DropInfo) -> Bool {
//        guard let itemProvider = info.itemProviders(for: [.string]).first,
//              let item = itemProvider.item as? String,
//              let sourceIndex = Int(item) else {
//            return false
//        }
//        
//        if let destinationIndex = photos.firstIndex(of: current) {
//            photos.move(fromOffsets: IndexSet(integer: sourceIndex), toOffset: destinationIndex)
//        }
//        
//        return true
//    }
//}
