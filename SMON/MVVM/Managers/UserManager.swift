import Foundation

struct UserModel: Codable {
    var userId: String = ""
    var token: String = ""
    var needInfo: Bool = true
    var isLogin: Bool {
        !token.isEmpty
    }
}

class UserManager: ObservableObject {
    static let shared = UserManager()
    @Published var user: UserModel = .init()

    init() {
        user = loadUserData()
        #if DEBUG
        user = .init(userId: "", token: "", needInfo: true)
        #endif
    }

    func login(userId: String, token: String) {
        user.userId = userId
        user.token = token
        saveUserData(user: user)
    }

    func logout() {
        user = .init()
        clearUserData()
    }

    private func saveUserData(user: UserModel) {
        do {
            let userData = try JSONEncoder().encode(user)
            UserDefaults.standard.set(userData, forKey: "userData")
        } catch {
            print("Failed to encode user data: \(error.localizedDescription)")
        }
    }

    private func loadUserData() -> UserModel {
        if let userData = UserDefaults.standard.data(forKey: "userData"),
           let user = try? JSONDecoder().decode(UserModel.self, from: userData)
        {
            return user
        } else {
            return UserModel()
        }
    }

    private func clearUserData() {
        UserDefaults.standard.removeObject(forKey: "userData")
    }
}
