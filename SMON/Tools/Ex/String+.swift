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
        第六十一章
        大邦者下流也 天下之牝也 天下之郊也 牝恆以靚（静）勝牡  爲其靚也 故宜爲下
        大邦以下小邦 則取小邦 小邦以下大邦 則取於大邦 故或下以取 或下而取
        故大邦者 不過欲兼畜人 小邦者 不過欲入事人 夫皆得其欲 則大者宜爲下
        第六十三章爲無爲 事無事 味無味 大小多少 報怨以德 圖難於其易也 爲大於其細也 天下之難作於易 天下之大作於細 是以聖人終不爲大 故能成其大 夫輕諾必寡信 多易必多難 是以聖人猶難之 故終於無難
        第六十四章其安也 易持也 其未兆也 易謀也 其脆也 易判也 其微也 易散也 爲之於其未有也 治之於其未亂也 合抱之木 生於毫末 九成之臺 作於羸土 百仁之高 始於足下 爲之者敗之 執之者失之 是以聖人無爲也 故無敗也 無執也 故無失也 民之從事也 恆於其成事而敗之 故慎終若始 則無敗事矣 是以聖人欲不欲 而不貴難得之 學不學 而復眾人之所過 能輔萬物之自然 而弗敢爲
        """

        for _ in 0 ..< length {
            let randomIndex = Int(arc4random_uniform(UInt32(base.count)))
            let character = base[base.index(base.startIndex, offsetBy: randomIndex)]
            username.append(character)
        }

        return username
    }
}
