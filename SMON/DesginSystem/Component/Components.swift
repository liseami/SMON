//
//  Components.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/25.
//

import SwiftUI

enum XMDesgin {
    struct XMIcon: View {
        var size: CGFloat
        var color: Color
        var iconName: String?
        var systemName: String?

        init(iconName: String, size: CGFloat = 28, color: Color = .white) {
            self.iconName = iconName
            self.size = size
            self.color = color
        }

        init(systemName: String, size: CGFloat = 28, color: Color = .white) {
            self.systemName = systemName
            self.size = size
            self.color = color
        }

        var body: some View {
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
        var action : () -> ()
        @State var onTap : Bool = false
        init(fColor: Color = .black, backColor: Color = .white, iconName: String = "home_bell", text: String = "text",action : @escaping () -> ()) {
            self.fColor = fColor
            self.backColor = backColor
            self.iconName = iconName
            self.text = text
            self.action = action
        }

        var body: some View {
            Button(action: {
                action()
                onTap.toggle()
                Apphelper.shared.mada(style: .light)
                
            }, label: {
                HStack(spacing: 2) {
                    XMDesgin.XMIcon(iconName: iconName, size: 22, color: fColor)
                    Text(text)
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(fColor)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Rectangle().foregroundColor(backColor))
                .clipShape(RoundedRectangle(cornerRadius: 99))
            })
            .conditionalEffect(.pushDown, condition: onTap)
        }
    }
}

#Preview {
    VStack {
        XMDesgin.XMIcon(iconName: "tabbar_home")
        XMDesgin.XMIcon(systemName: "flag.badge.ellipsis")
        XMDesgin.SmallBtn {
            
        }
    }
}
