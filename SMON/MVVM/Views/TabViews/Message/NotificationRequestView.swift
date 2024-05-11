//
//  NotificationRequestView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/4/17.
//

import SwiftUI



struct NotificationRequestView: View {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Text("不错过大赛的爆红选手")
                .font(.XMFont.big2.bold())
                .fcolor(.XMColor.f1)
            Text("不想错过大赛热点信息，可以体验我们为您专属定制的大赛通报。")
                .font(.XMFont.f2)
                .fcolor(.XMColor.f1)
            Spacer()
            Image("nitification_pagepic")
                .resizable()
                .scaledToFit()
                .frame(width: 280, height: 280)
            Spacer()

            Group{
                XMDesgin.XMMainBtn(text: "好的！") {
                    let entity = JPUSHRegisterEntity()
                    entity.types = 3
                    JPUSHService.register(forRemoteNotificationConfig: entity, delegate: appDelegate)
                    Apphelper.shared.closeSheet()
                }
            }
            
        }
        .background(content: {
            AutoLottieView(lottieFliesName: "location_background", loopMode: .loop, speed: 1)
                .scaleEffect(3)
        })
        .padding(.vertical, 32)
        .padding(.all, 32)
        .overlay(alignment: .topLeading) {
            XMDesgin.XMIcon(iconName: "system_xmark", size: 22, color: .XMColor.f1, withBackCricle: true)
                .onTapGesture {
                    Apphelper.shared.closeSheet()
                }
                .padding(.leading, 12)
        }
    }
}

#Preview {
    NotificationRequestView()
}
