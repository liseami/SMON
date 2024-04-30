//
//  UserInfoRequestMainView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

struct UserInfoRequestMainView: View {
    @StateObject var vm: UserInfoRequestViewModel = .init()
    var body: some View {
        NavigationStack(path: $vm.presentedSteps, root: {
            Color.clear
                .navigationDestination(for: UserInfoRequestViewModel.PageStep.self) { step in
                    Group {
                        switch step {
                        case .name: NameRequestView()
                        case .photo: AvatarRequestView()
                        case .morephoto: MorePhotoRequestView()
                        case .brithday: BrithdayDayRequestView()
                        case .sex: SexRequestView()
                        case .relationhope: RelationHopeRequestView()
                        case .hobby: HobbyRequestView()
                        case .height: HeightRequestView()
                        case .bdsm: BdsmRequestView()
                        case .wechat: WechatRequestView()
                        case .bio: BioRequestView()
                        }
                    }
                    .navigationBarBackButtonHidden()
                    .environmentObject(vm)
                }
        })
        
        .overlay {
            progressLine
        }
    }

    var progressLine: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(Color.XMDesgin.b3.opacity(0.3).gradient)
            Capsule()
                .fill(Color.XMDesgin.main.gradient)
                .frame(width: 40 + CGFloat(240 * vm.presentedSteps.count / UserInfoRequestViewModel.PageStep.allCases.count))
        }
        .frame(width: 280, height: 5)
        .changeEffect(.shine(duration: 1).delay(1), value: vm.presentedSteps, isEnabled: true)
        .overlay(alignment: .trailing, content: {
            Text("🔥")
                .opacity(0)
                .changeEffect(.rise(origin: .bottom) {
                    Text("🔥")
                        .fcolor(.XMDesgin.f1)
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
