//
//  PostEditView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/29.
//

import SwiftUI
import SwiftUIX

class PostEditViewModel: ObservableObject {
    /// 已选择的图片
    @Published var imageSelected: [UIImage] = []
    
    /// 文本输入框内容
    @Published var textInput: String = ""
    
    /// 发布帖子
    func publishPost() async {}
}

struct PostEditView: View {
    /// 视图模型
    @StateObject var vm: PostEditViewModel = .init()
    
    /// 环境变量,用于控制视图的展示与隐藏
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView(content: {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 12) {
                    textInput
                    images
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .scrollDismissesKeyboard(.immediately)
            }
            .overlay(alignment: .bottom) {
                // 底部工具栏
                HStack(alignment: .center, spacing: 12, content: {
                    XMDesgin.XMButton(enable: !vm.textInput.isEmpty || !vm.imageSelected.isEmpty) {
                        openPhotoSelecter()
                    } label: {
                        XMDesgin.XMIcon(iconName: "post_image", size: 16, withBackCricle: true)
                    }
                    Spacer()
                })
                .padding()
            }
            .toolbar {
                // 导航栏按钮
                ToolbarItem(placement: .topBarLeading) {
                    XMDesgin.XMButton.init {
                        presentationMode.dismiss()
                    } label: {
                        Text("取消").font(.XMFont.f1)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    XMDesgin.SmallBtn(fColor: Color.XMDesgin.b1, backColor: Color.XMDesgin.f1, iconName: "", text: "发布") {}
                }
            }
        })
    }
    
    var textInput: some View {
        // 头像和文本输入框
        HStack(alignment: .top, spacing: 12) {
            XMUserAvatar(str: UserManager.shared.user.avatar, userId: "", size: 44)

            VStack(alignment: .leading) {
                HStack {
                    Text(String.randomChineseString(length: Int.random(in: 3 ... 12)))
                        .font(.XMFont.f1b)
                        .lineLimit(1)
                        .fcolor(.XMDesgin.f1)
                    Spacer()
                }
                
                TextField(text: $vm.textInput, axis: .vertical) {}
                    .autoOpenKeyboard()
                    .frame(minHeight: 120, alignment: .topLeading)
                    .font(.XMFont.f1)
                    .fcolor(.XMDesgin.f1)
                    .tint(.XMDesgin.main)
            }
        }
    }

    var images: some View {
        // 图片选择和预览区域
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                Spacer().frame(width: 16 + 44 + 12 - 4)
                
                // 添加图片按钮
                XMDesgin.XMButton {
                    openPhotoSelecter()
                } label: {
                    Color.XMDesgin.b1
                        .overlay(content: {
                            XMDesgin.XMIcon(iconName: "system_add")
                        })
                        .frame(width: 160, height: 160 / 3 * 4)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .ifshow(show: vm.imageSelected.count < 4)
                
                // 预览已选择的图片
                ForEach(vm.imageSelected, id: \.self) { uiimage in
                    Image(uiImage: uiimage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 160, height: 160 / 3 * 4)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay {
                            // 删除图片按钮
                            XMDesgin.XMButton(enable: true) {
                                withAnimation {
                                    self.vm.imageSelected.removeAll { targetuiimage in
                                        targetuiimage == uiimage
                                    }
                                }
                            } label: {
                                XMDesgin.XMIcon(iconName: "system_xmark", size: 16, withBackCricle: true)
                                    .moveTo(alignment: .topTrailing)
                                    .padding(.all, 6)
                            }
                        }
                        .transition(.asymmetric(insertion: .movingParts.boing.animation(.spring).combined(with: .opacity), removal: .movingParts.poof.animation(.easeInOut(duration: 0.5))))
                }
                
                Spacer().frame(width: 12)
            }
            .padding(.vertical, 6)
        }
        .padding(.horizontal, -16)
    }
    
    /// 打开图片选择器
    func openPhotoSelecter() {
        Apphelper.shared.present(
            PhotoSelector(maxSelection: 4 - vm.imageSelected.count, completionHandler: { images in
                withAnimation {
                    vm.imageSelected += images
                }
            }),
            presentationStyle: .fullScreen
        )
    }
}

#Preview {
    MainView()
        .fullScreenCover(isPresented: .constant(true)) {
            PostEditView()
        }
}
