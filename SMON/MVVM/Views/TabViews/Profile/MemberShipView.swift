//
//  MemberShipView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/5/14.
//

import SwiftUI
import SwiftUIX
struct MemberShipView: View {
    var startDate: Date = .now
    var body: some View {
        NavigationView(content: {
            ScrollView(content: {
                VStack(alignment: .leading, spacing: 32) {
                    title
                    cards
                    funcs
                }
                .padding(.all, 16)
            })
            .scrollIndicators(.hidden)
            .overlay(alignment: .bottom) { bottomBuyBar }
            .toolbar { toolBar }
        })
    }

    var cards: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text("选择一个套餐")
                .font(.XMFont.f1b)
                .fcolor(.XMColor.f1)
            MemberShipCardRow()
        })
    }

    var title: some View {
        Text("开通每日大赛至尊会员，可以无限制私聊和查看给你点赞的人，快速达成配对。")
            .lineSpacing(4)
            .font(.XMFont.big2.bold())
            .fcolor(.XMColor.f1)
    }

    @ToolbarContentBuilder
    var toolBar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            XMDesgin.XMButton {
                Apphelper.shared.closeSheet()
            } label: {
                XMDesgin.XMIcon(iconName: "system_xmark", withBackCricle: true)
            }
        }
    }

    var bottomBuyBar: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text("当您点击继续后，我们将向您收取费用。您的订阅会议相同的套餐期限和价格自动续订，直至您在AppStore设置中取消自动续订。点击即表示您已阅读并同意我们的隐私政策。")
                .font(.XMFont.f3)
                .fcolor(.XMColor.f3)
            XMDesgin.XMMainBtn(fColor: .XMColor.f1, backColor: .XMColor.main, iconName: "", text: "立刻升级", enable: true) {}
        })
        .padding(.all)
        .background(BlurEffectView(style: .dark).ignoresSafeArea(.all, edges: .bottom))
        .overlay(alignment: .top) {
            Divider()
        }
    }

    var funcs: some View {
        HStack(alignment: .center, spacing: 12, content: {
            VStack(alignment: .leading, spacing: 24, content: {
                Text("功能权限")
                    .font(.XMFont.f1b)
                Text("私信任何人")
                Text("隐私相册")
                Text("附近的人")
                Text("我的访客")
                Text("喜欢我的")
                Text("签到火苗")
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .center, spacing: 24, content: {
                Text("普通会员")
                    .font(.XMFont.f1b)
                Text("/")
                Text("/")
                Text("/")
                Text("/")
                Text("/")
                Text("100")
            })
            VStack(alignment: .center, spacing: 24, content: {
                Text("至尊会员")
                    .font(.XMFont.f1b)
                Text("✅")
                Text("✅")
                Text("✅")
                Text("✅")
                Text("✅")
                Text("500")
            })
        })
        .font(.XMFont.f2)
        .fcolor(.XMColor.f1)
        .padding(.all, 16)
        .padding(.top, 16)
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(lineWidth: 1.2)
                .fcolor(.XMColor.f2)
                .overlay(alignment: .top) {
                    Text("至尊会员专属特权")
                        .font(.XMFont.f3)
                        .fcolor(.XMColor.f2)
                        .padding(.all, 8)
                        .background(Color.XMColor.b1)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .overlay(alignment: .center) {
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(lineWidth: 1.2)
                                .fcolor(.XMColor.f2)
                        }
                        .offset(y: -16)
                }
        }
    }
}

#Preview {
    MemberShipView()
}

struct MemberShipCardView: View {
    var memberShipInfo: MemberShipInfo
    init(memberShipInfo: MemberShipInfo) {
        self.memberShipInfo = memberShipInfo
    }

    let cardW = UIScreen.main.bounds.width * 0.86
    var cardH: CGFloat {
        self.cardW / 16 * 12
    }

    var startDate: Date = .now
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .center, spacing: 4, content: {
                Image("saicoin")
                    .resizable()
                    .frame(width: 32, height: 32)
                Text("大赛至尊会员")
                    .font(.XMFont.f1b)
                    .fcolor(.XMColor.f1)
                Spacer()
                XMDesgin.SmallBtn(fColor: .XMColor.f1, backColor: .XMColor.main, iconName: "", text: "立刻升级🙋") {}
            })
            Spacer()
            VStack(alignment: .leading, spacing: 12, content: {
                Text("一个月")
                    .font(.XMFont.big1.bold())
                Text("219¥")
                    .font(.XMFont.big1.bold())
                    .fcolor(.XMColor.main)
            })
        }
        .padding(.all, 16)
        .frame(height: cardH)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            TimelineView(.animation) { context in
                if #available(iOS 17.0, *) {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.white, lineWidth: 3)
                        .colorEffect(
                            ShaderLibrary.default.circleMesh(.boundingRect, .float(context.date.timeIntervalSince1970 - startDate.timeIntervalSince1970))
                        )
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        .background(Color.XMColor.b1.gradient)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}