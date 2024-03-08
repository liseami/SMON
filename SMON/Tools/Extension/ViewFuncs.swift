//
//  ViewFuncs.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/25.
//

import Foundation
import SwiftUI

extension View {
    func addBack() -> some View {
        return self
    }

    func ifshow(show: Bool) -> some View {
        Group {
            if show {
                self
            } else {
                EmptyView()
            }
        }.hidden(!show)
    }

    func host() -> UIViewController {
        return UIHostingController(rootView: self)
    }

    func isShakeBtn(enable: Bool, action: @escaping () -> Void) -> some View {
        disabled(true).modifier(ShakeViewModifier(enable: enable, action: action))
    }

    func autoOpenKeyboard() -> some View {
        return modifier(KeyBoardFocusModifier())
    }

    func moveTo(alignment: SwiftUI.Alignment) -> some View {
        return frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }

    func canSkip(action: @escaping () -> Void) -> some View {
        overlay {
            XMDesgin.XMButton {
                action()
            } label: {
                Text("跳过").font(.XMFont.f1)
                    .fcolor(.XMDesgin.f2)
            }
            .padding(.all)
            .padding(.bottom, 22)
            .moveTo(alignment: .bottomLeading)
        }
    }
}

struct ShakeViewModifier: ViewModifier {
    @State var shake: Int = 0
    var action: () -> Void
    var enable: Bool = true
    init(enable: Bool = true, action: @escaping () -> Void) {
        self.action = action
        self.enable = enable
    }

    func body(content: Content) -> some View {
        XMDesgin.XMButton {
            guard enable else { shake += 1; return }
            action()
        } label: {
            content
        }
        .changeEffect(.shake(rate: .fast), value: shake)
    }
}

struct KeyBoardFocusModifier: ViewModifier {
    @FocusState var input
    func body(content: Content) -> some View {
        content.focused($input)
            .onAppear {
                input = true
            }
    }
}
