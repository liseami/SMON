//
//  String+.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/25.
//

import Foundation

extension String {
    static func randomChineseString(length: Int) -> String {
        guard length > 0 else { return "" }

        var username = ""
        let base = """
        本片沿袭了《还是觉得你最好》第一部的基调，电影男女主也从大哥大嫂为中心的恋爱故事，换成了二哥陈礼与女友冯静、三弟陈熹与猪猪芬（Josephine）之间的故事，故事内容也从谈恋爱时的浪漫逐渐走向了婚姻的现实，粉色的玫瑰花瓣褪去，只剩下了鸡毛蒜皮的日子还会美好吗？

        看得出来这部室内情景剧场景变化不多，导演很努力地在螺丝场里做道场，这部电影的质感不是胜在它有多宏大的场面，有多炸裂的特效，而是它挖掘了出来人物内心的复杂变化，展现了人性中美好的一面和不够完美的一面。

        电影不流于从外部描述，而是专注于内心深处情感的挖掘，努力从各个层面纤毫毕现地展示在恋爱关系和婚姻关系中，每个人不同真实情感的丰富心理状况。他们也曾小心翼翼掩埋小时候受到的亏欠和伤害的伤口，努力地想掩饰自己内心的恐惧和脆弱，努力克服对父母失败婚姻的记忆和对自己即将到来的婚姻的恐惧，从不知道如何去信任和依赖身边的人，再到学会成长，学会去相信，尝试着去依赖，在琐碎的日常生活中学习成长。

        电影用港式无厘头的喜剧风格演绎抓马的剧情，二哥的婚礼现场暗流涌动，Monica被长辈辱骂水性杨花，陈礼被痛骂勾引了义嫂，双方大打出手，掀翻宴席，婚礼真的能举办吗？重新和好的猪猪和三弟在婚礼举办时再生嫌隙，一个由他人顶替参加的婚礼会迎来一个美满的结局吗？

        最后，港式电影依然秉承着原来港式喜剧一家人齐齐整整的基调，在熙熙攘攘的热闹之后，一切归于日常生活的平静，这一家能够过上HE的结局吗？
        """

        for _ in 0 ..< length {
            let randomIndex = Int(arc4random_uniform(UInt32(base.count)))
            let character = base[base.index(base.startIndex, offsetBy: randomIndex)]
            username.append(character)
        }

        return username
    }
}
