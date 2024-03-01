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
            .foregroundColor(color)
            .frame(width: size, height: size, alignment: .center)
        }
    }

    struct SmallBtn: View {
        var fColor: Color
        var backColor: Color
        var iconName: String
        var text: String
        var action: () -> ()
        @State var onTap: Bool = false
        init(fColor: Color = .black, backColor: Color = .white, iconName: String = "home_bell", text: String = "text", action: @escaping () -> ()) {
            self.fColor = fColor
            self.backColor = backColor
            self.iconName = iconName
            self.text = text
            self.action = action
        }

        var body: some View {
            XMDesgin.XMButton {
                action()
            } label: {
                HStack(spacing: 2) {
                    if !iconName.isEmpty {
                        XMDesgin.XMIcon(iconName: iconName, color: fColor)
                    }

                    Text(text)
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(fColor)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Rectangle().foregroundColor(backColor))
                .clipShape(RoundedRectangle(cornerRadius: 99))
            }
        }
    }

    struct CircleBtn: View {
        var backColor: Color
        var fColor: Color
        var iconName: String
        var enable: Bool
        var action: () -> ()

        init(backColor: Color = .black, fColor: Color = .white, iconName: String = "home_bell", enable: Bool = true, action: @escaping () -> ()) {
            self.backColor = backColor
            self.fColor = fColor
            self.enable = enable
            self.iconName = iconName
            self.action = action
        }

        var body: some View {
            XMDesgin.XMButton(enable: enable) {
                action()
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
        var action: () -> ()
        var label: () -> Content
        @State var onTap: Bool = false
        @State var shake: Int = 0
        init(enable: Bool = true, action: @escaping () -> (), @ViewBuilder label: @escaping () -> Content) {
            self.enable = enable
            self.action = action
            self.label = label
        }

        var body: some View {
            label()
                ._onButtonGesture {
                    onTap = $0
                } perform: {
                    guard enable else {
                        shake += 1
                        Apphelper.shared.nofimada(.error)
                        return
                    }
                    Apphelper.shared.mada(style: .light)
                    action()
                }
                .conditionalEffect(.pushDown, condition: self.onTap)
                .changeEffect(.glow(color: .white), value: self.onTap)
                .changeEffect(.shake(rate: .fast), value: shake)
        }
    }

    struct XMMainBtn: View {
        var fColor: Color
        var backColor: Color
        var iconName: String
        var text: String
        var action: () -> ()
        @State var onTap: Bool = false
        init(fColor: Color = .black, backColor: Color = .white, iconName: String = "", text: String = "text", action: @escaping () -> ()) {
            self.fColor = fColor
            self.backColor = backColor
            self.iconName = iconName
            self.text = text
            self.action = action
        }

        var body: some View {
            XMDesgin.XMButton {
                action()
            } label: {
                HStack(spacing: 2) {
                    if !iconName.isEmpty {
                        XMDesgin.XMIcon(iconName: iconName, color: fColor)
                    }
                    Text(text)
                        .font(.body.bold())
                        .bold()
                        .foregroundStyle(fColor)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Rectangle().foregroundColor(backColor))
                .clipShape(RoundedRectangle(cornerRadius: 99))
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
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.XMDesgin.f1)
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
            }
        }
    }

    struct XMListRow: View {
        var info: LabelInfo
        var action: () -> ()
        init(_ info: LabelInfo, action: @escaping () -> ()) {
            self.info = info
            self.action = action
        }

        var body: some View {
            XMButton {
                action()
            } label: {
                VStack(alignment: .leading, spacing: 14) {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 1)
                        .foregroundColor(.XMDesgin.f3.opacity(0.8))
                        .opacity(0)

                    HStack(spacing: 14) {
                        XMDesgin.XMIcon(iconName: info.icon, size: 28)
                        Text(info.name).bold()
                            .foregroundStyle(Color.XMDesgin.f1)
                        Spacer()
                        Text(info.subline)
                            .font(.subheadline)
                            .foregroundStyle(Color.XMDesgin.f2)
                        XMDesgin.XMIcon(iconName: "system_arrow_right", size: 18, color: Color.XMDesgin.f2)
                    }
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 2)
                        .foregroundColor(.XMDesgin.b1)
                        .padding(.leading, 28 + 14)
                }
                .contentShape(RoundedRectangle(cornerRadius: 12))
            }
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
    }
    .padding(.all)
}
