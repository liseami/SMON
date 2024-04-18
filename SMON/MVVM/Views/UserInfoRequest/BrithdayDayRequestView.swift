//
//  BrithdayDayRequestView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import SwiftUI

struct BrithdayDayRequestView: View {
    @EnvironmentObject var vm: UserInfoRequestViewModel
    var body: some View {
        InfoRequestView(title: "您的生日是？", subline: "一旦选择，无法更改，请提供有效信息。", btnEnable: true) {
            VStack(alignment: .leading, spacing: 12, content: {
                XMDesgin.XMTag(text: "\(vm.brithday.zodiacEmojiString) \(vm.brithday.zodiacString)")

                    .changeEffect(.spray(origin: .center) {
                        Group {
                            Text("❤️‍🔥")
                            Text("🔥")
                        }
                        .font(.title)
                    }, value: vm.brithday)

                DatePicker("", selection: $vm.brithday, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .environment(\.locale, Locale(identifier: "zh-hans"))
                    .padding(.all)
                    .background(Color.XMDesgin.b1)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
            })

        } btnAction: {
            let result = await UserManager.shared.updateUserInfo(updateReqMod: .init(birthday: vm.brithday.string(withFormat: "yyyy-MM-dd")))
            if result.is2000Ok {
                vm.presentedSteps.append(.sex)
            }
        }
    }
}

#Preview {
    BrithdayDayRequestView()
        .environmentObject(UserInfoRequestViewModel())
}
