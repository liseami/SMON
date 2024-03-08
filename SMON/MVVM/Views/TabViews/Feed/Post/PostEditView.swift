//
//  PostEditView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/29.
//

import SwiftUI
import SwiftUIX

class PostEditViewModel: ObservableObject {
    @Published var imageSelected: [UIImage] = []
    @Published var textInput: String = ""
}

struct PostEditView: View {
    @StateObject var vm: PostEditViewModel = .init()
    @Environment(\.presentationMode) var presentationMode
    @State private var showImagePicker: Bool = false
    var body: some View {
        NavigationView(content: {
            ScrollView(showsIndicators: false) {
                HStack(alignment: .top, spacing: 12) {
                    AsyncImage(url: AppConfig.mokImage)
                        .scaledToFit()
                        .frame(width: 38, height: 38) // Adjust the size as needed
                        .clipShape(Circle())

                    VStack(alignment: .leading) {
                        HStack {
                            Text(String.randomChineseString(length: Int.random(in: 3 ... 12)))
                                .font(.XMFont.f1b)
                                .lineLimit(1)
                                .fcolor(.XMDesgin.f1)
                            Spacer()
                        }

                        TextEditor(text: $vm.textInput)
                            .autoOpenKeyboard()
                            .font(.XMFont.f1)
                            .fcolor(.XMDesgin.f1)
                            .frame(height: 160)
                            .tint(.XMDesgin.main)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 4) {
                                Spacer().frame(width: 16 + 38 + 12 - 4)
                                ForEach(vm.imageSelected.indices, id: \.self) { index in

                                    Image(uiImage: vm.imageSelected[index])
                                        .overlay {
                                            XMDesgin.XMButton(enable: true) {
                                                vm.imageSelected.remove(at: index)
                                            } label: {
                                                XMDesgin.XMIcon(iconName: "system_add", size: 16)
                                                    .padding(.all, 6)
                                                    .background(Color.XMDesgin.b1)
                                                    .clipShape(Circle())
                                                    .rotationEffect(.init(degrees: 45))
                                                    .moveTo(alignment: .bottomTrailing)
                                                    .padding()
                                            }
                                        }
                                        .frame(width: 160, height: 160 / 3 * 4)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                Spacer().frame(width: 12)
                            }
                        }
                        .frame(height: 160 / 3 * 4)
                        .padding(.leading, -(16 + 38 + 12))
                        .padding(.trailing, -16)
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
            }
            .overlay(alignment: .bottom) {
                HStack(alignment: .center, spacing: 12, content: {
                    XMDesgin.XMButton(enable: true) {
                        showImagePicker = true
                    } label: {
                        XMDesgin.XMIcon(iconName: "post_image", size: 16)
                            .padding(.all, 6)
                            .background(Color.XMDesgin.b1)
                            .clipShape(Circle())
                    }

                    Spacer()
                })
                .padding()
            }
            .sheet(isPresented: $showImagePicker, content: {
                PhotoSelector(maxSelection: 4 - vm.imageSelected.count) { uiimages in
                    vm.imageSelected.append(contentsOf: uiimages)
                }
            })
            .toolbar {
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
}

#Preview {
    MainView()
        .fullScreenCover(isPresented: .constant(true)) {
            PostEditView()
        }
}
