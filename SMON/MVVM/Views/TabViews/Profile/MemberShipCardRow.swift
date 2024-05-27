//
//  MembershipCardRow.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/5/16.
//

import SwiftUI

struct MemberShipInfo: Identifiable, Convertible {
    var id: String = ""
//    var info: String = String.randomString(length: 12)

    var title: String = ""
    var titleDesc: String = ""
    var coverUrl: String = ""
    var goodsCode: String = ""
    var price: String = ""
}

class MemberShipManager: XMListViewModel<MemberShipInfo> {
    init() {
        super.init(target: GoodAPI.getVipList, atKeyPath: .data)
        Task {
            await self.getListData()
        }
    }
}

struct MemberShipCardRow: View {
    @StateObject var vm: MemberShipManager = .init()
    @ObservedObject var configStroe: ConfigStore = .shared
    @State var index: Int = 0
    @Binding var currentGoodId : String
    let cardW = UIScreen.main.bounds.width * 0.86
    var cardH: CGFloat {
        self.cardW / 16 * 12
    }
    
    init(currentGoodId  : Binding<String>) {
        self._currentGoodId = currentGoodId
    }

    var body: some View {
        Color.clear
            .frame(maxWidth: .infinity)
            .frame(height: cardH)
            .overlay {
//                BannerRow(imageW: cardW, spacing: 16, index: $index, list: [MemberShipInfo(), MemberShipInfo(), MemberShipInfo()]) {
                BannerRow(imageW: cardW, spacing: 16, index: $index, list: vm.list) { membership in
                    MemberShipCardView(memberShipInfo: membership)
                        .frame(width: cardW, height: cardH)
                }
                .transition(.movingParts.move(edge: .leading).animation(.bouncy))
            }
            .padding(.top, 24)
            // 把当前选择的产品传递给外部
            .onChange(of: self.index) { index in
                currentGoodId = vm.list[index].goodsCode
            }
            .onChange(of: vm.list.count) { list in
                currentGoodId = vm.list.first?.goodsCode ?? ""
            }
        //            .task {
        //                await configStroe.getProducts()
        //            }
    }
}

#Preview {
    MemberShipCardRow(currentGoodId: .constant(""))
}
