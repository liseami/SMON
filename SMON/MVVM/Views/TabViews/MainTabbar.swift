//
//  MainTabbar.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/23.
//

struct MainTabbar: View {
    @EnvironmentObject var vm: MainViewModel
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
                    .foregroundColor(.secondary.opacity(0.4))
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
            if vm.currentTabbar == .home {
                vm.showHotBuyView = true
            } else {
                vm.showPostEditor = true
            }
        } label: {
            LinearGradient(gradient: Gradient(colors: [Color(hex: "AA7E1F"), Color(hex: "7A5309"), Color(hex: "AA7E1F")]), startPoint: .bottomLeading, endPoint: .topTrailing)
                .frame(width: 58, height: 58, alignment: .center)
                .overlay(alignment: .center, content: {
                    Circle().stroke(lineWidth: 2)
                        .foregroundColor(.init(hex: "D9C15B"))
                })
                .clipShape(Circle())
                .changeEffect(.shine, value: vm.currentTabbar, isEnabled: true)
                .shadow(color: .gray, radius: 2, x: 0, y: 1)
                .shadow(color: .black.opacity(0.6), radius: 8, x: 0, y: 1)
                .overlay {
                    VStack(spacing: 0) {
                        XMDesgin.XMIcon(iconName: iconName, color: .white)
                        Text(btnName)
                            .font(.caption2)
                            .foregroundColor(.white)
                            .ifshow(show: !btnName.isEmpty)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .ifshow(show: !iconName.isEmpty)
        }
    }

    var tabIcons: some View {
        HStack {
            ForEach(MainViewModel.TabbarItem.allCases, id: \.self) { tabitem in
                let selected = vm.currentTabbar == tabitem
                Button(action: {
                    vm.currentTabbar = tabitem
                    Apphelper.shared.mada(style: .rigid)
                }, label: {
                    XMDesgin.XMIcon(iconName: tabitem.labelInfo.icon, size: 28)
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
