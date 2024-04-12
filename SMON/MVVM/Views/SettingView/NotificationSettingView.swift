//
//  NotificationSettingView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/10.
//

import SwiftUI

struct NotificationSetting: Convertible {
    var sayHello: Int = 0 // ": 10,
    var dynamic: Int = 0 // ": 10,
    var receiveGift: Int = 0 // ": 10,
    var theme: Int = 0 // ": 0,
}

struct NotificationSettingBool {
    var sayHello: Bool = false
    var dynamic: Bool = false
    var receiveGift: Bool = false
    var theme: Bool = false
}

class NotificationSettingViewModel: ObservableObject {
    @Published var setting: NotificationSetting?

    @Published var settingBool: NotificationSettingBool = .init()

    init() {
        Task {
            await self.getCurrentSetting()
        }
    }

    @Published var allOpen: Bool = true

    @MainActor
    func updateSetting() async {
        guard let setting else { return }
        let updateSetting = NotificationSetting(sayHello: self.settingBool.sayHello ? 10 : 0, dynamic: self.settingBool.dynamic ? 10 : 0, receiveGift: self.settingBool.receiveGift ? 10 : 0, theme: self.settingBool.theme ? 10 : 0)
        let t = NoticeAPI.setting(p: updateSetting)
        let r = await Networking.request_async(t)
        if r.is2000Ok {
            MainViewModel.shared.pageBack()
        }
    }

    @MainActor
    func getCurrentSetting() async {
        let t = NoticeAPI.getSettingInfo
        let r = await Networking.request_async(t)
        if r.is2000Ok, let mod = r.mapObject(NotificationSetting.self) {
            self.setting = mod
            self.settingBool = .init(sayHello: mod.sayHello == 10, dynamic: mod.dynamic == 10, receiveGift: mod.receiveGift == 10, theme: mod.theme == 10)
        }
    }
}

struct NotificationSettingView: View {
    @StateObject var vm: NotificationSettingViewModel = .init()
    var body: some View {
        List {
            XMSection(title: "通知开关") {
                if let _ = vm.setting {
                    Group {
                        Toggle(isOn: $vm.allOpen, label: {
                            Text("全局开关")
                        })
                        Toggle(isOn: $vm.settingBool.sayHello, label: {
                            Text("私信")
                        })
                        Toggle(isOn: $vm.settingBool.dynamic, label: {
                            Text("动态点赞、评论")
                        })
                        Toggle(isOn: $vm.settingBool.receiveGift, label: {
                            Text("收获礼物")
                        })
                        Toggle(isOn: $vm.settingBool.theme, label: {
                            Text("大赛")
                        })
                    }
                } else {
                    ProgressView()
                }
            }
            .onChange(of: vm.allOpen) { bool in
                vm.settingBool.dynamic = bool
                vm.settingBool.receiveGift = bool
                vm.settingBool.sayHello = bool
                vm.settingBool.theme = bool
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                XMDesgin.SmallBtn(text: "完成") {
                    await vm.updateSetting()
                }
            }
        })
        .navigationTitle("通知")
        .listStyle(.plain)
    }
}

#Preview {
    NotificationSettingView()
}
