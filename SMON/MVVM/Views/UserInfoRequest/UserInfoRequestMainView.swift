//
//  UserInfoRequestMainView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import SwiftUI

struct UserInfoRequestMainView: View {
    @StateObject var vm: UserInfoRequestViewModel = .init()
    var body: some View {
        NavigationStack(path: $vm.presentedSteps, root: {
            Text("1234")
                .onTapGesture {
                    vm.presentedSteps.append(.photo)
                }
                .navigationDestination(for: UserInfoRequestViewModel.PageStep.self) { step in
                    switch step {
                    case .photo: NameRequestView()
                            .environmentObject(vm)
                    }
                }
                
        })
    }
}

#Preview {
    UserInfoRequestMainView()
}
