//
//  RequestUserLocationAuthorizationView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/4/2.
//

import CoreLocation
import SwiftUI

struct RequestUserLocationAuthorizationView: View {
    @ObservedObject var location: LocationManager = .shared
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: NearRankViewModel
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Text("查看您附近的人？")
                .font(.XMFont.big2.bold())
                .fcolor(.XMDesgin.f1)
            Text("打开你的手机，看看谁在你所在的区域。否则无法推送与你最佳匹配的用户")
                .font(.XMFont.f2)
                .fcolor(.XMDesgin.f1)
            Spacer()
            Image("location_pagepic")
                .resizable()
                .scaledToFit()
                .frame(width: 280, height: 280)
            Spacer()
            if location.authorizationStatus == .denied {
                XMDesgin.XMMainBtn(text: "去系统设置打开位置权限") {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }

                XMDesgin.XMMainBtn(text: "我已打开，刷新权限") {
                    if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                        presentationMode.dismiss()
                        await vm.getListData()
                    } else {
                        Apphelper.shared.pushNotification(type: .error(message: "重试或重新打开APP"))
                    }
                }
            } else {
                XMDesgin.XMMainBtn(text: "打开位置权限") {
                    location.requestLocationPermission()
                }
            }
        }
        .onChange(of: location.authorizationStatus, perform: { value in
            if value == .authorizedWhenInUse {
                presentationMode.dismiss()
                location.startUpdatingLocation {
                    Task { await vm.getListData() }
                }
            }
        })
        .background(content: {
            AutoLottieView(lottieFliesName: "location_background", loopMode: .loop, speed: 1)
                .scaleEffect(3)
        })
        .padding(.vertical, 24)
        .padding(.all, 32)
    }
}

#Preview {
    RequestUserLocationAuthorizationView()
        .environmentObject(NearRankViewModel())
}
