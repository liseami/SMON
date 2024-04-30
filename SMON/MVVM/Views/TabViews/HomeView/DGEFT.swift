//
//  DGEFT.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/4/30.
//

import SwiftUI

//
//  GradientWave.swift
//  NewScroll
//
//  Created by Astemir Eleev on 01.07.2023.
//

import SwiftUI

@available(iOS 17.0, *)
struct GradientWave: View {
    @State private var thinness: CGFloat = 5.0
    @State private var scale: CGFloat = 1.0
    @State private var color: Color = .black

    private let date = Date()

    var body: some View {
        List {
            TimelineView(.animation) {
                let time = date.timeIntervalSince1970 - $0.date.timeIntervalSince1970

                Rectangle()
                    .aspectRatio(1, contentMode: .fit)
                    .colorEffect(ShaderLibrary.gradientWave(
                        .boundingRect,
                        .float(time),
                        .color(color),
                        .float(thinness),
                        .float(0),
                        .float(scale)
                    ))
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))

            Section("Thinness") {
                Slider(value: $thinness, in: 0.5...10)
            }
            Section("Scale") {
                Slider(value: $scale, in: 1...10)
            }
            Section("Color") {
                ColorPicker(
                    "Wave",
                    selection: $color,
                    supportsOpacity: false
                )
            }
        }
    }
}

#Preview("Gradient Wave") {
    Group {
        if #available(iOS 17.0, *) {
            GradientWave()
        } else {
            // Fallback on earlier versions
        }
    }
}
