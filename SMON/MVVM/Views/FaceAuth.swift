//
//  FaceAuth.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/5/24.
//

import SwiftUI
import TencentCloudHuiyanSDKFace
class FaceAuthViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var idnumber: String = ""

    @MainActor func faceAuthVerify(orderNo: String) async {
        let t = CommonAPI.faceAuthVerify(orderNo: orderNo)
        let r = await Networking.request_async(t)
        if r.is2000Ok {
            Apphelper.shared.pushNotification(type: .success(message: "实名认证成功。"))
            MainViewModel.shared.pageBack()
        }
    }

    struct FaceInfo: Convertible {
        var faceId: String = "" // tx01cce896498a4a61a35cd4dd661b37",
        var agreementNo: String = "" // nwwjy4y11ji6eyb6rbzs8y79xin4dx",
        var bizSeqNo: String = "" // 24052310001184421115432123658057",
        var openApiAppId: String = "" // TIDApXcx",
        var openApiAppVersion: String = "" // 1.0.0",
        var openApiNonce: String = "" // nwwjy4y11ji6eyb6rbzs8y79xin4dx",
        var openApiUserId: String = "" // 1764610746026688512",
        var openApiSign: String = "" // C6DDB7B47F9A7F04F119360FAA892286017A6939",
        var keyLicence: String = "" // c3/5fS6Kz3axq6YbiSSSozYnbY/Y1y3xXgzLxcs0lNPICbuCDDxe4/kwSn2YVG6lk11tHuMfNsNaFU+gCcV6w7a7iZ8IGZdgKq7zoRq3G496ArZBHkcxc9DztVB1Kom6L6bUDQrZb4M8qoGHfB4y0X7e1I0bcnbHSXLOr5AWXxi3xG3qtmrRcCp+Ahn+BAbbe462vzFC/aXYUbFYKqYi05CAQ8ePIRsWdkECvqz/KJqqi9uBo+nnqSP5/Wvz0qilK689OKdh+ziDaDnSRcoQ66U6Qk83x/iBMjm5NlhUnbTopxWIodnD5kpir0FZDwZwbZUoEL6HEUJFQ+OmzPE4EQ=="
    }

    @MainActor func getTXFaceInfo() async {
        let t = CommonAPI.faceAuth(realName: self.name, idNo: self.idnumber)
        let r = await Networking.request_async(t)
        if r.is2000Ok, let data = r.mapObject(FaceInfo.self) {
            let sdkConfig = WBFaceVerifySDKConfig()
            sdkConfig.theme = .darkness
            sdkConfig.windowLevel = 99
            sdkConfig.useWindowSecene = true
            WBFaceVerifyCustomerService.sharedInstance().initSDK(
                withUserId: data.openApiUserId,
                nonce: data.openApiNonce,
                sign: data.openApiSign,
                appid: data.openApiAppId,
                orderNo: data.agreementNo,
                apiVersion: data.openApiAppVersion,
                licence: data.keyLicence,
                faceId: data.faceId,
                sdkConfig: sdkConfig
            ) {
                WBFaceVerifyCustomerService.sharedInstance().startWbFaceVeirifySdk()
            } failure: { error in
                print(error)
                Apphelper.shared.pushNotification(type: .error(message: "暂不可用。"))
            }
        }
    }
}

struct FaceAuth: View {
    @StateObject var vm: FaceAuthViewModel = .init()
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            VStack(alignment: .leading, spacing: 12, content: {
                Text("姓名")
                TextField(text: $vm.name)
                    .font(.XMFont.f1)
                    .fcolor(.XMColor.f1)
                    .scrollContentBackground(.hidden)
                    .keyboardType(.default)
                    .padding(.all, 12)
                    .background {
                        Color.XMColor.b1
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            })

            VStack(alignment: .leading, spacing: 12, content: {
                Text("身份证")
                TextField(text: $vm.idnumber)
                    .font(.XMFont.f1)
                    .fcolor(.XMColor.f1)
                    .keyboardType(.numberPad)
                    .scrollContentBackground(.hidden)
                    .padding(.all, 12)
                    .background {
                        Color.XMColor.b1
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            })

            Spacer().frame(width: 24, height: 120)
            XMDesgin.XMMainBtn(text: "立即认证") {
                Apphelper.shared.closeKeyBoard()
                await vm.getTXFaceInfo()
            }
        }
        .padding(.all, 24)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.WBFaceVerifyCustomerServiceDidFinished), perform: { output in
            if let faceResult = output.userInfo?["faceVerifyResult"] as? WBFaceVerifyResult {
                print(faceResult.orderNo)
                LoadingTask(loadingMessage: "正在验证...") {
                    await vm.faceAuthVerify(orderNo: faceResult.orderNo)
                }
            }
        })
    }
}

#Preview {
    FaceAuth()
}
