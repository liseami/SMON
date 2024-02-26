import Foundation

struct UserModel: Codable {
    var userId: String?
    var token: String?
    var isLoggedIn: Bool = false
}

class UserManager: ObservableObject {
    var user: UserModel = .init()

    static let shared = UserManager()

    init() {
        user = loadUserData()
    }

    func login(userId: String, token: String) {
        user.userId = userId
        user.token = token
        user.isLoggedIn = true

        saveUserData(user: user)
    }

    func logout() {
        user.userId = nil
        user.token = nil
        user.isLoggedIn = false

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
