//
//  MainTabbar.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/23.
//

struct MainTabbar: View {
    @ObservedObject var vm: MainViewModel = .shared
    @State var showCircleBtn: Bool = false
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.frame(height: 40)
                .ignoresSafeArea()
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0.6)]), startPoint: .center, endPoint: .top)
                .blur(radius: 12)
                .frame(height: 100)
                .padding(.horizontal, -30)
                .ignoresSafeArea(edges: .bottom)
            VStack(spacing: 16) {
                // 悬浮圆形按钮
                circleBtn
                    .transition(.offset(x: -200).combined(with: .movingParts.flip).combined(with: .scale(scale: 0)).combined(with: .opacity))
                    .ifshow(show: showCircleBtn)
                // 细线
                Capsule()
                    .frame(height: 2)
                    .fcolor(.XMColor.f2.opacity(0.4))
                    .padding(.horizontal)
                // tabbarIcons
                tabIcons
            }
            .padding(.all)
            .padding(.bottom)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                withAnimation(.interpolatingSpring(stiffness: 100, damping: 20)) {
                    showCircleBtn = true
                }
            }
        })
    }

    var circleBtn: some View {
        let iconName = vm.currentTabbar.circleBtnInfo.icon
        let btnName = vm.currentTabbar.circleBtnInfo.name
        return XMDesgin.XMButton {
            if vm.currentTabbar == .rank {
//                vm.showHotBuyView = true
                DispatchQueue.main.async {
                    Apphelper.shared.presentPanSheet(HotBuyView(), style: .cloud)
                }
            } else {
                DispatchQueue.main.async {
                    Apphelper.shared.present(PostEditView(), presentationStyle: .fullScreen)
                }
            }

        } label: {
            LinearGradient(gradient: Gradient(colors: [Color(hex: "AA7E1F"), Color(hex: "7A5309"), Color(hex: "AA7E1F")]), startPoint: .bottomLeading, endPoint: .topTrailing)
                .frame(width: 58, height: 58, alignment: .center)
                .overlay(alignment: .center, content: {
                    Circle().stroke(lineWidth: 2)
                        .fcolor(.init(hex: "D9C15B"))
                })
                .clipShape(Circle())
                // 冒烟
                .conditionalEffect(.smoke, condition: vm.currentTabbar == .rank)
                .overlay {
                    VStack(spacing: 0) {
                        XMDesgin.XMIcon(iconName: iconName, color: .white)
                        Text(btnName)
                            .font(.XMFont.f3b)
                            .fcolor(.XMColor.f1)
                            .ifshow(show: !btnName.isEmpty)
                    }
                }
                // 变到榜单时，jump
                .changeEffect(.spray(origin: .center) {
                    Group {
                        Text("❤️‍🔥")
                        Text("🔥")
                    }
                    .font(.title)
                }, value: vm.homeBtnJump)
                .changeEffect(.jump(height: 32), value: vm.homeBtnJump, isEnabled: true)
                .changeEffect(.shine, value: vm.currentTabbar, isEnabled: true)

                .shadow(color: .gray, radius: 2, x: 0, y: 1)
                .shadow(color: .black.opacity(0.6), radius: 8, x: 0, y: 1)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .ifshow(show: !iconName.isEmpty)
        }
    }

    var tabIcons: some View {
        HStack {
            ForEach(MainViewModel.TabbarItem.allCases, id: \.self) { tabitem in
                let selected = vm.currentTabbar == tabitem
                Button(action: {
                    // 从别的地方切换到home
                    if tabitem == .rank {
                        vm.homeBtnJump += 1
                    }
//                    // 现在是hot，切换到别的地方
//                    if vm.currentTabbar == .home, tabitem != .home {
//                        vm.homeBtnJump += 1
//                    }
                    vm.currentTabbar = tabitem
                    Apphelper.shared.mada(style: .rigid)
                }, label: {
                    XMDesgin.XMIcon(iconName: tabitem.labelInfo.icon, size: 28)
                        .overlay(alignment: .topTrailing) {
                            Circle().fill(Color.XMColor.main.gradient)
                                .frame(width: 12, height: 12)
                                .font(.XMFont.f3b)
                                .ifshow(show: tabitem == .message && vm.unreadCount != 0)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.black.opacity(0.01))
                        .changeEffect(.jump(height: 3), value: vm.currentTabbar, isEnabled: tabitem == vm.currentTabbar)
                        .conditionalEffect(.pushDown, condition: tabitem == vm.currentTabbar)
                })
                .opacity(selected ? 1 : 0.6)
            }
        }
    }
}

#Preview {
//    MainTabbar().environmentObject(MainViewModel())
    MainView(vm: MainViewModel(currentTabbar: .feed))
}
