//
//  ProfileView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var vm: ProfileViewModel = .init()
    @State var openSettingView: Bool = true
    var body: some View {
        ScrollView(content: {
            ZStack(alignment: .top) {
                topImage
                profileInfo
            }
            tabBar
            mediaView
        })
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                XMDesgin.XMIcon(iconName: "profile_share")
                    .padding(.horizontal,8)
            }
            ToolbarItem(placement: .topBarTrailing) {
                XMDesgin.XMIcon(iconName: "home_bell")
                    .padding(.horizontal,8)
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingView()
                } label: {
                    XMDesgin.XMIcon(iconName: "profile_setting")
                }
                .foregroundColor(.white)
            }
        }
    }

    var topImage: some View {
        AsyncImage(url: URL(string: "https://i.pravatar.cc/1000")!)
            .scaledToFill()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
            .clipped()
            .ignoresSafeArea()
    }

    var profileInfo: some View {
        VStack {
            Spacer().frame(height: UIScreen.main.bounds.width - 60)
            VStack(alignment: .leading, spacing: 16) {
                Text("赵纯想")
                    .font(.largeTitle.bold())
                Text("乐观主义 · 天蝎座 · S属性 · 小顽童")
                    .font(.subheadline).foregroundStyle(.secondary)
                Text(String.randomChineseString(length: 120))
                    .lineLimit(4)
                    .font(.subheadline)
                XMDesgin.SmallBtn(fColor: .black, backColor: .white, iconName: "profile_edit", text: "编辑社交资料") {}
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(alignment: .top) {
                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black]), startPoint: .top, endPoint: .center)
                    .frame(height: 80)
//                            .offset(y:-12)
            }
        }
    }

    var tabBar: some View {
        HStack {
            ForEach(ProfileViewModel.ProfileBarItem.allCases, id: \.self) { tabitem in
                let selected = tabitem == vm.currentTab
                Text(tabitem.info.name)
                    .font(.body)
                    .bold()
                    .opacity(selected ? 1 : 0.6)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 24)
    }

    var w: CGFloat {
        (UIScreen.main.bounds.width - (16 * 2 + 8)) / 2
    }

    var h: CGFloat {
        w / 3 * 4
    }

    var mediaView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 16) {
            ForEach(0...99, id: \.self) { _ in

                ZStack(alignment: .bottom) {
                    AsyncImage(
                        url: URL(string: "https://i.pravatar.cc/500")!,
                        content: { image in

                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: w, height: h)
                        },
                        placeholder: {
                            ProgressView()
                                .frame(width: w, height: h)
                        }
                    )

                    LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black]), startPoint: .top, endPoint: .bottom)
                        .frame(height: 60)
                    Text(String.randomChineseString(length: Int.random(in: 2...24)))
                        .font(.subheadline)
                        .bold()
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.all, 12)
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.all)
    }
}

#Preview {
//    ProfileView()
    MainView(vm: .init(currentTabbar: .profile))
}
