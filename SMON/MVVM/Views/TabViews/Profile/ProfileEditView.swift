//
//  ProfileEditView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/2.
//

import SwiftUI

class ProfileEditViewModel: ObservableObject {
    @Published var updateModel: XMUserProfile

    init() {
        self.updateModel = UserManager.shared.user
        Task {
            await self.getPhotos()
        }
    }

    @Published var avatar: UIImage?
    @Published var photos: [XMPhoto] = []

    @MainActor
    func updateUserInfo() async {
        if let avatar, let newAvatarUrl = await AliyunOSSManager.shared.upLoadImages_async(images: [avatar])?.first {
            updateModel.avatar = newAvatarUrl
        }
        // 阿里云图片上传，之后请求接口，刷新页面
        // 期间不允许用户操作
        let p = XMUserUpdateReqMod(from: updateModel)
        let target = UserAPI.updateUserInfo(p: p)
        let result = await Networking.request_async(target)
        if result.is2000Ok {
            await UserManager.shared.getUserInfo()
            MainViewModel.shared.pageBack()
            Apphelper.shared.pushNotification(type: .success(message: "资料修改成功。"))
        }
    }

    @MainActor
    func getPhotos() async {
        let target = UserAPI.albumList(id: nil)
        let result = await Networking.request_async(target)
        if result.is2000Ok, let photos = result.mapArray(XMPhoto.self) {
            self.photos = photos
        }
    }

    @MainActor
    func updatePhotos(urls: [String]) async {
        let urls = photos.map { $0.picPath } + urls
        let target = UserAPI.updateAlbum(p: urls)
        let result = await Networking.request_async(target)
        if result.is2000Ok {
            await getPhotos()
        }
    }
}

struct ProfileEditView: View {
    @StateObject var vm: ProfileEditViewModel = .init()
    var w: CGFloat {
        (UIScreen.main.bounds.size.width - 16 - 16 - 8 - 8 - 8) / 3
    }

    @State private var active: XMPhoto?

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 28, pinnedViews: [], content: {
                avatar
                nickname
                bio
                
                bdsmAtt
                photosWall
                emotionNeed
                interestsTag
                height
                moreInfo
            })
            .tint(Color.XMDesgin.main)
            .font(.XMFont.f1b)
            .scrollIndicators(.hidden)
            .fcolor(.XMDesgin.f1)
            .padding(.all, 16)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    XMDesgin.SmallBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.main, iconName: "", text: "完成") {
                        await vm.updateUserInfo()
                        await vm.updatePhotos(urls: [])
                    }
                }
                
                ToolbarItem(placement: .keyboard) {
                    XMDesgin.XMIcon(iconName: "system_arrow_down_circle", withBackCricle: true)
                        .onTapGesture {
                            Apphelper.shared.closeKeyBoard()
                        }
                        .moveTo(alignment: .trailing)
                }
            }
        }
        .reorderableForEachContainer(active: $active)
    }

    var avatar: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text("头像")
            XMDesgin.XMButton(action: {
                Apphelper.shared.present(
                    SinglePhotoSelector(completionHandler: { UIImage in
                        vm.avatar = UIImage
                    }), presentationStyle: .fullScreen
                )
            }, label: {
                Group {
                    if let avatar = vm.avatar {
                        Image(uiImage: avatar)
                            .resizable()
                            .scaledToFill()
                    } else {
                        WebImage(str: vm.updateModel.avatar)
                            .scaledToFill()
                    }
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            })
        })
    }

    var moreInfo: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text("更多信息")
            Picker(selection: $vm.updateModel.education) {
                ForEach(0...5, id: \.self) { index in
                    Text("\(index.educationString)").tag(index)
                }
            } label: {
                XMDesgin.XMListRow(.init(name: "教育信息", icon: "inforequest_drink", subline: ""), showRightArrow: false) {}
                    .disabled(true)
            }
            .pickerStyle(.navigationLink)
        })
    }

    

    var height: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text("身高")
            XMDesgin.XMListRow(.init(name: "\(vm.updateModel.height)cm", icon: "inforequest_ruler", subline: "")) {
                Apphelper.shared.presentPanSheet(
                    VStack(alignment: .leading, spacing: 12, content: {
                        Text("身高设置")
                            .font(.headline).bold()
                        Picker("Height", selection: $vm.updateModel.height) {
                            ForEach(130 ..< 240) { height in
                                Text("\(height) cm").tag(height)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .labelsHidden()
                    }).padding(.all),
                    style: .sheet
                )
            }
        })
    }

    var interestsTag: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text("兴趣标签")
            NavigationLink {
                HobbySelectedView()
                    .navigationTitle("选择标签")
                    .toolbarRole(.editor)
                    .environmentObject(vm)
                    .navigationBarTitleDisplayMode(.inline)

            } label: {
                XMDesgin.XMListRow(.init(name: vm.updateModel.interestsTagList.joined(separator: "、").or("尚无标签"), icon: "", subline: "选择标签")) {}
                    .disabled(true)
            }
        })
    }

    var bdsmAtt: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text("自我认同")

            Picker(selection: $vm.updateModel.bdsmAttr) {
                ForEach(0...4, id: \.self) { index in
                    Text(index.bdsmAttrString)
                        .tag(index)
                }
            }
            .pickerStyle(.segmented)
        })
    }

    var photosWall: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text("照片墙")
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 8) {
                ReorderableForEach(vm.photos, active: $active) { photo in
                    XMDesgin.XMButton.init {
                        Apphelper.shared.tapToShowImage(tapUrl: photo.picUrl, rect: nil, urls: nil)
                    } label: {
                        WebImage(str: photo.picUrl)
                            .scaledToFill()
                            .frame(width: w, height: w / 3 * 4)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .overlay(alignment: .topTrailing) {
                        XMDesgin.XMButton(action: {
                            withAnimation {
                                vm.photos.removeAll(where: { $0.id == photo.id })
                            }
                        }, label: {
                            XMDesgin.XMIcon(iconName: "system_xmark", size: 16, color: .XMDesgin.f1, withBackCricle: true)
                        })
                        .padding(.all, 6)
                    }
                    .transition(.asymmetric(insertion: .movingParts.blur, removal: .movingParts.poof.animation(.easeInOut(duration: 0.5))))
                } preview: { _ in
                    Color.clear
                        .scaledToFill()
                        .frame(width: w, height: w / 3 * 4)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } moveAction: { from, to in
                    vm.photos.move(fromOffsets: from, toOffset: to)
                }

                XMDesgin.XMButton {
                    Apphelper.shared.present(
                        PhotoSelector(maxSelection: 9 - vm.photos.count, completionHandler: { uiimages in
                            LoadingTask(loadingMessage: "正在处理..") {
                                // 阿里云图片上传，之后请求接口，刷新页面
                                // 期间不允许用户操作
                                if let urls = await AliyunOSSManager.shared.upLoadImages_async(images: uiimages) {
                                    await vm.updatePhotos(urls: urls)
                                }
                            }
                        }),
                        presentationStyle: .fullScreen
                    )
                } label: {
                    Color.XMDesgin.b1
                        .overlay(content: {
                            XMDesgin.XMIcon(iconName: "system_add")
                        })
                        .frame(width: w, height: w / 3 * 4)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                }.ifshow(show: vm.photos.count < 9)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        })
    }

    var emotionNeed: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text("情感需求")
            Picker(selection: $vm.updateModel.emotionalNeeds) {
                ForEach(0...2, id: \.self) { index in
                    Text(index.emotionalNeedsString)
                        .tag(index)
                }
            }
            .pickerStyle(.segmented)
        })
    }

    var bio: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text("个人简介 (\(vm.updateModel.signature.count)/300)")

            TextEditor(text: $vm.updateModel.signature)
                .font(.XMFont.f1)
                .fcolor(.XMDesgin.f1)
                .tint(Color.XMDesgin.main)
                .frame(height: 100)
                .scrollContentBackground(.hidden)
                .padding(.all, 12)
                .background {
                    Color.XMDesgin.b1
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
        })
    }

    var nickname: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text("昵称")
            TextField(text: $vm.updateModel.nickname)
                .font(.XMFont.f1)
                .fcolor(.XMDesgin.f1)
                .scrollContentBackground(.hidden)
                .padding(.all, 12)
                .background {
                    Color.XMDesgin.b1
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
        })
    }
}

#Preview {
    ProfileEditView()
}

public typealias Reorderable = Identifiable & Equatable
public struct ReorderableForEach<Item: Reorderable, Content: View, Preview: View>: View {
    public init(
        _ items: [Item],
        active: Binding<Item?>,
        @ViewBuilder content: @escaping (Item) -> Content,
        @ViewBuilder preview: @escaping (Item) -> Preview,
        moveAction: @escaping (IndexSet, Int) -> Void
    ) {
        self.items = items
        self._active = active
        self.content = content
        self.preview = preview
        self.moveAction = moveAction
    }

    public init(
        _ items: [Item],
        active: Binding<Item?>,
        @ViewBuilder content: @escaping (Item) -> Content,
        moveAction: @escaping (IndexSet, Int) -> Void
    ) where Preview == EmptyView {
        self.items = items
        self._active = active
        self.content = content
        self.preview = nil
        self.moveAction = moveAction
    }

    @Binding
    private var active: Item?

    @State
    private var hasChangedLocation = false

    private let items: [Item]
    private let content: (Item) -> Content
    private let preview: ((Item) -> Preview)?
    private let moveAction: (IndexSet, Int) -> Void

    public var body: some View {
        ForEach(items) { item in
            if let preview {
                contentView(for: item)
                    .onDrag {
                        dragData(for: item)
                    } preview: {
                        preview(item)
                    }
            } else {
                contentView(for: item)
                    .onDrag {
                        dragData(for: item)
                    }
            }
        }
    }

    private func contentView(for item: Item) -> some View {
        content(item)
            .opacity(active == item && hasChangedLocation ? 0.5 : 1)
            .onDrop(
                of: [.text],
                delegate: ReorderableDragRelocateDelegate(
                    item: item,
                    items: items,
                    active: $active,
                    hasChangedLocation: $hasChangedLocation
                ) { from, to in
                    withAnimation {
                        moveAction(from, to)
                    }
                }
            )
    }

    private func dragData(for item: Item) -> NSItemProvider {
        active = item
        return NSItemProvider(object: "\(item.id)" as NSString)
    }
}

struct ReorderableDragRelocateDelegate<Item: Reorderable>: DropDelegate {
    let item: Item
    var items: [Item]

    @Binding var active: Item?
    @Binding var hasChangedLocation: Bool

    var moveAction: (IndexSet, Int) -> Void

    func dropEntered(info: DropInfo) {
        guard item != active, let current = active else { return }
        guard let from = items.firstIndex(of: current) else { return }
        guard let to = items.firstIndex(of: item) else { return }
        hasChangedLocation = true
        if items[to] != current {
            moveAction(IndexSet(integer: from), to > from ? to + 1 : to)
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        hasChangedLocation = false
        active = nil
        return true
    }
}

struct ReorderableDropOutsideDelegate<Item: Reorderable>: DropDelegate {
    @Binding
    var active: Item?

    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        active = nil
        return true
    }
}

public extension View {
    func reorderableForEachContainer<Item: Reorderable>(
        active: Binding<Item?>
    ) -> some View {
        onDrop(of: [.text], delegate: ReorderableDropOutsideDelegate(active: active))
    }
}
