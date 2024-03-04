import Foundation
import KakaJSON

class UserManager: ObservableObject {
    static let shared = UserManager()

    @Published var user: XMUser {
        didSet {
            savaModel(model: user)
        }
    }

    @Published var OSSInfo: XMUserOSSTokenInfo {
        didSet {
            savaModel(model: OSSInfo)
        }
    }

    private init() {
        user = .init()
        OSSInfo = .init()
        user = loadModel(type: XMUser.self)
        OSSInfo = loadModel(type: XMUserOSSTokenInfo.self)
        #if DEBUG
//        user = .init(userId: "", token: "", needInfo: true)
        #endif
        Task {
            await getUploadToken()
        }
    }

    // 持久化数据
    func savaModel<M: Convertible>(model: M) {
        let jsonString = model.kj.JSONString()
        // 仅得到TypeName，例如“UserModel”
        let modelName = String(describing: type(of: model))
        // 以TypeName作为键，存入StringJson
        UserDefaults.standard.setValue(jsonString, forKey: modelName)
    }

    // 读数据
    func loadModel<M: Convertible>(type: Convertible.Type) -> M {
        // 仅得到TypeName，例如“UserModel”
        let modelName = String(describing: type).components(separatedBy: "(").first!
        // 以TypeName作为键，找寻数据
        if let data = UserDefaults.standard.string(forKey: modelName),
           // JsonString to ConvertibleModel
           let model = data.kj.model(type: type)
        {
            return model as! M
        } else {
            return .init()
        }
    }

    // 获取最新的阿里云OSS上传Token
    func getUploadToken() async {
        let target = CommonAPI.getUploadToken
        let result = await Networking.request_async(target)
        if result.is2000Ok, let ossinfo = result.mapObject(XMUserOSSTokenInfo.self) {
            DispatchQueue.main.async {
                self.OSSInfo = ossinfo
            }
        }
    }

    func updateUserInfo(updateReqMod: XMUserUpdateReqMod) async -> MoyaResult {
        let target = UserAPI.update(p: updateReqMod)
        let result = await Networking.request_async(target)
        if result.is2000Ok {
            Apphelper.shared.pushNotification(type: .success(message: "🎉 资料修改成功"))
        }
        return result
    }
}
