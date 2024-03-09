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

protocol XMListDataViewModelProtocol: AnyObject, ObservableObject {
    associatedtype ListRowMod: Convertible
    var list: [ListRowMod] { get }
    var target: XMTargetType { get }
    var reqStatus: XMRequestStatus { get }
    func getListData() async
    func loadMore() async
}

class XMListDataViewModel<ListRowMod: Convertible>: ObservableObject, XMListDataViewModelProtocol {
    @Published var list: [ListRowMod] = []
    @Published var reqStatus: XMRequestStatus = .isLoading
    var target: XMTargetType
    var currentPageIndex: Int = 0

    init(target: XMTargetType) {
        self.target = target
        Task { await getListData() }
    }
}

extension XMListDataViewModel {
    @MainActor
    func getListData() async {
        await waitme(sec: 1)
        if reqStatus != .isOK || reqStatus != .isOKButEmpty {
            reqStatus = .isLoading
        }
        currentPageIndex = 1
        if target.parameters != nil {
            target.appendParameters(newParameters: ["page": currentPageIndex + 1])
        }
        let result = await Networking.request_async(target)
        if result.is2000Ok, let items = result.mapArray(ListRowMod.self) {
            if items.isEmpty {
                reqStatus = .isOKButEmpty
            } else {
                list = items
                reqStatus = .isOK
            }
        } else {
            reqStatus = .isNeedReTry
        }
    }

    @MainActor
    func loadMore() async {}
}
