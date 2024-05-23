//
//  XMListDataViewModel.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/8.
//

import Foundation

// 页面请求指标
public enum XMRequestStatus: String {
    case isLoading
    case isNeedReTry
    case isOK
    case isOKButEmpty
}

protocol XMListDataViewModelProtocol: ObservableObject {
    associatedtype ListRowMod: Convertible
    associatedtype ListData: RandomAccessCollection where ListData.Element == ListRowMod

    var list: ListData { get set }
    var reqStatus: XMRequestStatus { get set }
    var loadingMoreStatus: XMRequestStatus { get set }
    var currentPage: Int { get set }

    func getListData() async
    func loadMore() async
}

// 定义泛型 ViewModel 类,用于list请求
class XMListViewModel<ListRowMod: Convertible>: XMListDataViewModelProtocol {
    @Published var list: [ListRowMod]
    @Published var reqStatus: XMRequestStatus = .isOK
    @Published var loadingMoreStatus: XMRequestStatus = .isOK
    var currentPage: Int = 1
    var target: XMTargetType
    var pagesize: Int = 20
    var atKetPath: String = ""

    init(target: XMTargetType, pagesize: Int = 20, atKeyPath: String = .datalist) {
        self.target = target
        self.pagesize = pagesize
        self.list = []
        self.atKetPath = atKeyPath
    }

    deinit {}

    @MainActor
    func getListData() async {
        reqStatus = .isLoading
        await waitme(sec: 0.4)
        // 手动更新 parameters 字典
        currentPage = 1
        if target.parameters?.contains(where: { $0.key == "page" }) == true {
            target = target.updatingParameters(currentPage)
        }
        list = []
        let result = await Networking.request_async(target)
        if result.is2000Ok, let items = result.mapArray(ListRowMod.self, atKeyPath: atKetPath) {
            print("取值键: \(result)")
            // 过滤黑名单的用户和内容
//            let filtereditems = items.filter { item in
//                let itemdict = item.kj.JSONObject()
//                let blacklist = ConfigStore.shared.blackUserList.userIds
//                guard let id = itemdict["id"] as? String, !blacklist.contains(id) else {
//                    return false
//                }
//                guard let id = itemdict["userId"] as? String, !blacklist.contains(id) else {
//                    return false
//                }
//                return true
//            }
            // ————————————————
            if items.isEmpty {
                reqStatus = .isOKButEmpty
            } else {
                list = items
                reqStatus = .isOK
            }
        } else {
            if result.is2000Ok {
                reqStatus = .isOKButEmpty
            } else {
                reqStatus = .isNeedReTry
            }
        }
        loadingMoreStatus = .isOK
    }

    @MainActor
    func loadMore() async {
        loadingMoreStatus = .isLoading
        await waitme(sec: 0.2)
        // 手动更新 parameters 字典
        if target.parameters?.contains(where: { $0.key == "page" }) == true {
            target = target.updatingParameters(currentPage + 1)
        }
        let r = await Networking.request_async(target)
        if r.is2000Ok, let items = r.mapArray(ListRowMod.self, atKeyPath: atKetPath) {
            // 没有更多数据
            if items.isEmpty {
                await waitme(sec: 0.2)
                loadingMoreStatus = .isOKButEmpty
                // 数据小于10个
            } else if items.count < pagesize {
                await waitme(sec: 0.2)
                loadingMoreStatus = .isOKButEmpty
                list += items
            } else {
                // 下一页数据数据多于等于10
                list += items
                currentPage += 1
                await waitme(sec: 0.2)
                loadingMoreStatus = .isOK
            }
        } else {
            await waitme(sec: 0.2)
            loadingMoreStatus = .isNeedReTry
        }
    }
}
