//
//  LaunchScreenAnimation.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/26.
//


struct LaunchScreenAnimation: View {
    @State var animationStep: Int = 0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
                .transition(.asymmetric(insertion: .scale(scale: 1), removal: .opacity))
                .ifshow(show: animationStep < 1)

            Image("Logo")
                .resizable()
                .frame(width: 92, height: 92)
                .scaleEffect(animationStep >= 2 ? 0.4 : 1)
                .opacity(animationStep >= 2 ? 0 : 1)
                .offset(x: animationStep >= 2 ? 120 : 0, y: animationStep >= 1 ? 320 : -120)
                .animation(.interpolatingSpring(stiffness: 100, damping: 12), value: animationStep)
        }
        .onAppear(perform: {
            withAnimation {
                animationStep += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        animationStep += 1
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                animationStep += 1
                            }
                        }
                    }
                }
            }
        })
        .ifshow(show: animationStep < 3)
    }
}

#Preview {
    LaunchScreenAnimation()
}
