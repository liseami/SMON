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
    
    
}

struct ShakeViewModifier: ViewModifier {
    @State var shake: Bool = false
    func body(content: Content) -> some View {
        content
            .changeEffect(.shake, value: shake)
    }
}
