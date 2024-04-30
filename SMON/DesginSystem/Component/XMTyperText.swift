//
//  XMTyperText.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/2.
//

import SwiftUI


struct XMTyperText: View {
    let text: String
    var guangbiao: String {
        return currentIndex == text.count ? "" : " 🧡"
    }

    init(text: String) {
        self.text = text
    }
    @State private var currentIndex: Int = 0

    @State var timer: Timer?
    
    func scheduleTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: Double.random(in: 0.03...0.07), repeats: false) { _ in
            if currentIndex < text.count {
                DispatchQueue.main.async {
                    currentIndex += 1
                    Apphelper.shared.mada(style: .soft)
                    scheduleTimer()
                }
            }
        }
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Text(text.prefix(currentIndex))
            
                +
                Text(guangbiao)
        }
        .onAppear {
            scheduleTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
}

#Preview {
    XMTyperText(text: String.randomChineseString(length: 120))
}
