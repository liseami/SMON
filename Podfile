platform :ios, '16.0'
target 'SMON' do
# 强制使用动态库
use_frameworks!
# 开启 modular headers。开启后 Pod 模块才能使用 @import 导入。
#use_modular_headers!
pod 'Moya'# 网络底层
pod 'Moya/Combine', '~> 15.0'# 网络底层结合SwiftUICombine
pod 'KakaJSON'# JSON处理
pod 'SwiftyJSON'# JSON处理
pod 'lottie-ios'# JSON动画
pod 'Kingfisher'# Web图片
pod 'Introspect' # 链接UIKIT
pod 'SwifterSwift' # 语法糖
pod 'Tagly'# 标签云
pod 'PanModal' # slack 开源弹窗
pod 'Lantern'# 照片详情
pod 'AliyunOSSiOS' #阿里云OSS
pod 'JDStatusBarNotification' # 通知小弹窗
pod 'SwiftyStoreKit'# 内购
# 腾讯IM -——————————————————
pod 'TXIMSDK_Plus_iOS'
# 集成聊天功能
pod 'TUIChat/UI_Classic'
# 集成会话功能
pod 'TUIConversation/UI_Classic'
# 以下部分没有导入，仅作候选
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
pod 'JCore', '3.2.3-noidfa'    
pod 'JPush', '4.8.0'

end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
      end
    end
  end
end
