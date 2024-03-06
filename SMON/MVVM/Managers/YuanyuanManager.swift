import Combine
import Foundation
import WebKit

class YuanyuanManager:  NSObject,ObservableObject, WKNavigationDelegate {
    // 私有属性,用于存储 WKWebView 实例
    @Published var webView: WKWebView!

    // 私有属性,用于存储 Combine 订阅者,监听网页加载进度
    private var cookiesObserver: AnyCancellable?

    // 私有属性,用于标记是否已经登录
    private var didLogin = false

    // 初始化方法
    override init() {
        super.init()
        setupWebView()
    }

    // 私有方法,用于设置 WKWebView 实例
    private func setupWebView() {
        // 创建 WKWebViewConfiguration 实例
        let configuration = WKWebViewConfiguration()
        
        // 设置 UserAgent 为 Safari 浏览器的 UserAgent
        configuration.applicationNameForUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.6 Safari/605.1.15"


        // 创建 WKWebView 实例
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self

        // 清除所有 Cookies
//        clearAllCookies()
    }

    // 公共方法,用于加载网页并自动登录
    func loadWebAndLogin(completion: @escaping (String?) -> Void) {
        // 检查是否有有效的 URL
        guard let url = URL(string: AppConfig.yuanyuanurl) else {
            completion(nil)
            return
        }

        // 使用 Combine 订阅网页加载进度
        cookiesObserver = webView.publisher(for: \.estimatedProgress)
            .sink { [weak self] estimatedProgress in
                guard let self = self else { return }
                print(estimatedProgress)

                // 当网页完全加载后
                if estimatedProgress >= 1.0 {
                    // 检查 Cookies
                    self.findCookies { cookies in
                        print(cookies)
                        print(cookies)

                        // 如果还未登录且获取到有效 Cookies,则检查是否存在登录按钮
                        if !self.didLogin, !cookies.isEmpty {
                            // 检查网页中是否存在登录按钮
//                            self.checkForLoginButton { buttonExists in
//                                if buttonExists {
//                                    // 如果登录按钮存在,则点击登录按钮
////                                    self.startLoginByCookies()
//                                }
//                            }
                        }
                    }
                }
            }

        // 创建 URLRequest 并加载网页
        let request = URLRequest(url: url)
        webView.load(request)
    }

    // 私有方法,用于检查网页中是否存在登录按钮
    private func checkForLoginButton(completion: @escaping (Bool) -> Void) {
        let jsCode = "document.querySelector('ui-button.sign-in-button').click();"
        webView.evaluateJavaScript(jsCode) { result, error in
            guard let result = result as? Bool, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }

    // 私有方法,用于注入 JavaScript 代码点击登录按钮
    private func startLoginByCookies() {
        let jsCode = "document.querySelector('ui-button.sign-in-button').click();"
        webView.evaluateJavaScript(jsCode) { _, _ in }
    }

    // 私有方法,用于获取所有 Cookies 并转换为 JSON 字符串
    private func findCookies(completion: @escaping (String) -> Void) {
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
            var cookieArray: [[String: Any]] = []
            for cookie in cookies {
                var cookieDictionary: [String: Any] = [:]
                cookieDictionary["domain"] = cookie.domain
                cookieDictionary["httpOnly"] = cookie.isHTTPOnly
                cookieDictionary["name"] = cookie.name
                cookieDictionary["path"] = cookie.path
                cookieDictionary["sameSite"] = cookie.sameSitePolicy?.rawValue
                cookieDictionary["secure"] = cookie.isSecure
                cookieDictionary["session"] = cookie.isSessionOnly
                cookieDictionary["value"] = cookie.value
                cookieArray.append(cookieDictionary)
            }

            // 将 Cookie 数组转换为 JSON 字符串
            if let jsonData = try? JSONSerialization.data(withJSONObject: cookieArray, options: .prettyPrinted),
               let jsonString = String(data: jsonData, encoding: .utf8)
            {
                completion(jsonString)
            } else {
                completion("")
            }
        }
    }

    // 私有方法,用于清除所有 Cookies
    
//    private func clearAllCookies() async {
//        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
//        WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: Date.distantPast)
//    }

    // WKNavigationDelegate 方法,用于允许网页加载
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        return .allow
    }
}
