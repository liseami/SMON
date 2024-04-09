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
    @EnvironmentObject var superVM: RankViewModel
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

            Group{
                switch CLLocationManager().authorizationStatus {
                case .notDetermined:
                    XMDesgin.XMMainBtn(text: "打开位置权限") {
                        CLLocationManager().requestWhenInUseAuthorization()
                    }
                case .restricted, .denied:
                    XMDesgin.XMMainBtn(text: "去系统设置打开位置权限") {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }
                case .authorizedAlways:
                    EmptyView()
                case .authorizedWhenInUse:
                    EmptyView()
                @unknown default:
                    EmptyView()
                }
            }
            
        }
        
        .onAppear(perform: {
            print( CLLocationManager().authorizationStatus.rawValue)
        })
        .background(content: {
            AutoLottieView(lottieFliesName: "location_background", loopMode: .loop, speed: 1)
                .scaleEffect(3)
        })
        .padding(.vertical, 24)
        .padding(.all, 32)
        .overlay(alignment: .topLeading) {
            XMDesgin.XMIcon(iconName: "system_xmark", size: 22, color: .XMDesgin.f1, withBackCricle: true)
                .onTapGesture {
                    Apphelper.shared.closeSheet()
                    superVM.currentTopTab = .localCity
                }
                .padding(.leading, 12)
        }
    }
}

#Preview {
    RequestUserLocationAuthorizationView()
        .environmentObject(NearRankViewModel())
        .environmentObject(RankViewModel())
}
