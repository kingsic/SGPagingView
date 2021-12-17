//
//  UIButton+SGPagingView.swift
//  SGPagingView
//
//  Created by kingsic on 2021/11/17.
//  Copyright © 2021 kingsic. All rights reserved.
//

import UIKit

@objc public enum ImageLocation: Int {
    case left, right, top, bottom
}

public extension UIButton {
    /// Set image location
    ///
    /// Image and title must be set before this method will work, It is recommended to set it inside the block
    ///
    /// - parameter location: location of image relative to title
    /// - parameter space: space between image and title
    /// - parameter completion: set image and title
    @objc func setImage(location: ImageLocation, space: CGFloat, completion: (UIButton) -> ()) {
        completion(self)
        setImage(location: location, space: space)
    }
    
    /// Set image location
    ///
    /// Image and title must be set before this method will work
    ///
    /// - parameter location: Location of image relative to title
    /// - parameter space: Space between image and title
    @objc func setImage(location: ImageLocation, space: CGFloat) {
        
        let imageView_Width = imageView?.frame.size.width
        let imageView_Height = imageView?.frame.size.height
        let titleLabel_iCSWidth = titleLabel?.intrinsicContentSize.width
        let titleLabel_iCSHeight = titleLabel?.intrinsicContentSize.height
        
        switch location {
        case .left:
            if contentHorizontalAlignment == .left {
                titleEdgeInsets = UIEdgeInsets.init(top: 0, left: space, bottom: 0, right: 0)
            } else if contentHorizontalAlignment == .right {
                imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: space)
            } else {
                let spacing_half = 0.5 * space;
                imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -spacing_half, bottom: 0, right: spacing_half)
                titleEdgeInsets = UIEdgeInsets.init(top: 0, left: spacing_half, bottom: 0, right: -spacing_half)
            }
        case .right:
            let titleLabelWidth = titleLabel?.frame.size.width
            if contentHorizontalAlignment == .left {
                imageEdgeInsets = UIEdgeInsets.init(top: 0, left: titleLabelWidth! + space, bottom: 0, right: 0)
                titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -imageView_Width!, bottom: 0, right: 0)
            } else if contentHorizontalAlignment == .right {
                imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -titleLabelWidth!)
                titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: imageView_Width! + space)
            } else {
                let imageOffset = titleLabelWidth! + 0.5 * space
                let titleOffset = imageView_Width! + 0.5 * space
                imageEdgeInsets = UIEdgeInsets.init(top: 0, left: imageOffset, bottom: 0, right: -imageOffset)
                titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -titleOffset, bottom: 0, right: titleOffset)
            }
        case .top:
            imageEdgeInsets = UIEdgeInsets.init(top: -(titleLabel_iCSHeight! + space), left: 0, bottom: 0, right: -titleLabel_iCSWidth!)
            titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -imageView_Width!, bottom: -(imageView_Height! + space), right: 0)
        case .bottom:
            imageEdgeInsets = UIEdgeInsets.init(top: titleLabel_iCSHeight! + space, left: 0, bottom: 0, right: -titleLabel_iCSWidth!)
            titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -imageView_Width!, bottom: imageView_Height! + space, right: 0)
        }
    }
}
