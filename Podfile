
# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'
target 'SMON' do
# 是否强制使用动态库
use_frameworks!
# 开启 modular headers。请按需开启，开启后 Pod 模块才能使用 @import 导入。
use_modular_headers!

pod 'Moya'# 网络底层
pod 'Moya/Combine', '~> 15.0'# 网络底层结合SwiftUICombine
pod 'KakaJSON'# JSON处理
pod 'SwiftyJSON'# JSON处理
pod 'lottie-ios'# JSON动画
pod 'Kingfisher'# Web图片
pod 'Introspect' # 链接UIKIT
pod 'SwifterSwift' # 语法糖
pod 'Tagly'# 标签云
pod 'SPAlert'# 完成弹窗
pod 'PanModal' # slack 开源弹窗
pod 'Lantern'# 照片详情
# 腾讯IM -——————————————————
# 集成聊天功能
pod 'TUIChat/UI_Classic'
# 集成会话功能
pod 'TUIConversation/UI_Classic'
# 集成关系链功能
#pod 'TUIContact/UI_Classic'
# 集成群组功能
#pod 'TUIGroup/UI_Classic'
# 集成搜索功能（需要购买旗舰版套餐）
#pod 'TUISearch/UI_Classic'
# 集成音视频通话功能
#pod 'TUICallKit'
# 集成快速会议
#pod 'TUIRoomKit'
# 腾讯IM -——————————————————

end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
               end
          end
   end
end
