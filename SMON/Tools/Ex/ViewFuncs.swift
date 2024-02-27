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
        Button(action: {
            Apphelper.shared.mada(style: .rigid)
            guard enable else { shake += 1; return }
            action()
        }) {
            content
        }
        .changeEffect(.shake(rate: .fast), value: shake)
    }
}
