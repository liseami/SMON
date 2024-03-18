//
//  XMListDataViewModel.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/8.
//

import Foundation

// 页面请求指标
public enum XMRequestStatus {
    case isLoading
    case isNeedReTry
    case isOK
    case isOKButEmpty
}



// 定义泛型 ViewModel 类
class XMListViewModel<ListRowMod: Convertible>: ObservableObject {
    @Published var list: [ListRowMod] = []
    @Published var reqStatus: XMRequestStatus = .isLoading
    @Published var isLoadingMore: Bool = false
    var pageindex: Int = 0

    private let targetBuilder: (Int) -> XMTargetType
    var target: XMTargetType {
        self.targetBuilder(self.pageindex)
    }
    var pageName: String
    init(autoGetData: Bool = true, pageName: String, targetBuilder: @escaping (Int) -> XMTargetType) {
        self.targetBuilder = targetBuilder
        self.pageName = pageName
        guard autoGetData else { return }
        Task { await self.getListData() }
    }

    deinit {}

    @MainActor
    func getListData(_ atKeyPath: String = .datalist) async {
        if self.reqStatus != .isOK || self.reqStatus != .isOKButEmpty {
            self.reqStatus = .isLoading
        }
        self.pageindex = 1
        let r = await Networking.request_async(self.target)
        if r.is2000Ok {
            if let list = r.mapArray(ListRowMod.self, atKeyPath: atKeyPath), list.isEmpty == false {
                self.list.removeAll()
                self.pageindex += 1
                self.list = list
                self.reqStatus = .isOK
            } else {
                self.reqStatus = .isOKButEmpty
            }
        } else {
            self.reqStatus = .isNeedReTry
        }
    }

    @MainActor
    func loadMore(_ atKeyPath: String = .datalist) async {
        guard self.reqStatus == .isOK else { return }
        await waitme()
        guard self.reqStatus == .isOK else { return }
        self.isLoadingMore = true
        let r = await Networking.request_async(self.target)
        if r.is2000Ok {
            if let list = r.mapArray(ListRowMod.self), list.isEmpty == false {
                self.list.append(contentsOf: list)
                self.pageindex += 1
            } else {}
            if self.list.isEmpty {
                self.pageindex = 1
                self.reqStatus = .isOKButEmpty
            }
        } else {}
        self.isLoadingMore = false
    }
}
