//
//  UserInfoRequestMainView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import Pow
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
                        case .bdsm: BdsmRequestView()
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
        .overlay {
            progressLine
        }
    }

    var progressLine: some View {
        ZStack(alignment: .leading) {
            Capsule().fill(Color.XMDesgin.b3.opacity(0.3))
            LinearGradient(gradient: Gradient(colors: [Color(hex: "AA7E1F"), Color(hex: "7A5309"), Color(hex: "AA7E1F")]), startPoint: .leading, endPoint: .trailing)
                .clipShape(Capsule())
                .frame(width: 40 + CGFloat(240 * vm.presentedSteps.count / UserInfoRequestViewModel.PageStep.allCases.count))
        }
        .frame(width: 280, height: 5)
        .changeEffect(.shine(duration: 1).delay(1), value: vm.presentedSteps, isEnabled: true)
        .overlay(alignment: .trailing, content: {
            Text("🔥")
                .opacity(0)
                .changeEffect(.rise(origin: .bottom) {
                    Text("🔥")
                        .foregroundStyle(Color.XMDesgin.f1)
                }, value: vm.presentedSteps)
        })
        .changeEffect(.glow(color: .white), value: vm.presentedSteps)
        .moveTo(alignment: .top)
        .padding(.top, 24)
    }
}

#Preview {
    UserInfoRequestMainView()
}
