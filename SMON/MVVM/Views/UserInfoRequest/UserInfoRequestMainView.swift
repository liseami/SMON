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
            NameRequestView()
                .environmentObject(vm)
                .navigationDestination(for: UserInfoRequestViewModel.PageStep.self) { step in
                    Group {
                        switch step {
                        case .photo: AvatarRequestView()
                        case .morephoto: MorePhotoRequestView()
                        case .brithday: BrithdayDayRequestView()
                        case .sex: SexRequestView()
                        case .relationhope: RelationHopeRequestView()
                        case .hobby: HobbyRequestView()
                        case .height: HeightRequestView()
                        case .drink: DrinkRequestView()
                        case .bdsm : BdsmRequestView()
                        case .smoke: SmokeRequestView()
                        case .bio: BioRequestView()
                        }
                    }
                    .navigationBarBackButtonHidden()
                    .environmentObject(vm)
                }
        })
        .fullScreenCover(isPresented: $vm.showCompleteView, content: {
            RequestCompleteView()
                .preferredColorScheme(.dark)
        })
    }
}

#Preview {
    UserInfoRequestMainView()
}
