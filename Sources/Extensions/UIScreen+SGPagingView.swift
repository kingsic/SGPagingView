//
//  UIScreen+SGPagingView.swift
//  SGPagingView
//
//  Created by kingsic on 2021/11/17.
//  Copyright © 2021 kingsic. All rights reserved.
//

import UIKit

public extension UIScreen {
    /// Gets the size of the screen
    @objc static var size: CGSize { return UIScreen.main.bounds.size }
    
    /// Gets the width of the screen
    @objc static var width: CGFloat { return UIScreen.main.bounds.size.width }
    
    /// Gets the height of the screen
    @objc static var height: CGFloat { return UIScreen.main.bounds.size.height }
    
    /// Gets status bar height
    @objc static var statusBarHeight: CGFloat {
        if #available(iOS 13, *) {
            return (UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height)!
        } else {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }
    
    /// Gets navigation bar height
    @objc static var navBarHeight: CGFloat { return statusBarHeight + 44 }
    
    /// Gets tab bar height
    @objc static var tabBarHeight: CGFloat { return statusBarHeight == 20 ? 49 : 83 }
    
    /// Gets bottom safeArea height
    @objc static var safeAreaInsetBottom: CGFloat { return statusBarHeight == 20 ? 0 : 34 }
}
