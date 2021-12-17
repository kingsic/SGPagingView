//
//  SGPagingTitleView.swift
//  SGPagingView
//
//  Created by kingsic on 2020/12/23.
//  Copyright © 2020 kingsic. All rights reserved.
//

import UIKit

@objc public protocol SGPagingTitleViewDelegate: NSObjectProtocol {
    /// 获取当前选中标题下标值
    @objc optional func pagingTitleView(titleView: SGPagingTitleView, index: Int)
}

public class SGPagingTitleView: UIView {
    @objc public init(frame: CGRect, titles:[String], configure: SGPagingTitleViewConfigure) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white.withAlphaComponent(0.77)
        assert(!titles.isEmpty, "SGPagingTitleView 初始化方法中的配置信息必须设置")
        
        self.titles = titles
        self.configure = configure
        
        initialization()
        addSubviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// SGPagingTitleView 的代理
    @objc public weak var delegate: SGPagingTitleViewDelegate?

    /// 选中标题的下标，默认为 0
    @objc public var index: Int = 0
    
    /// 重置选中标题的下标
    @objc public func reset(index: Int) {
        btn_action(button: tempBtns[index])
    }
    

    // MARK: 私有属性
    private var titles = [String]()
    private var configure: SGPagingTitleViewConfigure!
    private var allBtnTextWidth: CGFloat = 0.0
    private var allBtnWidth: CGFloat = 0.0
    private var tempBtns = [SGPagingTitleButton]()
    private var tempBtn: UIButton?
    private var separators = [UIView]()
    private var previousIndexValue: Int?
    private var signBtnIndex: Int = 0
    private var signBtnClick: Bool = false
    /// 开始颜色, 取值范围 0~1
    private var startR: CGFloat = 0.0
    private var startG: CGFloat = 0.0
    private var startB: CGFloat = 0.0
    /// 完成颜色, 取值范围 0~1
    private var endR: CGFloat = 0.0
    private var endG: CGFloat = 0.0
    private var endB: CGFloat = 0.0
    
    private lazy var scrollView: UIScrollView = {
        let tempScrollView = UIScrollView()
        tempScrollView.showsVerticalScrollIndicator = false
        tempScrollView.showsHorizontalScrollIndicator = false
        tempScrollView.alwaysBounceHorizontal = true
        tempScrollView.frame = bounds
        return tempScrollView
    }()
    
    private lazy var bottomSeparator: UIView = {
       let tempBottomSeparator = UIView()
        tempBottomSeparator.backgroundColor = configure.bottomSeparatorColor
        let w: CGFloat = frame.size.width
        let h: CGFloat = 0.5
        let y: CGFloat = frame.size.height - h
        tempBottomSeparator.frame = CGRect(x: 0, y: y, width: w, height: h)
        return tempBottomSeparator
    }()
    
    private lazy var indicator: UIView = {
        let tempIndicator = UIView()
        tempIndicator.backgroundColor = configure.indicatorColor
        P_layoutIndicator(tempIndicator: tempIndicator)
        return tempIndicator
    }()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        btn_action(button: tempBtns[index])
    }
}


// MARK: 外部方法
public extension SGPagingTitleView {
    /// 根据 SGPagingContentView 子视图的滚动而去修改标题选中样式
    @objc func setPagingTitleView(progress: CGFloat, currentIndex: Int, targetIndex: Int) {
        p_setPagingTitleView(progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
    }
    
    /// 根据标题下标值重置标题文字
    @objc func resetTitle(text: String, index: Int) {
        p_resetTitle(text: text, index: index)
    }
    
    /// 根据标题下标值设置标题的 attributed 属性
    @objc func setTitle(attributed: NSAttributedString, selectedAttributed: NSAttributedString, index: Int) {
        p_setTitle(attributed: attributed, selectedAttributed: selectedAttributed, index: index)
    }
    
    /// 重置指示器颜色
    @objc func resetIndicator(color: UIColor) {
        p_resetIndicator(color: color)
    }
    
    /// 重置标题颜色(color：普通状态下标题颜色、selectedColor：选中状态下标题颜色)
    @objc func resetTitle(color: UIColor, selectedColor: UIColor) {
        p_resetTitle(color: color, selectedColor: selectedColor)
    }
    
    /// 根据标题下标值添加对应的 badge
    @objc func addBadge(index: Int) {
        p_addBadge(index: index)
    }
    
    /// 根据标题下标值添加对应的 badge 及其文字
    @objc func addBadge(text: String, index: Int) {
        p_addBadge(text: text, index: index)
    }
    
    /// 根据标题下标值移除对应的 badge
    @objc func removeBadge(index: Int) {
        p_removeBadge(index: index)
    }
    
    /// 设置标题图片及相对文字的位置（支持本地和网络图片）
    @objc func setImage(names: Array<String>, location: ImageLocation, spacing: CGFloat) {
        p_setImage(names: names, location: location, spacing: spacing)
    }
    
    /// 根据标题下标值设置标题图片及相对文字的位置（支持本地和网络图片）
    @objc func setImage(name: String, location: ImageLocation, spacing: CGFloat, index: Int) {
        p_setImage(name: name, location: location, spacing: spacing, index: index)
    }
    
    /// 根据标题下标值设置标题背景图片（支持本地和网络图片）
    @objc func setBackgroundImage(name: String, selectedName: String?, index: Int) {
        P_setBackgroundImage(name: name, selectedName: selectedName, index: index)
    }
}


// MARK: 修改指示器颜色、标题颜色、标题文字相关方法
private extension SGPagingTitleView {
    /// 根据标题下标值重置标题文字
    func p_resetTitle(text: String, index: Int) {
        let btn: UIButton = tempBtns[index]
        btn.setTitle(text, for: .normal)
        if configure.showIndicator && signBtnIndex == index {
            if configure.indicatorType == .Default || configure.indicatorType == .Cover {
                var indicatorWidth = P_calculateWidth(string: text, font: configure.font) + configure.indicatorAdditionalWidth
                if indicatorWidth > btn.frame.size.width {
                    indicatorWidth = btn.frame.size.width
                }
                indicator.frame.size.width = indicatorWidth
                indicator.center.x = btn.center.x
            }
        }
    }
    /// 根据标题下标值设置标题的 attributed 属性
    func p_setTitle(attributed: NSAttributedString, selectedAttributed: NSAttributedString, index: Int) {
        let btn: UIButton = tempBtns[index]
        btn.titleLabel?.lineBreakMode = .byCharWrapping
        btn.titleLabel?.textAlignment = .center
        btn.setAttributedTitle(attributed, for: .normal)
        btn.setAttributedTitle(selectedAttributed, for: .selected)
    }
    
    /// 重置指示器颜色
    func p_resetIndicator(color: UIColor) {
        indicator.backgroundColor = color
    }
    /// 重置标题颜色(color：普通状态下标题颜色、selectedColor：选中状态下标题颜色)
    func p_resetTitle(color: UIColor, selectedColor: UIColor) {
        for (_, btn) in tempBtns.enumerated() {
            btn.setTitleColor(color, for: .normal)
            btn.setTitleColor(selectedColor, for: .selected)
        }
        if configure.gradientEffect {
            configure.color = color
            configure.selectedColor = selectedColor
            P_startColor(color: configure.color)
            P_endColor(color: configure.selectedColor)
        }
    }
}

// MARK: 设置标题图片相关方法
private extension SGPagingTitleView {
    /// Set title image
    ///
    /// Support local and network images
    ///
    /// - parameter names: Title images name
    /// - parameter location: Position of image relative to text
    /// - parameter spacing: Space between image and text
    func p_setImage(names: Array<String>, location: ImageLocation, spacing: CGFloat) {
        if tempBtns.count == 0 {
            return
        }
        if names.count < tempBtns.count {
            for (index, btn) in tempBtns.enumerated() {
                if index >= names.count {
                    return
                }
                setImage(btn: btn, imageName: names[index], location: location, spacing: spacing)
            }
        } else {
            for (index, btn) in tempBtns.enumerated() {
                setImage(btn: btn, imageName: names[index], location: location, spacing: spacing)
            }
        }
    }
    
    /// Set the title image according to the subscript
    ///
    /// Support local and network images
    ///
    /// - parameter names: Title image name
    /// - parameter location: Position of image relative to text
    /// - parameter spacing: Space between image and text
    /// - parameter index: Title subscript
    func p_setImage(name: String, location: ImageLocation, spacing: CGFloat, index: Int) {
        if tempBtns.count == 0 {
            return
        }
        let btn = tempBtns[index]
        setImage(btn: btn, imageName: name, location: location, spacing: spacing)
    }
    
    /// 设置标题背景图片
    func P_setBackgroundImage(name: String, selectedName: String?, index: Int) {
        let btn: UIButton = tempBtns[index]
        btn.setTitleColor(.clear, for: .normal)
        btn.setTitleColor(.clear, for: .selected)
        
        if name.hasPrefix("http") {
            loadImage(urlString: name) { (image) in
                btn.setBackgroundImage(image, for: .normal)
            }
        } else {
            btn.setBackgroundImage(UIImage.init(named: name), for: .normal)
        }
        
        if let tempSelectedName = selectedName {
            if tempSelectedName.hasPrefix("http") {
                loadImage(urlString: tempSelectedName) { (image) in
                    btn.setBackgroundImage(image, for: .selected)
                }
            } else {
                btn.setBackgroundImage(UIImage.init(named: tempSelectedName), for: .selected)
            }
        }
    }
}

// MARK：添加、移除 Badge 相关方法
private extension SGPagingTitleView {
    /// 根据标题下标添加对应的 badge
    func p_addBadge(index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            let btn: UIButton = self.tempBtns[index]
            let btnTextWidth: CGFloat = self.P_calculateWidth(string: btn.currentTitle!, font: self.configure.font)
            let btnTextHeight: CGFloat = self.P_calculateHeight(string: btn.currentTitle!, font: self.configure.font)
            let badgeX: CGFloat = 0.5 * (btn.frame.size.width - btnTextWidth) + btnTextWidth + self.configure.badgeOff.x
            let badgeY: CGFloat = 0.5 * (btn.frame.size.height - btnTextHeight) + self.configure.badgeOff.y - self.configure.badgeHeight
            let badgeW: CGFloat = self.configure.badgeHeight
            let badgeH: CGFloat = badgeW
            let badge: UILabel = UILabel()
            badge.frame = CGRect.init(x: badgeX, y: badgeY, width: badgeW, height: badgeH)
            badge.layer.backgroundColor = self.configure.badgeColor.cgColor
            badge.layer.cornerRadius = 0.5 * self.configure.badgeHeight
            btn.addSubview(badge)
        }
    }
    /// 根据标题下标添加对应的 badge 及其文字
    func p_addBadge(text: String, index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            let btn: UIButton = self.tempBtns[index]
            let btnTextWidth: CGFloat = self.P_calculateWidth(string: btn.currentTitle!, font: self.configure.font)
            let btnTextHeight: CGFloat = self.P_calculateHeight(string: btn.currentTitle!, font: self.configure.font)
            let badgeX: CGFloat = 0.5 * (btn.frame.size.width - btnTextWidth) + btnTextWidth + self.configure.badgeOff.x
            let badgeY: CGFloat = 0.5 * (btn.frame.size.height - btnTextHeight) + self.configure.badgeOff.y - self.configure.badgeHeight
            let badgeW: CGFloat = self.P_calculateWidth(string: text, font: self.configure.badgeTextFont) + self.configure.badgeAdditionalWidth
            let badgeH: CGFloat = self.configure.badgeHeight
            let badge: UILabel = UILabel()
            badge.frame = CGRect.init(x: badgeX, y: badgeY, width: badgeW, height: badgeH)
            badge.text = text
            badge.textColor = self.configure.badgeTextColor
            badge.font = self.configure.badgeTextFont
            badge.textAlignment = .center
            badge.layer.backgroundColor = self.configure.badgeColor.cgColor
            badge.layer.cornerRadius = self.configure.badgeCornerRadius
            badge.layer.borderWidth = self.configure.badgeBorderWidth
            badge.layer.borderColor = self.configure.badgeBorderColor.cgColor
            btn.addSubview(badge)
        }
    }
    /// 根据标题下标移除对应的 badge
    func p_removeBadge(index: Int) {
        let btn: UIButton = tempBtns[index]
        for (_, subView) in btn.subviews.enumerated() {
            if subView.isMember(of: UILabel.self) {
                subView.removeFromSuperview()
            }
        }
    }
}
// MARK: 用于修改标题选中样式
private extension SGPagingTitleView {
    /// 修改标题选中样式
    func p_setPagingTitleView(progress: CGFloat, currentIndex: Int, targetIndex: Int) {
        let currentBtn = tempBtns[currentIndex]
        let targetBtn = tempBtns[targetIndex]
        signBtnIndex = targetBtn.tag
        /// 1、标题选中居中处理
        if allBtnWidth > frame.size.width {
            if signBtnClick == false  {
                selectedBtnCenter(btn: targetBtn)
            }
            signBtnClick = false
        }
        
        /// 2、处理指示器的逻辑
        if configure.showIndicator { // 指示器存在逻辑处理
            if allBtnWidth <= frame.size.width { // 固定样式处理
                if configure.equivalence { // 均分样式
                    if configure.indicatorScrollStyle == .Default {
                        equivalenceIndicatorScrollDefaull(progress: progress, currentBtn: currentBtn, targetBtn: targetBtn)
                    } else {
                        equivalenceIndicatorScrollHalfEnd(progress: progress, currentBtn: currentBtn, targetBtn: targetBtn)
                    }
                } else {
                    if configure.indicatorScrollStyle == .Default {
                        indicatorScrollDefaull(progress: progress, currentBtn: currentBtn, targetBtn: targetBtn)
                    } else {
                        indicatorScrollHalfEnd(progress: progress, currentBtn: currentBtn, targetBtn: targetBtn)
                    }
                }
            } else { // 滚动样式处理
                if configure.indicatorScrollStyle == .Default {
                    indicatorScrollDefaull(progress: progress, currentBtn: currentBtn, targetBtn: targetBtn)
                } else {
                    indicatorScrollHalfEnd(progress: progress, currentBtn: currentBtn, targetBtn: targetBtn)
                }
            }
        } else { // 指示器不存在逻辑处理
            if configure.indicatorScrollStyle == .Half {
                noIndicatorScrollHalf(progress: progress, currentBtn: currentBtn, targetBtn: targetBtn)
            } else {
                noIndicatorScroll(progress: progress, currentBtn: currentBtn, targetBtn: targetBtn)
            }
        }
        
        /// 3、颜色的渐变(复杂)
        if configure.gradientEffect {
            gradientEffect(progress: progress, currentBtn: currentBtn, targetBtn: targetBtn)
        }
        
        /// 4、标题文字缩放属性(开启文字选中字号属性将不起作用)
        let selectedFont: UIFont = configure.selectedFont
        let defaultFont: UIFont = .systemFont(ofSize: 15)
        let selectedFontName: String = selectedFont.fontName
        let selectedFontPointSize: CGFloat = selectedFont.pointSize
        let defaultFontName: String = defaultFont.fontName
        let defaultFontPointSize: CGFloat = defaultFont.pointSize
        if selectedFontName == defaultFontName && selectedFontPointSize == defaultFontPointSize {
            if configure.textZoom {
                let currentBtnZoomRatio: CGFloat = (1 - progress) * configure.textZoomRatio
                currentBtn.transform = CGAffineTransform(scaleX: currentBtnZoomRatio + 1, y: currentBtnZoomRatio + 1)
                let targetBtnZoomRatio: CGFloat = progress * configure.textZoomRatio
                targetBtn.transform = CGAffineTransform(scaleX: targetBtnZoomRatio + 1, y: targetBtnZoomRatio + 1)
            }
        }
    }
    
    /// 有指示器：固定样式下：均分布局默认滚动样式
    private func equivalenceIndicatorScrollDefaull(progress: CGFloat, currentBtn: UIButton, targetBtn: UIButton) {
        if progress >= 0.8 { // 此处取 >= 0.8 而不是 1.0 为的是防止用户滚动过快而按钮的选中状态并没有改变
            changeSelectedBtn(btn: targetBtn)
        }
        
        let btnWidth: CGFloat = frame.size.width / CGFloat(titles.count)

        // Fixed 样式处理
        if configure.indicatorType == .Fixed {
            let targetBtnCenterX: CGFloat = targetBtn.center.x
            let currentBtnCenterX: CGFloat = currentBtn.center.x
            let totalOffsetCenterX: CGFloat = targetBtnCenterX - currentBtnCenterX
            indicator.center.x = currentBtnCenterX + progress * totalOffsetCenterX
            return
        }
        
        // Dynamic 样式处理
        if configure.indicatorType == .Dynamic {
            let currentBtnTag = currentBtn.tag
            let targetBtnTag = targetBtn.tag
            let targetBtnMaxX = CGFloat(targetBtn.tag + 1) * btnWidth
            let currentBtnMaxX = CGFloat(currentBtn.tag + 1) * btnWidth
            
            if currentBtnTag <= targetBtnTag { // 往左滑
                if progress <= 0.5 {
                    indicator.frame.size.width = configure.indicatorDynamicWidth + 2 * progress * btnWidth
                } else {
                    let targetBtnIndicatorX: CGFloat = targetBtnMaxX - 0.5 * (btnWidth - configure.indicatorDynamicWidth) - configure.indicatorDynamicWidth
                    indicator.frame.origin.x = targetBtnIndicatorX + 2 * (progress - 1) * btnWidth
                    indicator.frame.size.width = configure.indicatorDynamicWidth + 2 * (1 - progress) * btnWidth
                }
            } else {
                if progress <= 0.5 {
                    let currentBtnIndicatorX: CGFloat = currentBtnMaxX - 0.5 * (btnWidth - configure.indicatorDynamicWidth) - configure.indicatorDynamicWidth
                    indicator.frame.origin.x = currentBtnIndicatorX - 2 * progress * btnWidth
                    indicator.frame.size.width = configure.indicatorDynamicWidth + 2 * progress * btnWidth
                } else {
                    let targetBtnIndicatorX: CGFloat = targetBtnMaxX - configure.indicatorDynamicWidth - 0.5 * (btnWidth - configure.indicatorDynamicWidth)
                    indicator.frame.origin.x = targetBtnIndicatorX // 这句代码必须写，防止滚动结束之后指示器位置存在偏差，这里的偏差是由于 progress >= 0.8 导致的
                    indicator.frame.size.width = configure.indicatorDynamicWidth + 2 * (1 - progress) * btnWidth
                }
            }
            return
        }
        
        // Default、Cover 样式处理
        // 文字宽度
        let targetBtnTextWidth: CGFloat = P_calculateWidth(string: targetBtn.currentTitle!, font: configure.font)
        let currentBtnTextWidth: CGFloat = P_calculateWidth(string: currentBtn.currentTitle!, font: configure.font)
        let targetBtnMaxX: CGFloat = CGFloat(targetBtn.tag + 1) * btnWidth
        let currentBtnMaxX: CGFloat = CGFloat(currentBtn.tag + 1) * btnWidth

        let targetIndicatorX: CGFloat = targetBtnMaxX - targetBtnTextWidth - 0.5 * (btnWidth - targetBtnTextWidth + configure.indicatorAdditionalWidth)
        let currentIndicatorX: CGFloat = currentBtnMaxX - currentBtnTextWidth - 0.5 * (btnWidth - currentBtnTextWidth + configure.indicatorAdditionalWidth)
        let totalOffsetX: CGFloat = targetIndicatorX - currentIndicatorX

        /// 2、计算文字之间差值
        // targetBtn 文字右边的 x 值
        let targetBtnRightTextX: CGFloat = targetBtnMaxX - 0.5 * (btnWidth - targetBtnTextWidth)
        // originalBtn 文字右边的 x 值
        let currentBtnRightTextX: CGFloat = currentBtnMaxX - 0.5 * (btnWidth - currentBtnTextWidth)
        let totalRightTextDistance: CGFloat = targetBtnRightTextX - currentBtnRightTextX
        // 计算 indicatorView 滚动时 x 的偏移量
        let offsetX: CGFloat = totalOffsetX * progress
        // 计算 indicatorView 滚动时文字宽度的偏移量
        let distance: CGFloat = progress * (totalRightTextDistance - totalOffsetX)

        /// 3、计算 indicatorView 新的 frame
        indicator.frame.origin.x = currentIndicatorX + offsetX
        let indicatorWidth: CGFloat = configure.indicatorAdditionalWidth + currentBtnTextWidth + distance
        if indicatorWidth >= targetBtn.frame.size.width {
            let moveTotalX: CGFloat = targetBtn.frame.origin.x - currentBtn.frame.origin.x
            let moveX: CGFloat = moveTotalX * progress
            indicator.center.x = currentBtn.center.x + moveX
        } else {
            indicator.frame.size.width = indicatorWidth
        }
    }
    /// 有指示器：固定样式下：均分布局 Half、End 滚动样式
    private func equivalenceIndicatorScrollHalfEnd(progress: CGFloat, currentBtn: UIButton, targetBtn: UIButton) {
        let btnWidth: CGFloat = frame.size.width / CGFloat(titles.count)
        /// 1、处理 indicatorScrollStyle 的 Half 逻辑
        if configure.indicatorScrollStyle == .Half {
            // 1.1、处理 Fixed 样式
            if configure.indicatorType == .Fixed {
                if progress >= 0.5 {
                    UIView.animate(withDuration: configure.indicatorAnimationTime) {
                        self.indicator.center.x = targetBtn.center.x
                        self.changeSelectedBtn(btn: targetBtn)
                    }
                } else {
                    UIView.animate(withDuration: configure.indicatorAnimationTime) {
                        self.indicator.center.x = currentBtn.center.x
                        self.changeSelectedBtn(btn: currentBtn)
                    }
                }
                return
            }
            
            // 1.2、处理 Dynamic 样式
            if configure.indicatorType == .Dynamic {
                let currentBtnTag = currentBtn.tag
                let targetBtnTag = targetBtn.tag
                let targetBtnMaxX: CGFloat = CGFloat(targetBtn.tag + 1) * btnWidth
                let currentBtnMaxX: CGFloat = CGFloat(currentBtn.tag + 1) * btnWidth
                
                if currentBtnTag <= targetBtnTag { // 往左滑
                    if progress <= 0.5 {
                        indicator.frame.size.width = configure.indicatorDynamicWidth + 2 * progress * btnWidth
                        changeSelectedBtn(btn: currentBtn)
                    } else {
                        let targetBtnIndicatorX: CGFloat = targetBtnMaxX - 0.5 * (btnWidth - configure.indicatorDynamicWidth) - configure.indicatorDynamicWidth
                        indicator.frame.origin.x = targetBtnIndicatorX + 2 * (progress - 1) * btnWidth
                        indicator.frame.size.width = configure.indicatorDynamicWidth + 2 * (1 - progress) * btnWidth
                        changeSelectedBtn(btn: targetBtn)
                    }
                } else {
                    if progress <= 0.5 {
                        let currentBtnIndicatorX: CGFloat = currentBtnMaxX - 0.5 * (btnWidth - configure.indicatorDynamicWidth) - configure.indicatorDynamicWidth
                        indicator.frame.origin.x = currentBtnIndicatorX - 2 * progress * btnWidth
                        indicator.frame.size.width = configure.indicatorDynamicWidth + 2 * progress * btnWidth
                        changeSelectedBtn(btn: currentBtn)
                    } else {
                        let targetBtnIndicatorX: CGFloat = targetBtnMaxX - configure.indicatorDynamicWidth - 0.5 * (btnWidth - configure.indicatorDynamicWidth)
                        indicator.frame.origin.x = targetBtnIndicatorX // 这句代码必须写，防止滚动结束之后指示器位置存在偏差，这里的偏差是由于 progress >= 0.8 导致的
                        indicator.frame.size.width = configure.indicatorDynamicWidth + 2 * (1 - progress) * btnWidth
                        changeSelectedBtn(btn: targetBtn)
                    }
                }
                return
            }

            // 1.3、处理指示器 Default、Cover 样式
            if progress >= 0.5 {
                let indicatorWidth = P_calculateWidth(string: targetBtn.currentTitle!, font: configure.font) + configure.indicatorAdditionalWidth
                UIView.animate(withDuration: configure.indicatorAnimationTime) { [self] in
                    if indicatorWidth >= targetBtn.frame.size.width {
                        self.indicator.frame.size.width = targetBtn.frame.size.width
                    } else {
                        self.indicator.frame.size.width = indicatorWidth
                    }
                    self.indicator.center.x = targetBtn.center.x
                    self.changeSelectedBtn(btn: targetBtn)
                }
            } else {
                let indicatorWidth = P_calculateWidth(string: currentBtn.currentTitle!, font: configure.font) + configure.indicatorAdditionalWidth
                UIView.animate(withDuration: configure.indicatorAnimationTime) {
                    if indicatorWidth >= currentBtn.frame.size.width {
                        self.indicator.frame.size.width = currentBtn.frame.size.width
                    } else {
                        self.indicator.frame.size.width = indicatorWidth
                    }
                    self.indicator.center.x = currentBtn.center.x
                    self.changeSelectedBtn(btn: currentBtn)
                }
            }
            return
        }
        
        /// 2、处理 indicatorScrollStyle 的 End 逻辑
        // 1、处理 Fixed 样式
        if configure.indicatorType == .Fixed {
            if (progress == 1.0) {
                UIView.animate(withDuration: configure.indicatorAnimationTime) {
                    self.indicator.center.x = targetBtn.center.x
                    self.changeSelectedBtn(btn: targetBtn)
                }
            } else {
                UIView.animate(withDuration: configure.indicatorAnimationTime) {
                    self.indicator.center.x = currentBtn.center.x
                    self.changeSelectedBtn(btn: currentBtn)
                }
            }
            return
        }
        // 1.2、处理 Dynamic 样式
        if configure.indicatorType == .Dynamic {
            let currentBtnTag = currentBtn.tag
            let targetBtnTag = targetBtn.tag
            let targetBtnMaxX: CGFloat = CGFloat(targetBtn.tag + 1) * btnWidth
            let currentBtnMaxX: CGFloat = CGFloat(currentBtn.tag + 1) * btnWidth
            
            if currentBtnTag <= targetBtnTag { // 往左滑
                if progress <= 0.5 {
                    indicator.frame.size.width = configure.indicatorDynamicWidth + 2 * progress * btnWidth
                    if progress < 0.8 {
                        changeSelectedBtn(btn: currentBtn)
                    }
                } else {
                    let targetBtnIndicatorX: CGFloat = targetBtnMaxX - 0.5 * (btnWidth - configure.indicatorDynamicWidth) - configure.indicatorDynamicWidth
                    indicator.frame.origin.x = targetBtnIndicatorX + 2 * (progress - 1) * btnWidth
                    indicator.frame.size.width = configure.indicatorDynamicWidth + 2 * (1 - progress) * btnWidth
                    if progress >= 0.8 {
                        changeSelectedBtn(btn: targetBtn)
                    }
                }
            } else {
                if progress <= 0.5 {
                    let currentBtnIndicatorX: CGFloat = currentBtnMaxX - 0.5 * (btnWidth - configure.indicatorDynamicWidth) - configure.indicatorDynamicWidth
                    indicator.frame.origin.x = currentBtnIndicatorX - 2 * progress * btnWidth
                    indicator.frame.size.width = configure.indicatorDynamicWidth + 2 * progress * btnWidth
                    if progress < 0.8 {
                        changeSelectedBtn(btn: currentBtn)
                    }
                } else {
                    let targetBtnIndicatorX: CGFloat = targetBtnMaxX - configure.indicatorDynamicWidth - 0.5 * (btnWidth - configure.indicatorDynamicWidth)
                    indicator.frame.origin.x = targetBtnIndicatorX // 这句代码必须写，防止滚动结束之后指示器位置存在偏差，这里的偏差是由于 progress >= 0.8 导致的
                    indicator.frame.size.width = configure.indicatorDynamicWidth + 2 * (1 - progress) * btnWidth
                    if progress >= 0.8 {
                        changeSelectedBtn(btn: targetBtn)
                    }
                }
            }
            return
        }
        // 3、处理指示器 Default、Cover 样式
        if progress == 1.0 {
            let indicatorWidth = P_calculateWidth(string: targetBtn.currentTitle!, font: configure.font) + configure.indicatorAdditionalWidth
            UIView.animate(withDuration: configure.indicatorAnimationTime) { [self] in
                if indicatorWidth >= targetBtn.frame.size.width {
                    self.indicator.frame.size.width = targetBtn.frame.size.width
                } else {
                    self.indicator.frame.size.width = indicatorWidth
                }
                self.indicator.center.x = targetBtn.center.x
                self.changeSelectedBtn(btn: targetBtn)
            }
        } else {
            let indicatorWidth = P_calculateWidth(string: currentBtn.currentTitle!, font: configure.font) + configure.indicatorAdditionalWidth
            UIView.animate(withDuration: configure.indicatorAnimationTime) {
                if indicatorWidth >= currentBtn.frame.size.width {
                    self.indicator.frame.size.width = currentBtn.frame.size.width
                } else {
                    self.indicator.frame.size.width = indicatorWidth
                }
                self.indicator.center.x = currentBtn.center.x
                self.changeSelectedBtn(btn: currentBtn)
            }
        }
    }
    /// 有指示器：从左到右自动布局：默认滚动样式
    private func indicatorScrollDefaull(progress: CGFloat, currentBtn: UIButton, targetBtn: UIButton) {
        // 改变按钮的选择状态
        if (progress >= 0.8) {
            changeSelectedBtn(btn: targetBtn)
        }
        // 处理 Fixed 样式
        if configure.indicatorType == .Fixed {
            let targetIndicatorX: CGFloat = targetBtn.frame.maxX - 0.5 * (targetBtn.frame.size.width - configure.indicatorFixedWidth) - configure.indicatorFixedWidth
            let currentIndicatorX: CGFloat = currentBtn.frame.maxX - configure.indicatorFixedWidth - 0.5 * (currentBtn.frame.size.width - configure.indicatorFixedWidth)
            let totalOffsetX: CGFloat = targetIndicatorX - currentIndicatorX
            let offsetX: CGFloat = totalOffsetX * progress
            indicator.frame.origin.x = currentIndicatorX + offsetX
            return
        }

        // 处理 Dynamic 样式
        if configure.indicatorType == .Dynamic {
            let currentBtnTag = currentBtn.tag
            let targetBtnTag = targetBtn.tag
            if currentBtnTag <= targetBtnTag { // 往左滑
                // targetBtn 与 currentBtn 中心点之间的距离
                let btnCenterXDistance: CGFloat = targetBtn.center.x - currentBtn.center.x
                if progress <= 0.5 {
                    indicator.frame.size.width = 2 * progress * btnCenterXDistance + configure.indicatorDynamicWidth
                } else {
                    let targetBtnX: CGFloat = targetBtn.frame.maxX - configure.indicatorDynamicWidth - 0.5 * (targetBtn.frame.size.width - configure.indicatorDynamicWidth)
                    indicator.frame.origin.x = targetBtnX + 2 * (progress - 1) * btnCenterXDistance
                    indicator.frame.size.width = 2 * (1 - progress) * btnCenterXDistance + configure.indicatorDynamicWidth
                }
            } else {
                // currentBtn 与 targetBtn 中心点之间的距离
                let btnCenterXDistance: CGFloat = currentBtn.center.x - targetBtn.center.x
                if progress <= 0.5 {
                    let currentBtnX: CGFloat = currentBtn.frame.maxX - configure.indicatorDynamicWidth - 0.5 * (currentBtn.frame.size.width - configure.indicatorDynamicWidth)
                    indicator.frame.origin.x = currentBtnX - 2 * progress * btnCenterXDistance
                    indicator.frame.size.width = 2 * progress * btnCenterXDistance + configure.indicatorDynamicWidth
                } else {
                    let targetBtnX: CGFloat = targetBtn.frame.maxX - configure.indicatorDynamicWidth - 0.5 * (targetBtn.frame.size.width - configure.indicatorDynamicWidth)
                    indicator.frame.origin.x = targetBtnX // 这句代码必须写，防止滚动结束之后指示器位置存在偏差，这里的偏差是由于 progress >= 0.8 导致的
                    indicator.frame.size.width = 2 * (1 - progress) * btnCenterXDistance + configure.indicatorDynamicWidth
                }
            }
            return
        }
        
        // 处理指示器 Default、Cover 样式
        if configure.textZoom {
            let currentBtnTextWidth: CGFloat = P_calculateWidth(string: currentBtn.currentTitle!, font: configure.font)
            let targetBtnTextWidth: CGFloat = P_calculateWidth(string: targetBtn.currentTitle!, font: configure.font)
            // 文字距离差
            let diffText: CGFloat = targetBtnTextWidth - currentBtnTextWidth
            // 中心点距离差
            let distanceCenter: CGFloat = targetBtn.center.x - currentBtn.center.x
            let offsetCenterX: CGFloat = distanceCenter * progress
            
            let indicatorWidth: CGFloat = configure.indicatorAdditionalWidth + targetBtnTextWidth
            if indicatorWidth >= targetBtn.frame.size.width {
                indicator.frame.size.width = targetBtn.frame.size.width
            } else {
                let tempIndicatorWidth: CGFloat = currentBtnTextWidth + diffText * progress
                indicator.frame.size.width = tempIndicatorWidth + configure.indicatorAdditionalWidth
            }
            indicator.center.x = currentBtn.center.x + offsetCenterX
            return
        }

        // 1、计算 targetBtn 与 currentBtn 之间的 x 差值
        let totalOffsetX: CGFloat = targetBtn.frame.origin.x - currentBtn.frame.origin.x
        // 2、计算 targetBtn 与 currentBtn 之间距离的差值
        let totalDistance: CGFloat = targetBtn.frame.maxX - currentBtn.frame.maxX
        /// 计算 indicator 滚动时 x 的偏移量
        var offsetX: CGFloat = 0.0
        /// 计算 indicator 滚动时宽度的偏移量
        var distance: CGFloat = 0.0
        let targetBtnTextWidth: CGFloat = P_calculateWidth(string: targetBtn.currentTitle!, font: configure.font)
        let indicatorWidth: CGFloat = configure.indicatorAdditionalWidth + targetBtnTextWidth
        
        if indicatorWidth >= targetBtn.frame.size.width {
            offsetX = totalOffsetX * progress
            distance = progress * (totalDistance - totalOffsetX)
            indicator.frame.origin.x = currentBtn.frame.origin.x + offsetX
            indicator.frame.size.width = currentBtn.frame.size.width + distance
        } else {
            offsetX = totalOffsetX * progress + 0.5 * configure.additionalWidth - 0.5 * configure.indicatorAdditionalWidth
            distance = progress * (totalDistance - totalOffsetX) - configure.additionalWidth
            /// 计算 indicator 新的 frame
            indicator.frame.origin.x = currentBtn.frame.origin.x + offsetX
            indicator.frame.size.width = currentBtn.frame.size.width + distance + configure.indicatorAdditionalWidth
        }
    }
    /// 有指示器：从左到右自动布局：Half、End 滚动样式
    private func indicatorScrollHalfEnd(progress: CGFloat, currentBtn: UIButton, targetBtn: UIButton) {
        // 1、处理 indicatorScrollStyle 的 Half 逻辑
        if configure.indicatorScrollStyle == .Half {
            // 1.1、处理 Fixed 样式
            if configure.indicatorType == .Fixed {
                if progress >= 0.5 {
                    UIView.animate(withDuration: configure.indicatorAnimationTime) {
                        self.indicator.center.x = targetBtn.center.x
                        self.changeSelectedBtn(btn: targetBtn)
                    }
                } else {
                    UIView.animate(withDuration: configure.indicatorAnimationTime) {
                        self.indicator.center.x = currentBtn.center.x
                        self.changeSelectedBtn(btn: currentBtn)
                    }
                }
                return
            }
            // 1.2、处理 Dynamic 样式
            if configure.indicatorType == .Dynamic {
                let currentBtnTag = currentBtn.tag
                let targetBtnTag = targetBtn.tag
                if currentBtnTag <= targetBtnTag { // 往左滑
                    // targetBtn 与 currentBtn 中心点之间的距离
                    let btnCenterXDistance: CGFloat = targetBtn.center.x - currentBtn.center.x
                    if progress <= 0.5 {
                        indicator.frame.size.width = 2 * progress * btnCenterXDistance + configure.indicatorDynamicWidth
                        changeSelectedBtn(btn: currentBtn)
                    } else {
                        let targetBtnX: CGFloat = targetBtn.frame.maxX - configure.indicatorDynamicWidth - 0.5 * (targetBtn.frame.size.width - configure.indicatorDynamicWidth)
                        indicator.frame.origin.x = targetBtnX + 2 * (progress - 1) * btnCenterXDistance
                        indicator.frame.size.width = 2 * (1 - progress) * btnCenterXDistance + configure.indicatorDynamicWidth
                        changeSelectedBtn(btn: targetBtn)
                    }
                } else {
                    // currentBtn 与 targetBtn 中心点之间的距离
                    let btnCenterXDistance: CGFloat = currentBtn.center.x - targetBtn.center.x
                    if progress <= 0.5 {
                        let currentBtnX: CGFloat = currentBtn.frame.maxX - configure.indicatorDynamicWidth - 0.5 * (currentBtn.frame.size.width - configure.indicatorDynamicWidth)
                        indicator.frame.origin.x = currentBtnX - 2 * progress * btnCenterXDistance
                        indicator.frame.size.width = 2 * progress * btnCenterXDistance + configure.indicatorDynamicWidth
                        changeSelectedBtn(btn: currentBtn)
                    } else {
                        let targetBtnX: CGFloat = targetBtn.frame.maxX - configure.indicatorDynamicWidth - 0.5 * (targetBtn.frame.size.width - configure.indicatorDynamicWidth)
                        indicator.frame.origin.x = targetBtnX // 这句代码必须写，防止滚动结束之后指示器位置存在偏差，这里的偏差是由于 progress >= 0.8 导致的
                        indicator.frame.size.width = 2 * (1 - progress) * btnCenterXDistance + configure.indicatorDynamicWidth
                        changeSelectedBtn(btn: targetBtn)
                    }
                }
                return
            }
            // 1.3、处理指示器 Default、Cover 样式
            if progress >= 0.5 {
                let indicatorWidth = P_calculateWidth(string: targetBtn.currentTitle!, font: configure.font) + configure.indicatorAdditionalWidth
                UIView.animate(withDuration: configure.indicatorAnimationTime) { [self] in
                    if indicatorWidth >= targetBtn.frame.size.width {
                        self.indicator.frame.size.width = targetBtn.frame.size.width
                    } else {
                        self.indicator.frame.size.width = indicatorWidth
                    }
                    self.indicator.center.x = targetBtn.center.x
                    self.changeSelectedBtn(btn: targetBtn)
                }
            } else {
                let indicatorWidth = P_calculateWidth(string: currentBtn.currentTitle!, font: configure.font) + configure.indicatorAdditionalWidth
                UIView.animate(withDuration: configure.indicatorAnimationTime) {
                    if indicatorWidth >= currentBtn.frame.size.width {
                        self.indicator.frame.size.width = currentBtn.frame.size.width
                    } else {
                        self.indicator.frame.size.width = indicatorWidth
                    }
                    self.indicator.center.x = currentBtn.center.x
                    self.changeSelectedBtn(btn: currentBtn)
                }
            }
            return
        }
        
        // 2、处理 indicatorScrollStyleEnd 逻辑
        // 1、处理 Fixed 样式
        if configure.indicatorType == .Fixed {
            if (progress == 1.0) {
                UIView.animate(withDuration: configure.indicatorAnimationTime) {
                    self.indicator.center.x = targetBtn.center.x
                    self.changeSelectedBtn(btn: targetBtn)
                }
            } else {
                UIView.animate(withDuration: configure.indicatorAnimationTime) {
                    self.indicator.center.x = currentBtn.center.x
                    self.changeSelectedBtn(btn: currentBtn)
                }
            }
            return
        }
        // 2、处理 Dynamic 样式
        if configure.indicatorType == .Dynamic {
            let currentBtnTag = currentBtn.tag
            let targetBtnTag = targetBtn.tag
            if currentBtnTag <= targetBtnTag { // 往左滑
                // targetBtn 与 currentBtn 中心点之间的距离
                let btnCenterXDistance: CGFloat = targetBtn.center.x - currentBtn.center.x
                if progress <= 0.5 {
                    indicator.frame.size.width = 2 * progress * btnCenterXDistance + configure.indicatorDynamicWidth
                    changeSelectedBtn(btn: currentBtn)
                } else {
                    let targetBtnX: CGFloat = targetBtn.frame.maxX - configure.indicatorDynamicWidth - 0.5 * (targetBtn.frame.size.width - configure.indicatorDynamicWidth)
                    indicator.frame.origin.x = targetBtnX + 2 * (progress - 1) * btnCenterXDistance
                    indicator.frame.size.width = 2 * (1 - progress) * btnCenterXDistance + configure.indicatorDynamicWidth
                    if progress >= 0.8 {
                        changeSelectedBtn(btn: targetBtn)
                    }
                }
            } else {
                // currentBtn 与 targetBtn 中心点之间的距离
                let btnCenterXDistance: CGFloat = currentBtn.center.x - targetBtn.center.x
                if progress <= 0.5 {
                    let currentBtnX: CGFloat = currentBtn.frame.maxX - configure.indicatorDynamicWidth - 0.5 * (currentBtn.frame.size.width - configure.indicatorDynamicWidth)
                    indicator.frame.origin.x = currentBtnX - 2 * progress * btnCenterXDistance
                    indicator.frame.size.width = 2 * progress * btnCenterXDistance + configure.indicatorDynamicWidth
                    changeSelectedBtn(btn: currentBtn)
                } else {
                    let targetBtnX: CGFloat = targetBtn.frame.maxX - configure.indicatorDynamicWidth - 0.5 * (targetBtn.frame.size.width - configure.indicatorDynamicWidth)
                    indicator.frame.origin.x = targetBtnX // 这句代码必须写，防止滚动结束之后指示器位置存在偏差，这里的偏差是由于 progress >= 0.8 导致的
                    indicator.frame.size.width = 2 * (1 - progress) * btnCenterXDistance + configure.indicatorDynamicWidth
                    if progress >= 0.8 {
                        changeSelectedBtn(btn: targetBtn)
                    }
                }
            }
            return
        }
        // 3、处理指示器 Default、Cover 样式
        if progress == 1.0 {
            let indicatorWidth = P_calculateWidth(string: targetBtn.currentTitle!, font: configure.font) + configure.indicatorAdditionalWidth
            UIView.animate(withDuration: configure.indicatorAnimationTime) { [self] in
                if indicatorWidth >= targetBtn.frame.size.width {
                    self.indicator.frame.size.width = targetBtn.frame.size.width
                } else {
                    self.indicator.frame.size.width = indicatorWidth
                }
                self.indicator.center.x = targetBtn.center.x
                self.changeSelectedBtn(btn: targetBtn)
            }
        } else {
            let indicatorWidth = P_calculateWidth(string: currentBtn.currentTitle!, font: configure.font) + configure.indicatorAdditionalWidth
            UIView.animate(withDuration: configure.indicatorAnimationTime) {
                if indicatorWidth >= currentBtn.frame.size.width {
                    self.indicator.frame.size.width = currentBtn.frame.size.width
                } else {
                    self.indicator.frame.size.width = indicatorWidth
                }
                self.indicator.center.x = currentBtn.center.x
                self.changeSelectedBtn(btn: currentBtn)
            }
        }
    }
    
    /// 无指示器
    private func noIndicatorScroll(progress: CGFloat, currentBtn: UIButton, targetBtn: UIButton) {
        if progress == 1.0 {
            UIView.animate(withDuration: configure.indicatorAnimationTime) {
                self.changeSelectedBtn(btn: targetBtn)
            }
        } else {
            UIView.animate(withDuration: configure.indicatorAnimationTime) {
                self.changeSelectedBtn(btn: currentBtn)
            }
        }
    }
    /// 无指示器：Half 滚动样式
    private func noIndicatorScrollHalf(progress: CGFloat, currentBtn: UIButton, targetBtn: UIButton) {
        if progress >= 0.5 {
            UIView.animate(withDuration: configure.indicatorAnimationTime) {
                self.changeSelectedBtn(btn: targetBtn)
            }
        } else {
            UIView.animate(withDuration: configure.indicatorAnimationTime) {
                self.changeSelectedBtn(btn: currentBtn)
            }
        }
    }

    
    /// 颜色的渐变逻辑处理(复杂)
    private func gradientEffect(progress: CGFloat, currentBtn: UIButton, targetBtn: UIButton) {
        let targetProgress: CGFloat = progress
        let currentProgress: CGFloat = 1 - progress
        
        let r = endR - startR
        let g = endG - startG
        let b = endB - startB
        let currentColor: UIColor = UIColor.init(red: startR +  r * currentProgress, green: startG +  g * currentProgress, blue: startB +  b * currentProgress, alpha: 1.0)
        let targetColor: UIColor = UIColor.init(red: startR +  r * targetProgress, green: startG +  g * targetProgress, blue: startB +  b * targetProgress, alpha: 1.0)

        currentBtn.titleLabel?.textColor = currentColor
        targetBtn.titleLabel?.textColor = targetColor
    }
}

// MARK: initialization
private extension SGPagingTitleView {
    func initialization() {
        if configure.textZoomRatio < 0.0 {
            configure.textZoomRatio = 0.0
        } else if configure.textZoomRatio > 1.0 {
            configure.textZoomRatio = 1.0
        }
        if configure.indicatorAnimationTime < 0.0 {
            configure.indicatorAnimationTime = 0.0
        } else if configure.indicatorAnimationTime > 0.3 {
            configure.indicatorAnimationTime = 0.3
        }
    }
}
// MARK: 添加内部子视图
private extension SGPagingTitleView {
    func addSubviews() {
        addSubview(scrollView)
        if configure.showBottomSeparator {
            addSubview(bottomSeparator)
        }
        addTitleBtns()
        if configure.showIndicator {
            if configure.indicatorLocation == .Default {
                scrollView.insertSubview(indicator, at: 0)
            } else {
                scrollView.addSubview(indicator)
            }
        }
    }
    
    func addTitleBtns() {
        let titleCount = titles.count
        titles.forEach { (title) in
            let titleWidth: CGFloat = P_calculateWidth(string: title, font: configure.font)
            allBtnTextWidth += titleWidth
        }
        allBtnWidth = allBtnTextWidth + configure.additionalWidth * CGFloat(titleCount)
        allBtnWidth = CGFloat(ceilf(Float(allBtnWidth)))
        
        for idx in 0..<titleCount {
            let btn = SGPagingTitleButton()
            btn.tag = idx
            btn.titleLabel?.font = configure.font
            btn.setTitle(titles[idx], for: .normal)
            btn.setTitleColor(configure.color, for: .normal)
            btn.setTitleColor(configure.selectedColor, for: .selected)
            btn.addTarget(self, action: #selector(btn_action(button:)), for: .touchUpInside)
            scrollView.addSubview(btn)
            tempBtns.append(btn)
        }
        
        // 添加按钮间分割线
        if configure.showSeparator {
            for _ in 0..<(titleCount - 1) {
                let separator: UIView = UIView()
                separator.backgroundColor = configure.separatorColor
                scrollView.addSubview(separator)
                separators.append(separator)
            }
        }
        
        // 标题文字渐变效果下对标题文字默认、选中状态下颜色的记录
        if configure.gradientEffect {
            P_startColor(color: configure.color)
            P_endColor(color: configure.selectedColor)
        }
        
        if allBtnWidth <= frame.size.width {
            let btnY: CGFloat = 0.0
            let btnW: CGFloat = frame.size.width / CGFloat(titleCount)
            let btnH: CGFloat = frame.size.height

            if configure.equivalence { /// 固定样式下均分布局标题
                for (index, btn) in tempBtns.enumerated() {
                    let btnX = btnW * CGFloat(index)
                    btn.frame = CGRect.init(x: btnX, y: btnY, width: btnW, height: btnH)
                }
                
                // 设置标题间分割线的 frame
                if configure.showSeparator {
                    let separatorW: CGFloat = 1
                    var separatorH: CGFloat = frame.size.height - configure.separatorAdditionalReduceLength
                    if separatorH < 0 {
                        separatorH = frame.size.height
                    }
                    let separatorY: CGFloat = 0.5 * (frame.size.height - separatorH)
                    for (idx, separator) in separators.enumerated() {
                        let separatorX: CGFloat = btnW * CGFloat((idx + 1)) - 0.5 * separatorW
                        separator.frame = CGRect.init(x: separatorX, y: separatorY, width: separatorW, height: separatorH)
                    }
                }

            } else { /// 固定样式下从左到右布局标题
                fromLeftToRightLayout()
            }
            if configure.bounce == false {
                scrollView.bounces = false
            }
        } else {
            fromLeftToRightLayout()
            if configure.bounces == false {
                scrollView.bounces = false
            }
        }
    }
    
    /// 从左到右布局标题
    func fromLeftToRightLayout() {
        var btnX: CGFloat = 0.0
        let btnY: CGFloat = 0.0
        var btnW: CGFloat = 0.0
        let btnH: CGFloat = frame.size.height
        for (_, btn) in tempBtns.enumerated() {
            btnW = P_calculateWidth(string: btn.currentTitle!, font: configure.font) + configure.additionalWidth
            btn.frame = CGRect.init(x: btnX, y: btnY, width: btnW, height: btnH)
            btnX = btnX + btnW
        }
        
        // 设置标题间分割线的 frame
        if configure.showSeparator {
            let separatorW: CGFloat = 1
            var separatorH: CGFloat = frame.size.height - configure.separatorAdditionalReduceLength
            if separatorH < 0 {
                separatorH = frame.size.height
            }
            let separatorY: CGFloat = 0.5 * (frame.size.height - separatorH)
            for (idx, separator) in separators.enumerated() {
                let btn: UIButton = tempBtns[idx]
                let separatorX: CGFloat = btn.frame.maxX - 0.5 * separatorW
                separator.frame = CGRect.init(x: separatorX, y: separatorY, width: separatorW, height: separatorH)
            }
        }
        
        let lastBtn = tempBtns.last
        scrollView.contentSize = CGSize(width: (lastBtn?.frame.maxX)!, height: frame.size.height)
    }
}
// MARK: 标题按钮的点击事件
private extension SGPagingTitleView {
    @objc func btn_action(button: UIButton) {
        changeSelectedBtn(btn: button)
        if allBtnWidth > frame.size.width {
            signBtnClick = true
            selectedBtnCenter(btn: button)
        }
        if configure.showIndicator {
            changeIndicatorWithButton(btn: button)
        }
        if delegate != nil && (delegate?.responds(to: #selector(delegate?.pagingTitleView(titleView:index:))))! {
            delegate?.pagingTitleView!(titleView: self, index: button.tag)
        }
        signBtnIndex = button.tag
    }
    
    /// 改变选中按钮
    func changeSelectedBtn(btn: UIButton) {
        if tempBtn == nil {
            btn.isSelected = true
            tempBtn = btn
        } else if tempBtn != nil && tempBtn == btn {
            btn.isSelected = true
        } else if tempBtn != nil && tempBtn != btn {
            tempBtn?.isSelected = false
            btn.isSelected = true
            tempBtn = btn
        }
        
        index = btn.tag
        
        let selectedFont: UIFont = configure.selectedFont
        let defaultFont: UIFont = .systemFont(ofSize: 15)
        let selectedFontName: String = selectedFont.fontName
        let selectedFontPointSize: CGFloat = selectedFont.pointSize
        let defaultFontName: String = defaultFont.fontName
        let defaultFontPointSize: CGFloat = defaultFont.pointSize
        
        if selectedFontName == defaultFontName && selectedFontPointSize == defaultFontPointSize {
            // 标题文字缩放属性(开启 selectedFont 属性将不起作用)
            if configure.textZoom {
                tempBtns.forEach { (EBtn) in
                    EBtn.transform = .identity
                }
                // 1.记录按钮缩放前的宽度
                let zoomFrontBtnWidth: CGFloat = btn.frame.size.width
                /// 处理按钮缩放
                let afterZoomRatio: CGFloat = 1 + configure.textZoomRatio
                btn.transform = CGAffineTransform(scaleX: afterZoomRatio, y: afterZoomRatio)
                
                // 2.记录按钮缩放后的宽度
                let zoomAfterBtnWidth: CGFloat = btn.frame.size.width
                // 缩放后与缩放前之间的差值
                let diffForntAfter: CGFloat = zoomAfterBtnWidth - zoomFrontBtnWidth
                
                /// 处理指示器
                if configure.indicatorAdditionalWidth >= diffForntAfter {
                    configure.indicatorAdditionalWidth = diffForntAfter
                }


                if configure.indicatorType == .Fixed {
                    var indicatorWidth = configure.indicatorFixedWidth
                    if indicatorWidth > btn.frame.size.width {
                        indicatorWidth = btn.frame.size.width
                    }
                    indicator.frame.size.width = configure.indicatorFixedWidth
                    indicator.center.x = btn.center.x
                } else {
                    let btnTextWidth = P_calculateWidth(string: btn.currentTitle!, font: configure.font)
                    var indicatorWidth = btnTextWidth + configure.indicatorAdditionalWidth
                    if indicatorWidth > btn.frame.size.width {
                        indicatorWidth = btn.frame.size.width
                    }
                    indicator.frame.size.width = indicatorWidth
                    indicator.center.x = btn.center.x
                }
            }
            
            // 此处作用：避免滚动过程中点击标题手指不离开屏幕的前提下再次滚动造成的误差（由于文字渐变效果导致未选中标题的不准确处理）
            if configure.gradientEffect {
                tempBtns.forEach { (EBtn) in
                    EBtn.titleLabel?.textColor = configure.color
                }
                btn.titleLabel?.textColor = configure.selectedColor
            }
        } else {
            // 此处作用：避免滚动过程中点击标题手指不离开屏幕的前提下再次滚动造成的误差（由于文字渐变效果导致未选中标题的不准确处理）
            if configure.gradientEffect {
                tempBtns.forEach { (EBtn) in
                    EBtn.titleLabel?.textColor = configure.color
                    EBtn.titleLabel?.font = configure.font
                }
                btn.titleLabel?.textColor = configure.selectedColor
                btn.titleLabel?.font = configure.selectedFont
            } else {
                tempBtns.forEach { (EBtn) in
                    EBtn.titleLabel?.font = configure.font
                }
                btn.titleLabel?.font = configure.selectedFont
            }
        }
    }
    
    /// 滚动样式下选中标题居中处理
    func selectedBtnCenter(btn: UIButton) {
        var offsetX: CGFloat = btn.center.x - frame.size.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        let maxOffsetX: CGFloat = scrollView.contentSize.width - frame.size.width
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        scrollView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
    }
    
    /// 根据标题按钮选中的变化而去改变指示器
    func changeIndicatorWithButton(btn: UIButton) {
        UIView.animate(withDuration: configure.indicatorAnimationTime) {
            if self.configure.indicatorType == .Fixed {
                self.indicator.frame.size.width = self.configure.indicatorFixedWidth
                self.indicator.center.x = btn.center.x
                return
            }
            
            if self.configure.indicatorType == .Dynamic {
                self.indicator.frame.size.width = self.configure.indicatorDynamicWidth
                self.indicator.center.x = btn.center.x
                return
            }
            
            if self.configure.textZoom == false {
                var indicatorWidth: CGFloat = self.P_calculateWidth(string: btn.currentTitle!, font: self.configure.font) + self.configure.indicatorAdditionalWidth
                if indicatorWidth > btn.frame.size.width {
                    indicatorWidth = btn.frame.size.width
                }
                self.indicator.frame.size.width = indicatorWidth
                self.indicator.center.x = btn.center.x
            }
        }
    }
}

// MARK: Indicator 布局及相关属性处理
extension SGPagingTitleView {
    func P_layoutIndicator(tempIndicator: UIView) {
        if configure.indicatorType == .Cover {
            if configure.indicatorHeight >= frame.size.height {
                tempIndicator.frame.origin.y = 0
                tempIndicator.frame.size.height = frame.size.height
            } else {
                tempIndicator.frame.origin.y = 0.5 * (frame.size.height - configure.indicatorHeight)
                tempIndicator.frame.size.height = configure.indicatorHeight
            }
            tempIndicator.layer.borderWidth = configure.indicatorBorderWidth
            tempIndicator.layer.borderColor = configure.indicatorBorderColor.cgColor
        } else {
            if configure.indicatorHeight >= frame.size.height {
                tempIndicator.frame.origin.y = 0
                tempIndicator.frame.size.height = frame.size.height
            } else {
                tempIndicator.frame.origin.y = frame.size.height - configure.indicatorToBottomDistance - configure.indicatorHeight
                tempIndicator.frame.size.height = configure.indicatorHeight
            }
        }
        
        if configure.indicatorCornerRadius > 0.5 * tempIndicator.frame.size.height {
            tempIndicator.layer.cornerRadius = 0.5 * tempIndicator.frame.size.height
        } else {
            tempIndicator.layer.cornerRadius = configure.indicatorCornerRadius
        }
    }
}


// MARK: 内部公共方法抽取
private extension SGPagingTitleView {
    /// 计算字符串的宽度
    func P_calculateWidth(string: String, font: UIFont) -> CGFloat {
        let attrs = [NSAttributedString.Key.font: font]
        let attrString = NSAttributedString(string: string, attributes: attrs)
        return attrString.boundingRect(with: CGSize(width: 0, height: 0), options: .usesLineFragmentOrigin, context: nil).size.width
    }
    /// 计算字符串的高
    func P_calculateHeight(string: String, font: UIFont) -> CGFloat {
        let attrs = [NSAttributedString.Key.font: font]
        let attrString = NSAttributedString(string: string, attributes: attrs)
        return attrString.boundingRect(with: CGSize(width: 0, height: 0), options: .usesLineFragmentOrigin, context: nil).size.height
    }
    
    /// 开始颜色
    func P_startColor(color: UIColor) {
        let components = P_getRGBComponents(color: color)
        startR = components[0]
        startG = components[1]
        startB = components[2]
    }
    /// 结束颜色
    func P_endColor(color: UIColor) {
        let components = P_getRGBComponents(color: color)
        endR = components[0]
        endG = components[1]
        endB = components[2]
    }
    /// 颜色处理
    func P_getRGBComponents(color: UIColor) -> [CGFloat] {
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let data = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let context = CGContext(data: data, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: rgbColorSpace, bitmapInfo: 1)
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect.init(x: 0, y: 0, width: 1, height: 1))
        var components:[CGFloat] = []
        for i in 0..<3 {
            components.append(CGFloat(data[i])/255.0)
        }
        return components
    }
}

// MARK: - 内部标题图片相关方法
private extension SGPagingTitleView {
    func setImage(btn: UIButton, imageName: String, location: ImageLocation, spacing: CGFloat) {
        if imageName.hasPrefix("http") {
            loadImage(urlString: imageName) { (image) in
                btn.setImage(image, for: .normal)
                btn.setImage(location: location, space: spacing)
            }
        } else {
            btn.setImage(UIImage.init(named: imageName), for: .normal)
            btn.setImage(location: location, space: spacing)
        }
    }
    
    typealias LoadImageCompleteBlock = ((_ image: UIImage) -> ())?
    /// 加载网络图片
    func loadImage(urlString: String, complete: LoadImageCompleteBlock) {
        let blockOperation = BlockOperation.init {
            let url = URL.init(string: urlString)
            guard let imageData = NSData(contentsOf: url!) else { return }
            let image = UIImage(data: imageData as Data)
            OperationQueue.main.addOperation {
                if complete != nil {
                    complete!(image!)
                }
            }
        }
        OperationQueue().addOperation(blockOperation)
    }
}


private class SGPagingTitleButton: UIButton {
    override var isHighlighted: Bool {
        set {}
        get {return false}
    }
}
