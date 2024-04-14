//
//  ConfigStore.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/4/12.
//

import SwiftUI

struct BlackList: Convertible {
    var userIds: [String] = []
}

class ConfigStore: ObservableObject {
    static let shared = ConfigStore()
 
    init() {
        blackUserList = .init()
        APPVersionInfo = .init()
        blackUserList = loadModel(type: BlackList.self)
        APPVersionInfo = loadModel(type: XMVersionInfo.self)
        Task {
            await self.getAllBlack()
            await getVersionInfo()
        }
    }
    
    // APP版本信息
    @Published var APPVersionInfo: XMVersionInfo {
        didSet {
            savaModel(model: APPVersionInfo)
        }
    }

    // 黑名单列表
    @Published var blackUserList: BlackList {
        didSet {
            savaModel(model: blackUserList)
        }
    }

    /*
     获取所有的黑名单列表
      */
    func getAllBlack() async {
        let t = UserRelationAPI.blackAllList
        let r = await Networking.request_async(t)
        if r.is2000Ok, let list = r.mapObject(BlackList.self) {}
    }
    
    /*
     获取版本信息
     */
    @MainActor
    func getVersionInfo() async {
        let t = CommonAPI.versionInfo(lat: UserManager.shared.userlocation.lat, lon: UserManager.shared.userlocation.long)
        let r = await Networking.request_async(t)
        if r.is2000Ok, let versionInfo = r.mapObject(XMVersionInfo.self) {
            APPVersionInfo = versionInfo
            // 强制更新
            if versionInfo.status == 3 {
                Apphelper.shared.presentPanSheet(Color.red.ignoresSafeArea(), style: .setting)
            }
        }
    }
}

extension ConfigStore {
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
}