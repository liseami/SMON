import Foundation
import TUIChat
import TUICore

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

    @Published var IMInfo: IMUserSing {
        didSet {
            savaModel(model: IMInfo)
        }
    }

    private init() {
        user = .init()
        OSSInfo = .init()
        IMInfo = .init()
        user = loadModel(type: XMUser.self)
        OSSInfo = loadModel(type: XMUserOSSTokenInfo.self)
        IMInfo = loadModel(type: IMUserSing.self)
        #if DEBUG
//        user = .init(userId: "", token: "", needInfo: true)
        #endif
        Task {
            guard user.isLogin else { return }
            await getUploadToken()
            await getImUserSign()
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

    // 获取最新的IMUserSign
    func getImUserSign() async {
        let target = CommonAPI.getImUserSign
        let result = await Networking.request_async(target)
        if result.is2000Ok, let Iminfo = result.mapObject(IMUserSing.self) {
            DispatchQueue.main.async {
                self.IMInfo = Iminfo
                self.TUIInit()
            }
        }
    }

    // 更新用户资料
    func updateUserInfo(updateReqMod: XMUserUpdateReqMod) async -> MoyaResult {
        let target = UserAPI.update(p: updateReqMod)
        let result = await Networking.request_async(target)
        if result.is2000Ok {
            Apphelper.shared.pushNotification(type: .success(message: "🎉 资料修改成功"))
        }
        return result
    }
}

extension UserManager {
    func TUIInit() {
        let config = V2TIMSDKConfig()
        config.logLevel = .LOG_NONE
        V2TIMManager.sharedInstance().initSDK(Int32(Int(AppConfig.TIMAppID)!), config: config)

        TUILogin.login(Int32(Int(AppConfig.TIMAppID)!), userID: "liseami", userSig: self.IMInfo.imUserSign) {}

        // 注册主题
        if let customChatThemePath = Bundle.main.path(forResource: "TUIChatXMTheme.bundle", ofType: nil),
           let customConversationThemePath = Bundle.main.path(forResource: "TUIConversationXMTheme.bundle", ofType: nil),
           let customCoreThemePath = Bundle.main.path(forResource: "TUICoreXMTheme.bundle", ofType: nil)
        {
            TUIThemeManager.share().registerThemeResourcePath(customChatThemePath, for: .chat)
            TUIThemeManager.share().registerThemeResourcePath(customConversationThemePath, for: .conversation)
            TUIThemeManager.share().registerThemeResourcePath(customCoreThemePath, for: .core)
        }

        // 更换主题
        TUIThemeManager.share().applyTheme("dark", for: .all)
        // 修改UI
        TUIConfig.default().avatarType = .TAvatarTypeRounded
        TUIChatConfig.default().backgroudColor = .black
        TUIChatConfig.default().enableWelcomeCustomMessage = false

        TUITextMessageCell.outgoingTextFont = .boldSystemFont(ofSize: 16)
        TUITextMessageCell.outgoingTextColor = UIColor(Color.XMDesgin.f1)
        TUITextMessageCell.incommingTextFont = .boldSystemFont(ofSize: 16)
        TUITextMessageCell.incommingTextColor = UIColor(Color.XMDesgin.f1)
        TUIMessageCell.outgoingNameFont = .boldSystemFont(ofSize: 16)
        TUIMessageCell.outgoingNameColor = UIColor(Color.XMDesgin.f1)
        TUIMessageCell.incommingNameFont = .boldSystemFont(ofSize: 16)
        TUIMessageCell.incommingNameColor = UIColor(Color.XMDesgin.f1)

        TUIMessageCellLayout.outgoingMessage().avatarSize = .init(width: 44, height: 44)
        TUIMessageCellLayout.outgoingMessage().avatarInsets = .init(horizontal: 16, vertical: 16)
        TUIMessageCellLayout.incommingMessage().avatarSize = .init(width: 44, height: 44)
        TUIMessageCellLayout.incommingMessage().avatarInsets = .init(horizontal: 16, vertical: 16)
        TUIMessageCellLayout.outgoingTextMessage().avatarSize = .init(width: 44, height: 44)
        TUIMessageCellLayout.outgoingTextMessage().avatarInsets = .init(horizontal: 16, vertical: 16)
        TUIMessageCellLayout.incommingTextMessage().avatarSize = .init(width: 44, height: 44)
        TUIMessageCellLayout.incommingTextMessage().avatarInsets = .init(horizontal: 16, vertical: 16)
    }
}
