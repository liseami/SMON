//
//  Cloud.swift
//  Naduo
//
//  Created by 赵翔宇 on 2023/3/8.
//

import Foundation
import PanModal

// PanModal推送的样式
public enum PanPresentStyle {
    /// 通用
    case cloud
    /// 设置
    case setting
    case shop
    case sheet
}

class PanViewBox<Content>: UIHostingController<AnyView>, PanModalPresentable where Content: View {
    var style: PanPresentStyle
    var isShortFormEnabled = false
    init(content: Content, style: PanPresentStyle) {
        self.style = style
        let contentView = AnyView(content)
        super.init(rootView: contentView)
    }

    var panScrollable: UIScrollView? {
        return nil
    }

    // 是否显示pan的下拉指示器
    var showDragIndicator: Bool {
        return true
    }

    // 允许下拉关闭
    var allowsDragToDismiss: Bool {
        switch self.style {
        case .setting: return false
        default: return true
        }
    }

    override var disablesAutomaticKeyboardDismissal: Bool {
        return true
    }

    // 最大高度
    var longFormHeight: PanModalHeight {
        switch self.style {
        case .shop: return .contentHeightIgnoringSafeArea(UIScreen.main.bounds.height * 0.7)
        case .sheet : return .contentHeightIgnoringSafeArea(UIScreen.main.bounds.height * 0.5)
        default: return .maxHeight
        }
    }

    // 最小高度
    var shortFormHeight: PanModalHeight {
        return self.longFormHeight
    }

    // 两种高度
    func willTransition(to state: PanModalPresentationController.PresentationState) {
        guard self.isShortFormEnabled, case .longForm = state
        else { return }
        self.isShortFormEnabled = false
        panModalSetNeedsLayoutUpdate()
    }

    // 距离顶部距离
    var topOffset: CGFloat {
        switch self.style {
        case .cloud: return UIScreen.main.bounds.height * 0.12
        default: return 0
        }
    }

    // 上弹后背景颜色
    var panModalBackgroundColor: UIColor {
        switch self.style {
        default: return UIColor(Color.XMDesgin.b1.opacity(0.8))
        }
    }

    // 允许点击背景后消失
    var allowsTapToDismiss: Bool {
        switch self.style {
        default: return true
        }
    }

    // 圆角
    var cornerRadius: CGFloat {
        switch self.style {
        case .setting: return 16
        default: return 24
        }
    }

    // 弹簧
    var springDamping: CGFloat {
        0.9
    }

    @available(*, unavailable)
    @MainActor dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
     生命周期....
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 移除背景色
        switch self.style {
        default: break
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        overrideUserInterfaceStyle = .dark
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didMove(toParent parent: UIViewController?) {}
}
