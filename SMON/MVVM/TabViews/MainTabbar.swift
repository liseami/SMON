//
//  MainTabbar.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/23.
//

import SwiftUI

struct MainTabbar: View {
    @EnvironmentObject var vm: MainViewModel
    var body: some View {
        HStack {
            ForEach(MainViewModel.TabbarItem.allCases, id: \.self) { tabitem in
                Button(action: { vm.currentTabbar = tabitem }, label: {
                    Text(tabitem.labelInfo.name)
                        .frame(maxWidth: .infinity)
                })
            }
        }
        .padding(.all)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
}

#Preview {
    MainTabbar().environmentObject(MainViewModel())
}
