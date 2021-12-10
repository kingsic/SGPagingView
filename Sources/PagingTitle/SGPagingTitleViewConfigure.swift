//
//  SGPagingTitleViewConfigure.swift
//  SGPagingView
//
//  Created by kingsic on 2020/12/23.
//  Copyright © 2020 kingsic. All rights reserved.
//

import UIKit

/// 指示器样式
public enum IndicatorType: Int {
    case Default, Cover, Fixed, Dynamic
}

/// 指示器随内容子视图滚动而滚动的样式
public enum IndicatorScrollStyle: Int {
    case Default, Half, End
}

public class SGPagingTitleViewConfigure: NSObject  {
    // MARK: SGPagingTitleView 相关属性
    /// SGPagingTitleView 固定样式下，是否需要回弹效果，默认为 false
    public var bounce = false
    
    /// SGPagingTitleView 滚动样式下，是否需要回弹效果，默认为 true
    public var bounces = true
    
    /// SGPagingTitleView 固定样式下标题是否均分布局，默认为 true
    public var equivalence = true
    
    /// SGPagingTitleView 是否显示底部分割线，默认为 true
    public var showBottomSeparator = true
    
    /// SGPagingTitleView 底部分割线颜色，默认为 lightGray
    public var bottomSeparatorColor: UIColor = .lightGray
    
    
    // MARK: 标题相关属性
    /// 标题文字大小，默认为 .systemFont(ofSize: 15)
    public var font: UIFont = .systemFont(ofSize: 15)
    
    /// 标题文字选中时大小，默认为 .systemFont(ofSize: 15)，一旦设置此属性，textZoom 属性将不起作用
    public var selectedFont: UIFont = .systemFont(ofSize: 15)
    
    /// 普通状态下标题颜色，默认为 black
    public var color: UIColor = .black
    
    /// 选中状态下标题颜色，默认为 red
    public var selectedColor: UIColor = .red
    
    /// 标题文字是否具有渐变效果，默认为 false
    public var gradientEffect = false
    
    /// 标题文字是否具有缩放效果，默认为 false。为 true 时，请与 textZoomRatio 属性结合使用，否则不起作用。（特别需要注意的是：此属性为 true 时，与 indicatorScrollStyle 属性不兼容）
    public var textZoom = false
    
    /// 标题文字缩放比，默认为 0.0f，取值范围 0.0 ～ 1.0f。请与 textZoom = true 时结合使用，否则不起作用
    public var textZoomRatio: CGFloat = 0.0
    
    /// 标题额外需要增加的宽度，默认为 20.0（标题宽度 = 文字宽度 + additionalWidth)
    public var additionalWidth: CGFloat = 20.0
    
    
    // MARK: 指示器相关属性
    /// 是否显示指示器，默认为 true
    public var showIndicator = true
    
    /// 指示器颜色，默认为 red
    public var indicatorColor: UIColor = .red
    
    /// 指示器高度，默认为 2.0f
    public var indicatorHeight: CGFloat = 2.0
    
    /// 指示器动画时间，默认为 0.1f，取值范围 0.0 ～ 0.3f
    public var indicatorAnimationTime: TimeInterval = 0.1
    
    /// 指示器圆角大小，默认为 0.0f
    public var indicatorCornerRadius: CGFloat = 0.0
    
    /// 指示器 Cover 样式下的边框宽度，默认为 0.0f
    public var indicatorBorderWidth: CGFloat = 0.0
    
    /// 指示器 Cover 样式下的边框颜色，默认为 clear
    public var indicatorBorderColor: UIColor = .clear
    
    /// 指示器 Cover、Default 样式下额外增加的宽度，默认为 0.0f；指示器默认宽度等于标题文字宽度
    public var indicatorAdditionalWidth: CGFloat = 0.0
    
    /// 指示器 Fixed 样式下的宽度，默认为 20.0f；最大宽度并没有做限制，请根据实际情况妥善设置
    public var indicatorFixedWidth: CGFloat = 20.0
    
    /// 指示器 Dynamic 样式下的宽度，默认为 20.0f；最大宽度并没有做限制，请根据实际情况妥善设置
    public var indicatorDynamicWidth: CGFloat = 20.0
    
    /// 指示器距 SGPagingTitleView 底部间的距离，默认为 0.0f
    public var indicatorToBottomDistance: CGFloat = 0.0
    
    /// 指示器样式，默认为 Default
    public var indicatorType: IndicatorType = .Default
    
    /// 滚动内容视图时，指示器切换样式，默认为 Default。（特别需要注意的是：此属性与 textZoom = true 时不兼容）
    public var indicatorScrollStyle: IndicatorScrollStyle = .Default

    
    // MARK: 标题间分割线相关属性
    /// 是否显示标题间分割线，默认为 false
    public var showSeparator = false
    
    /// 标题间分割线颜色，默认为 red
    public var separatorColor: UIColor = .red
    
    /// 标题间分割线额外减少的长度，默认为 20.0f
    public var separatorAdditionalReduceLength: CGFloat = 20.0
    
    
    // MARK: badge 相关属性，默认所在位置以标题文字右上角为起点
    /// badge 颜色，默认为 red
    public var badgeColor: UIColor = .red
    
    /// badge 的高，默认为 7.0f
    public var badgeHeight: CGFloat = 7.0
    
    /// badge 的偏移量，默认为 zero
    public var badgeOff: CGPoint = .zero
    
    /// badge 的文字颜色，默认为 white（只针对：addBadge(text:index:) 方法有效）
    public var badgeTextColor: UIColor = .white
    
    /// badge 的文字大小，默认为 .systemFont(ofSize: 10)（只针对：addBadge(text:index:) 方法有效）
    public var badgeTextFont: UIFont = .systemFont(ofSize: 10)
    
    /// badge 额外需要增加的宽度，默认为 10.0f（只针对：addBadge(text:index:) 方法有效）
    public var badgeAdditionalWidth: CGFloat = 10.0
    
    /// badge 边框的宽度，默认为 0（只针对：addBadge(text:index:) 方法有效）
    public var badgeBorderWidth: CGFloat = 0.0
    
    /// badge 边框的颜色，默认为 clear（只针对：addBadge(text:index:) 方法有效）
    public var badgeBorderColor: UIColor = .clear
    
    /// badge 圆角大小，默认为 5.0f（只针对：addBadge(text:index:) 方法有效）
    public var badgeCornerRadius: CGFloat = 5.0
}
