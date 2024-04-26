//
//  Components.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/25.
//

enum XMDesgin {
    struct XMIcon: View {
        var size: CGFloat
        var color: Color
        var withBackCricle: Bool
        var iconName: String?
        var systemName: String?

        init(iconName: String, size: CGFloat = 22, color: Color = .white, withBackCricle: Bool = false) {
            self.iconName = iconName
            self.size = size
            self.withBackCricle = withBackCricle
            self.color = color
        }

        init(systemName: String, size: CGFloat = 22, color: Color = .white, withBackCricle: Bool = false) {
            self.systemName = systemName
            self.size = size
            self.withBackCricle = withBackCricle
            self.color = color
        }

        var body: some View {
            if withBackCricle {
                icon
                    .padding(.all, 8)
                    .background(Color.XMDesgin.b1)
                    .clipShape(Circle())
                    .contentShape(Circle())
            } else {
                icon
            }
        }

        var icon: some View {
            Group {
                if let iconName {
                    Image(iconName)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                } else if let systemName {
                    Image(systemName: systemName)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                }
            }
            .fcolor(color)
            .frame(width: size, height: size, alignment: .center)
        }
    }

    struct XMAuthorTag: View {
        var body: some View {
            Text("作者")
                .font(.XMFont.f3b)
                .fcolor(.XMDesgin.f1)
                .padding(.all, 4)
                .padding(.horizontal, 2)
                .background(Capsule().fill(Color.XMDesgin.main.gradient))
        }
    }

    struct XMTag: View {
        let text: String
        let bgcolor: Color
        init(text: String, bgcolor: Color = Color.XMDesgin.b1) {
            self.text = text
            self.bgcolor = bgcolor
        }

        var body: some View {
            Text(text)
                .font(.XMFont.f2b)
                .fcolor(.XMDesgin.f1)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(bgcolor)
                .clipShape(Capsule())
        }
    }

    struct SmallBtn: View {
        var fColor: Color
        var backColor: Color
        var iconName: String
        var text: String
        var action: () async -> ()
        @State var onTap: Bool = false
        init(fColor: Color = .black, backColor: Color = .white, iconName: String = "", text: String = "text", action: @escaping () async -> ()) {
            self.fColor = fColor
            self.backColor = backColor
            self.iconName = iconName
            self.text = text
            self.action = action
        }

        var body: some View {
            XMDesgin.XMButton {
                await action()
            } label: {
                HStack(spacing: 2) {
                    XMDesgin.XMIcon(iconName: iconName, color: fColor)
                        .opacity(iconName.isEmpty ? 0 : 1)
                        .ifshow(show: !iconName.isEmpty)

                    Text(text)
                        .height(22)
                        .font(.XMFont.f2b)
                        .lineLimit(1)
                        .fcolor(fColor)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Rectangle().fcolor(backColor))
                .clipShape(Capsule())
            }
        }
    }

    struct CircleBtn: View {
        var backColor: Color
        var fColor: Color
        var iconName: String
        var enable: Bool
        var action: () async -> ()

        init(backColor: Color = .black, fColor: Color = .white, iconName: String = "home_bell", enable: Bool = true, action: @escaping () async -> ()) {
            self.backColor = backColor
            self.fColor = fColor
            self.enable = enable
            self.iconName = iconName
            self.action = action
        }

        var body: some View {
            XMDesgin.XMButton(enable: enable) {
                await action()
            } label: {
                Circle()
                    .fill(backColor)
                    .frame(width: 58, height: 58)
                    .overlay {
                        XMDesgin.XMIcon(iconName: iconName, color: fColor)
                    }
            }
        }
    }

    struct XMButton<Content>: View where Content: View {
        var enable: Bool
        var action: () async -> ()
        var label: () -> Content
        @State var onTap: Bool = false
        @State var shake: Int = 0
        @State var isLoading: Bool = false
        init(enable: Bool = true, action: @MainActor @escaping () async -> (), @ViewBuilder label: @escaping () -> Content) {
            self.enable = enable
            self.action = action
            self.label = label
        }

        var body: some View {
            label()
                .opacity(isLoading ? 0 : 1)
                ._onButtonGesture {
                    guard isLoading == false else { return }
                    onTap = $0
                } perform: {
                    Task {
                        guard !isLoading else { return }
                        guard enable else {
                            shake += 1
                            Apphelper.shared.nofimada(.error)
                            return
                        }
                        Apphelper.shared.mada(style: .light)
                        self.isLoading = true
                        await action()
                        self.isLoading = false
                    }
                }
                .conditionalEffect(.pushDown, condition: self.onTap)
                .changeEffect(.glow(color: .white), value: self.onTap)
                .changeEffect(.shake(rate: .fast), value: shake)
                .overlay {
                    ProgressView()
                        .preferredColorScheme(.dark)
                        .ifshow(show: isLoading)
                }
        }
    }

    struct XMMainBtn: View {
        var fColor: Color
        var backColor: Color
        var iconName: String
        var text: String
        var enable: Bool
        var action: () async -> ()
        @State var onTap: Bool = false
        init(fColor: Color = .XMDesgin.b1, backColor: Color = .XMDesgin.f1, iconName: String = "", text: String = "text", enable: Bool = true, action: @escaping () async -> ()) {
            self.fColor = fColor
            self.backColor = backColor
            self.iconName = iconName
            self.text = text
            self.action = action
            self.enable = enable
        }

        var body: some View {
            XMDesgin.XMButton(enable: enable) {
                await action()
            } label: {
                HStack(spacing: 2) {
                    if !iconName.isEmpty {
                        XMDesgin.XMIcon(iconName: iconName, color: fColor)
                    }
                    Text(text)
                        .font(.XMFont.f2)
                        .foregroundStyle(fColor)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Rectangle().fcolor(backColor))
                .clipShape(RoundedRectangle(cornerRadius: 4))
            }
        }
    }

    struct SelectionTable: View {
        var text: String
        var selected: Bool
        var action: () -> ()

        init(text: String, selected: Bool = false, action: @escaping () -> ()) {
            self.text = text
            self.selected = selected
            self.action = action
        }

        var body: some View {
            XMDesgin.XMButton {
                action()
            } label: {
                HStack(spacing: 24) {
                    Text(LocalizedStringKey(text))
                        .font(.XMFont.f1)
                        .multilineTextAlignment(.leading)
                        .fcolor(.XMDesgin.f1)
                        .tint(Color.XMDesgin.main)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    XMDesgin.XMIcon(systemName: "circle", size: 18, color: Color.XMDesgin.f1)
                        .overlay(alignment: .center) {
                            Circle()
                                .fill(Color.XMDesgin.f1)
                                .frame(width: 10, height: 10)
                                .ifshow(show: selected)
                        }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
                .background(Color.XMDesgin.b1)
                .clipShape(RoundedRectangle(cornerRadius: 12))
//                .changeEffect(.spray(origin: .center) {
//                    Group {
//                        Text("❤️‍🔥")
//                        Text("🔥")
//                    }
//                    .font(.title)
//                },  value: self.selected,isEnabled: self.selected != true)
            }
        }
    }

    struct XMListRow: View {
        var info: LabelInfo
        var showRightArrow: Bool
        var action: () -> ()
        init(_ info: LabelInfo, showRightArrow: Bool = true, action: @escaping () -> ()) {
            self.info = info
            self.showRightArrow = showRightArrow
            self.action = action
        }

        var body: some View {
            XMDesgin.XMButton {
                action()
            } label: {
                HStack(spacing: 14) {
                    XMDesgin.XMIcon(iconName: info.icon, size: 24)
                        .ifshow(show: !info.icon.isEmpty)
                    Text(info.name)
                        .font(.XMFont.f1b)
                        .fcolor(.XMDesgin.f1)
                        .lineLimit(1)
                    Spacer()
                    Text(info.subline)
                        .font(.XMFont.f2)
                        .fcolor(.XMDesgin.f2)
                    XMDesgin.XMIcon(iconName: "system_arrow_right", size: 16, color: Color.XMDesgin.f2)
                        .ifshow(show: showRightArrow)
                }
                .contentShape(Rectangle())
            }
        }
    }

    struct XMListRowInlist: View {
        var info: LabelInfo
        var action: () -> ()
        init(_ info: LabelInfo, action: @escaping () -> ()) {
            self.info = info
            self.action = action
        }

        var body: some View {
            XMDesgin.XMButton {
                action()
            } label: {
                HStack(spacing: 14) {
                    XMDesgin.XMIcon(iconName: info.icon, size: 24)
                        .ifshow(show: !info.icon.isEmpty)
                    Text(info.name)
                        .font(.XMFont.f1b)
                        .fcolor(.XMDesgin.f1)
                    Spacer()
                    Text(info.subline)
                        .font(.XMFont.f2)
                        .fcolor(.XMDesgin.f2)
                    XMDesgin.XMIcon(iconName: "system_arrow_right", size: 16, color: Color.XMDesgin.f2)
                }
                .contentShape(Rectangle())
            }
            .listRowBackground(Color.XMDesgin.b1)
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        XMDesgin.XMIcon(iconName: "tabbar_home")
        XMDesgin.XMIcon(systemName: "flag.badge.ellipsis")
        XMDesgin.SmallBtn {}
        XMDesgin.CircleBtn(backColor: .white, fColor: .black, iconName: "home_bell", enable: true) {}
        XMDesgin.SelectionTable(text: "男", selected: false) {}
        XMDesgin.XMMainBtn {}
        XMDesgin.XMListRow(.init(name: "home_bell", icon: "home_bell", subline: "2323")) {}
        XMDesgin.XMListRowInlist(.init(name: "home_bell", icon: "home_bell", subline: "")) {}
        XMDesgin.CircleBtn {
            await waitme()
        }
        XMDesgin.XMTag(text: "标签")
    }
    .padding(.all)
}
