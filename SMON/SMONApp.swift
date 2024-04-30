//  SMONApp.swift
//  SMON
//  Created by 赵翔宇 on 2024/2/22.

@_exported import Combine
@_exported import KakaJSON
@_exported import Pow
@_exported import SwifterSwift
@_exported import SwiftUI


@main
struct SMONApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var userManager: UserManager = .shared
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
            Group {
                if userManager.logged{
                   // 已登录用户
                    // 需要进入资料流程
                    if userManager.userLoginInfo.isNeedInfo {
                        // 需要进入资料流程
                        UserInfoRequestMainView()
                    } else {
                        // APP正式页面
                        MainView()
                            .onAppear(perform: {
                             let a =    RSA.decryptString("PPtlluq0F+5QDw2V/tKr/i+ImhCSHMHZpLtGjrbrBmpUL8/jj1pCpdaF0r+1yFE6N2q9g2CURaTMDxjp446gQIBNqb8mwPcqjFlBmHGzsZBPs4IoT4r+o1/kNxyGRC0ME2Zop9wUkN//dgu1f7E4CboVkfVDgz2yTPbBShDzHgNdLR54fL6b+4bd98maQPr/S0vN5sLtM8VIlyiC+FoEhJFvib611m1M/IIR35SiKPLCUIv8pTzavTegcj7gg9b3fgde7w762CcfG2UTVPlPi7bElNY/Q0if5Z++FN9Tq1wWGShINKzY+0XLiv6f1gfpAcz7CBqnExAQSZxNezItgorZpf0c74fXOycKZxXhY2brIZUuft8GtSs5kLgltKTBItPNMPF6ThnSirziUxhtrP4lKJT+LkOpfhTGaiU0pZCav9KaUcaIVFgqXord5GRBmYD467d1NvDxAKfmkw5sWa/66bszpEBtnWJx0Pgd7nrIuThp0DDZziM1V56Xr+MRnDz4E8aFcUt4rNvxq9xXES1JaYz8s/UCQT6Fexq+AEvKdn8FTHA5jKCPjlgH8YpP+UUYKzrTuWyDXNbYJDB/FSRuR8OTaVrj4OzprqGCmuiBc0Vp8JlxBGUFJOolGVoH5sWGK8QDFLC+uF/3uLak7Qd0RUUMqINq2glXvikEt8IeG+HnqqiVWfb89u3XGYi9ezWOLuCfxl+aIz7nBz0xLOn7s5odBd066BJqIvNW1YkAJDGwk3OFsUpB5j7yjNWJVaSDXT/diQ765Cex7EXwHAhcRMJP4v90TfDkSHgwLUs4w8TgRutRUiwgQpwysKceN1HiwXF+H1P42GIk//ZhwLEKdghykopq6SOVJ/DrUlir85RfWpDKi1QSsiMsHw33QubZkkz/gmgTn+tdhrAFGNhZumInwt7PTPKUteVXeZLzBQkOiyfmRa0jP4SS+Re8OSRGjY+lWBrF2XMIEbaTp+d/9LmoWgL3U6u9yo7i1YYaFRDb+UJu+TSA/oW7aF/yDMZOfP1lr50uhxi5ok+T7ucz8MTD8tSoy+Vq7HBCPi1ZXewC5vc7kzkWUJe1iIzPHMRopP2hJ3q4+mcXpKgMOU/HZ/07v//HxecorFsMA1FphMypLyCfsrZ4wO8r3FNNFTdnOONRu+1M5DuZzYzwl3DUH4dnxVTctIjCXK90BxA6gvbUOmz61czzZTserlqskefqbqrCQYsAN/CGT8odM4FdZ2qw2JtCIBLeomKWWAK87Lm/AJvHOQ/e0Xb9sXZYgPJpjoCbP7Dk2qLatPTNeC5I+REDzflzaEak5tMI7oukXy3aQ+0gBBR+Izmx0v9cSuZ4HTC8DaH08qgH11cxbQ==", privateKey: "MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC2qEqUzgpnnQDmCqVvi7fhKAqDLUZsZzRJVrzUL4Orc73Vjt+BhNocQL0B+77Q2etQuh6BcZXR8Ct2XHl6h1nPqoFZ0VW37NbAFKZfe9Lji/7Zj2ze3PsAvMMhwWnA8lfxce446pEe176SeD9E5YnbCtHanR5JRUPyi9my4Xv6+WDNDsiXA+6cHccMtHGg9a7Zmfl+8VzFVRBLLCX951TfGiqLE5iHP4c1jVamCMOEPw5VnFMZA5ZJ+jwdtTc5jSSSJNsNFQh0awjGqhQaUcktQvmD4tJPDvcmd8uzYFvQFgbgQe9ex+etlRQupicgB/NzEaMGOORBsmOIPa8nWP9xAgMBAAECggEAXPR4QBI7KU+1TVzNpF6uTV9bOjaoSDKdYVVK85DaqT5VtYDoLbm2ZfpsNb4v9YlxP7v4Glf7rsNS2wFksP6ArjZPba4iuV9GSqo3oRAa2sI8B+v9s80xz8ZAZ8VOVGsAZldcrIpzIAcbbN7VE/LcnSR8d4zOBOvDEIQrXeVyet3frVQItFCZjdl/BpRzQhuBCr4uiLCMybQAKU9a49C9H/oJ4sjwSipZQzbYyqktPhhUEqAbg699up10LhJPj6fNiiPrK90cEafn4Nt43JI+84E8mmHKDWiAzWXtz5rHuRzyZ29mb6nvnyVKnK0IujV5JoGmbCII24Ff08GrEK6/gQKBgQD8iqxXCKPl7Ij4J7rnlnutOPv8M5Gy/WC36TP7wkmCuek56u387rgW50VlZq1bRWCM6Bw4Poa3n2xZ+mFK78GzP1YimlY93XBoQ//X7pEGEpDPJr8uy4vnOjwUnK73Ll+Q/7uuwzyHdRMfBbWn/3xzzAYhQIUXj5IB/lHaqR5/rQKBgQC5KKCKLVghA679r1dKnrgf6fEAAUOexa0pbZQqFfJuO5xS9djzMqMLfxj/a61C+lvwy3r2CtoyCfRBeU6pCLWqSv9vj7oAkyQv00PMGvcj9UxqYdGBYNwNe5BOt9EVY3kW2VN8fDmHFQn1JRLXnlFCpW1JyZFAV2nL6lEJGYJnVQKBgQCT0Td+2ffVJNYnKlokI9jQU4Jq5GRruBNckoty2Q3eDqOM2w3h9niaL1RXPfpKahlRYKrj4PVJlW7+W6eHDT77hB8Osfe4zlx1Kxgdc+4+9677EVrmMQ36kgOIrQ1ccTBO1uEsMerD/qrqhZUGeGyH+uu7muBMIiT8NbgDnOnVIQKBgBKcJb6dnhz7XMw8ol5qo4D5p3JjriM4JRZj4B92wz4XGbgw45RWA5M1PBL4BJsVxMXn/bzbDGE5JOarxZ8xs+igzxmsbXp/T4TLDCZok2x2zC5pFICXdqaYQ8HVsdsfe10zjLOXXMTZ9X1BM6qeS/aR3/EppEK+RnDrZSev+65dAoGBAPN+9xK1Si1B6VJnZJRTEaWH6c4y9ZaOQgEOOy2UHOWPJcdCIjhpO8CUstnTSdo7xhgnTbyf/hyEUSDbLemwrmFfIhXQ/qvawZIRW3nJhGtzGLY7LBF1TpNqeCPCNsfYcei/AvDm75xedqGA6ZLcxqRSb/9II2m1nddFQIWB0aBM")
                            })
                    }
                } else {
                    // 登录页面
                    LoginMainView()
                }
            }
            .tint(Color.XMDesgin.f1)
            .preferredColorScheme(.dark)
        }
        // 场景状态改变
        .onChange(of: scenePhase) { newValue in
            switch newValue {
            case .background:
                print("进入background")
            case .inactive:
                print("进入inactive")
             
            case .active:
                NotificationCenter.default.post(name: Notification.Name.APP_GO_TO_ACTIVE, object: nil, userInfo: nil)
                print("进入active")
            @unknown default:
                break
            }
        }
    }
}
