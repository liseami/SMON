//
//  MainTabbar.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/23.
//

import Pow
import SwiftUI

struct MainTabbar: View {
    @EnvironmentObject var vm: MainViewModel
    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0.8), Color.black.opacity(0)]), startPoint: .bottom, endPoint: .top)
                .frame(height: 120)
                .frame(maxHeight: .infinity, alignment: .bottomLeading)
                .ignoresSafeArea()
            VStack(spacing: 16) {
                Capsule()
                    .frame(height: 2)
                    .foregroundColor(.secondary.opacity(0.4))
                    .padding(.horizontal)
                tabIcons
            }
            .padding(.horizontal)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
    }

    var tabIcons: some View {
        HStack {
            ForEach(MainViewModel.TabbarItem.allCases, id: \.self) { tabitem in
                let selected = vm.currentTabbar == tabitem
                Button(action: {
                    vm.currentTabbar = tabitem
                    Apphelper.shared.mada(style: .rigid)
                }, label: {
                    XMDesgin.XMIcon(iconName: tabitem.labelInfo.icon)
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
    MainView()
}
